function getTestingResults(trainedClassifier)
% this script takes in a classifier and returns ALL_TCGA_TESTING_STATS
% therefore useless for synthetic data model comparison stage,
% just for RUSBoost testing reporting
% a mashup of functions from the 05_Eval_and_Plotting folder

loadXY; 

%% accuracy / error / recall / precision / f-score / MCC / kappa
Y = ConsensusY;
predictedY = trainedClassifier.predictFcn(ConsensusX);

%convert to binary classification for now
Y(Y ~= 1) = 2; 
predictedY(predictedY ~= 1) = 2;
 
[TCGAfullResult, ~] = runAllStats(Y,predictedY);

TCGAfullResult.p_value = 1 - Hypergeometric_pvalue(Y, predictedY);

save TCGAresultsRUS.mat TCGAfullResult  

end