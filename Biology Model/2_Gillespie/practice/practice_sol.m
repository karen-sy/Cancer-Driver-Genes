function [sol,v] = practice_sol
%solution (deterministic) to practice1.m

v = 1;
k = 100;
dx = @(t,x,v,k) v*x*(k-x)/k;

figure(2)
sol = ode15s(@(t,x) dx(t,x,v,k), [0, 150], [1]); 

plot(sol.x, sol.y,'o-');
