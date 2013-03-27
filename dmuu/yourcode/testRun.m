function [] = testRun(N)
    [MDPA,MDPD] = run(N,@sampleTrajectoriesMDP);
    %[MLSA,MLSD] = run(N,@sampleTrajectoriesMLS);
    %[QMDPA,QMDPD] = run(N,@sampleTrajectoriesQMDP);
    
    
    fprintf('MDP: average=%f, deviation=%f\n',MDPA,MDPD);
%    fprintf('MLS: average=%f, deviation=%f\n',MLSA,MLSD);
   %fprintf('QMDP: average=%f, deviation=%f\n',QMDPA,QMDPD);
    
end


function [average,deviation] = run(N,f)

    l = 0;
    nbOfSteps = zeros(1,N);

    initProblem;
    load('VQstar.mat');
    Q=Qstar;
    for i=1:N
        %l = printProgress(l,i,N);
        nbOfSteps(i)=f(0,Q);
    end
    
    average = sum(nbOfSteps)/N;
    
    deviation = sqrt(sum((nbOfSteps-average).^2)/N);
    
    
end



% sum = 0;
% 
% if (strcmp(test,'mls'))
%     for i=1:1000
%         [steps] = sampleTrajectoriesMLS(Q);
%         sum = sum+steps;
%     end
% elseif(strcmp(test,'mdp'))
%     for i=1:1000
%         [steps] = sampleTrajectoriesMDP(Q);
%         sum = sum+steps;
%     end
% elseif(strcmp(test,'qmdp'))
%     for i=1:1000
%         [steps] = sampleTrajectoriesQMDP(Q);
%         sum = sum+steps;
%     end
% else
%    sprintf('test is not known!');
% end
% 
% average = sum/1000;

