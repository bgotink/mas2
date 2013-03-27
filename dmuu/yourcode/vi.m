function [Q,iterations,time] = vi(nbOfIterations)
% Calculate the Q* matrix for the current problem.
%
% input:
%   nbOfIterations  -   the maximum number of value iterations
%                       (optional)
% output:
%   Q           -   the Q* matrix which gives the reward for applying an 
%                   action in a certain state.
%   iterations  -   required number of iterations before convergence.
%   time        -   required time to execute the iteration.

% Read the input arguments.
if nargin==0
    nbOfIterations = 10000;
end

global problem;
convergenceThreshold=1e-6;
startTime = tic;

Q = zeros(problem.nrStates,problem.nrActions);

if (problem.useSparse)
    for iterations=1:1:nbOfIterations
        OldQ = Q;
        maximumA = repmat(max(OldQ,[],2),1,problem.nrStates);

        for a=1:problem.nrActions
            temp = problem.transitionS{a}.*maximumA*problem.gamma;
            Q(:,a) = problem.rewardS{a}+sum(temp)';
        end
        
        delta = max(max(abs(OldQ-Q)));

        if (delta<convergenceThreshold)
            break;
        end
    end
else
    for iterations=1:1:nbOfIterations
        OldQ = Q;
        maximumA = repmat(max(OldQ,[],2),1,problem.nrStates);

        for a=1:problem.nrActions
            temp = problem.transition(:,:,a).*maximumA*problem.gamma;
            Q(:,a) = sum(temp);
        end
        
        Q=Q+problem.reward;
        delta=max(max(abs(OldQ-Q)));

        if (delta<convergenceThreshold)
            break;
        end
    end
end

time = toc(startTime);
