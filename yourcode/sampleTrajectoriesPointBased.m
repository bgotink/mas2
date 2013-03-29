function [nbOfSteps,dsr] = sampleTrajectoriesPointBased(plot, Vcalculated, nbBeliefSamples, nbStartStates, nbSamples)
% sample a trajectoriy through the point based POMDP.
%
% input:
%   plot    -   whether the progress of the robot should be plotted. 
%                   (0 = no plot / 1 = plot)
%                   (optional parameter, defaults to 0)
%   V       -   you can pass a precomputed V matrix to avoid recalculation
%               in subsequent experiments.
%                   (optional)
%   nbBeliefSamples - the number of belief samples to take
%                     (if Vcalculated is not given or zero) 
%                     (optional, defaults to 100)
%   nbStartStates   - the number of start states to test
%                     (optional, defaults to 1)
%   nbSamples       - the number of samples per start state
%                     (optional, defaults to 1)
% output:
%   nbofsteps   -   number of steps needed to converge.
%                       (200 steps when not converged)
%   dsr         -   the discounted sum of rewards

% initialize the problem.

% read the input arguments.
if (nargin<2 || Vcalculated == 0)
    if (nargin<3), nbBeliefSamples=100; end;

    runvi(sampleBeliefs(nbBeliefSamples));
    global vi;

    V=vi.V;
else
    V=Vcalculated;
end;
if (nargin<4), nbStartStates=1; end;
if (nargin<5), nbSamples=1; end;

% sample the trajectory.
R=sampleRewards(V,nbStartStates,1000,nbSamples);
nbOfSteps=R(:,3)';
dsr=R(:,4)';

end


