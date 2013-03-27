function [averageTime,averageIterations] = testViSpeed(N)
% function [averageTime,averageIterations] = testViSpeed(N)
%
% tests the speed of the value-iteration process by averaging the times and
% iterations over N runs.
%
% input:
%   N   -   the number of test runs.
% 
% output:
%   averageTime         -   the average time to perform one value iteration
%   averageIterations   -   the average number of iterations for a value
%                           iteration.
clear problem;
initProblem;

averageTime = 0;
averageIterations = 0;

length = 0;
for i=1:N
    length = printProgress(length,i,N);
    [~,it,t] = vi();
    
    averageTime = averageTime + t;
    averageIterations = averageIterations + it;
end

averageTime = averageTime/N;
averageIterations = averageIterations/N;

