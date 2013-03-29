function [average,deviation] = testHallway2Hand(N)

length = 0;
nbOfSteps = zeros(1,N);

for i=1:N
    
    length = printProgress(length,i,N);
    nbOfSteps(i) = hallway2hand;
end

average = sum(nbOfSteps)/N;
deviation = sqrt(sum((nbOfSteps-average).^2)/N);

