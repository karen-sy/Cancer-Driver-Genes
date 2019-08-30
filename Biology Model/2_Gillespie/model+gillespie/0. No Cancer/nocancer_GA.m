%function GA_ver
%gillespie version of the biology model

%only oxygen and one cell population; O2 KEPT CONSTANT AT O2 = 40
%ODE: see Summer 2018\1_Bio Model\Drafts\1_Without Mutation\Final2

%% setup
clc; clear;hold on

count = 1; %reaction counter
t = 0;     %initialize time

E = zeros(3,1);
N = 10; %initialize # of normal cells

tplot = zeros(1); %for plotting
Xplot = N; 

nocancer_GA_params; %load parameters 

%% %%%%%%%%%%%%%%% gillespie %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%O2 = @(v_3,cell,a_3,c_1) (v_3/(a_3 + cell*c_1))  ; 
O2 = @(v_3,cell,a_3,c_1) 40  ; 


while t < 750
    E(1) = v1 * N;   %normal --> divides
    E(2) = (a1+(D1/(1 + O2(v3,N,a3,c1)/k1))) * N;   %normal --> death
     
    all = sum(E); %all possibilities, combined

    %-------------------------------------------------
    
    r0 = rand(1); %predicts what happens
    r1 = rand(1); %predicts when it happens
    tau = (1/all)*log(1/r1);
    
    %-------------------------------------------------
    
    if r0 < E(1)/all
        N = N+1;
    else 
        N = N-1;  %normal --> TSG
    end
    
    %-------------------------------------------------
    
count = count+1; 
t = t+tau; %update time
disp(t); disp(N);

tplot(count) = t; %update plot
Xplot(count,1) = N; %cell: for plotting
Xplot(count,2) = O2(v3,N,a3,c1); %O2: for plotting
end

figure(1);
stairs(tplot,Xplot(:,1),'-'); 
hold on
legend('Cell: SSA','Cell: Continuous'); 

