function [steps] = hallway2hand(plot)
% function [steps] = hallway2hand(plot)
%
% the hand coded solution for the hallway2 problem. each location in the
% hallway is assigned a distance value based on the number of steps to 
% reach the goal. The robot is programmed to move to the next place with
% the lowest distance to the goal (based upon the algorithm of Dijkstra)
%
% input:
%   plot    -   whether the position of the robot should be plotted.
%
% ouput:
%   steps   -   number of required steps to reach the goal.
    hall = [-1  8  7  6  5  4 -1;
            10  9 -1  7 -1  3  4;
            -1  8 -1  6 -1  2 -1;
            8   7 -1  5 -1  1  0;
            -1  6  5  4  3  2 -1];
    endX = 4;
    endY = 7;    
    [x,y] = getStartPosition(hall);

    robot=struct;
    robot.orientation=randi(4);
    robot.x=x;
    robot.y=y;
    
    steps = 0;
    
    
    while(robot.x~=endX||robot.y~=endY) 
        steps = steps+1;
        robot = nextRobot(robot,hall);
        
        if (nargin>0&&plot==1)
            plotMap(robot.x,robot.y,robot.orientation);
            pause;
        end
    end
end

function [x,y] = getStartPosition(hall)
% function [x,y] = getStartPosition(hall)
% 
% samples a starting position using rejection sampling.
%
% input:
%   hall    -   matrix representing the hall.
%
% output:
%   x       -   starting x coordinate for the robot.
%   y       -   starting y coordinate for the robot.
    [m,n] = size(hall);

    finished = 0;

    while(finished == 0)
       x = randi(m);
       y = randi(n);

       if (hall(x,y)>=0)
           finished=1;
       end
    end
end

function [x,y] = bestNextPosition(robot,hall) 

[m,n]=size(hall);

best = 10000000;

    for i=-1:1
        for k=-1:1
            if (abs(i)+abs(k)~=1)
                continue;
            end

            xx=robot.x+i;
            yy=robot.y+k;

            if (xx<1||xx>m)
                continue;
            end
            if (yy<1||yy>n)
                continue;
            end

            val = hall(xx,yy);
            if (val<best&&val>=0)
                x = xx;
                y = yy;
                best = val;
            end
        end
    end
end

function [robot] = nextRobot(robot,hall) 
    [x,y] = bestNextPosition(robot,hall);
    
    if (y~=robot.y)
        if (y <robot.y)
            % Robot should move upwards
            if (robot.orientation == 1)
                robot.y=y;
            else
                if (robot.orientation == 2||robot.orientation==4)
                    robot.orientation = 1;
                else
                    robot.orientation = 2;
                end
            end
        else
            if (robot.orientation == 3)
                robot.y=y;
            else
                if (robot.orientation == 2||robot.orientation == 4)
                    robot.orientation=3;
                else
                    robot.orientation=2;
                end
            end
        end
    else 
        if (x<robot.x)
            if (robot.orientation==4)
                robot.x=x;
            else
               if (robot.orientation == 1||robot.orientation==3)
                   robot.orientation = 4;
               else
                   robot.orientation= 1;
               end
            end
        else
            if (robot.orientation==2)
                robot.x=x;
            else
                if (robot.orientation == 1||robot.orientation==3)
                   robot.orientation = 2;
               else
                   robot.orientation= 1;
                end
            end
        end
    end
end

