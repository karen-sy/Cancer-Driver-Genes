%See explanation

%%
clc; clf;hold on
clear

%% Call Parameters

LV_Params;
%c1 = 2e-3*factor(i);
%c2 = 2e-3*factor(i);
%mut = 1e-4 * factor(i); (include gamma/beta)
%r = 0.33 *factor(i);
%delta2 = 0.1*factor(i);

    

%% Solve ODEs
time = [0,500000];
init_con = [10 10];
options = odeset('NonNegative', [1 2]); 

sol = ode15s(@(t,x) LV_ODEs3(t,x,r,v3,a3,gamma1,gamma2,delta1,delta2,p2,p3,c1,c2,cp), time, init_con, options);

%% Plot

LV_Plot;

%end
  