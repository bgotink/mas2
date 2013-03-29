function [] = testRun(N,mmdp,handcoded)
% function [] = testRun(N,mmdp,handcoded)
%
% samples the trajectories for the current problem with different
% algorithms, printing the average number of steps and the standard
% deviation.
%
%  input:
%   N           -   the number of trails (optional, 100 is default)
%   mmdp        -   whether the problem is an MMDP problem (optionan, default
%                   is false)
%   handcoded   -   whether the hand coded solution should be used as well.   

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
    else
        [MMDPA,MMDPD] = run(N,@sampleTrajectoriesMMDP_puppeteer);
        fprintf('MMDP: average=%f, deviation=%f\n',MMDPA,MMDPD);  
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
    
    average = sum(nbOfSteps)/N;
    deviation = sqrt(sum((nbOfSteps-average).^2)/N);
    
    if (unconverged>0)
        fprintf('%i tests did not converge...\n',unconverged);
    end
end
