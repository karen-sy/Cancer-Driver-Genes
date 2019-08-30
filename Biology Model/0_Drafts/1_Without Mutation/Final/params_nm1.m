%stores initial parameter values

%% cell dynamics
v0 = 1;%replication rate

%cell death rates
a0 = 0.15; %"basal" rate
an = 0.45; %affected by oxygen


%% oxygen
v1 = 5; %default o2 into system (constant in time)
a1 = 3; %o2 out of system (constant per molecule)
K = 0.5; %rate of o2 use

