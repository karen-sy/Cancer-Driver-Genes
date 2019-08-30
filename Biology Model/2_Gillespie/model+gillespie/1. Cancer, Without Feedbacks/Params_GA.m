%% cell dynamics
%division rate
v1 = 0.03;
v2 = 0.03; %initially same

%cell death rates
a1 = 0.01; %"basal" rate
D1 = 0.03333; %maximum additional rate from o2

a2 = 0.01; %initially same
D2 = D1; %maximum additional rate from o2

%mutation rate (probability per division)
do = 3e-5;  
dt = 1e-6;  


%% oxygen
o2_data = []; %just for later plotting         
save o2data.mat o2_data; 

v3 = 1; %default o2 into system (constant in time)
a3 = 0.01; %o2 out of system (constant per molecule)
c1 = 1e-3; %o2 consumption 
c2 = 1e-3; %o2 consumption

k1 = 25; %o2 factor in cell death (lower k1 = higher o2 impact)
k2 = 25; %o2 factor in cancer cell death
k3 = 5;  %cancer factor in o2 saturation level 

vmax = 2;  


%% immune feedback
gamma1 = 0.03; %immune growth
gamma2 = 50; %immune homeostatic state
gamma0 = 1e-4; %sensitivity to immune predation
gamma3 = 1e-1; %immune reaction to cancer (recruitment potential)