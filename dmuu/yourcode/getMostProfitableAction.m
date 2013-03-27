function [action] = getMostProfitableAction(beliefs,Q)
% returns the most profitable action in the current belief state and using
% the value matrix Q.
%
% input:
%   beliefs     -   the current belief state
%   Q           -   the matrix which gives the reward for performing an
%                   action in a state.
%
% return:
%   action      -   the most profitable action.


global problem;
best=-1e6;
action=-1;
% Iterate over the actions with a random permutation to break ties from
% actions with an equal reward.

for a=randperm(problem.nrActions)
    sum = 0;  
    for s = 1:problem.nrStates
       sum = sum + beliefs(s)*Q(s,a);
    end
    
    if (sum > best)
       best = sum;
       action = a;
    end
end

end

