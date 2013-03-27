function [nbofsteps] = sampleTrajectoriesMDP(plot, Qcalculated)
% sample a trajectoriy through the MDP.
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

% initialize the problem.
clear problem;
initProblem;
global problem;

terminalStates= getTerminalStates;
problem.state = sampleFromCDF(problem.startCum);

% read the input arguments.
if (nargin<2), Q=vi(); else Q=Qcalculated; end;

% sample the trajectory.
for nbofsteps=1:200
	action = getActionForState(Q,problem.state);
	problem.state = sampleSuccessorState(problem.state,action);

	if (nargin>0&&plot>0) 
        plotMap(problem.state);
        if (plot>1),print(gcf,sprintf('step%i.png',nbofsteps),'-dpng');end;
        pause;
	end

	if find(terminalStates==problem.state)>0, break; end;
end

end


