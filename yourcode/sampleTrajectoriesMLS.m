function [nbofsteps,dsr]=sampleTrajectoriesMLS(plot,Qcalculated)
% samples a trajectory through a POMDP problem with the MLS heuristic.
%
% input:
%   plot    -   whether the progress of the robot should be plotted. 
%                   (0 = no plot / 1 = plot)
%                   (optional parameter)
% output:
%   nbofsteps   -   number of steps needed to reach the final state.
%                       (1000 steps when not converged!)
%   dsr         -   the discounted sum of rewards

% initialize the problem.
clear problem;
initProblem;
global problem;

dsr=0;
terminalStates= getTerminalStates;
problem.state = sampleFromCDF(problem.startCum);

% read the input arguments.
if (nargin<2), Q=vi(); else Q=Qcalculated; end;

% sample the trajectory
for nbofsteps=1:200
    mls = getMostLikelyState(problem.belief);
    action = getActionForState(Q,mls);
    oldState = problem.state;
    problem.state = sampleSuccessorState(problem.state,action);
    observation = sampleObservation(problem.state,action);
    problem.belief = beliefUpdate(problem.belief,action,observation);
    
    if (nargin>0&&plot>0) 
        plotMap(problem.state,problem.belief,nbofsteps);
        if (plot>1),print(gcf,sprintf('step%i.png',nbofsteps),'-dpng');end;
        pause;
    end
        
    dsr = dsr + getReward(problem.state,oldState,action)*problem.gamma^(nbofsteps-1);
    if (find(terminalStates==problem.state)>0), break; end;
end

end

