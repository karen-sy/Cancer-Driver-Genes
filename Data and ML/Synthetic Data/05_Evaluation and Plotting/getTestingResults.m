function [TCGAfullResult, TCGAfullResult_top100] = getTestingResults(trainedClassifier, ConsensusY, ConsensusX)
% this script takes in a classifier and returns ALL_TCGA_TESTING_STATS
% therefore useless for synthetic data model comparison stage,
% just for RUSBoost testing reporting
% a mashup of functions from the 05_Eval_and_Plotting folder


%% accuracy / error / recall / precision / f-score / MCC / kappa
Y = ConsensusY;
[predictedY, predictedYscores] = trainedClassifier.predictFcn(ConsensusX);

%convert to binary classification for now
Y = makeBinary(Y); predictedY = makeBinary(predictedY);

%% for top 50 analysis: rank 
% get driver scores predicted by classifier and retrieve rank
if size(predictedYscores,2) > 1
    driverScores = sum(predictedYscores(:,end-1:end),2);
else
    driverScores = predictedYscores;
end

[~,ranks] = sort(driverScores,'descend');

% arrange true labels in rank order (visualize which are ranked "on top")
Y = Y(ranks);
predictedY = predictedY(ranks);

%% Run stats
  
[TCGAfullResult, ~] = runAllStats(1-Y,1-predictedY);
[TCGAfullResult_top100, ~] = runAllStats(1-Y(1:100),1-predictedY(1:100));
[TCGAfullResult_top1000, ~] = runAllStats(1-Y(1:1000),1-predictedY(1:1000));
[TCGAfullResult_top500, ~] = runAllStats(1-Y(1:500),1-predictedY(1:500));


TCGAfullResult.p_value = 1 - Hypergeometric_pvalue(Y, predictedY);
TCGAfullResult_top100.p_value = 1 - Hypergeometric_pvalue(Y(1:100), predictedY(1:100));


%save predictedY.mat predictedY predictedYscores
%save TCGAfullReferenceResult.mat TCGAfullReferenceResult
%save TCGAresultsRUS.mat TCGAfullResult  
%save TCGAresultsRUS_top50.mat TCGAfullResult_top50

end