
figure (1) ; load o2data.mat o2_data
o2_data = sortrows(o2_data,1);
plot(o2_data(:,1), o2_data(:,2)); axis auto
title('O2 Concentration');

figure (3)
plot( sol.x,sol.y,sol.x,sum(sol.y), '-');ylim([0 inf]); 
xlabel('time'); ylabel('cell population')
title(['Cell Populations: initial conditions =' num2str(init_con(1)) ',' num2str(init_con(2))]);
legend('normal', 'cancer');
