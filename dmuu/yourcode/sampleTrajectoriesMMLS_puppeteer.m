function [nbofsteps] = sampleTrajectoriesMMLS_puppeteer()
% sample a number of trajectories through the MDP, following the
% policy specified by Q.

% Initialize the problem.
clear problem;
initProblem;
global problem;
Q=vi();
problem.state = sampleFromCDF(cumsum(problem.start));
end1 = problem.agentGoals(1);
end2 = problem.agentGoals(2);

nbofsteps = 0;

for i=1:1000  
    
    mls = getMostLikelyState(problem.belief);
    action = getActionForState(Q,mls);
    problem.state = sampleSuccessorState(problem.state,action);
    
    observation = sampleObservation(problem.state,action);
    problem.belief = beliefUpdate(problem.belief,action,observation);
    
    [s1,s2] = splitMMDPagentStates(problem.state);
    
    plotMapDetail([s1 s2],problem.belief);
    pause(0.5);
    nbofsteps = nbofsteps+1;
    
    fprintf('robot 1 @ %d - robot 2 @ %d\n', s1, s2);
    
    if (s1==end1&&s2==end2)
        fprintf('Reach goal in %i steps\n',i);
        break;
    elseif (s1 == end1)
        fprintf('Robot 1 reached goal\n');
    elseif (s2 ==end2)
        fprintf('Robot 2 reached goal\n');
    end
end

end


