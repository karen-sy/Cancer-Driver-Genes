%% 
%o2_data = []; %just for later plotting
%save o2data.mat o2_data;

v3 = 1; %default o2 into system (constant in time)
a3 = 0.01; %o2 out of system (constant per molecule)
c1 = 100; %o2 consumption
c2 = 0; %o2 consumption

r = 1/3;
%cell death rates
a1 = 0.1; %"basal" rate
a2 = 0.1; %initially same

%% cells
%cell cycle rate
r = 0.33; %# of div per day
mut = 1e-4; %mutation prob

% "symmetric" division probability (N-->N, M-->M)
gamma1 = (1-mut)^2; %gamma1+p2+p3 must = 0
gamma2 = 1; %cancer can't "go back"  

% mutated division probability (for normal cells)
p2 = 2*(mut)*(1-mut); %N --> N,M (no net change in # of N)
p3 = (mut)^2; %N --> M,M (-1 net N)
 
% cell death (% per cell cycle?)
delta1 = 0.1; 
delta2 = 0.1; %initially same

