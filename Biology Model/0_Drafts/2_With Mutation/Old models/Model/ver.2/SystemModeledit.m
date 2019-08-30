function SystemModel2
%a ROUGH DRAFT for the complete model with: Normal Cell,
%Drivers, and O2 /// Including feedbacks // NO passengers
% NO CONTROL FROM NORMAL CELLS
%
clc
clear
clf; hold off

%% Call Parameters
% oxygen
o2_data = []; %just for later plotting
save o2data.mat o2_data;

v3 = 1; %default o2 into system (constant in time)
a3 = 0.01; %o2 out of system (constant per molecule)
c1 = 1e-3; %o2 consumption
c2 = 1e-3; %o2 consumption

k1 = 25; %o2 factor in cell death
k2 = 25; %o2 factor in cancer cell death
k3 = 5;  %cancer factor in o2 saturation level

vmax = 2;

% cell dynamics
 v1 = 0.03;
v2 = 0.03; %initially same

 a1 = 0.01; %"basal" rate
D1 = 0.03333; %cell death affected by oxygen

a2 = 0.01; %initially same
D2 = D1;

 do = 3e-5;
dt = 1e-6;


%% Add Feedback + Solve ODEs
sol = dde23(@(t,x,Z) ODEs(t,x,Z,D1,D2,a1,a2,a3,v1,v2,v3,do,dt,k1,k2,k3,c1,c2,vmax), 2, [1,0], [0, 1.5e6]);

figure (1)
plot(sol.x, sol.y(1,:), '-.'); hold on;
plot(sol.x, sol.y(2,:), '-');
ylim([0 inf]); axis 'auto'
xlabel('time'); ylabel('cell population')
title('Cell Populations, \beta_{1} = 0.01, \beta_{2} = 25', 'fontweight', 'bold', 'fontsize', 13);
legend('Normal: \alpha = 0.01', 'Cancer: \alpha = 0.01', 'Normal: \alpha = 0.05','Cancer: \alpha = 0.05', 'Normal: \alpha = 0.5','Cancer: \alpha = 0.5','Normal: \alpha = 1','Cancer: \alpha = 1') %,'Normal: \beta_{2} = 50','Cancer: \beta_{2} = 50');

figure (2) ; load o2data.mat o2_data
o2_data = sortrows(o2_data,1)
plot(o2_data(:,1), o2_data(:,2)); axis auto

% ode file
    function dx = ODEs(t,x,Z,D1,D2,a1,a2,a3,v1,v2,v3,do,dt,k1,k2,k3,c1,c2,vmax)
       
         O2 = @(v_3,x_1,x_2,a_3,c_1,c_2,v_max,k_3,x_2d) (v_3/(a_3 + x_1*c_1 + x_2*c_2)) * (v_max/(1 + k_3/(1+x_2d))); %o2, with added feedback for angiogenesis
        
        
        dx = [x(1) * ((2*(1-do-dt)-1)*v1 - (a1 + D1/(1 + O2(v3,x(1),x(2),a3,c1,c2,vmax,k3,Z(2))/k1))); %normal
            1* (2*(do+dt)*v1*x(1)  +  x(2)*(v2 - (a2 + D2 / (1 + O2(v3,x(1),x(2),a3,c1,c2,vmax,k3,Z(2))/k2)))); %mutated
            ];
        
        
        
        
        load o2data.mat o2_data;
        o2_data = [o2_data; [t O2(v3,x(1),x(2),a3,c1,c2,vmax,k3,Z(2))]];
        save o2data.mat o2_data;
    end

end
