function [trainedClassifier] = decisionTree(predictors, response)
%% Train a classifier
% This code specifies all the classifier options and trains the classifier.

rng default
 
classificationTree = fitctree(...
    predictors, ...
    response, ...
    'SplitCriterion', 'gdi', ...
    'MaxNumSplits', 100, ...
    'Surrogate', 'off', ...
    'ClassNames', [1; 2; 3]);

% Create the result struct with predict function
predictorExtractionFcn = @(x) array2table(x);
treePredictFcn = @(x) predict(classificationTree, x);
trainedClassifier.predictFcn = @(x) treePredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedClassifier.ClassificationTree = classificationTree;
 
%% Set up holdout validation
cvp = cvpartition(response, 'Holdout', 0.15);
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :);
 
%% Train a classifier
% This code specifies all the classifier options and trains the classifier.
classificationTree = fitctree(...
    trainingPredictors, ...
    trainingResponse, ...
    'SplitCriterion', 'gdi', ...
    'MaxNumSplits', 100, ...
    'Surrogate', 'off', ...
    'ClassNames', [1; 2; 3]);

%% Create the result struct with predict function
treePredictFcn = @(x) predict(classificationTree, x);
validationPredictFcn = @(x) treePredictFcn(x);


%% Compute validation predictions
validationPredictors = predictors(cvp.test, :);
validationResponse = response(cvp.test, :);
[validationPredictions, validationScores] = validationPredictFcn(validationPredictors);
[fullPredictions, fullScores] = treePredictFcn(predictors);
    
%% display results
figure;
%ConfusionPlot(confusionmat(validationResponse,validationPredictions)); title('tree');
[treeResult,~] = runAllStats(1-makeBinary(validationResponse),1-makeBinary(validationPredictions));
save treeResults.mat treeResult validationPredictions validationResponse validationScores fullPredictions fullScores
save treeModel.mat classificationTree
end
