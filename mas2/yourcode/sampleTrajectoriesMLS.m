function [nbofsteps]=sampleTrajectoriesMLS(plot)
% samples a trajectory through a POMDP problem with the MLS heuristic.
%
% input:
%   plot    -   whether the progress of the robot should be plotted. 
%               (0 = no plot / 1 = plot)
%               (optional parameter)
% output:
%   nbofsteps   -   number of steps needed to reach the final state.
%                   (1000 steps when not converged!)

% Initialize the problem.
clear problem;
initProblem;
global problem;
Q=vi();
terminalStates= getTerminalStates;
problem.state = sampleFromCDF(problem.startCum);

% perform the iteration
for nbofsteps=1:1000
    mls = getMostLikelyState(problem.belief);
    action = getActionForState(Q,mls);
   
    problem.state = sampleSuccessorState(problem.state,action);
    
    observation = sampleObservation(problem.state,action);
    problem.belief = beliefUpdate(problem.belief,action,observation);
    
    if (nargin>0&&plot~=0)
        plotMap(problem.state,problem.belief);
        pause(0.5);
    end
        
    if (find(terminalStates==problem.state)>0)
        break;
    end
end

end

