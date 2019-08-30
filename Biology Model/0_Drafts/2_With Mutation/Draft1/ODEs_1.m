function dx = ODEs_1 (~,y,a0,a1,a2,v0,v1,v2,p,do,dt) 
%draft: no oxygen

dx = [ v0*y(1) - (p+do+dt)*y(1) - a0*y(1); %normal
       v1*y(2) + p*y(1) - (do + dt)*y(2) - a1*y(2); %passenger
       v2*y(3) + (do+dt)*(y(1)+y(2)) - a2*y(3); %driver
      ]; 
end
