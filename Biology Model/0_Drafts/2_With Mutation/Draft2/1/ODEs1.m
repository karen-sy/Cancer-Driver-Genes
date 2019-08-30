function dx = ODEs(t,x,a0,an,a1,a2,v0,v1,v2,p,do,dt,K,alpha,beta)
%feedbacks + ODE
Feedbacks

%% ODE

%should add "division probability" as additional coefficient before "v"'s?
% 'division rate' matters separately or no? (theres no 'apoptosis rate' just probabilty...)
dx = [v0*(1-x(1)) - (a0*x(1) + K*(x(2)+x(3)+x(4))) + F(K,x(4)); %O2
      x(2) * (v1*x(1) -  p - (do + dt) - (a1 + A(x(1)))); %normal cell: regulated by oxygen
      p*x(2)+ x(3)*(v2 - (do + dt) - a2) - A(x(1));
      (do+dt)*(x(2) + x(3)) - x(4)*(v3 + a3) - A(x(1));  
      ]; 

end 