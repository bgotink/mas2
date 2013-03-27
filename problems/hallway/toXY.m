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
else
    x = mod(state,13)-1;
    y = floor(state/13)+1;
end

