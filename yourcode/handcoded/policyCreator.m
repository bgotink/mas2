function [stateaction] = policyCreator()
% function [stateaction] = policyCreator()
%
% this function allows the user to easily create a handcoded policy for the
% hallway2 problem. It iterates over all the states of the problem,
% visually plots the state and requests the best action for that state.
%
% output:
%   stateaction     -   a matrix which contains the best action for each
%                       state.
clear problem;
initProblem;
global problem;

stateaction = zeros(1,problem.nrStates);

for s=1:problem.nrStates
    plotMap(s);
    stateaction(s) = input('which action? 0=stay,1=forward,2=right,3=around,4=left\n')+1;
end

end

