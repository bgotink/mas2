function b1 = beliefUpdate(b,a,o)
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

b1=zeros(1,problem.nrStates);

for j=1:problem.nrStates
    addition = 0;
    for i=1:problem.nrStates
        addition=addition+b(i)*problem.transition(j,i,a);
    end
    b1(j) = addition*problem.observation(j,a,o);
end
b1 = b1./sum(b1);


