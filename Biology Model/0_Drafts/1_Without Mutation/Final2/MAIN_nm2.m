%model_nm1: No mutation,O2 regulates cell population with asymtotic fcn


clear
clc
params_nm2


%% solve / plot
figure (1); 
initial = 10; %initial cell size


sol = ode45(@(t,x) ODE_nm2(t,x,v0,a0,v1,a1,D,a2,k), [0, 750],initial);  
%ylim([0 Inf]); axis 'auto x';  
%plot(sol.x, sol.y, 'o-');    
%title(['cell population, initial size =' num2str(initial)]); 


figure (2);
plot(sol.x, v1./(a1+sol.y*1e-6),'.-');
axis auto;
xlabel('time');
ylabel('O_{2} concentration (%)');  
title(['O_{2} Concentration, for initial cell population ' num2str(initial) ', O2 = ' num2str(40)], 'fontweight', 'bold', 'fontsize', 13);

