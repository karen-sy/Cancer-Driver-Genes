function dx = ODE_nm2(~,x,v0,a0,v1,a1,D,a2,k)
%normal cell and oxygen only7


%O2 = @(v_1,x_1,a_1,a_2) v_1 / (a_1+ x_1*a_2); %o2 concenetration

O2 = @(v_1,x_1,a_1,a_2) 40;

dx = x * (v0  - (a0 + D /(1 + O2(v1,x,a1,a2)/k)) ); 
     
end
