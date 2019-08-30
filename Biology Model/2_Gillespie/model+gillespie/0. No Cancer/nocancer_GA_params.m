%% cell dynamics
v1 = 0.03;%division rate

%cell death rates
a1 = 0.01; %"basal" rate
D1 = 1/30; %maximum additional rate from o2

%% oxygen
o2_data = []; %just for later plotting         

v3 = 1; %default o2 into system (constant in time)
a3 = 0.01; %o2 out of system (constant per molecule)
c1 = 1e-6; %o2 consumption 

k1 = 25; %o2 factor in cell death (lower k1 = higher o2 impact)

vmax = 2;  