%stores initial parameter values

%% initial # of cells, oxygen
x(1) = 1.5e5;
x(2) = 0;
x(3) = 1e10;

%% cell dynamics
%replication rates
v0 = 1/3;  
v1 = 1/3; 
  
%death rates
a0 = 1/3; 
a1 = 1/3; 

%mutation rate/possibility (%)
%m = 0.015;

%oxygen 
T = 100; %o2(in-out) rate in system 
K = 5; %rate of o2 use

Min = K*(x(1)+x(2)); 
S = log(1-(x(3)-Min)/Min)/log(x(3)); %connection between oxygen and selective advantage 
                                     %negative when x(3) < Min

 