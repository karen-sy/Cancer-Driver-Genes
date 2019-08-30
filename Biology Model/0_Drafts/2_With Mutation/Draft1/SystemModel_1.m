function SystemModel_1
% a ROUGH DRAFT for the complete model with: Normal Cell, Passengers,
% Drivers, and O2 /// Including feedbacks
%%
clear
close all
clc  

%% Call Parameters
Params_1

%% Add Feedback + Solve ODEs
Feedbacks_1

sol = ode23(@(t,y) ODEs_1(t,y,a0,a1,a2,v0,v1,v2,p,do,dt), [0, 100], [1.5e10, 0, 0]); %function / tspan / initial

plot(sol.x, sol.y, '.-');
axis tight
legend('Normal Cell', 'Passenger Cell', 'Driver Cell');


end