function dx = LV_ODEs2(t,x,v1,v2,v3,a1,a2,a3,c1,c2,k1,k2,D1,D2,cp)
%LV_ODES2: defines logistic term in respect to o2 concentration (which is a
%function of total cell #) 

O2 = @(x_1,x_2) max(0, (v3/(a3 + x_1*c1 + x_2*c2))); %c1, c2 accounts for competition
 
    
dx = [x(1) * ((v1-a1) * (1-(((v3/a3)-O2(x(1),x(2)))/cp))); %v3/a3 = O2max
      x(2) * ((v2-a2) * (1-(((v3/a3)-O2(x(1),x(2)))/cp))) ];
  
  
  if t > 4000 %notice: no change to dynamics
      v1 = 2*v1; 
      a2 = 2*a2;
  end
  
load o2data.mat o2_data;
o2_data = [o2_data; [t v3/(a3 + x(1)*c1 + x(2)*c2)]];
save o2data.mat o2_data;
end
