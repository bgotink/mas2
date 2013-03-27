function Q = viMMDP(index,R)
% Calculate the Q matrix from the problem.
global problem;
convergenceThreshold=1e-7;


nrStates=sqrt(problem.nrStates);
nrActions=sqrt(problem.nrActions);

transition = problem.transitionInd{index};


Q = zeros(nrStates,nrActions);

prevLength = 0;
n = 100000;

for o=1:n
    delta = 0;
    OldQ = Q;
    
    for i=1:nrStates
        for k=1:nrActions
            v = OldQ(i,k);
            sum = 0;
            maxima = max(OldQ,[],2);
            
            
            for s=1:nrStates
                maximum = maxima(s);
                sum = sum+transition(s,i,k)*maximum;
            end
           
            Q(i,k) = R(i,k) + problem.gamma * sum;
            
            delta = max(delta,abs(v-Q(i,k)));
        end
    end
    
    %prevLength=printProgress(prevLength,o,n);
    if (delta<convergenceThreshold)
       % fprintf('Stopped at iteration %i\n',o);
        break;
    end
end
