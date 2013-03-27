function [Q,iterations,time] = viMMDP(index,R,nbOfIterations)
% Calculate the Q* matrix for an MMDP problem with two agents.
%
% input:
%   index           -   index of the agent to create the Q* matrix for.
%   R               -   the reward matrix which should be used for (if none
%                       is passed, the default will be used)
%   nbOfIterations  -   the maximum number of value iterations
%                       (optional)
% output:
%   Q           -   the Q* matrix which gives the reward for applying an 
%                   action in a certain state.
%   iterations  -   required number of iterations before convergence.
%   time        -   required time to execute the iteration.

global problem;

% Read the input arguments.
if nargin<3
    nbOfIterations = 10000;
end
if nargin<1
    R=problem.rewardInd{index};
end

startTime = tic;
convergenceThreshold=1e-6;
nrStates=sqrt(problem.nrStates);
nrActions=sqrt(problem.nrActions);
transition = problem.transitionInd{index};

Q = zeros(nrStates,nrActions);

for iterations=1:1:nbOfIterations
	OldQ = Q;
	maximumA = repmat(max(OldQ,[],2),1,nrStates);
    
    for a=1:nrActions
        Q(:,a) = sum(transition(:,:,a).*maximumA*problem.gamma);
    end
        
	Q=Q+R;
	delta=max(max(abs(OldQ-Q)));

	if (delta<convergenceThreshold)
        break;
	end
end

time = toc(startTime);
% for iterations=1:nbOfIterations
%     delta = 0;
%     OldQ = Q;
%     
%     for i=1:nrStates
%         for k=1:nrActions
%             v = OldQ(i,k);
%             sum = 0;
%             maxima = max(OldQ,[],2);
%             
%             
%             for s=1:nrStates
%                 maximum = maxima(s);
%                 sum = sum+transition(s,i,k)*maximum;
%             end
%            
%             Q(i,k) = R(i,k) + problem.gamma * sum;
%             
%             delta = max(delta,abs(v-Q(i,k)));
%         end
%     end
%     
%     if (delta<convergenceThreshold),break; end;
% end
