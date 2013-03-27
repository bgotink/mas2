function s1 = sampleSuccessorState(s,a)
% Sample a successor state s1 (at t+1) given state s and action a at t

global problem;

if problem.useSparse==1
    s1=min(find(cumsum(problem.transitionS{a}(:,s))>rand));
else
    s1=min(find(cumsum(problem.transition(:,s,a))>rand));
end
