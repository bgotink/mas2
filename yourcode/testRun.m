function [] = testRun(N,mmdp,handcoded)
% function testRun(N,algo,handcoded)
%
% input:
%   N          -    the number of runs, defaults to 100
%   algo       -    what algorithms to test, defaults to 0:
%                     0 - test standard MDP, MLS and Q_MDP
%                     1 - test point based POMDP
%                     2 - test MMDP
%   handcoded   -   whether the hand coded solution should be used as well, defaults to 0, only used if algo==0
%
% output:
%       none

    if (nargin < 3), handcoded=0; end;
    if (nargin < 2), mmdp=0; end;
    if (nargin < 1), N=100; end;

    if (mmdp == 0)
        if (handcoded==1)
            [HANDA,HANDD] = run(N,@sampleTrajectoriesHandCoded);
            fprintf('Handcoded: average=%f, deviation=%f\n',HANDA,HANDD);
        end
        
        %[MDPA,MDPD] = run(N,@sampleTrajectoriesMDP);
        %fprintf('MDP: average=%f, deviation=%f\n',MDPA,MDPD);

        [MLSA,MLSD] = run(N,@sampleTrajectoriesMLS);
        fprintf('MLS: average=%f, deviation=%f\n',MLSA,MLSD);
        
        [QMDPA,QMDPD] = run(N,@sampleTrajectoriesQMDP);
        fprintf('QMDP: average=%f, deviation=%f\n',QMDPA,QMDPD);
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
        [MMDPA,MMDPD] = run(N,@sampleTrajectoriesMMDP_puppeteer);
        fprintf('MMDP puppeteer: average=%f, deviation=%f\n',MMDPA,MMDPD);  

        [MMDPAi,MMDPDi] = runNoQ(N,@sampleTrajectoriesMMDP_independent);
        fprintf('MMDP independent: average=%f, deviation=%f\n',MMDPAi,MMDPDi);  

        [MMDPAiwc,MMDPDiwc] = runNoQ(N, @sampleTrajectoriesMMDP_independent_with_collisions);
        fprintf('MMDP independent with collisions: average=%f, deviation=%f\n',MMDPAiwc,MMDPDiwc);  
    end
end


function [average,deviation] = run(N,f)
    l = 0;
    nbOfSteps = zeros(1,N);

    initProblem;

    if (exist('VQstar.mat'))
        load('VQstar.mat');
        Q=Qstar;
    elseif (exist('QMatrix.mat'))
        load('QMatrix.mat');
    else
        Q=vi;
    end
    
    unconverged=0;
    for i=1:N
       l = printProgress(l,i,N);
       nbOfSteps(i)=f(0,Q);
       
       if (nbOfSteps(i)==200)
          unconverged=unconverged+1; 
       end
    end
    
    if (unconverged>0)
        fprintf('%i tests did not converge...\n',unconverged);
    end
    
    average = sum(nbOfSteps)/N;
    deviation = sqrt(sum((nbOfSteps-average).^2)/N);
end

function [average,deviation] = runNoQ(N,f)
    l = 0;
    nbOfSteps = zeros(1,N);

    initProblem;

    unconverged=0;
    for i=1:N
        %l = printProgress(l,i,N);
        nbOfSteps(i)=f(0);
        if (nbOfSteps(i)==200)
          unconverged=unconverged+1; 
       end
    end
    
    if (unconverged>0)
        fprintf('%i tests did not converge...\n',unconverged);
    end

    average = sum(nbOfSteps)/N;
    deviation = sqrt(sum((nbOfSteps-average).^2)/N);
end

function [steps,discReward] = runPB(N,nbBeliefSamples)
    runvi(sampleBeliefs(nbBeliefSamples));
    global vi;

    R=sampleRewards(vi.V,N,1000,1);
    nbOfSteps=R(:,3)';
    discountedReward=R(:,4)';

    steps=struct;
    [steps.average,steps.deviation]=analyse(nbOfSteps,N);

    discReward=struct;
    [discReward.average,discReward.deviation]=analyse(discountedReward,N);
end

function [average,deviation] = analyse(data, N)
    average = sum(data)/N;
    deviation = sqrt(sum((data-average).^2)/N);
end
