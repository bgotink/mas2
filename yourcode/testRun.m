function [] = testRun(N,mmdp)

    if (nargin < 2), mmdp=0; end;
    if (nargin < 1), N=100; end;

    if (mmdp == 0)
        [MDPA,MDPD] = run(N,@sampleTrajectoriesMDP);
        fprintf('MDP: average=%f, deviation=%f\n',MDPA,MDPD);

        [MLSA,MLSD] = run(N,@sampleTrajectoriesMLS);
        fprintf('MLS: average=%f, deviation=%f\n',MLSA,MLSD);
        
        [QMDPA,QMDPD] = run(N,@sampleTrajectoriesQMDP);
        fprintf('QMDP: average=%f, deviation=%f\n',QMDPA,QMDPD);
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
