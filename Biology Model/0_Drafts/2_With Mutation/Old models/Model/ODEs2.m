function dx = ODEs2(t,x,Z,D1,D2,a1,a2,a3,v1,v2,v3,do,dt,k1,k2,k3,c1,c2,vmax)
% ODE version with NOTHING: no feedback, no immune response, no angiogenesis
       
        %% ODEs
        %normal cell, cancer cell; NO control, NO feedback
        O2 = @(v_3,x_1,x_2,a_3,c_1,c_2,v_max,k_3,x_2d) (v_3/(a_3 + x_1*c_1 + x_2*c_2)); %o2, no angiogenesis
        
        
        dx = [x(1) * ((2*(1-do-dt)-1)*v1 - (a1 + D1/(1 + O2(v3,x(1),x(2),a3,c1,c2,vmax,k3,Z(2))/k1))); %normal
            1* (2*(do+dt)*v1*x(1)  +  x(2)*(v2 - (a2 + D2 / (1 + O2(v3,x(1),x(2),a3,c1,c2,vmax,k3,Z(2))/k2)))); %mutated
           ];      
        
        load o2data.mat o2_data;
        o2_data = [o2_data; [t O2(v3,x(1),x(2),a3,c1,c2,vmax,k3,Z(2))]];
        save o2data.mat o2_data;
        disp(t)
    end

