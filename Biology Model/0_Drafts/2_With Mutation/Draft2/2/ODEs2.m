function dx = ODEs2(t,x,a0,an,a1,a2,v0,v1,v2,p,do,dt,K,alpha,beta)
%% feedbacks
%1) driver to driver
v2 = v2 * (1+(alpha))^(1+ x(3)*do*t*v2*alpha);  %more (oncogene) drivers = higher div rate 
a2 = a2 * (1-(alpha))^(1+ x(3)*dt*t*v2*alpha); %more (tumor suppressor) drivers = lower death rate

%2) passenger to cell
a1 = a1 * (1+beta)^(x(2)*p*t*v1*beta); %more passenger mutations fixate in population => more apoptosis 
a2 = a2 * (2+beta)^(x(3)*p*t*v2*beta); 

%3) between oxygen and cells
A = @(j,k) j*(1 - k/(2-k));  %O2 -> 'additional' death rate of cells
F = @(j,k) j*k; %add. O2 entering through angiogenesis

%4) normal cell controls (immune system) (add more)
c = 0.95;


%% ODE

dx = [v0*(1-x(1)) - (a0*x(1) + K*(x(2)+x(3))) + F(2*K,x(3)); %O2
      x(2)*(v1*x(1) - (do+dt) - (a1 + A(an,x(1)))); %normal cell: regulated by oxygen
      x(2)*(do+dt) + x(3)*(c*v2*x(1) - (a2/c + A(0.25*an, x(1))));  
      ]; 

end 