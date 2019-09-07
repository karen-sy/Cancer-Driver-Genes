function [trainedClassifier, validationAccuracy] = SVMClassifier(trainingData)
%% SVMClassifier.m
% SVMClassifier is a gausisan SVM classifier.

clearvars -except X y trainingData
clc;  rng default
predictors = trainingData(:,1:(end-1));
response = trainingData(:,end);
 
% Set up holdout validation
cvp = cvpartition(response, 'Holdout', 0.10);
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :);


[C,gamma] = meshgrid((-5:2:15),(-15:2:3));
load syn_cost.mat cost

validationAccuracy = zeros(1,numel(C));
 
% Train a classifier
%This code specifies all the classifier options and trains the classifier.
    
template = templateSVM(...
    'KernelFunction', 'gaussian', ...
    'PolynomialOrder', [], ...   
    'Standardize', true);
classificationSVM = fitcecoc(...
    trainingPredictors, ...
    trainingResponse, ...
    'Learners', template, ...
    'Coding', 'onevsone', ...
    'ClassNames', [1; 2; 3],'Cost',cost); %custom misclassification cost 

% Create the result struct with predict function
svmPredictFcn = @(x) predict(classificationSVM, x);
trainedClassifier.predictFcn = @(x) svmPredictFcn(x);

% Add additional fields to the result struct
trainedClassifier.ClassificationSVM = classificationSVM; 

%% Compute validation predictions
validationPredictors = predictors(cvp.test, :);
validationResponse = response(cvp.test, :);
[validationPredictions, ~] = trainedClassifier.predictFcn(validationPredictors);

% Compute validation accuracy
correctPredictions = (validationPredictions == validationResponse);
validationAccuracy = sum(correctPredictions)/length(correctPredictions);

% end
% i = i(max(validationAccuracy)) % = 40

%% display results
figure(2)
ConfusionPlot(confusionmat(validationResponse,validationPredictions));
[pre,rec,score] =(fScore(confusionmat(validationResponse,validationPredictions)))
% 
% figure(3) %what it said
% gplotmatrix(validationPredictors,[],validationPredictions,[],'.',4,'on','hist')
% 
% figure(4) %what it actually is
% gplotmatrix(validationPredictors,[],validationResponse,[],'.',4,'on','hist')

end

