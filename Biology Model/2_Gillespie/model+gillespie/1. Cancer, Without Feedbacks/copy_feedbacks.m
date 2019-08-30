%angiogenesis + driver/immune feedbacks, copied for use in Params_GA.


%% feedbacks
O2 = @(v_3,x_1,x_2,a_3,c_1,c_2,v_max,k_3,x_2d) (v_3/(a_3 + x_1*c_1 + x_2*c_2)) * (v_max/(1 + k_3/(1+x_2d))) * (v_max/(1 + k_3/(1+x_2d))); 
%o2, with added feedback for angiogenesis

%% 
% 1) driver effects
alpha = 0.01; %higher a1 = stronger early feedbacks; faster steady state time
a2 = a2*(1/(1 + (dt/(do+dt))*M*alpha));
beta1 = 0.02; %maximum additional growth rate feedback can add to v
beta2 = 25; %lower beta2 = stronger early feedback to v2
v2 = v2 + (beta1 / (1 + (do/(do+dt))*M/beta2)); %more x2 = more v2   
  
% 2) reaction to immune feedback
delta1 = 1;
delta2 = 15;
gamma0 = gamma0*(1/(1 + M*delta1)); % insensitivity to immune predation
gamma3 = gamma3*(1/(1 + M*delta2)); %cancer cells may well evade immune destruction


%% note
%o2 is called as --> O2(v3,N,M,a3,c1,c2,vmax,k3,M)