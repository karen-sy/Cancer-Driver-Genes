%% FinalParams2.m
% Stores the parameters used in ODEs

% Oxygen
o2_data = []; %just for later plotting
save o2data.mat o2_data;

o2max = 100;
o2thresh = 90;

a3 = 0.01; %o2 out of system 
v3 = 100*a3;

Dmax = 0.01; %necrosis

% Cells growth/death
vn = 1/3;
vm = 1/2;

vnDefault = vn;
vmDefault = vm;

mu_o = 3e-5;  
mu_t = 1e-6;  
mut = mu_o+mu_t; %mutation prob

% "symmetric" division probability (N-->N)
pn = (1-mut)^2; %pn+pr+ps must = 0
 

% mutated division probability (for normal cells)
pa = 2*(mut)*(1-mut); %N --> N,M (no net change in # of N)
ps = (mut)^2; %N --> M,M (-1 net N)
 
% cell death (% per cell cycle?)
dn = 0.01; 
dm = 0.01; %initially same
dnDefault = dn;
dmDefault = dm;
 
% Oxygen use rate
c1 = 8e-6; %carrying cap ~10000
c2 = 5.5e-6; %carry cap ~15000

% %% Immune feedback
% S = 1e-4; %sensitivity to immune predation
% vi = 3e-3; %immune growth
% I_H = 100; %immune homeostatic steady state mi
% r = 1e-3; %immune recruitment potential; from cancer-immune interaction
% 
