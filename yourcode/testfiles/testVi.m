function [ ] = testVi()

initProblem;

succes1=oneIteration();
succes2=twoIterations();
succes3=fourIterations();
succes4=final();

if (succes1&&succes2&&succes3&&succes4)
    fprintf('function vi works correctly\n');
else
    fprintf('error in function vi!\n');
end

end

function [succes] = oneIteration()
    Q = vi(1);
    Q1=zeros(6,4);
    Q1(6,4)=10;
    
    if max(max(abs(Q-Q1)))<0.1
       fprintf('Succesful after 1 iteration\n'); 
       succes=1;
    else
       fprintf('Failed after 1 iteration\n');
       succes=0;
    end
end

function [succes] = twoIterations()
    Q = vi(2);
    Q2=zeros(6,4);
    Q2(6,4)=10;
    Q2(6,3)=9.5;
    Q2(6,2)=9.5;
    Q2(5,2)=9.5;
    
    if max(max(abs(Q-Q2)))<0.1
       fprintf('Succesful after 2 iterations\n'); 
       succes=1;
    else
       fprintf('Failed after 2 iterations\n');
       disp(abs(Q-Q2));
       succes=0;
    end
end

function [succes] = fourIterations()
    Q = vi(4);
    Q5=zeros(6,4);
    Q5(6,4)=10;
    Q5(6,3)=9.5;
    Q5(6,2)=9.5;
    Q5(6,1)=9.03;
    Q5(5,1)=8.57;
    Q5(5,2)=9.5;
    Q5(5,3)=9.03;
    Q5(5,4)=9.03;
    Q5(4,1)=8.57;
    Q5(4,2)=9.03;
    Q5(4,3)=8.57;
    Q5(4,4)=8.57;
    Q5(1,3)=8.57;
    
    if max(max(abs(Q-Q5)))<0.1
       fprintf('Succesful after 4 iterations\n'); 
       succes=1;
    else
       fprintf('Failed after 4 iterations\n');
       disp(abs(Q-Q5));
       succes=0;
    end
end

function [succes] = final()
    Q = vi();
    Qf=[30.75 29.21 32.37 30.75;
        30.75 27.75 29.21 29.21;
        29.21 27.75 27.75 27.75;
        32.37 34.07 32.37 32.37;
        32.37 35.86 34.07 34.07;
        34.07 35.86 35.86 37.75];
    
    
    
    if max(max(abs(Q-Qf)))<0.1
       fprintf('Succesful convergence\n'); 
       succes=1;
    else
       fprintf('Failed to converge\n');
       disp(abs(Q-Qf));
       succes=0;
    end
end
