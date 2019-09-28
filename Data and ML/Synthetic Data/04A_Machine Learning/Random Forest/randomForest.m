function [trainedClassifier, validationAccuracy] = randomForest(trainingData)

clearvars -except X y trainingData
rng default
predictors = trainingData(:,1:(end-1));
response = trainingData(:,end);
 
% Set up holdout validation
cvp = cvpartition(response, 'Holdout', 0.25);
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :);
 
%% Train a classifier
 
template = templateTree(...
    'MaxNumSplits', 5000);
classificationEnsemble = fitcensemble(...
    trainingPredictors, ...
    trainingResponse, ... 
    'Method', 'Bag', ... 
    'NumLearningCycles', 30, ...
    'Cost', cost,...
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
[validationPredictions, ~] = trainedClassifier.predictFcn(validationPredictors);
 

%% results
%figure(2)
%ConfusionPlot(confusionmat(validationResponse,validationPredictions)); %visualize confusion plot
%[ForestResult,ForestReferenceResult] = runAllStats(validationResponse,validationPredictions); %get all stats values
[ForestResult,ForestReferenceResult] = runAllStats(makeBinary(validationResponse),makeBinary(validationPredictions)); %get all stats values

save forestResults.mat ForestResult ForestReferenceResult

end

