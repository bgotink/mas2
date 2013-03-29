function [x,y] = toXY(state)

if (state==15)
    x=8;
    y=2;
elseif (state==14)
    x=6;
    y=2;
elseif (state==13)
    x=4;
    y=2;
elseif (state == 12)
    x=1;
    y=1;
elseif (state == 1)
    x=1;
    y=1;
elseif (state>0)
    x = state-1;
    y = 1;
end

