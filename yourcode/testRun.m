function [] = testRun(N,mmdp)
% function testRun(N,mmdp)
%
% input:
%       N - the number of runs, defaults to 100
%       mmdp - what algorithms to test, defaults to 0:
%                     0 - test standard MDP, MLS and Q_MDP
%                     1 - test point based POMDP
%                     2 - test MMDP
%
% output:
%       none

    if (nargin < 2), mmdp=0; end;
    if (nargin < 1), N=100; end;
    if (mmdp==1 && nargin < 3), beliefSamples=10; end;

    if (mmdp == 0)
        [MDPA,MDPD] = run(N,@sampleTrajectoriesMDP);
        fprintf('MDP: average=%f, deviation=%f\n',MDPA,MDPD);

        [MLSA,MLSD] = run(N,@sampleTrajectoriesMLS);
        fprintf('MLS: average=%f, deviation=%f\n',MLSA,MLSD);
        
        [QMDPA,QMDPD] = run(N,@sampleTrajectoriesQMDP);
        fprintf('QMDP: average=%f, deviation=%f\n',QMDPA,QMDPD);
    elseif (mmdp == 1)
        [PBMDPA10   ,PBMDPD10   ] = runPB(N, 10   );
        [PBMDPA100  ,PBMDPD100  ] = runPB(N, 100  );
        [PBMDPA1000 ,PBMDPD1000 ] = runPB(N, 1000 );
        [PBMDPA10000,PBMDPD10000] = runPB(N, 10000);

        fprintf('Point-based POMDP:\n');
        fprintf('1e1 belief samples: average=%f, deviation=%f\n',PBMDPA10   ,PBMDPD10   );
        fprintf('1e2 belief samples: average=%f, deviation=%f\n',PBMDPA100  ,PBMDPD100  );
        fprintf('1e3 belief samples: average=%f, deviation=%f\n',PBMDPA1000 ,PBMDPD1000 );
        fprintf('1e4 belief samples: average=%f, deviation=%f\n',PBMDPA10000,PBMDPD10000);
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
    
    for i=1:N
        %l = printProgress(l,i,N);
        nbOfSteps(i)=f(0,Q);
    end
    
    average = sum(nbOfSteps)/N;
    deviation = sqrt(sum((nbOfSteps-average).^2)/N);
end

function [average,deviation] = runNoQ(N,f)
    l = 0;
    nbOfSteps = zeros(1,N);

    initProblem;

    for i=1:N
        %l = printProgress(l,i,N);
        nbOfSteps(i)=f(0);
    end
    
    average = sum(nbOfSteps)/N;
    deviation = sqrt(sum((nbOfSteps-average).^2)/N);
end

function [average,deviation] = runPB(N,nbBeliefSamples)
    runvi(sampleBeliefs(nbBeliefSamples));
    global vi;

    R=sampleRewards(vi.V,N,1000,1);
    nbOfSteps=R(:,3)';

    average = sum(nbOfSteps)/N;
    deviation = sqrt(sum((nbOfSteps-average).^2)/N);
end
