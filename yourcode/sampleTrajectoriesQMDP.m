function [nbofsteps,dsr,converged]=sampleTrajectoriesQMDP(plot,Qcalculated)
% sample a trajectoriy through the MDP with the QMDP heuristic.
%
% input:
%   plot    -   whether the progress of the robot should be plotted. 
%                   (0 = no plot / 1 = plot)
%                   (optional parameter)
%   Q       -   you can pass a precomputed Q matrix to avoid recalculation
%               in subsequent experiments.
%                   (optional)
% output:
%   nbofsteps   -   number of steps needed to converge.
%                       (200 steps when not converged)
%   dsr         -   the discounted sum of rewards
%   converged   -   1 if the goal state was reached, 0 otherwise

% Initialize the problem.
clear problem;
initProblem;
global problem;

dsr=0;
converged=0;
terminalStates= getTerminalStates;
problem.state = sampleFromCDF(problem.startCum);

% read the input arguments.
if (nargin<2), Q=vi(); else Q=Qcalculated; end;

% perform the iteration.
for nbofsteps=1:200
    action = getMostProfitableAction(problem.belief,Q);
    oldState= problem.state;
    problem.state = sampleSuccessorState(problem.state,action);
    observation = sampleObservation(problem.state,action);
    problem.belief = beliefUpdate(problem.belief,action,observation);
    
    if (nargin>0&&plot>0) 
        plotMap(problem.state,problem.belief);
        if (plot>1),print(gcf,sprintf('step%i.png',nbofsteps),'-dpng');end;
        pause;
    end
    
    dsr = dsr + getReward(problem.state,oldState,action)*problem.gamma^(nbofsteps-1);
    if (find(terminalStates==problem.state)>0), converged=1; break; end
end

end

