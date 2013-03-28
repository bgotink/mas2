function initProblem
% Problem specific initialization function for Hallway2.
% $Id: initProblem.m,v 1.10 2004/09/20 15:03:53 mtjspaan Exp $

clear global pomdp;
global problem;
global pomdp;

% String describing the problem.
problem.description='Hallway2';

% String used for creating filenames etc.
problem.unixName='hallway2';

% Use sparse matrix computation.
problem.useSparse=1;
% Use a full observation model.
problem.useSparseObs=1;

% Load the (cached) .POMDP, defaults to unixName.POMDP.
initPOMDP;

% Generic POMDP initialization code. Should be called after initPOMDP.
initProblemGeneric;

% Hallway2.POMDP does not list the action by name, so we provide them
% here.
problem.actions=char('Stay in place','Move forward','Turn right',['Turn ' ...
                    'around'],'Turn left');
                
problem.rewardS = sparse(problem.reward);
% Compute the observation CDF
for a=1:problem.nrActions
    problem.observationCum{a}=cumsum(problem.observationS{a});
end