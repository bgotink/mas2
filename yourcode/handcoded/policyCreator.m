function [stateaction] = policyCreator()

clear problem;
initProblem;
global problem;

stateaction = zeros(1,problem.nrStates);

for s=1:problem.nrStates
    
    plotMap(s);
    stateaction(s) = input('which action? 0=stay,1=forward,2=right,3=around,4=left\n');
    
    
end


end

