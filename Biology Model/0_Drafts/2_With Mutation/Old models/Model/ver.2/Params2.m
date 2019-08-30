%% cell dynamics
%division rate
v1 = 0.03;
v2 = 0.03; %initially same

%cell death rates
a1 = 0.01; %"basal" rate
D1 = 0.03333; %cell death affected by oxygen

a2 = 0.01; %initially same
D2 = D1;

%mutation rate (probability per division)
do = 3e-5;
dt = 1e-6;

