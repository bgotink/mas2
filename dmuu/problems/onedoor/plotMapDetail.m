function [] = plotMapDetail(states, beliefstate)
% Plots the map of the Hallway 2 problem together with the robots and
% their orientation.
%
% Input:
%   states  -   1xm matrix with the states of the robots to draw.
global problem;
    clf;
    if (nargin > 1)
        subplot(1,2,1);
    end

    map = [1 1 0 1 1;
            1 1 0 1 1;
            1 1 1 1 1;
            1 1 0 1 1;
            1 1 0 1 1];
    [width,height]=size(map);
    axis([0 width 0 height]);
    axis equal;
    set(gca,'Visible','off');

    index=0;
    colors = ['r','g'];
    for x=1:width
        for y=1:height
            if map(x,y)==1
                terminal=0;
                for s=problem.agentGoals
                   [xxx,yyy]=toXY(s);
                   
                   if (xxx==x&&yyy==y)
                       terminal=1;
                       index=index+1;
                       break;
                   end
                end
                    
                if (terminal==1)
                    rectangle('Position',[x-1,y-1,1,1],'FaceColor',colors(index));
                else
                    rectangle('Position',[x-1,y-1,1,1],'FaceColor','blue');
                end
            end
        end
    end

    hold on;
    index=1;
    for s=states
        [x,y] = toXY(s);
        rectangle('Position',[x-0.75,y-0.75,0.5,0.5],'FaceColor',colors(index));
        index=index+1;
    end
    hold off;
    
    if (nargin>1)
        subplot(1,2,2);
        [~,d]=size(beliefstate);

        belief=zeros(7*2,5*2);

        for i=1:d
          [s,or]=splitStateOrientation(i);
          [x,y]=toXY(s);
          switch orientationToStr(or)
           case 'north'
            ox=0;
            oy=0;
           case 'east'
            ox=0;
            oy=1;
           case 'south'
            ox=1;
            oy=0;
           case 'west'
            ox=1;
            oy=1;
          end

          belief(x*2-ox,y*2-oy)=beliefstate(i);
        end

        bar3(belief,1,'detached','b');
        [maxX maxY]=size(belief);
        set(gca,'XLim',[0 maxY+1]);
        set(gca,'YLim',[0 maxX+1]);
        set(gca,'ZLim',[0 1]);
    end
end

