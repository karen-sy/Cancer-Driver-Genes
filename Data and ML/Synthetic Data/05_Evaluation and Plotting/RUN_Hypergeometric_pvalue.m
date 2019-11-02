load('ALL_PREDICTIONS_SUMMARY.mat')

[k1, s1, m1, n1] = Hypergeometric_pvalue(forestY, forestPredY); %3.474567360735496e-27
[k2, s2, m2, n2] = Hypergeometric_pvalue(logitY, logitPredY); % 1
[k3, s3, m3, n3] = Hypergeometric_pvalue(treeY, treePredY); % 5.585721358481817e-43
[k4, s4, m4, n4] = Hypergeometric_pvalue(svmY, svmPredY); % 1.695467488512681e-41
[k5, s5, m5, n5] = Hypergeometric_pvalue(rusY, rusPredY); % 2.466850161042697e-08

clearvars -except k1 k2 k3 k4 k5 s1 s2 s3 s4 s5 m1 m2 m3 m4 m5 n1 n2 n3 n4 n5


%% for RUS
load predictedY; loadXY; Y = ConsensusY; 
n = numel(Y);  
m = sum(Y~=1);   
s = sum(predictedY);  
k = length(intersect(find(Y ~= 1), find(predictedY == 1))); % 0.01197107250621899




%%
disp("done")
