figure (1)
plot(sol.x, sol.y(1,:), '-.'); hold on;
plot(sol.x, sol.y(2,:), '-');
xlabel('time'); ylabel('cell population')
title('Cell Populations');
legend('Normal', 'Cancer');

figure (2) ; 
plot(sol.x, max(0, (v3./(a3 + sol.y(1,:)*c1 + sol.y(2,:)*c2))));