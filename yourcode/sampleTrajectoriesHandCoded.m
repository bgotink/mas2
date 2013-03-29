function [nbofsteps,dsr] = sampleTrajectoriesHandCoded(plot,Q)
% sample a trajectoriy through the MDP.
%
% input:
%   plot    -   whether the progress of the robot should be plotted. 
%                   (0 = no plot / 1 = plot)
%                   (optional parameter)
%   Q       -   precalculated Q matrix, used to check whether the action
%               differs.
% output:
%   nbofsteps   -   number of steps needed to converge.
%                       (200 steps when not converged)
%   dsr         -   the discounted sum of rewards

% initialize the problem.
clear problem;
initProblem;
global problem;

dsr=0;
terminalStates= getTerminalStates;
problem.state = sampleFromCDF(problem.startCum);

if (exist('handcodedactions.mat'))
    load('handcodedactions.mat');
else
    error('no hand coded actions available!');
end


% sample the trajectory.
for nbofsteps=1:200
	action = SA(problem.state);
    
    if (nargin>1)
        [~,Qaction] = max(Q(problem.state,:));
        if (action ~= Qaction)
            fprintf('hand coded policy prefers action %s over Q* policy action %s\n',actionToStr(action),actionToStr(Qaction));
        end
    end
    
    oldState = problem.state;
	problem.state = sampleSuccessorState(problem.state,action);

	if (nargin>0&&plot>0) 
        plotMap(problem.state);
        if (plot>1),print(gcf,sprintf('step%i.png',nbofsteps),'-dpng');end;
        pause;
    end

    dsr = dsr + getReward(problem.state,oldState,action)*problem.gamma^(nbofsteps-1);
	if find(terminalStates==problem.state)>0, break; end;
end

end


