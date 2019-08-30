%predator-prey btwn immune system and cancer
clear; clc

a1= 0.3; %cancer growth
a2 = 0.1; %death
gamma1 = 1e-4; %sensitivity to immune predation


v3 = 0.3; %immune growth

ie = 100; %immune homeostatic state
mu = 1e-3; %immune 'recruitment potential'

sol = ode23s(@(t,x) immune_ODEs(t,x,a1,a2,gamma1,v3,ie,mu), [0,1000], [1, 1]);

figure(3)
plot(sol.x,sol.y, '-');
legend('cancer' ,'immune');

function dx = immune_ODEs(t,x,a1,a2,gamma1,v3,ie,mu)
dx = [(a1-a2)*x(1) - gamma1*x(1)*x(2) ; %cancer "prey"
      v3*x(2)*(1-x(2)/(ie+mu*x(1)*x(2)))]; %immune "predator"
end
