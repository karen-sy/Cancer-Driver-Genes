%NOCAPACITY also known as the "old model"; cell death regulated by O2,
%  mutations present, without carrying capacity.

clc
clear
clf; hold off

%% Call Parameters
NoCapacity_Params

%% Add Feedback + Solve ODEs
sol = ode15s(@(t,x) ODEs(t,x,D1,D2,delta1,delta2,gamma1,gamma2,v3,a3,p2,p3,k1,k2,c1,c2,r), [0, 1.5e4], [1 0],['nonnegative',[1,2]]);

NoCapacity_Plot


%% ODES
    function dx = ODEs(~,x,D1,D2,delta1,delta2,gamma1,gamma2,v3,a3,p2,p3,k1,k2,c1,c2,r)
        
        O2 = @(x_1,x_2) max(0, (v3/(a3 + x_1*c1 + x_2*c2))); %o2, with added feedback for angiogenesis
        
        dx = [r*x(1) * (gamma1-(delta1 + D1/(1+O2(x(1),x(2))/k1)) - p3); %gamma1+p3+p2 = 0
            r*x(2) * (gamma2-(delta2 + D2/(1+O2(x(1),x(2))/k2))) + r*x(1)*(2*p3+p2)];
 
    end
