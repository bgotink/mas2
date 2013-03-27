function [] = testRun(N)
%    [MDPA,MDPD] = run(N,@sampleTrajectoriesMDP);
%    [MLSA,MLSD] = run(N,@sampleTrajectoriesMLS);
%    [QMDPA,QMDPD] = run(N,@sampleTrajectoriesQMDP);
    [MMDPA,MMDPD] = run(N,@sampleTrajectoriesMMDP_puppeteer);
    
    
%    fprintf('MDP: average=%f, deviation=%f\n',MDPA,MDPD);
%    fprintf('MLS: average=%f, deviation=%f\n',MLSA,MLSD);
%    fprintf('QMDP: average=%f, deviation=%f\n',QMDPA,QMDPD);
    fprintf('MMDP: average=%f, deviation=%f\n',MMDPA,MMDPD);  
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
