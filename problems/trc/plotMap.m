function [] = plotMap(states, beliefstate)
% Plots the map of the Hallway 2 problem together with the robots and
% their orientation.
%
% Input:
%   states  -   1xm matrix with the states of the robots to draw.
    clf;
    if (nargin > 1)
        subplot(1,2,1);
    end
    
    global problem;
    
    terminalStates = getTerminalStates();
    XX = problem.MS(:,1);
    YY = problem.MS(:,2);
    scatter(XX,YY,35,'b');
   
    hold on;
    for s = terminalStates
        [x,y] = toXY(s);
        scatter(x,y,40,'g','fill');
    end
    
    for s=states
        [x,y] = toXY(s);
        scatter(x,y,35,'r','fill');
    end
    hold off;
    
    if (nargin>1)
        subplot(1,2,2);
        plot(beliefstate);
    end
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