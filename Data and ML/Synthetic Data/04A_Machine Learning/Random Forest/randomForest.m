function [trainedClassifier] = randomForest(predictors, response)

rng default
 
% Set up holdout validation
cvp = cvpartition(response, 'Holdout', 0.15);
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :);
 
%% Train a classifier
load Cost.mat cost

template = templateTree(...
    'MaxNumSplits', 5000);
classificationEnsemble = fitcensemble(...
    trainingPredictors, ...
    trainingResponse, ... 
    'NumLearningCycles', 20, ...    %'Cost', cost,...
    'Learners', template, ...
    'ClassNames', [1; 2; 3],...      
    'nprint',100);

% Create the result struct with predict function
ensemblePredictFcn = @(x) predict(classificationEnsemble, x);
trainedClassifier.predictFcn = @(x) ensemblePredictFcn(x);

% Add additdaional fields to the result struct
trainedClassifier.ClassificationEnsemble = classificationEnsemble;

 
%% Compute validation predictions
validationPredictors = predictors(cvp.test, :);
validationResponse = response(cvp.test, :);
[validationPredictions, validationScores] = trainedClassifier.predictFcn(validationPredictors);
[fullPredictions, fullScores] = trainedClassifier.predictFcn(predictors);

%% results
%figure(2)
%ConfusionPlot(confusionmat(validationResponse,validationPredictions)); %visualize confusion plot
%[ForestResult,ForestReferenceResult] = runAllStats(validationResponse,validationPredictions); %get all stats values
[ForestResult,~] = runAllStats(1-makeBinary(validationResponse),1-makeBinary(validationPredictions)); %get all stats values

save forestResults.mat ForestResult validationPredictions validationResponse validationScores fullPredictions fullScores trainedClassifier
save forestModel.mat trainedClassifier
end

