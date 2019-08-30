%% oxygen
o2_data = []; %just for later plotting
save o2data.mat o2_data;

v3 = 10; %default o2 into system (constant in time)
a3 = 0.1; %o2 out of system (constant per molecule)

k1 = 25; %o2 factor in cell death
k2 = 25; %o2 factor in cancer cell death

%% cells
% division rate
v1 = 0.03;
v2 = 0.03; %test different values

% cell death rates
a1 = 0.01; %"basal" rate
D1 = 0.03333; %'additional' death; not really used


a2 = a1; %initially same
D2 = D1;
 
%% Important variables
cp = 50; %carrying capacity (entire cell population)
c1 = 2e-3;
c2 = 2e-3;
