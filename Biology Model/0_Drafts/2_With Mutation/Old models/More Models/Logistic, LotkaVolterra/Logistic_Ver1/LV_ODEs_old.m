function dx = LV_ODEs_old(t,x,v1,v2,v3,a1,a2,a3,c1,c2,k1,k2,D1,D2,cp,alpha12,alpha21)
O2 = @(v_3,x_1,x_2,a_3,c_1,c_2) max(0,(v_3/(a_3 + x_1*c_1 + x_2*c_2))); %oxygen

%if t < 200    %what happens if dynamics change before steady state?
if t < 5000     %what if change is AFTER steady state is achieved?
    dx = [x(1)* (v1-(a1 + D1/(1+O2(v3,x(1),x(2),a3,c1,c2)/k1))) * (1-(x(1)+(alpha12)*x(2))/cp );
        x(2)* (v2-(a2 + D2/(1+O2(v3,x(1),x(2),a3,c1,c2)/k2))) * (1-((alpha21)*x(1)+x(2))/cp)];
else
    dx = [x(1)* (0.5*v1-(a1 + D1/(1+O2(v3,x(1),x(2),a3,c1,c2)/k1)))*(1-(x(1)+(alpha12)*x(2))/cp); %notice changes in v1, a2
        x(2)* (v2-0.5*(a2 + D2/(1+O2(v3,x(1),x(2),a3,c1,c2)/k2)))*(1-((alpha21)*x(1)+x(2))/cp)];
end

load o2data.mat o2_data;
o2_data = [o2_data; [t O2(v3,x(1),x(2),a3,c1,c2)]];
save o2data.mat o2_data;
end
