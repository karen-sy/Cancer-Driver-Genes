function dx = ODEs(t,x,Z,D1,D2,a1,a2,a3,v1,v2,v3,do,dt,k1,k2,k3,c1,c2,vmax)
%full version

        %% 1) driver effects  
        alpha = 0.1; %higher a1 = stronger early feedbacks; faster steady state time
        a2 = a2*(1/(1 + (dt/(do+dt))*x(2)*alpha));  
        
        beta1 = 0.2; %maximum additional growth rate feedback can add to v
        beta2 = 25; %lower beta2 = stronger early feedback to v2
        v2 = v2 + (beta1 / (1 + (do/(do+dt))*x(2)/beta2)); %more x2 = more v2
        
        %% 2) immune feedback
        gamma1 = 0.03; %immune growth
        gamma2 = 50; %immune homeostatic state
        
        gamma0 = 1e-4; %sensitivity to immune predation
        gamma3 = 1e-1; %immune reaction to cancer (recruitment potential)
        
        %reaction to immune feedback
        delta1 = 1; 
        delta2 = 15; 
        gamma0 = gamma0*(1/(1 + x(2)*delta1)); % insensitivity to immune predation 
        gamma3 = gamma3*(1/(1 + x(2)*delta2)); %cancer cells may well evade immune destruction; disabling components of the immune system that have been dispatched to eliminate them.
        %% ODEs
        %normal cell, cancer cell, immune control
        O2 = @(v_3,x_1,x_2,a_3,c_1,c_2,v_max,k_3,x_2d) (v_3/(a_3 + x_1*c_1 + x_2*c_2)) * (v_max/(1 + k_3/(1+x_2d))); %o2, with added feedback for angiogenesis
        
        
        dx = [x(1) * ((2*(1-do-dt)-1)*v1 - (a1 + D1/(1 + O2(v3,x(1),x(2),a3,c1,c2,vmax,k3,Z(2))/k1))); %normal
            (2*(do+dt)*v1*x(1)  +  x(2)*(v2 - (a2 + D2 / (1 + O2(v3,x(1),x(2),a3,c1,c2,vmax,k3,Z(2))/k2)))- gamma0*x(2)*x(3)); %mutated
            gamma1*x(3)*(1-x(3)/(gamma2 + gamma3*Z(2)*x(3)))];      
        
        load o2data.mat o2_data;
        o2_data = [o2_data; [t O2(v3,x(1),x(2),a3,c1,c2,vmax,k3,Z(2))]];
        save o2data.mat o2_data;
    end

