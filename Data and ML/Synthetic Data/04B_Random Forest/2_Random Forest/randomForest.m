function [trainedClassifier, validationAccuracy] = randomForest(trainingData)
% [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
% returns a trained classifier and its accuracy. Use the
% generated code to automate training the same model with new data, or to
% learn how to programmatically train models.
%
%  Input:
%      trainingData: a matrix with the same number of columns and data type
%       as imported into the app.
%
%  Output:
%      trainedClassifier: a struct containing the trained classifier. The
%       struct contains various fields with information about the trained
%       classifier.
%
%      trainedClassifier.predictFcn: a function to make predictions on new
%       data.
%
%      validationAccuracy: a double containing the accuracy in percent. In
%       the app, the History list displays this overall accuracy score for
%       each model.
%
% Use the code to train the model with new data. To retrain your
% classifier, call the function from the command line with your original
% data or new data as the input argument trainingData.
%
% For example, to retrain a classifier trained with the original data set
% T, enter:
%   [trainedClassifier, validationAccuracy] = trainClassifier(T)
%
% To make predictions with the returned 'trainedClassifier' on new data T2,
% use
%   yfit = trainedClassifier.predictFcn(T2)
%
% T2 must be a matrix containing only the predictor columns used for
% training. For details, enter:
%   trainedClassifier.HowToPredict

%% 
clearvars -except X y trainingData
rng default
predictors = trainingData(:,1:(end-1));
response = trainingData(:,end);
 
% Set up holdout validation
cvp = cvpartition(response, 'Holdout', 0.25);
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :);
 
%% Train a classifier

% cost
load syn_cost.mat cost %class weights to account for imbalance

template = templateTree(...
    'MaxNumSplits', 5000);
classificationEnsemble = fitcensemble(...
    trainingPredictors, ...
    trainingResponse, ... 
    'Method', 'Bag', ... 
    'NumLearningCycles', 30, ...
    'Cost', cost,...
    'Learners', template, ...
    'ClassNames', [1; 2; 3],...    %'Cost',cost,...
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

% Compute validation accuracy
correctPredictions = (validationPredictions == validationResponse);
validationAccuracy = sum(correctPredictions)/length(correctPredictions);


%% results
figure(2)
ConfusionPlot(confusionmat(validationResponse,validationPredictions)); %visualize confusion plot
[ForestResult,ForestReferenceResult] = runAllStats(validationResponse,validationPredictions); %get all stats values
save results.mat ForestResult ForestReferenceResult

end

