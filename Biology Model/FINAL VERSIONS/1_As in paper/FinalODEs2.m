function dx = FinalODEs2(t,x,v3,a3,c1,c2,Dmax,o2max,o2thresh,pn,ps,pa,vm,dm,vmDefault,dmDefault,...
    vn,dn,vnDefault,dnDefault,mu_t,mu_o,mut)
%% FinalODEs2 
%contains the method call to solve the ODEs that model cancer biology 
%vn,vc = cell cycle rates
%dn,dc = cell death rates
%pr,ps,pa = prob of diff divs


% Call Feedbacks
FinalFeedbacks 

% ODEs
%all normal steady state = 500 --> c1 = 1.2e-4
%all cancer steady state = 1000 --> c2 = 1e-4
O2 = @(x_1,x_2)  v3/(a3+ (x_1+x_2)*(c1-(c1-c2)/(1+(5000/x_2)^10))); %o2 = 10 at critical level
D = @(O2) Dmax / (1 + (O2/(o2max-o2thresh))^5); %necrosis
L = @(O2) (1- (o2max - O2)/o2thresh);

dx = [ x(1) * (vn*(pn-ps)-dn)* L(O2(x(1),x(2))) - D(O2(x(1),x(2)))*x(1); %steady sol@ (O2_max = 100)-O2 = cp
       x(2) * (vm-dm) * L(O2(x(1),x(2))) + x(1)*vn*(2*ps+pa)*L(O2(x(1),x(2)))-D(O2(x(1),x(2)))*x(2)];%- x(2)*S*x(3);
 
load o2data.mat o2_data;
o2_data = [o2_data; [t O2(x(1),x(2))]];
save o2data.mat o2_data;
end