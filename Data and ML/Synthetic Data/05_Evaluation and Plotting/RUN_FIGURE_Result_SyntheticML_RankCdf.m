function RUN_FIGURE_Result_SyntheticML_RankCdf
% Runs FIGURE_Result_SyntheticML_RankCdf on all ML models

close all;
%% get results
%load knnResults.mat
%[f1, x1] = FIGURE_Result_SyntheticML_RankCdf(validationScores, validationResponse);

load logitResults.mat
[f2, x2] = FIGURE_Result_SyntheticML_RankCdf(validationScores, validationResponse,'y');

load treeResults.mat
[f3, x3] = FIGURE_Result_SyntheticML_RankCdf(validationScores, validationResponse,'n'); 

load polySVMResults.mat
[f4, x4] = FIGURE_Result_SyntheticML_RankCdf(validationScores, validationResponse,'y');

load forestResults.mat
[f5, x5] = FIGURE_Result_SyntheticML_RankCdf(validationScores, validationResponse,'n');

load RUSsyntheticResults.mat
[f6, x6] = FIGURE_Result_SyntheticML_RankCdf(validationScores, validationResponse,'y');

%% plot
%plot(x1, f1, 'LineWidth', 3);
figure; hold on
plot(x2, f2, 'LineWidth', 1);
plot(x3, f3, 'LineWidth', 1);
plot(x4, f4, 'LineWidth', 1);
plot(x5, f5, 'LineWidth', 1);
plot(x6, f6, 'LineWidth', 3);

legend('logistic regression', 'decision tree', 'polynomial SVM', 'random forest', 'RUSBoosted random forest', 'Location', 'southeast');
title('Cumulative distribution function of ranks for ML models');
xlabel('Rank');
ylabel('Cumulative distribution');

export_fig -r300 -transparent FIGURE_Result_SyntheticML_RankCdf.png;


%% zoomed in plot
%zoom into the plot and shit
export_fig -r300 -transparent FIGURE_Result_Zoomed_SyntheticML_RankCdf.png;

end

