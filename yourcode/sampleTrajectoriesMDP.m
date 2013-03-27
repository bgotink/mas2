function [nbofsteps] = sampleTrajectoriesMDP(plot, Q)
% sample a number of trajectories through the MDP using the value matrix Q.
%
% input:
%   plot    -   whether the robot should be plotted
%               (optional)
%   Q       -   you can pass a precomputed Q matrix to avoid recalculation
%               in subsequent experiments.
% output:
%   nbofsteps   -   number of steps needed to converge.

% Initialize the problem
clear problem;
initProblem;
global problem;

if (nargin<2)
    Q=vi();
end

terminalStates= getTerminalStates;
problem.state = sampleFromCDF(problem.startCum);
fprintf('start state: %i\n',problem.state);

for nbofsteps=1:200
	action = getActionForState(Q,problem.state);
	problem.state = sampleSuccessorState(problem.state,action);

	if (nargin>0&&plot>0) 
        plotMap(problem.state);
        if (plot>1)
            print(gcf,sprintf('step%i.png',nbofsteps),'-dpng');
        end
        pause;
	end


	if find(terminalStates==problem.state)>0
        break;
	end  
end

end


