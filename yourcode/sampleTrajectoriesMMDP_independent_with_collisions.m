function [nbofsteps,dsr] = sampleTrajectoriesMMDP_independent_with_collisions(plot)
% sample a trajectory through the MMDP. each of the robots will make
% independent decisions.
%
% input:
%   plot    -   whether the progress of the robot should be plotted. 
%                   (0 = no plot / 1 = plot)
%                   (optional parameter)
%
% output:
%   nbofsteps   -   number of steps needed to converge.
%                       (200 steps when not converged)

% initialize the problem
clear problem;
initProblem;
global problem;

dsr=0;

% initialize the start locations
s1 = problem.agentStartLocations(1);
s2 = problem.agentStartLocations(2);

% calculate the Q matrix for agent1
R1 = problem.rewardInd{1};
Q1 = viMMDP(1,R1);

% calculate the Q matrix for agent2
R2 = problem.rewardInd{2};
Q2 = viMMDP(2,R2);

% calculate the goal states
end1 = problem.agentGoals(1);
end2 = problem.agentGoals(2);

% sample the trajectory
for nbofsteps=1:200    
    % select the action for agent1
    [~,a1]=max(Q1(s1,:));
    s1 = sampleSuccessorState(s1,a1);
    
    % select the action for agent2
    [~,a2]=max(Q2(s2,:));
    s2 = sampleSuccessorState(s2,a2);
        
	if (nargin>0&&plot>0) 
        plotMap([s1 s2]);
        if (plot>1),print(gcf,sprintf('step%i.png',nbofsteps),'-dpng');end;
        pause;
	end
    
    dsr = dsr + (R2(s2,a2)+R1(s1,a1))*problem.gamma^(nbofsteps-1);
    if (s1==end1&&s2==end2), break; end;
end

end


