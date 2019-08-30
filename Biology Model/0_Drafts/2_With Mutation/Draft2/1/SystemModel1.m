function SystemModel
% a ROUGH DRAFT for the complete model with: Normal Cell, Passengers,
% Drivers, and O2 /// Including feedbacks
%%
clc
clear
clf(1); clf(2) 

%% Call Parameters
Params

%% Add Feedback + Solve ODEs
options = odeset('NonNegative',[1,2,3,4]);
sol = ode15s(@(t,x) ODEs(t,x,a0,an,a1,a2,a3,v0,v1,v2,v3,p,do,dt,K,alpha,beta), [0, 50], [20,1,0,2],options); %function / tspan / initial

figure(2);
plot(sol.x, sol.y(1,:),'.-');
xlabel('time'); ylabel('oxygen concentration')

figure (1);
hold on
plot(sol.x, sol.y(2:4,:), sol.x, sum(sol.y), '.-');
hold off
axis auto

legend('Normal','Passenger', 'Driver', 'Total');
xlabel('time'); ylabel('cell population, in relation to initial size')


end