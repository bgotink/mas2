function [average] = testHallway2Hand()

sum = 0;

length = 0;
for i=1:1000
    
    length = printProgress(length,i,1000);
    steps = hallway2hand;
    sum = sum+steps;
end

average = sum/1000;

