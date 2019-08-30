function Gillespie
%% Gillespie
% Gillespie SSA implementation of final mathematical model
% (A simplified demo)

clc; hold off
clear

for i = 1:3 %do three runs

% Initialize
count = 1; %reaction counter
t = 0; %initialize time

E = zeros(8,1);
N = 5; %init # of normal cells
M = 1;

tplot = zeros(1); %for plotting
Xplot = [N M];

% Call Parameters
GillespieParameters;

%feedback variables (feedback processes are embedded in SSA process)
alpha_d = dnDefault - dmDefault; %feedback to death rate, from TSGs
alpha_v = vmDefault - vnDefault ;%maximum additional growth rate feedback can add to v

%---------implement gillespie-----------------
O2 = @(x1,x2)  v3/(a3+ (x1+x2)*(c1-(c1-c2)/(1+(5000/x2)^10))); %o2 = 10 at critical level
D = @(O2) Dmax / (1 + (O2/(o2max-o2thresh))^5);
L = @(O2) (1- (o2max - O2)/o2thresh);

while t < 10 %run for 10 time frames
    E(1) = (mu_o/mut)*pa *vn * N * L(O2(N,M)); %normal -> onco /normal
    E(2) = (mu_t/mut)*pa *vn * N * L(O2(N,M)); %normal -> TSG / normal
    E(3) = (pn-ps)       *vn * N * L(O2(N,M)); %normal -> normal div
    E(4) = 2*ps * (mu_o/mut) * vn* N * L(O2(N,M)); %normal -> two onco
    E(5) = 2*ps * (mu_t/mut) * vn* N * L(O2(N,M)); %normal -> two tsg
    E(6) = (dn* L(O2(N,M)) + D(O2(N,M))) * N;      %normal -> death
    E(7) = vm * M * L(O2(N,M));                    %mutated -> div
    E(8) = (dm * L(O2(N,M))+ D(O2(N,M))) * M;      %mutated -> death
    all = sum(E); %all possibilities, combined
    fprintf('o2 level = %.5f \t D = %.3f \t',(O2(N,M)),D(O2(N,M)));
    
    %-------------------------------------------------
    r0 = rand(1); %predicts _what_ happens
    r1 = rand(1); %predicts _when_ it happens
    tau = (1/all)*log(1/r1);
    %-------------------------------------------------

    if r0 <= sum(E(1:1))/all
        M = M+1; %normal -> asymmetric
        vm = vmDefault + (alpha_v / (1 + (mu_o/mut)*(1/M))); %onco
    elseif r0 <= sum(E(1:2))/all
        M = M+1;
        dm = dmDefault - (alpha_d / (1 + (mu_t/mut)*(1/M))); %tsg
    elseif r0 <= sum(E(1:3))/all
        N = N+1;  %normal -> normal division
    elseif r0 <= sum(E(1:4))/all
        N = N-1;  %normal -> two onco
        M = M+2;
        vm = vmDefault + (alpha_v / (1 + (mu_o/mut)*(1/M))); %onco
    elseif r0 <= sum(E(1:5))/all
        N = N-1;  %normal -> two tsg
        M = M+2;
        dm = dmDefault - (alpha_d / (1 + (mu_t/mut)*(1/M))); %tsg
    elseif r0 <= sum(E(1:6))/all
        N = N-1; %normal -> death
    elseif r0 <= sum(E(1:7))/all
        M = M+1;  %mutated -> division
        vm = vmDefault + (alpha_v / (1 + (mu_o/mut)*(1/M)));
        dm = dmDefault - (alpha_d / (1 + (mu_t/mut)*(1/M)));
    else
        M = M-1;  %mutated -> death
    end

    %-------------------------------------------------


    count = count+1;
    t = t+tau; %update time
    fprintf('time = %.4f \n',t);
    fprintf('normal cells = %d, cancer cells = %d \n\n',N, M);

    tplot(count) = t; %update plot
    Xplot(count,1) = N; %normal population
    Xplot(count,2) = M; %cancer population
    Xplot(count,3) = O2(N,M) ; %o2


end

if i == 1
    plot(tplot(1:end-1),Xplot(1:end-1,1:2),'LineWidth',2);
    hold on;
elseif i == 2
    plot(tplot(1:end-1),Xplot(1:end-1,1:2),'LineWidth',2);
elseif i == 3
    plot(tplot(1:end-1),Xplot(1:end-1,1:2),'LineWidth',2);
end

end
legend('Run 1: Wild type','Run 1: Cancerous',...
    'Run 2: Wild type', 'Run 2: Cancerous',...
    'Run 3: Wild type','Run 3: Cancerous','location','NorthWest');
xlim([0,10]);
ylabel('Cell population');
xlabel('time');
title("Stochastic Model")

set(gca,'FontSize',14,'FontName', 'Times New Roman');

export_fig -r300 -transparent gillespie4.png
end