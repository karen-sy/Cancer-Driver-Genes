%model_nm1: No mutation,O2 regulates cell population with asymtotic fcn


clear
clc
clf


params_nm1

%% setup

%% solve / plot
figure (1);
options = odeset('NonNegative',[1,2]);
sol = ode45(@(t,x) ODE_nm1(t,x,v0,a0,v1,a1,an,K), [0, 100], [1, 1],options);  %vary o2 use rate

p1 = plot(sol.x, sol.y(1,:), '.-');
axis auto; %how to cut to the 'interesting' part?
xlabel('time')
ylabel('Cell Population, in relation to initial size')
title('Cell Population');



figure (2);
sol = ode45(@(t,x) ODE_nm1(t,x,v0,a0,v1,a1,an,K), [0, 100], [1, 1],options);  %vary o2 use rate

p2 = plot(sol.x, 100*sol.y(2,:), '.-');
axis auto;
xlabel('time');
ylabel('O_{2} concentration (%)')  
title('O_{2} Concentration', 'fontweight', 'bold', 'fontsize', 13);

