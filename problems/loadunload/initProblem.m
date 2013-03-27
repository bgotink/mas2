function initProblem
% Courtesy of Niels Billen

clear global pomdp;
global problem;

problem.description='Load/Unload';
problem.unixName='loadunload';

problem = struct;
T = GetExampleT();
R = GetExampleReward();

problem.nrStates = 6;
problem.nrActions = 4;
problem.transition = T;
problem.reward = R;
problem.gamma = 0.95;
problem.useSparse = 0;

function [R] = GetExampleReward()
    R = zeros(6,4);
    R(6,4)=10;


function [T] = GetExampleT()
    T = zeros(6,6,4);
    T(1,1,1)=1;
    T(1,2,1)=1;
    T(2,3,1)=1;
    T(4,4,1)=1;
    T(4,5,1)=1;
    T(5,6,1)=1;
    
    T(2,1,2)=1;
    T(3,2,2)=1;
    T(3,3,2)=1;
    T(5,4,2)=1;
    T(6,5,2)=1;
    T(6,6,2)=1;
    
    T(4,1,3)=1;
    T(2,2,3)=1;
    T(3,3,3)=1;
    T(4,4,3)=1;
    T(5,5,3)=1;
    T(6,6,3)=1;
    
    T(1,1,4)=1;
    T(2,2,4)=1;
    T(3,3,4)=1;
    T(4,4,4)=1;
    T(5,5,4)=1;
    T(3,6,4)=1;

