function basic_model
%to look at cell and oxygen SEPARATELY

clear;
clc;
clf;

v0 = 1/3;  
a0 = 1/4;

v1 = 1/5;
a1 = 1/8;

figure(1); 
sol = ode23(@(t,x) ODEcell(t,x,v0,a0), [0, 500], 1);  
plot(sol.x, sol.y(1,:), '.-');
axis tight
title('cell');

figure(2);
sol = ode23(@(t,y) ODEo2(t,y,a1,v1), [0, 500], 1);  
plot(sol.x, sol.y(1,:), '.-');
axis auto
title('O2');


function dx = ODEcell(t,x,v0,a0)
dx = (v0-a0)*x;
end

function dy = ODEo2(t,y,a1,v1)
dy = v1-a1*y;
end

end
