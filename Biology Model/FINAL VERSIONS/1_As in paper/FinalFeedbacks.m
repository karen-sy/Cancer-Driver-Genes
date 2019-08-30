%% FinalFeedbacks.m
% Stores driver effects on cancer population growth
alpha_d = dnDefault - dmDefault; %feedback to death rate, from TSGs
dm = dmDefault - (alpha_d / (1 + (mu_t/mut)*(1/x(2))));
alpha_v = vmDefault-vnDefault ;%maximum additional growth rate feedback can add to v
vm = vmDefault + (alpha_v / (1 + (mu_o/mut)*(1/x(2)))); %more x2 = more v2

 