function [trainedClassifier] = knnClassifier(predictors, response)
%% knnClassifier.m
% knnClassifier uses the k nearest neighbor algorithm. 
clc; rng default

% Set up holdout validation
cvp = cvpartition(response, 'Holdout', 0.15);
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :);

% Train a classifier
classificationKNN = fitcknn(...
    trainingPredictors, ...
    trainingResponse, ...
    'Distance', 'chebychev', ...
    'Exponent', [], ...
    'NumNeighbors', 1, ...
    'DistanceWeight', 'Equal', ...
    'Standardize', true, ...
    'ClassNames', [1; 2; 3]);

% Create the result struct with predict function
knnPredictFcn = @(x) predict(classificationKNN, x);
validationPredictFcn = @(x) knnPredictFcn(x);

% Compute validation predictions
validationPredictors = predictors(cvp.test, :);
validationResponse = response(cvp.test, :);
[validationPredictions, validationScores] = validationPredictFcn(validationPredictors);
[fullPredictions, fullScores] = knnPredictFcn(predictors);
 
%% Create the result struct with predict function
trainedClassifier.predictFcn = @(x) knnPredictFcn(x);

% Add additional fields to the result struct
trainedClassifier.model = classificationKNN;


%%
% figure;
% ConfusionPlot(confusionmat((validationResponse),validationPredictions)); title('knn');
[knnResult,~] = runAllStats(1-makeBinary(validationResponse),1-makeBinary(validationPredictions));
save knnResults.mat knnResult validationPredictors validationResponse validationScores fullPredictions fullScores trainedClassifier
save knnModel.mat trainedClassifier
end
 