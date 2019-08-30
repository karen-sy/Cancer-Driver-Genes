function [trainedClassifier, validationAccuracy] = RUSBoostClassifier(trainingData)

%%
close all;
rng default;
predictors = trainingData(:,1:(end-1));
response = trainingData(:,end);

% Set up holdout validation
cvp = cvpartition(response, 'Holdout', 0.15); 
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :);

%% Train a classifier

% cost
load syn_cost.mat cost %class weights to account for imbalance

treeTemplate = templateTree('MaxNumSplits',500);
classificationEnsemble = fitcensemble(...
    trainingPredictors, ...
    trainingResponse, ...
    'NumLearningCycles',1200,...
    'Method', 'RUSBoost', ...
    'LearnRate' , 0.1,...
    'Learners', treeTemplate, ...
    'RatiotoSmallest',[2 1 1],...
    'nprint',100);


%2. with hyperparams tuning
classificationEnsemble = fitcensemble(...
    trainingPredictors, ...
    trainingResponse, ...
    'Learners', 'tree', ...
    'Method', 'RUSBoost', ...
    'OptimizeHyperparameters',{'NumLearningCycles','MaxNumSplits'},...
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    'expected-improvement-plus','Verbose',0),...
    'LearnRate', 0.1,...
    'RatiotoSmallest',[2 1 1]);

% Create the result struct with predict function
%ensemblePredictFcn = @(x) predict(classificationEnsemble, x);
trainedClassifier.predictFcn = @(x) predict(classificationEnsemble, x);

% Add additdaional fields to the result struct
trainedClassifier.ClassificationEnsemble = classificationEnsemble;


%% Compute validation predictions
validationPredictors = predictors(cvp.test, :);
validationResponse = response(cvp.test, :);  %actual class
[validationPredictions, validationScores] = trainedClassifier.predictFcn(validationPredictors); %predicted class

% Compute validation accuracy
correctPredictions = (validationPredictions == validationResponse);
validationAccuracy = sum(correctPredictions)/length(correctPredictions);


%% plot results
ConfusionPlot(confusionmat(validationResponse,validationPredictions)); %visualize confusion plot
title("validation set");

[validationResult,validationReferenceResult] = runAllStats(validationResponse,validationPredictions); %get all stats values
[fullResult,fullReferenceResult] = runAllStats(response,trainedClassifier.predictFcn(predictors)); %get all stats values
%save RUSresults.mat validationResult validationReferenceResult fullResult fullReferenceResult

%% plot ensemble quality
figure;

%on **TCGA**: test set
loadXY; 
plot(loss(classificationEnsemble,ConsensusX,ConsensusY,'mode','cumulative'),'LineWidth',5);

%on subset of **synthetic** data: validation set
hold on;
plot(loss(classificationEnsemble,validationPredictors,validationResponse,'mode','cumulative'),'r','LineWidth',5);
hold off;
xlabel('Number of trees');
ylabel('Classification error');
legend('Test','Cross-validation','Location','NE');
set(gca,'FontSize',12,'FontName', 'Times New Roman');
% export_fig -r300 -transparent RUSensembleQuality.png;

end

