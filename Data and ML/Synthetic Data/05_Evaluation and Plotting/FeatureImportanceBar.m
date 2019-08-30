function FeatureImportanceBar(mdl)
% FeatureImportanceBar.m ranks the importance of the features of the
% machine learning classifier.

%% FeatureImportanceBar.m
close all;
categoryNames(1,1) = "silent fraction";
categoryNames(2,1) = "nonsense fraction";
categoryNames(3,1) = "missense fraction";
categoryNames(4,1) = "nonsense to missense ratio";
categoryNames(5,1) = "missense to silent ratio";
categoryNames(6,1) = "nonsilent to silent ratio";
categoryNames(7,1) = "gene occurrence fraction";
categoryNames(8,1) = "gene length";
categoryNames(9,1) = "missense position entropy";
categoryNames(10,1) = "mutation position entropy";
categoryNames(11,1) = "missense count p-value";
categoryNames(12,1) = "nonsense count p-value";
categoryNames(13,1) = "silent count p-value"; 


[importance, idx] = sort(predictorImportance(mdl.ClassificationEnsemble));
barh(importance); yticks(1:1:31);
yticklabels(categoryNames(idx(end:-1:1)))
set(gca,'FontSize',12,'FontName', 'Times New Roman');
title("Feature Importance")

export_fig -r300 -transparent FeatImp.png

end