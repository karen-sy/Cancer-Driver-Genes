% See brief explanation of this model in file LV_ODEs2
%%
clc; hold on
clear

%% Call Parameters
LotkaParams;

%% Solve ODEs
time = [0,7500];
init_con = [10 10];
options = odeset('NonNegative', [1 2]); 

sol = ode15s(@(t,x) LV_ODEs2(t,x,v1,v2,v3,a1,a2,a3,c1,c2,k1,k2,D1,D2,cp,mut), time, init_con, options);

%% Plot

LotkaPlot;


 