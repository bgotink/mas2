function [Q,iterations,time] = viQMDP(nbOfIterations,beliefs)
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
    nbOfIterations = 100000;
end

global problem;
convergenceThreshold=1e-6;
startTime = tic;

Q = zeros(problem.nrStates,problem.nrActions);

for iterations=1:1:nbOfIterations
    delta = 0;
    OldQ = Q;
    maximumA(1:problem.nrStates) = max(OldQ,[],2);

    for s=1:problem.nrStates
        for a=1:problem.nrActions
            v = OldQ(s,a);
            sum = 0;
            
            for ss=1:problem.nrStates
                sum = sum+problem.transition(ss,s,a)*maximumA(ss);
            end
            
            Q(s,a) = problem.reward(s,a)*beliefs(s)+ problem.gamma * sum;
            
            delta = max(delta,abs(v-Q(s,a)));
        end
    end
    
    if (delta<convergenceThreshold)
        break;
    end
end

time = toc(startTime);
