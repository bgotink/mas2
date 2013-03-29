function [nbofsteps,dsr] = sampleTrajectoriesMMDP_puppeteer(plot,Qcalculated)
% sample a trajectoriy through the MMDP in which one agent controls all the
% other agents.
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

% initialize the problem.
clear problem;
initProblem;
global problem;

dsr = 0;
problem.state = sampleFromCDF(cumsum(problem.start));
end1 = problem.agentGoals(1);
end2 = problem.agentGoals(2);

% read the input arguments.
if (nargin<2), Q=vi(); else Q=Qcalculated; end;

for nbofsteps=1:200    
    a = getActionForState(Q,problem.state);
    oldState = problem.state;
    problem.state = sampleSuccessorState(problem.state,a);
    [s1,s2] = splitMMDPagentStates(problem.state);
    
    if (nargin>0&&plot>0) 
        plotMap([s1 s2]);
        if (plot>1),print(gcf,sprintf('step%i.png',nbofsteps),'-dpng');end;
        pause;
    end
    
    dsr = dsr + getReward(problem.state,oldState,a)*problem.gamma^(nbofsteps-1);
    if (s1==end1&&s2==end2),break; end
end

end


