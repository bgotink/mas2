function [o] = sampleObservation(state,action)
% samples an observation resulting from taking the given action in the
% given state
%
% input:
%   state   -   state the action was taken in
%   action  -   the action taken by the robot
%
% output:
%   o   -   the observation resulting from taking the given action in the
%   given state

global problem;

if (problem.useSparse==1)
    
    temp = problem.observationS{action};
    [~,n]=size(temp);
    chances(1:n) = temp(state,:);
else
    [~,~,n]=size(problem.observation);
    chances(1:n) = problem.observation(state,action,:);
end

o=min(find(cumsum(chances/sum(chances))>=rand(1)));    


end

