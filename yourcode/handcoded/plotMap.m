function [] = plotMap(xx,yy,orientation)
% Plots the map of the Hallway 2 problem together with the robots and
% their orientation.
%
% Input:
%   xx              -   x coordinate of the robot.
%   yy              -   y coordinate of the robot.
%   orientation     -   orientation for the robot


    map = [0 1 1 1 1 1 0;
           1 1 0 1 0 1 1;
           0 1 0 1 0 1 0;
           1 1 0 1 0 1 1;
           0 1 1 1 1 1 0]';
    [width,height]=size(map);
    
    axis([0 width 0 height]);
    axis equal;

    set(gca,'Visibl','off');
    for x=1:width
        for y=1:height
            if map(x,y)==1
                if (x==7&&y==4)
                    rectangle('Position',[x-1,height-y,1,1],'FaceColor','green');
                else
                    rectangle('Position',[x-1,height-y,1,1],'FaceColor','blue');
                end
            end
        end
    end

    hold on;
    rectangle('Position',[yy-0.75,height-xx+0.25,0.5,0.5],'FaceColor','red');

    if (orientation == 3)
    	rightTriangle(yy-0.5,height-xx+0.5);
	elseif(orientation == 2)
        downTriangle(yy-0.5,height-xx+0.5);
	elseif(orientation == 1)
        leftTriangle(yy-0.5,height-xx+0.5);
	elseif(orientation == 4)
        upTriangle(yy-0.5,height-xx+0.5);
    end
    hold off;
end

function [] = upTriangle(x, y)
    width = 0.4;
    height = 0.4;

    X=[0 width/2 width 0]+x-width/2;
    Y=[0 height 0 0]+y-height/2;

    fill(X,Y,'black');
end

function [] = downTriangle(x, y)
    width = 0.4;
    height = 0.4;

    X=[0 width/2 width 0]+x-width/2;
    Y=[height 0 height height]+y-height/2;

    fill(X,Y,'black');
end

function [] = rightTriangle(x, y)
    width = 0.4;
    height = 0.4;

    X=[0 width 0 0]+x-width/2;
    Y=[0 height/2 height 0]+y-height/2;

    fill(X,Y,'black');
end

function [] = leftTriangle(x, y)
    width = 0.4;
    height = 0.4;

    X=[width 0 width width]+x-width/2;
    Y=[0 height/2 height 0]+y-height/2;

    fill(X,Y,'black');
end

