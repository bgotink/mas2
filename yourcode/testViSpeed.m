function [averageTime,averageIterations] = testViSpeed(N)

% Initialize the problem
clear problem;
initProblem;
global problem;


averageTime = 0;
averageIterations = 0;

length = 0;
for i=1:N
    
%    length = printProgress(length,i,N);
    [~,it,t] = vi();
    
    averageTime = averageTime + t;
    averageIterations = averageIterations + it;
end

averageTime = averageTime/N;
averageIterations = averageIterations/N;

