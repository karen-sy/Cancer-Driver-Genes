function Logistic
%Logistic growth model (carrying capacity)
 
%%
clc; clf;
clear

%% Parameters
% oxygen
o2_data = []; %just for later plotting
save o2data.mat o2_data;

v3 = 1; %default o2 into system (constant in time)
a3 = 0.01; %o2 out of system (constant per molecule)
c1 = 1e-3; %o2 consumption
c2 = 1e-3; %o2 consumption

k1 = 25; %o2 factor in cell death
k2 = 25; %o2 factor in cancer cell death


% cell dynamics
% division rate
v1 = 0.03;
v2 = v1; %initially same

% cell death rates
a1 = 0.01; %"basal" rate
D1 = 0.03333; %cell death affected by oxygen

a2 = a1; %initially same
D2 = D1;

%%%%%%%%%%%%%specific to logistic%%%%%%%%%%%%%%%%%
cp = 100; %carrying capacity (entire cell population)

 
%% Add Feedback + Solve ODEs
init_con = [10 1];

sol = ode23s(@(t,x) ODEs(t,x,v1,v2,v3,a1,a2,a3,c1,c2,k1,k2,D1,D2,cp), [0,5000], init_con);

figure (1)
plot(sol.x, sol.y, '-');ylim([0 inf]); axis 'auto x'
xlabel('time'); ylabel('cell population')
title(['Cell Populations: initial conditions =' num2str(init_con(1)) ',' num2str(init_con(2)) ] );
legend('normal', 'cancer');

figure (2) ; load o2data.mat o2_data
o2_data = sortrows(o2_data,1);
plot(o2_data(:,1), o2_data(:,2)); axis auto
title('O2 Concentration');

figure(3) 
plot(sol.x,sum(sol.y),'-'); 
title('TOTAL Cell Population'); 
%% ODES
    function dx = ODEs(t,x,v1,v2,v3,a1,a2,a3,c1,c2,k1,k2,D1,D2,cp)
        O2 = @(v_3,x_1,x_2,a_3,c_1,c_2) (v_3/(a_3 + x_1*c_1 + x_2*c_2)); %oxygen
    
        %if t < 200    %what happens if dynamics change at t = 200, before steady state @ ~325?
        %if t < 3000     %what if change is AFTER steady state is achieved?
            dx = [x(1)* (v1-(a1 + D1/(1+O2(v3,x(1),x(2),a3,c1,c2)/k1))) * (1-(x(1)+x(2))/cp);
                  x(2)* (v2-(a2 + D2/(1+O2(v3,x(1),x(2),a3,c1,c2)/k2))) * (1-(x(1)+x(2))/cp)];
        %else
        %    dx = [x(1)* (2*v1-(a1 + D1/(1+O2(v3,x(1),x(2),a3,c1,c2)/k1)))*(1-(x(1)+x(2))/cp); %notice changes in v1, a2
        %          x(2)* (v2-0.5*(a2 + D2/(1+O2(v3,x(1),x(2),a3,c1,c2)/k2)))*(1-(x(1)+x(2))/cp)];
        %end
        
        load o2data.mat o2_data;
        o2_data = [o2_data; [t O2(v3,x(1),x(2),a3,c1,c2)]];
        save o2data.mat o2_data; 
    end
        
    end
