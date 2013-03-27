function b2 = beliefUpdate(b,a,o)
% Update belief b to b1 by taking action a and receiving observation o.
% 
% input:
%   b   -   the current belief state.
%   a   -   last action which was undertaken.
%   o   -   last observation which was noticed.
%
% result:
%   b1  -   the updated belief vector.

global problem;

b2 = zeros(1,problem.nrStates);

if (problem.useSparse)
    for j=1:problem.nrStates
        b2(j) = sum(problem.transitionS{a}(j,:).*b)*problem.observationS{a}(j,o);
    end
else
    for j=1:problem.nrStates     
        b2(j) = sum(problem.transition(j,:,a).*b)*problem.observation(j,a,o);
    end
end
b2 = b2./sum(b2);


