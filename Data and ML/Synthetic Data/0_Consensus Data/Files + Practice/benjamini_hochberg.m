function p_q = benjamini_hochberg
% p and q values
% 



clear all; clc; rng default %for reproducibility
wt = normrnd(60,10,[1,1000]);
exp = normrnd(95,10,[1,1000]);

figure(1)
plot([1:1000],wt,'r.',[1:1000],exp,'b.');

figure(2)
histogram(wt,'FaceColor','r'); hold on
histogram(exp,'FaceColor','b'); hold off


p = zeros(1,10000);
for i = 1:10000
    wt_choice = datasample(wt,10); %choose 10 randomly
    exp_choice = datasample(exp,10);
    [~,p(i)] = ttest(wt_choice,exp_choice);
end
figure(3)
hist(p); 

%% applying b-h proccedure
%given: 10000 p-values
alpha = 0.05; %false discovery rate; can change this

bh = zeros(length(p),3); %make matrix
bh(:,1) = sort(p); %p value, in order 
bh(:,2) = (1:length(bh))'; %p value rank

p_adj = bh(:,1).*(length(bh)./bh(:,2));  
bh(:,3) = min([p_adj, [p_adj(2:end);p_adj(end)]],[],2); %adjusted p-value (q value)
bh(:,4) = (bh(:,3)<= alpha); %is q value <= critical value?

limit = find((bh(:,4) == 1),1,'last'); %index of the last 'significant' value

y = [bh(:,1),bh(:,1)];
y(limit+1:end,2) = NaN;

figure(4) 
hist(y) ; %graph so that only the significant ones are shown in diff.color
hold off


p_q = [bh(:,1),bh(:,3)]; %matrix of p and q values
end
