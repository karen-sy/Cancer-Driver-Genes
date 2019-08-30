%stores initial parameter values

%% cell dynamics
v0 = 0.03;%replication rate

%cell death rates
a0 = 0.01; %"basal" rate
D = 1/30;

k = 25;

%% oxygen
v1 = 1; %default o2 into system (constant in time)
a1 = 0.01; %o2 out of system (constant per molecule)
a2 = 1e-6; %rate of o2 use

