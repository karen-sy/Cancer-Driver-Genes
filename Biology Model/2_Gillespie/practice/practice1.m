%get a1, get a2, get r0, get r2
% dn/dt = vn(1-n/k) = n(v-vn/k)
function practice1
clear; clc
%% setup
tic;

count = 1; %reaction counter

n = 1; %initial # (vary to check time and error)
disp(n)

tplot = zeros(1); %for plotting
Xplot = n;      %for plotting

v = 1;
k = 100;
t = 0;

%% gillespie

while t < 500
    a1 = v*n;           %possibilities
    a2 = (v/k) *(n^2);
    
    r0= rand(1);        %probabilities
    r1 = rand(1);
    tau = (1/(a1+a2))*log(1/r1);
    
    
    if r0 < a1 / (a1+a2)  %rxn 1 happens (birth)
        n = n+1;
    else
        n = n-1;
    end
    
    count = count+1;
    t = t+tau;
    
    tplot(count) = t;
    Xplot(count) = n;
end


stairs(tplot,Xplot,'.-');
hold on;

%% error
%xx = 0:floor(tplot(end));
%sol = practice_sol;

%yy_ga = spline(tplot(:),Xplot(:),xx);
%yy_exact = spline(sol.x, sol.y, xx);

%err = sum(abs(yy_ga(:,20) - yy_exact(:,20)))/size(xx(:,20),2); %average error 

toc;
end



