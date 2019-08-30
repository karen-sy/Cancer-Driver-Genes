function [trainedClassifier, validationAccuracy] = RUSBoostBinary(trainingData)
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
clc;  rng default
predictors = trainingData(:,1:(end-1));
response = trainingData(:,end);
response(response == 3) = 2;
 
% Set up holdout validation
cvp = cvpartition(response, 'Holdout', 0.25);
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :);
 
%% Train a classifier

% cost
%load syn_cost.mat cost
%cost = [0 1; 20 0];
cost = 1-eye(2);

template = templateTree(...
    'MaxNumSplits', 500);
classificationEnsemble = fitcensemble(...
    trainingPredictors, ...
    trainingResponse, ... 
    'Method', 'RUSBoost', ... 
    'NumLearningCycles', 500, ...
    'Learners', template, ...
    'LearnRate', 0.2, ...     
    'ClassNames',[1;2],...
    'Cost',cost,...
    'nprint',100, 'Prior', [0.95; 0.05]);

% Create the result struct with predict function
ensemblePredictFcn = @(x) predict(classificationEnsemble, x);
trainedClassifier.predictFcn = @(x) ensemblePredictFcn(x);

% Add additdaional fields to the result struct
trainedClassifier.ClassificationEnsemble = classificationEnsemble;
trainedClassifier.HowToPredict = sprintf('To make predictions on a new predictor column matrix, X, use: \n  yfit = c.predictFcn(X) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nX must contain exactly 10 columns because this model was trained using 10 predictors. \nX must contain only predictor columns in exactly the same order and format as your training \ndata. Do not include the response column or any columns you did not import into the app. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

 
%% Compute validation predictions
validationPredictors = predictors(cvp.test, :);
validationResponse = response(cvp.test, :);
[validationPredictions, validationScores] = trainedClassifier.predictFcn(validationPredictors);

% Compute validation accuracy
correctPredictions = (validationPredictions == validationResponse);
validationAccuracy = sum(correctPredictions)/(correctPredictions);


%% display results
figure(2)
ConfusionPlot(confusionmat(validationResponse,validationPredictions));
[pre rec score] = (fScore(confusionmat(validationResponse,validationPredictions)))

 
end

