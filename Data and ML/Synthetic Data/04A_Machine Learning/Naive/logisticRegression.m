function logisticRegression(data)
%% LogisticRegression.m
% LogisticRegression uses a simple logistic regression-classification model

% logistic regression: Initialize
clc; rng default

X = (data(:,1:end-1));
y = data(:,end);

% Setup 
Lambda = logspace(-10,10,20); %Create a set of 11 logarithmically-spaced regularization strengths from 1e-6 to 1e-0.5
 
% Fit a classification model

t = templateLinear('learner','logistic','Lambda',Lambda);


% customize the cost function 
%cost = 1-eye(3); %defaultcost.png
p = sum(y == 1);
og = sum(y == 2);
tsg = sum(y == 3);


% train 
%For each regularization strength, train a classification model 
%using the entire data set and the same options as when you cross-validated the models. 
c = cvpartition(y,'Kfold',10,'Stratify',true);
[Model] = fitcecoc(X,y,'Learners',t,'cvpartition',c,'Cost',cost);
ce = kfoldLoss(Model,'lossfun','logit'); %avg error from cross-validations (measure of how overall classifier is doing)
     %Because there are 11 regularization strengths, ce is a 1-by-11 vector of classification error rates.


% Plot
%Determine how well the models generalize by 
%plotting the averages of the 5-fold classification error 
%for each regularization strength. 
figure;
plot(log10(Lambda),log10(ce),'o-'); 
ylabel('log_{10} classification error')
xlabel('log_{10} Lambda')
title('Test-Sample Statistics')
hold off


%Identify the regularization strength that minimizes the generalization error over the grid.idxFinal 
%Select the model from Mdl with the chosen regularization strength.
minLambda = find(ce == min(ce));
t = templateLinear('Learner','logistic',...
    'Lambda',Lambda(minLambda(1)));
 
ModelFinal = fitcecoc(X(1:9500,:),y(1:9500),'Learners',t,'Cost',cost);
%To estimate labels for new observations, pass MdlFinal and the new data to predict.

% predict 
[predicted,score] = predict(ModelFinal,X(500:end,:));
 

% Check accuracy
%confusion matrix
g1 = y(7500:end); 
g2 = predicted; 
%C = confusionmat(g1,g2);

figure;
ConfusionPlot(C); title('LR'); %plot confusion matrix 
%[LRegResult,LRegReferenceResult] = runAllStats((g1),(g2));  
[LRegResult,LRegReferenceResult] = runAllStats(makeBinary(g1),makeBinary(g2)); %get all stats values
save LogisticResults.mat C LRegResult LRegReferenceResult
end


