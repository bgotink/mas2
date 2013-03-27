function [nbofsteps]=sampleTrajectoriesQMDP(plot)
% samples a trajectory through a POMDP problem with the QMDP heuristic.
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
terminalStates= getTerminalStates;
problem.state = sampleFromCDF(problem.startCum);

Q=vi();
% perform the iteration.
for nbofsteps=1:1000
    action = getMostProfitableAction(problem.belief,Q);
    %x=repmat(problem.belief',1,size(Q,2));
    %QMDP = Q.*x;
    %action = getActionForState(QMDP,problem.state); 
    problem.state = sampleSuccessorState(problem.state,action);
    observation = sampleObservation(problem.state,action);
    problem.belief = beliefUpdate(problem.belief,action,observation);
    
    if (nargin>0&&plot~=0)
        plotMap(problem.state,problem.belief);
        pause;
    end
    
    if (find(terminalStates==problem.state)>0)
        fprintf('Reach goal in %i steps\n',nbofsteps);
        break;
    end
end

end

