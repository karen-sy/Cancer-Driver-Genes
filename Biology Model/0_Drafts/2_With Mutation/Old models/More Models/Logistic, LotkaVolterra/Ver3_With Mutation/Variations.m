%% Change dynamics?

if t>25000
    %Experiment #1
    mut = 0; %decrease mutation rate....
    gamma1 = (1-mut)^2;
    gamma2 = 1;  
    p2 = 2*(mut)*(1-mut);  
    p3 = (mut)^2; 
    %Experiment #2
    delta2 = 2;
elseif t>2000 %try changing dynamics (mut rate) after cells reach steady state   
    %Experiment #2
    r = 3000; %much quicker cell cycles 
elseif t>1000 %try changing dynamics (mut rate) after cells reach steady state
    %Experiment #1
    mut = 0; %decrease mutation rate....
    gamma1 = (1-mut)^2;
    gamma2 = 1;  
    p2 = 2*(mut)*(1-mut);  
    p3 = (mut)^2; 
    
    %Experiment #2
    r = 300; %much quicker cell cycles
elseif t>200 %try changing dynamics (mut rate) before cells reach steady state
    %Experiment #1
    mut = 0e-4; %increase mutation rate....
    gamma1 = (1-mut)^2;
    gamma2 = 1;  
    p2 = 2*(mut)*(1-mut);  
    p3 = (mut)^2;  
    
    %Experiment #2
    r = 3; % cell cycle increase 
end