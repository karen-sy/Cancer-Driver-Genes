function MAIN
%% MAIN.m
% main method that solves the cell population ODEs and plots the results

%Setup
clc; hold on
clear

% Call Parameters
FinalParams2;

% Solve ODEs
time = [0,20];
init_con = [100 1];
options = odeset('NonNegative', [1 2]); 


sol = ode15s(@(t,x) FinalODEs2(t,x,v3,a3,c1,c2,Dmax,o2max,o2thresh,pn,ps,pa,...
    vm,dm,vmDefault,dmDefault,vn,dn,vnDefault,dnDefault,...
    mu_t,mu_o,mut), time, init_con, options);
 

% Plot
figure()
plot(sol.x, sol.y(1:2,:),'-', 'LineWidth',3); %sol.x, sum(sol.y(1:2,:))%normal and cancer cells
hold on; plot(sol.x, sum(sol.y(1:2,:)),'k--', 'LineWidth',2);
ylabel('population size');
xlabel('time');
legend('Wild type', 'Cancerous', 'Total','location','best');
title('Mathematical Model: Cellular Growth');
set(gca,'FontSize',14,'FontName', 'Times New Roman');
export_fig -r300 -transparent continuous_long.png
end


