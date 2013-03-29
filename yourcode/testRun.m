% <<<<<<< HEAD
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

    currentDir=dir;
    currentDirStruct = struct2cell(currentDir);

    if (any(ismember(currentDirStruct(1,:),'VQstar.mat')))
        load('VQstar.mat');
        Q=Qstar;
    elseif (any(ismember(currentDirStruct(1,:),'QMatrix.mat')))
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
        l = printProgress(l,i,N);
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
% =======
% function [] = testRun(N,mmdp,handcoded)
% % function testRun(N,algo,handcoded)
% %
% % input:
% %   N          -    the number of runs, defaults to 100
% %   algo       -    what algorithms to test, defaults to 0:
% %                     0 - test standard MDP, MLS and Q_MDP
% %                     1 - test point based POMDP
% %                     2 - test MMDP
% %   handcoded   -   whether the hand coded solution should be used as well, defaults to 0, only used if algo==0
% %
% % output:
% %       none
% 
%     if (nargin < 3), handcoded=0; end;
%     if (nargin < 2), mmdp=0; end;
%     if (nargin < 1), N=100; end;
% 
%     if (mmdp == 0)
%         if (handcoded==1)
%             [HANDA,HANDD] = run(N,@sampleTrajectoriesHandCoded);
%             fprintf('Handcoded: average=%f, deviation=%f\n',HANDA,HANDD);
%         end
%         
%         %[MDPA,MDPD] = run(N,@sampleTrajectoriesMDP);
%         %fprintf('MDP: average=%f, deviation=%f\n',MDPA,MDPD);
% 
%         [MLSA,MLSD] = run(N,@sampleTrajectoriesMLS);
%         fprintf('MLS: average=%f, deviation=%f\n',MLSA,MLSD);
%         
%         [QMDPA,QMDPD] = run(N,@sampleTrajectoriesQMDP);
%         fprintf('QMDP: average=%f, deviation=%f\n',QMDPA,QMDPD);
%     elseif (mmdp == 1)
%         [PBMDPA10   ,PBMDPD10   ] = runPB(N, 10   );
%         [PBMDPA100  ,PBMDPD100  ] = runPB(N, 100  );
%         [PBMDPA1000 ,PBMDPD1000 ] = runPB(N, 1000 );
%         [PBMDPA10000,PBMDPD10000] = runPB(N, 10000);
% 
%         fprintf('Point-based POMDP:\n');
%         fprintf('1e1 belief samples: average=%f, deviation=%f\n',PBMDPA10   ,PBMDPD10   );
%         fprintf('1e2 belief samples: average=%f, deviation=%f\n',PBMDPA100  ,PBMDPD100  );
%         fprintf('1e3 belief samples: average=%f, deviation=%f\n',PBMDPA1000 ,PBMDPD1000 );
%         fprintf('1e4 belief samples: average=%f, deviation=%f\n',PBMDPA10000,PBMDPD10000);
%     else
%         [MMDPA,MMDPD] = run(N,@sampleTrajectoriesMMDP_puppeteer);
%         fprintf('MMDP puppeteer: average=%f, deviation=%f\n',MMDPA,MMDPD);  
% 
%         [MMDPAi,MMDPDi] = runNoQ(N,@sampleTrajectoriesMMDP_independent);
%         fprintf('MMDP independent: average=%f, deviation=%f\n',MMDPAi,MMDPDi);  
% 
%         [MMDPAiwc,MMDPDiwc] = runNoQ(N, @sampleTrajectoriesMMDP_independent_with_collisions);
%         fprintf('MMDP independent with collisions: average=%f, deviation=%f\n',MMDPAiwc,MMDPDiwc);  
%     end
% end
% 
% 
% function [average,deviation] = run(N,f)
%     l = 0;
%     nbOfSteps = zeros(1,N);
% 
%     initProblem;
% 
%     if (exist('VQstar.mat'))
%         load('VQstar.mat');
%         Q=Qstar;
%     elseif (exist('QMatrix.mat'))
%         load('QMatrix.mat');
%     else
%         Q=vi;
%     end
%     
%     unconverged=0;
%     for i=1:N
%        l = printProgress(l,i,N);
%        nbOfSteps(i)=f(0,Q);
%        
%        if (nbOfSteps(i)==200)
%           unconverged=unconverged+1; 
%        end
%     end
%     
%     if (unconverged>0)
%         fprintf('%i tests did not converge...\n',unconverged);
%     end
%     
%     average = sum(nbOfSteps)/N;
%     deviation = sqrt(sum((nbOfSteps-average).^2)/N);
% end
% 
% function [average,deviation] = runNoQ(N,f)
%     l = 0;
%     nbOfSteps = zeros(1,N);
% 
%     initProblem;
% 
%     unconverged=0;
%     for i=1:N
%         %l = printProgress(l,i,N);
%         nbOfSteps(i)=f(0);
%         if (nbOfSteps(i)==200)
%           unconverged=unconverged+1; 
%        end
%     end
%     
%     if (unconverged>0)
%         fprintf('%i tests did not converge...\n',unconverged);
%     end
% 
%     average = sum(nbOfSteps)/N;
%     deviation = sqrt(sum((nbOfSteps-average).^2)/N);
% end
% 
% function [average,deviation] = runPB(N,nbBeliefSamples)
%     runvi(sampleBeliefs(nbBeliefSamples));
%     global vi;
% 
%     R=sampleRewards(vi.V,N,1000,1);
%     nbOfSteps=R(:,3)';
% 
%     average = sum(nbOfSteps)/N;
%     deviation = sqrt(sum((nbOfSteps-average).^2)/N);
% end
% >>>>>>> 17b10ac07a6cb2ab774c15ac8dbbb9aabd11133a
