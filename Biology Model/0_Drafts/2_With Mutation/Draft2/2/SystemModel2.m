function SystemModel2
% a ROUGH DRAFT for the complete model with: Normal Cell,
% Drivers, and O2 /// Including feedbacks // NO passengers
%%
clc
clear
clf

%% Call Parameters
Params2

%% Add Feedback + Solve ODEs
options = odeset('NonNegative',[1,2,3]);
sol = ode15s(@(t,x) ODEs2(t,x,a0,D,a1,a2,v0,v1,v2,p,do,dt,K,alpha,beta), [0, 50000], [1,N_init,T_init],options);  
figure(2);
plot(sol.x, sol.y(1,:),'.-');
xlabel('time'); ylabel('oxygen concentration')

figure (1);
hold on
plot(sol.x, sol.y(2:3,:), '.-');
hold off
axis auto

legend('normal cell', 'cancer cell');
xlabel('time'); ylabel('cell population, in relation to initial size')


end