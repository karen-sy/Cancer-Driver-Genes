clc
clear

%% Call Parmas

time = [0,7000];
init_con = [10 70 100];
options = odeset('NonNegative', [1 2 3]);


RStar_Params

%%
%scale = [0.25 0.5 1 1.5 2]??

sol = ode15s(@(t,x) ODEs(t,x,c1,c2,a1,a2,v3,a3,r,gamma1,gamma2,p2,p3), time, init_con, options);
    
    figure(1); plot(sol.x,sol.y(1,:),sol.x,sol.y(2,:),sol.x,sum(sol.y(1:2,:)),'-'); legend('normal', 'cancer','total');
    figure(2); plot(sol.x,sol.y(3,:),'-');
    
function dx = ODEs(t,x,c1,c2,a1,a2,v3,a3,r,gamma1,gamma2,p2,p3)

dx = [x(1) * r*(gamma1*c1*x(3) - a1 - p3);
          x(2) * r*(gamma2*c2*x(3) - a2) + r*x(1)*(2*p3+p2); %solution at x(3) = a2/c2 = 100
          v3 - r*x(3)*(c1*x(1)+c2*x(2))-a3]; %oxygen (resource)

end
