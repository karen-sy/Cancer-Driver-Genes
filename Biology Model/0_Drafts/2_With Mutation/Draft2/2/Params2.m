%stores initial parameter values

N_init = 2;
T_init = 0;


%% oxygen
v0 = 5; %default o2 into system (constant in time)
a0 = 3; %o2 out of system (constant per molecule)
K = 0.01; %rate of o2 use

%% cell dynamics
%division rate
v1 = 1;
v2 = v1; %initially same

%cell death rates
a1 = 0.5; %"basal" rate
D = 0.15; %affected by oxygen
a2 = a1; %initially same

%mutation rate (probability per division)
p = 0.016; 
do = 0.00005;  
dt = 0.00005;  

%% Feedback parameters (need?)
alpha = 0.002; %avg selective ADVANTAGE from DRIVERS
beta = 0.001; %avg selective DISADVANTAGE from PASSENGERS

