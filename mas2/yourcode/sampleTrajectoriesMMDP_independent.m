function [nbofsteps] = sampleTrajectoriesMMDP_independent()
% sample a number of trajectories through the MDP, following the
% policy specified by Q.

global problem;

s1 = problem.agentStartLocations(1);
s2 = problem.agentStartLocations(2);

R1 = problem.rewardInd{1};
Q1 = viMMDP(1,R1);

end1 = problem.agentGoals(1);
end2 = problem.agentGoals(2);


nbofsteps = 0;
nrStates = sqrt(problem.nrStates);


for i=1:1000    
    
    [~,a1]=max(Q1(s1,:));

    s1 = sampleSuccessorState(s1,a1);
    
    R2 = problem.rewardInd{2};
    R2(s1,:)=-350;
    Q2 = viMMDP(2,R2);
    [~,a2]=max(Q2(s2,:));
    s2 = sampleSuccessorState(s2,a2);
    
    nbofsteps = nbofsteps+1;
    
    plotMapDetail([s1 s2]);
    pause(0.2);
    
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


