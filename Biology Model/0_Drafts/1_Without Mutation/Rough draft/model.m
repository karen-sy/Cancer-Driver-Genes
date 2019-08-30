clear
clc

parameters
feedbacks
   
%% solve
sol = ode23(@(t,x) ODE_no_mutation(t,x,S,v0,a0,K,T,m), [0, 10000], [1.5e5, 0, 1e10]); %function / tspan / initial

plot(sol.x, sol.y(1:2, :), '.-');
axis tight;
legend('Normal Cell', 'Mutated Cell');


   