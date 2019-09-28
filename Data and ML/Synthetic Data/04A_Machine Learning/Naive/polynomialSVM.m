function [trainedClassifier] = polynomialSVM(data)
%the "polynomial" version of gaussian SVM: polynomial (degree 3)?

%% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
% Convert input to table
rng default


predictors = data(:,1:(end-1));
response = data(:,end);
 
% Train a classifier
% This code specifies all the classifier options and trains the classifier.
template = templateSVM(...
    'KernelFunction', 'polynomial', ...
    'PolynomialOrder', 3, ...
    'Standardize', true);
classificationSVM = fitcecoc(...
    predictors, ...
    response, ...
    'Learners', template, ...
    'Coding', 'onevsone', ...
    'ClassNames', [1; 2; 3]);

%% Create the result struct with predict function
 svmPredictFcn = @(x) predict(classificationSVM, x);
trainedClassifier.predictFcn = @(x) svmPredictFcn(x);

% Add additional fields to the result struct
trainedClassifier.ClassificationSVM = classificationSVM;

%% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
  
% Set up holdout validation
cvp = cvpartition(response, 'Holdout', 0.25);
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :);
 
% Create the result struct with predict function
svmPredictFcn = @(x) predict(classificationSVM, x);
validationPredictFcn = @(x) svmPredictFcn(x); 

% Compute validation predictions
validationPredictors = predictors(cvp.test, :);
validationResponse = response(cvp.test, :);
[validationPredictions, ~] = validationPredictFcn(validationPredictors);
 

%% display results
%figure;
%ConfusionPlot(confusionmat(validationResponse,validationPredictions));title('polynomial svm');
[polynomialSVMResult,polynomialSVMReferenceResult] = runAllStats(makeBinary(validationResponse),makeBinary(validationPredictions));
     save polynomialSVMResults.mat polynomialSVMResult polynomialSVMReferenceResult

end