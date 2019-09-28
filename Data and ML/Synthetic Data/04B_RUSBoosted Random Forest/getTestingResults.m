function getTestingResults(trainedClassifier)
% this script takes in a classifier and returns ALL_TCGA_TESTING_STATS
% therefore useless for synthetic data model comparison stage,
% just for RUSBoost testing reporting
% a mashup of functions from the 05_Eval_and_Plotting folder

loadXY; 

%% accuracy / error / recall / precision / f-score / MCC / kappa
Y = ConsensusY;
[predictedY, ~] = trainedClassifier.predictFcn(ConsensusX);

%convert to binary classification for now
Y = makeBinary(Y); predictedY = makeBinary(predictedY);
  
[TCGAfullResult, TCGAfullReferenceResult] = runAllStats(Y,predictedY);

TCGAfullResult.p_value = 1 - Hypergeometric_pvalue(Y, predictedY);

save predictedY.mat predictedY  
save TCGAfullReferenceResult.mat TCGAfullReferenceResult
save TCGAresultsRUS.mat TCGAfullResult  

end