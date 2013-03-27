function [mls] = getMostLikelyState(beliefs)
% returns the most likely state from the current beliefs.
%
% input:
%   beliefs     -   the belief vector
%
% result:
%   mls         -   the most likely state the robot is in.

global problem;

% [~,mls]=max(beliefs);
mls = -1;
maximum = -1;

% iterate with a random permutation through the states to break ties in
% states with equal probability.
for i = randperm(problem.nrStates)
    if (beliefs(i)>maximum)
        mls = i;
        maximum = beliefs(i);
    end
end


end

