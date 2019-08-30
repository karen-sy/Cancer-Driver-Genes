%function GA_ver
%gillespie version of the biology model

%driver feedbacks present; no immune feedback, no angiogenesis
% see: 1_Bio Model\DRafts\With Mutation\Draft2\2\ODEs2

%% setup
clc; clear; hold on

count = 1; %reaction counter
t = 0;     %initialize time

%E = zeros(11,1);
E = zeros(6,1); %no immune
N = 10; %initialize # of normal cells
M = 1;
I = 0;

tplot = zeros(1); %for plotting
Xplot = [N M]; 

%% 
Params_GA; %load parameters

%% 
% 1) driver effects params
alpha = 0.01;   
beta1 = 0.02; %maximum additional growth rate feedback can add to v
beta2 = 25;  


%% %%%%%%%%%%%%%%% gillespie %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
O2 = @(v_3,x_1,x_2,a_3,c_1,c_2,v_max,k_3,x_2d) (v_3/(a_3 + x_1*c_1 + x_2*c_2)) * (v_max/(1 + k_3/(1+x_2d))) ; 


while t < 60 %5e3
    E(1) = 2*do*v1 * N;   %one normal --> one onco  / one normal (add separate symmetric?)
    E(2) = 2*dt*v1 * N;   %normal --> TSG / normal
    E(3) = (2*(1-do-dt)-1)*v1 * N; %normal --> normal division
    E(4) = (a1 + (D1/(1 + O2(v3,N,M,a3,c1,c2,vmax,k3,M)/k1))) * N; %normal --> death  
    E(5) = v2 * M;         %mutated --> division
    E(6) = (a2 + D2/(1 + O2(v3,N,M,a3,c1,c2,vmax,k3,M)/k2)) * M;  %mutated --> death 
    all = sum(E); %all possibilities, combined
    fprintf('o2 level = %.5f \t',(O2(v3,N,M,a3,c1,c2,vmax,k3,M)));
    %-------------------------------------------------
    
    r0 = rand(1); %predicts what happens
    
    r1 = rand(1); %predicts when it happens
    tau = (1/all)*log(1/r1);
    
    %-------------------------------------------------
    
    a2 = a2*(1/(1 + (dt/(do+dt))*M*alpha)); %feedbacks
    v2 = v2 + v2*(beta1 / (1 + (do/(do+dt))*M/beta2)); %more x2 = more v2   
    
    %------------------------------------------------    
    
    if r0 <= sum(E(1:2))/all
        M = M+1;        
    elseif r0 <= sum(E(1:3))/all
        N = N+1;  %normal --> normal division
    elseif r0 <= sum(E(1:4))/all
        N = N-1;  %normal --> death
    elseif r0 <= sum(E(1:5))/all
        M = M+1;  %mutated --> division   
    elseif r0 <= sum(E(1:6))/all
        M = M-1;  %mutated --> death
    end

    %-------------------------------------------------


count = count+1; 
t = t+tau; %update time
fprintf('time = %.4f \n',t); 
fprintf('normal cells = %d, cancer cells = %d \n\n',N, M);

tplot(count) = t; %update plot
Xplot(count,1) = N; %normal population
Xplot(count,2) = M; %cancer population
Xplot(count,3) = O2(v3,N,M,a3,c1,c2,vmax,k3,M) ; %o2


end

figure(1);
plot(tplot,Xplot(:,1:2),'-'); 
legend("N", "M"); 

figure(2);
plot(tplot, Xplot(:,3),'-');
legend("Oxygen");