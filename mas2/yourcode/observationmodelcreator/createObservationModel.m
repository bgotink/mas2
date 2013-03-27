function [observation ] = createObservationModel(map,goalstates,nrStates,nrActions)

observation = zeros(nrStates,nrActions,17);

for s=1:nrStates
    for a=1:nrActions
        if (ismember(goalstates,s))
            observation(s,a,17)=1;
        else
            [x,y] = toXY(s);
            o = identifyObservation(map,x,y);
            observation(s,a,o+1)=1;
        end
    end
end


end

