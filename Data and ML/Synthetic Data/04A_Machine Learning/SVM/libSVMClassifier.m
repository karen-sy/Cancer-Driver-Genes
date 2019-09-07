function [trainedClassifier, validationAccuracy] = libSVMClassifier(trainingData)
% [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
% returns a trained classifier and its accuracy. This code recreates the
% classification model trained in Classification Learner app. Use the
% generated code to automate training the same model with new data, or to
% learn how to programmatically train models.

%% Setup
%clearvars -except X y trainingData
% 
% if ~exist('allPaths')
%     load all500TreePaths.mat allPaths
% end

clc;  rng default
predictors = trainingData(:,1:(end-1));
response = trainingData(:,end);
 
% Set up holdout validation
%cvp = cvpartition(response, 'Holdout', 0.15);
cvp = randperm(length(predictors));
cvp_training = cvp(1:floor(0.85*length(cvp)));
cvp_test = cvp(floor(0.85*length(cvp))+1:end);

trainingPredictors = predictors(cvp_training, :);
trainingResponse = response(cvp_training, :);

%% 
[C,gamma] = meshgrid((-5:2:15),(-15:2:3));
%load syn_cost.mat cost
cost = [0 1 1; 1 0 1; 1 1 0];

validationAccuracy = zeros(1,numel(C));
% %for i = 10:numel(C)
% i = 40; 
% boxconstraint = 2^(C(i));
% kernelscale = 2^(gamma(i));

% Train a classifier
% This code specifies all the classifier options and trains the classifier.

 
load SVMkernel.mat K;
K = [ (1:length(cvp_training))' , K];
%K =  [ (1:length(cvp))' , kernelRF(cvp_training,cvp_training,allPaths,trainingData) ];
%KK = [ (1:numTest)'  , chi2Kernel(testData,trainData)  ];

classificationSVM = svmtrain(trainingResponse,K,'-t 4');

% Create the result struct with predict function
svmPredictFcn = @(x) svmpredict(x, K, classificationSVM);
trainedClassifier.predictFcn = @(x) svmPredictFcn(x);

% Add additional fields to the result struct
trainedClassifier.ClassificationSVM = classificationSVM; 

% compute training predictions
[trainingPredictions, ~] = trainedClassifier.predictFcn(trainingResponse);


%% Compute validation predictions
validationPredictors = predictors(cvp_test, :);
validationResponse = response(cvp_test, :);
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

