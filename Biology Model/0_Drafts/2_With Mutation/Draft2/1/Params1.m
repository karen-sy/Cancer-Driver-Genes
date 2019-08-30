%stores initial parameter values


%% TO-DO
%see notebook for conditions/tresholds to think about


%% oxygen
v0 = 5; %default o2 into system (constant in time)
a0 = 3; %o2 out of system (constant per molecule)
K = 0.05; %rate of o2 use

%% cell dynamics
%division rate
v1 = 1/3;
v2 = v1; %initially same
v3 = v1;

%cell death rates
a1 = 0.15; %"basal" rate
an = 0.45; %affected by oxygen
a2 = 0.15;
a3 = 0.15;

%mutation rate (probability per division)
p = 0.016; 
do = 3e-5;  
dt = 1e-6;  


%% Feedback parameters (need?)
alpha = 0.04; %avg selective ADVANTAGE from DRIVERS
beta = 0.01; %avg selective DISADVANTAGE from PASSENGERS

