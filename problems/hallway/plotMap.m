function [] = plotMap(states)
% % Plots the map of the Hallway 2 problem together with the robots and
% % their orientation.
% %
% % Input:
% %   states  -   1xm matrix with the states of the robots to draw.
% 
% 
%     terminalStates = getTerminalStates();
% 
%     map = [1 1 1 1 1 1 1 1 1 1 1;
%            0 0 1 0 1 0 1 0 1 0 0]';
%     [width,height]=size(map);
%     axis([0 width 0 height]);
%     axis equal;
%     set(gca,'Visible','off');
% 
%     for x=1:width
%         for y=1:height
%             if map(x,y)==1
%                 terminal=0;
%                 for s=terminalStates
%                    [state,~]=splitStateOrientation(s);
%                    [xxx,yyy]=toXY(state);
%                    if (xxx==x&&yyy==y)
%                        terminal=1;
%                        break;
%                    end
%                 end
%                     
%                 if (terminal==1)
%                     rectangle('Position',[x-1,y-1,1,1],'FaceColor','green');
%                 else
%                     rectangle('Position',[x-1,y-1,1,1],'FaceColor','blue');
%                 end
%             end
%         end
%     end
% 
%     hold on;
%     for s=states
% 
%         [state,orientation]=splitStateOrientation(s);
%         [x,y] = toXY(state);
%         rectangle('Position',[x-0.75,y-0.75,0.5,0.5],'FaceColor','red');
% 
%         if (orientation == 2)
%             rightTriangle(x-0.5,y-0.5);
%         elseif(orientation == 3)
%             downTriangle(x-0.5,y-0.5);
%         elseif(orientation == 4)
%             leftTriangle(x-0.5,y-0.5);
%         elseif(orientation == 1)
%             upTriangle(x-0.5,y-0.5);
%         end
%     end
%     hold off;
% end
% 
% function [] = upTriangle(x, y)
%     width = 0.4;
%     height = 0.4;
% 
%     X=[0 width/2 width 0]+x-width/2;
%     Y=[0 height 0 0]+y-height/2;
% 
%     fill(X,Y,'black');
% end
% 
% function [] = downTriangle(x, y)
%     width = 0.4;
%     height = 0.4;
% 
%     X=[0 width/2 width 0]+x-width/2;
%     Y=[height 0 height height]+y-height/2;
% 
%     fill(X,Y,'black');
% end
% 
% function [] = rightTriangle(x, y)
%     width = 0.4;
%     height = 0.4;
% 
%     X=[0 width 0 0]+x-width/2;
%     Y=[0 height/2 height 0]+y-height/2;
% 
%     fill(X,Y,'black');
% end
% 
% function [] = leftTriangle(x, y)
%     width = 0.4;
%     height = 0.4;
% 
%     X=[width 0 width width]+x-width/2;
%     Y=[0 height/2 height 0]+y-height/2;
% 
%     fill(X,Y,'black');
% end

