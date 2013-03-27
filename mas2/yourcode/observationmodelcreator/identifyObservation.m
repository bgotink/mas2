function [o] = identifyObservation(map,x,y)

[m,n]=size(map);

wallId=0;
wallAbove = 0;
wallBelow = 0;
wallLeft=0;
wallRight=0;
if (y==1)
    wallLeft = 1;
elseif (map(x,y-1)==wallId)
    wallLeft=1;
end

if (y==n)
    wallRight=1;
elseif (map(x,y+1)==wallId)
    wallRight=1;
end

if(x==1)
    wallAbove=1;
elseif (map(x-1,y)==wallId)
    wallAbove=1;
end

if(x==m)
    wallBelow=1;
elseif(map(x+1,y)==wallId)
    wallBelow=1;
end
    o=wallLeft+2*wallRight+4*wallBelow+8*wallAbove;

end

