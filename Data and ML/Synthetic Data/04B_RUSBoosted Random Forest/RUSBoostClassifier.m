function [trainedClassifier] = RUSBoostClassifier(predictors, response)

%%
cd(fileparts(which('RUSBoostClassifier'))) %cd to current folder so new results folder will be created here

close all;
rng default;

%%
close all;
rng default; 

% Set up holdout validation
cvp = cvpartition(response, 'Holdout', 0.15); 
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :);

%% Train a classifier

% cost
load syn_cost.mat cost %class weights to account for imbalance

treeTemplate = templateTree('MaxNumSplits',5000);
classificationEnsemble = fitcensemble(...
    trainingPredictors, ...
    trainingResponse, ...
    'NumLearningCycles',1200,...
    'Method', 'RUSBoost', ...
    'LearnRate' , 0.1,...
    'Learners', treeTemplate, ...
    'RatiotoSmallest',[1 1 1],...
    'nprint',100);


%2. with hyperparams tuning
%classificationEnsemble = fitcensemble(...
%    trainingPredictors, ...
%    trainingResponse, ...
%    'Learners', 'tree', ...
%    'Method', 'RUSBoost');%, ...
    %'OptimizeHyperparameters',{'NumLearningCycles','MaxNumSplits'},...
    %'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    %'expected-improvement-plus','Verbose',0),...
    %'LearnRate', 0.1,...
    %'RatiotoSmallest',[2 1 1]);

% Create the result struct with predict function
%ensemblePredictFcn = @(x) predict(classificationEnsemble, x);
trainedClassifier.predictFcn = @(x) predict(classificationEnsemble, x);

% Add additdaional fields to the result struct
trainedClassifier.ClassificationEnsemble = classificationEnsemble;


%% Compute validation predictions
validationPredictors = predictors(cvp.test, :);
validationResponse = response(cvp.test, :);  %actual class
[validationPredictions, validationScores] = trainedClassifier.predictFcn(validationPredictors); %predicted class
[fullPredictions, fullScores] = trainedClassifier.predictFcn(predictors); %predicted class

 
%% In a new folder, save results
[validationResult,~] = runAllStats(validationResponse,validationPredictions); %get all stats values
[fullResult,~] = runAllStats(response,fullPredictions); %kinda useless

%time = clock;
%newfolder = sprintf('RUSResults_%d_%d_%d_%d_%d',time(1:5));
%mkdir (newfolder); cd (newfolder)
save RUSsyntheticResults.mat validationResponse validationResult validationScores fullResult fullScores
save RUSmdl.mat trainedClassifier %just another copy of the classifier

%% plot results
ConfusionPlot(confusionmat(validationResponse,validationPredictions)); %visualize confusion plot
title("validation set");
% plot ensemble quality
%FIGURE_Rusboost_EnsembleQuality (classificationEnsemble, validationPredictors, validationResponse)

end

