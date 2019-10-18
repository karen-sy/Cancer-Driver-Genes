function logisticRegression(X, y)
%% LogisticRegression.m
% LogisticRegression uses a simple logistic regression-classification model

% logistic regression: Initialize
rng default
load Cost.mat cost
 
% Setup 
Lambda = logspace(-10,10,20); %Create a set of 11 logarithmically-spaced regularization strengths from 1e-6 to 1e-0.5
 
% Fit a classification model

t = templateLinear('learner','logistic','Lambda',Lambda);


% train 
%For each regularization strength, train a classification model 
%using the entire data set and the same options as when you cross-validated the models. 
cvp = cvpartition(y, 'Holdout', 0.15); 
trainingPredictors = X(cvp.training, :);
trainingResponse = y(cvp.training, :);

[modeldraft] = fitcecoc(trainingPredictors,trainingResponse,'Learners',t, 'Cost', cost);
%ce = kfoldLoss(Model,'lossfun','logit'); %avg error from cross-validations (measure of how overall classifier is doing)
     %Because there are 11 regularization strengths, ce is a 1-by-11 vector of classification error rates.
ce = loss(modeldraft,X,y,'lossfun','logit');
minLambda = find(ce == min(ce));
t = templateLinear('learner','logistic','Lambda',Lambda(minLambda(1)));

[Model] = fitcecoc(trainingPredictors,trainingResponse,'Learners',t, 'Cost', cost);


% Create the result struct with predict function
%ensemblePredictFcn = @(x) predict(classificationEnsemble, x);
trainedClassifier.predictFcn = @(x) predict(Model, x);

% Add additdaional fields to the result struct
trainedClassifier.ClassificationEnsemble = Model;

%% validation predictions
validationPredictors = X(cvp.test, :);
validationResponse = y(cvp.test, :);  %actual class
[validationPredictions, validationScores] = predict(Model,validationPredictors); %predicted class
[fullPredictions, fullScores] = predict(Model, X);

%% In a new folder, save results
pred = makeBinary(validationPredictions);
resp = makeBinary(validationResponse);

[validationResult,~] = runAllStats(1-resp,1-pred); %get all stats values
[fullResult,~] = runAllStats(1-makeBinary(y),1-makeBinary(predict(Model,X))); %kinda useless... all predicted

save logitResults.mat validationResult validationResponse validationPredictions validationScores fullResult fullPredictions fullScores trainedClassifier
save logitModel.mat Model %just another copy of the classifier
 
end


