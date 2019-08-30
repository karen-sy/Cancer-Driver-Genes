function SystemModel
% a ROUGH DRAFT for the complete model with: Normal Cell,
% Drivers, and O2 /// Including feedbacks // NO passengers
%%
clc; clf
clear

%% Call Parameters
Params

%% Add Feedback + Solve ODEs
init_con = [10 1];

sol = dde23(@(t,x,Z) ODEs3(t,x,Z,D1,D2,a1,a2,a3,v1,v2,v3,do,dt,k1,k2,k3,c1,c2,vmax), 2, init_con, [0, 5e4]);

figure (1)
plot(sol.x, sol.y, '-'); 
ylim([0 inf]); axis 'auto x'
xlabel('time'); ylabel('cell population')
title(['Cell Populations --- All feedbacks, no control; initial conditions = ' num2str(init_con)] );
legend('normal', 'cancer');
%legend('Normal', 'Cancerous', 'immune response')
%legend('Normal: \alpha = 0.01', 'Cancer: \alpha = 0.01', 'Normal: \alpha = 0.05','Cancer: \alpha = 0.05', 'Normal: \alpha = 0.5','Cancer: \alpha = 0.5','Normal: \alpha = 1','Cancer: \alpha = 1') %,'Normal: \beta_{2} = 50','Cancer: \beta_{2} = 50');

figure (2) ; load o2data.mat o2_data
o2_data = sortrows(o2_data,1); %sort by time
plot(o2_data(:,1), o2_data(:,2));
title(['Oxygen Saturation ']); ylim([0 inf]); axis 'auto x'

end
