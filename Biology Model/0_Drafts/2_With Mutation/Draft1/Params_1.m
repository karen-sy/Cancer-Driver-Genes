%file holds INITIAL values of variables in system

y(1:3) = 0;

%replication rates
v0 = 1/3;  
v1 = 1/3; 
v2 = 1/3;  

%mutation rates (as a 'percentage' of mutation during replication)(values from bozic paper)
p = (3.15*1e7)*5e-10; 
do = (2*(286*114))*5e-10;  
dt = (2*(91*14))*5e-10;  

%death rates?
a0 = 1/4; 
a1 = 1/4; 
a2 = 1/4;    
