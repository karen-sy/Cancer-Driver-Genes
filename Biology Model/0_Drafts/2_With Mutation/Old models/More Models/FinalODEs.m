function dx = FinalODEs(t,x,r,v3,a3,gamma1,gamma2,delta1,delta2,p2,p3,c1,c2,cp,do,dt,mut)
%LV_ODES3 Final version of the (spinoff of) l-v competition model
%   WITH mutations; v's and a's and d's are all PROBABILITIES (compared to
%   the 'rate' interpretation of previous models). See LV_Params for
%   specific explanations.

%%
FinalFeedbacks

%% ODEs
O2 = @(x_1,x_2) max(0, (v3/(a3 + x_1*c1 + x_2*c2)) ); %c1, c2 accounts for competition

%%
S = 0;

dx = [ x(1) * r*(((gamma1-delta1) * (1-(((v3/a3)-O2(x(1),x(2)))/cp)) - p3)); %steady sol@ (O2_max = 100)-O2 = cp
    x(2) * r*(((1-delta2) * (1-(((v3/a3)-O2(x(1),x(2)))/cp)))) + r*(x(1)*(2*p3+p2))- x(2)*S*x(3);
    0];%(r_i)* x(3) * (1 - x(3)/(I_H + Recruit*x(2)*x(3))) ]; 


load o2data.mat o2_data;
o2_data = [o2_data; [t v3/(a3 + x(1)*c1 + x(2)*c2)]];
save o2data.mat o2_data;

end