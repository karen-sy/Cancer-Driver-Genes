function [trainedClassifier] = polynomialSVM(predictors, response)
%the "polynomial" version of gaussian SVM: polynomial (degree 3)?

%% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
rng default

% Set up holdout validation
cvp = cvpartition(response, 'Holdout', 0.15);
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :);


% Train a classifier
% This code specifies all the classifier options and trains the classifier.
template = templateSVM(...
    'KernelFunction', 'polynomial', ...
    'PolynomialOrder', 3, ...
    'Standardize', true);
classificationSVM = fitcecoc(...
    trainingPredictors, ...
    trainingResponse, ...
    'Learners', template, ...
    'Coding', 'onevsone', ...
    'ClassNames', [1; 2; 3]);

% Create the result struct with predict function
svmPredictFcn = @(x) predict(classificationSVM, x);

% Compute validation predictions
validationPredictors = predictors(cvp.test, :);
validationResponse = response(cvp.test, :);
[validationPredictions, validationScores] = svmPredictFcn(validationPredictors);
[fullPredictions, fullScores] = svmPredictFcn(predictors);

%% Create the result struct with predict function
trainedClassifier.predictFcn = @(x) svmPredictFcn(x);

% Add additional fields to the result struct
trainedClassifier.model = classificationSVM;

%% display results
%figure;
%ConfusionPlot(confusionmat(validationResponse,validationPredictions));title('polynomial svm');
[polySVMResult,~] = runAllStats(1-makeBinary(validationResponse),1-makeBinary(validationPredictions));

save polySVMSyntheticResults.mat polySVMResult validationPredictions validationResponse validationScores fullPredictions fullScores trainedClassifier
save polySVMmodel.mat trainedClassifier
end