% ODE; Oxygen / normal cell / mutant cell
function dx = ODE(t,x,S,v0,v1,a0,a1,K,T,m)
dx = [ S*(v0-a0)*x(1) - m*x(1);  
       S*(v1-a1)*x(2) + m*x(1);   
       T - K*(x(1) + x(2))]; %T= net amt(in-out) %K = use by cell