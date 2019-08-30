%model of the predator-prey relationship btwn immune system and cancer
clear; clc

%%
a1= 0.03; %cancer growth; same as in params.m
a2 = 0.01; %death

gamma0 = 1e-4; %sensitivity to immune predation
gamma1 = 0.03; %immune growth
gamma2 = 25; %immune steady state
gamma3 = 1e-1; %immune recruitment potential; from cancer-immune interaction
%gamma2+gamma3*x(1)*x(2) = carrying capacity



%% 
sol = dde23(@(t,x,Z) immune_ODEs(t,x,Z,a1,a2,gamma0,gamma1,gamma2,gamma3), 2, [1, gamma2], [0,5e4]);
%delay on immune system

figure(3)
plot(sol.x,sol.y, '-');
legend('cancer' ,'immune','cancer' ,'immune','cancer' ,'immune','cancer' ,'immune','cancer' ,'immune');

function dx = immune_ODEs(t,x,Z,a1,a2,gamma0,gamma1,gamma2,gamma3)

delta1 = 0.1; %compare with when delta1, delta2 = 1,2,...
delta2 = 0.1;
gamma0 = gamma0*(1/(1 + x(2)*delta1)); % insensitivity to immune predation
gamma3 = gamma3*(1/(1 + x(2)*delta2));

dx = [(a1-a2)*x(1) - gamma0*x(1)*x(2) ; %cancer "prey"
    gamma1*x(2)*(1-x(2)/(gamma2+gamma3*Z(1)*x(2)))]; %immune "predator"
end
