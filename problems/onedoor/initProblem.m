function initProblem
% $Id: initProblem.m,v 1.5 2003/12/09 17:27:16 mtjspaan Exp $

clear global pomdp;
global problem;
global pomdp;

problem.description='OneDoor';
problem.unixName='onedoor';

problem.randomSeed=sum(100*clock);
rand('state',problem.randomSeed); % seed the random number generator

problem.map=[
1,2,0,12,13;
3,4,0,14,15;
5,6,11,16,17;
7,8,0,18,19;
9,10,0,20,21;
            ];

problem.agentGoals=[13 9];
problem.agentStartLocations=[1 21];
problem.useSparseReward=1;
problem.useReward3=0;

initIDMG('h');


problem.startCum = cumsum(problem.start);
problem.belief = ones(1,problem.nrStates)./problem.nrStates;

problem.useSparse=1;
for a=1:problem.nrActions
    problem.transitionS{a} = sparse(problem.transition(:,:,a));
    problem.rewardS{a}= sparse(problem.reward(:,a));
end
%problem.observation = createObservationModel(problem.map,problem.agentGoals,problem.nrStates,problem.nrActions);