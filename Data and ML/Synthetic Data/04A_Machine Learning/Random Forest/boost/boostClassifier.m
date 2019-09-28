function [trainedClassifier, validationAccuracy] = boostClassifier(trainingData)

rng default
predictors = trainingData(:,1:(end-1));
response = trainingData(:,end);
 

% Set up holdout validation
cvp = cvpartition(response, 'Holdout', 0.15);
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :);
 

% Train a classifier
template = templateTree(...
    'MaxNumSplits', 500);
classificationEnsemble = fitcensemble(...
    trainingPredictors, ...
    trainingResponse, ... 
    'Method', 'AdaBoostM2', ... 
    'NumLearningCycles', 500, ...
    'Learners', template, ...
    'LearnRate', 0.1, ...
    'ClassNames', [1; 2; 3],'Cost',cost,'nprint',100,'Prior','uniform');

% Create the result struct with predict function
ensemblePredictFcn = @(x) predict(classificationEnsemble, x);
trainedClassifier.predictFcn = @(x) ensemblePredictFcn(x);

% Add additdaional fields to the result struct
trainedClassifier.ClassificationEnsemble = classificationEnsemble;


% Compute validation predictions
validationPredictors = predictors(cvp.test, :);
validationResponse = response(cvp.test, :);
[validationPredictions, ~] = trainedClassifier.predictFcn(validationPredictors);

%[boostResult,boostReferenceResult] = runAllStats(validationResponse,validationPredictions); %get all stats values
[boostResult,boostReferenceResult] = runAllStats(makeBinary(validationResponse),makeBinary(validationPredictions)); %get all stats values

save results.mat boostResult boostReferenceResult

%figure(1)
%ConfusionPlot(confusionmat(validationResponse,validationPredictions));
%[pre,rec,score] = (fScore(confusionmat(validationResponse,validationPredictions)));
end