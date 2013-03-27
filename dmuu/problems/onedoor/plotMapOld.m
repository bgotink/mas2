function [] = plotMap(s1,s2)

global problem;

[width,height] = size(problem.map);

position = zeros(width,height);
[x1,y1] = toXY(s1);
[x2,y2]= toXY(s2);

position(x1,y1)=1;
position(x2,y2)=2;

position(1,3)=0.5;
position(2,3)=0.5;
position(4,3)=0.5;
position(5,3)=0.5;

bar3(position,'detached','b');


end

