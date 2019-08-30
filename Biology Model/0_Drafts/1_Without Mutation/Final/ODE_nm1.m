% ODE; normal cell / oxygen saturation (0~1)
function dx = ODE_nm1(~,x,v0,a0,v1,a1,an,K)

A = @(k) an*(1 - k/(2-k));  %O2 affects 'additional' death rate

dx = [x(1) * (v0 * x(2) - (a0 + A(x(2)))); %cell: regulated by oxygen
      v1*(1-x(2)) - (a1*x(2) + K*x(1))];
     
end
