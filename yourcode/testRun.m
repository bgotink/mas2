function [] = testRun(N,mmdp,handcoded)
% function testRun(N,algo,handcoded)
%
% input:
%   N          -    the number of runs, defaults to 100
%   algo       -    what algorithms to test, defaults to 0:
%                     0 - test standard MDP, MLS and Q_MDP
%                     1 - test point based POMDP
%                     2 - test MMDP
%   handcoded   -   whether the hand coded solution should be
%                   used as well, defaults to 0, only used if algo==0
%
% output:
%       none, logs to stdout

    if (nargin < 3), handcoded=0; end;
    if (nargin < 2), mmdp=0; end;
    if (nargin < 1), N=100; end;

    if (mmdp == 0)
        if (handcoded==1)
            [stepData,rewardData] = run(N,@sampleTrajectoriesHandCoded);
            fprintf('Handcoded:\n');
            fprintf('\t number of steps => average=%f, deviation=%f\n',stepData.average,stepData.deviation);
            fprintf('\t reward => average=%f, deviation=%f\n',rewardData.average,rewardData.deviation);
        end
        
        [stepData,rewardData] = run(N,@sampleTrajectoriesMDP);
        fprintf('MDP:\n');
        fprintf('\t number of steps => average=%f, deviation=%f\n',stepData.average,stepData.deviation);
        fprintf('\t reward => average=%f, deviation=%f\n',rewardData.average,rewardData.deviation);

        [stepData,rewardData] = run(N,@sampleTrajectoriesMLS);
        fprintf('MLS:\n');
        fprintf('\t number of steps => average=%f, deviation=%f\n',stepData.average,stepData.deviation);
        fprintf('\t reward => average=%f, deviation=%f\n',rewardData.average,rewardData.deviation);
        
        [stepData,rewardData,unconverged,stepData2,rewardData2] = runQMDP(N);
        fprintf('QMDP:\n');
        fprintf('Looking at only the %i converged samples:\n', (N - unconverged));
        fprintf('\t number of steps => average=%f, deviation=%f\n',stepData.average,stepData.deviation);
        fprintf('\t reward => average=%f, deviation=%f\n',rewardData.average,rewardData.deviation);
        fprintf('Looking at all %i samples:\n', N);
        fprintf('\t number of steps => average=%f, deviation=%f\n',stepData2.average,stepData2.deviation);
        fprintf('\t reward => average=%f, deviation=%f\n',rewardData2.average,rewardData2.deviation);
    elseif (mmdp == 1)
        [PBMDPS10   ,PBMDPR10   ] = runPB(N, 10   );
        [PBMDPS100  ,PBMDPR100  ] = runPB(N, 100  );
        [PBMDPS1000 ,PBMDPR1000 ] = runPB(N, 1000 );
        [PBMDPS10000,PBMDPR10000] = runPB(N, 10000);

        fprintf('Point-based POMDP:\n');
        fprintf('1e1 belief samples: steps=[average=%f, deviation=%f], discountedReward=[average=%f, deviation=%f]\n', PBMDPS10.average   , PBMDPS10.deviation   , PBMDPR10.average   , PBMDPR10.deviation   );
        fprintf('1e2 belief samples: steps=[average=%f, deviation=%f], discountedReward=[average=%f, deviation=%f]\n', PBMDPS100.average  , PBMDPS100.deviation  , PBMDPR100.average  , PBMDPR100.deviation  );
        fprintf('1e3 belief samples: steps=[average=%f, deviation=%f], discountedReward=[average=%f, deviation=%f]\n', PBMDPS1000.average , PBMDPS1000.deviation , PBMDPR1000.average , PBMDPR1000.deviation );
        fprintf('1e4 belief samples: steps=[average=%f, deviation=%f], discountedReward=[average=%f, deviation=%f]\n', PBMDPS10000.average, PBMDPS10000.deviation, PBMDPR10000.average, PBMDPR10000.deviation);
    else
        [stepData,rewardData] = run(N,@sampleTrajectoriesMMDP_puppeteer);
        fprintf('MMDP puppeteer:\n');
        fprintf('\t number of steps => average=%f, deviation=%f\n',stepData.average,stepData.deviation);
        fprintf('\t reward => average=%f, deviation=%f\n',rewardData.average,rewardData.deviation); 

        [stepData,rewardData] = runNoQ(N,@sampleTrajectoriesMMDP_independent);
        fprintf('MMDP independent:\n');
        fprintf('\t number of steps => average=%f, deviation=%f\n',stepData.average,stepData.deviation);
        fprintf('\t reward => average=%f, deviation=%f\n',rewardData.average,rewardData.deviation);

        [stepData,rewardData] = runNoQ(N, @sampleTrajectoriesMMDP_independent_with_collisions);
        fprintf('MMDP independent with collisions:\n');
        fprintf('\t number of steps => average=%f, deviation=%f\n',stepData.average,stepData.deviation);
        fprintf('\t reward => average=%f, deviation=%f\n',rewardData.average,rewardData.deviation);
    end
end


function [stepData,rewardData] = run(N,f)
    l = 0;
    nbOfSteps = zeros(1,N);
    rewards = zeros(1,N);

    initProblem;

    
    Q=vi;
    
    unconverged=0;
    for i=1:N
       l = printProgress(l,i,N);
       [steps,r]=f(0,Q);
       
       nbOfSteps(i)=steps;
        rewards(i)=r;
        
       if (nbOfSteps(i)==200)
          unconverged=unconverged+1; 
       end
    end
    
    if (unconverged>0)
        fprintf('%i tests did not converge...\n',unconverged);
    end
    
    stepData=analyse(nbOfSteps,N);
    rewardData=analyse(rewards,N);
end

function [stepData,rewardData,unconverged,sD2,rD2] = runQMDP(N)
    l = 0;
    converged = zeros(1,N);
    nbOfsteps = zeros(1,N);
    rewards   = zeros(1,N);

    initProblem
    Q=vi;

    for i=1:N
        l = printProgress(l,i,N);
        [s,r,c]=sampleTrajectoriesQMDP(0,Q);

        nbOfSteps(i) = s;
        rewards(i)   = r;
        converged(i) = c;
    end

    nbConverged=sum(converged);
    unconverged = N - nbConverged;

    stepData = analyse(nbOfSteps(converged>0), nbConverged);
    rewardData = analyse(rewards(converged>0), nbConverged);

    sD2 = analyse(nbOfSteps, N);
    rD2 = analyse(rewards, N);
end

function [stepData,rewardData] = runNoQ(N,f)
    l = 0;
    nbOfSteps = zeros(1,N);
    rewards = zeros(1,N);

    initProblem;

    unconverged=0;
    for i=1:N
        l = printProgress(l,i,N);
        [steps,r]=f(0);
        
        nbOfSteps(i)=steps;
        rewards(i)=r;
        
        if (nbOfSteps(i)==200)
          unconverged=unconverged+1; 
       end
    end
    
    if (unconverged>0)
        fprintf('%i tests did not converge...\n',unconverged);
    end

    stepData=analyse(nbOfSteps,N);
    rewardData=analyse(rewards,N);
end

function [steps,discReward] = runPB(N,nbBeliefSamples)
    [nbOfSteps,discountedReward]=sampleTrajectoriesPointBased(0, 0, nbBeliefSamples, N);

    steps=analyse(nbOfSteps,N);
    discReward=analyse(discountedReward,N);
end

function [a] = analyse(data, N)
    a=struct;
    a.average = sum(data)/N;
    a.deviation = sqrt(sum((data-a.average).^2)/N);
end
