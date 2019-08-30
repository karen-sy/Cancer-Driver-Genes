%See explanation

%%
clc; hold off
clear

%% Call Parameters
FinalParams;


%% Solve ODEs
time = [0,5000000];
init_con = [10 0 25];
options = odeset('NonNegative', [1 2]); 

sol = ode15s(@(t,x) FinalODEs(t,x,r,v3,a3,gamma1,gamma2,delta1,delta2,p2,p3,c1,c2,cp,do,dt,mut), time, init_con, options);

%% Plot

figure(1)
plot(sol.x,sol.y(2,:),'-',sol.x,sum(sol.y(1:2,:)), '*-'); legend('normal', 'cancer','total')

figure(2)
load o2data.mat o2_data;
plot(o2_data(:,1),o2_data(:,2));

%end
  