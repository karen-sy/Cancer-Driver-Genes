function  SVMGaussian2
%% logistic regression: Initialize
clear; close all; clc

load no_nan_X.mat 
load no_nan_y.mat 

%% Setup 
%% Fit a classification model

%customize the cost function 
cost = [0 75 10; 50 0 1; 50 1 0];

%Set up a partition for cross-validation. This step fixes the train and test sets that the optimization uses at each step.
c = cvpartition(length(y),'KFold',10);


%To find a good fit, meaning one with a low cross-validation loss, set options to use Bayesian optimization. Use the same cross-validation partition c in all optimizations.
%For reproducibility, use the 'expected-improvement-plus' acquisition function.
opts = struct('Optimizer','bayesopt','ShowPlots',true,'CVPartition',c,...
    'AcquisitionFunctionName','expected-improvement-plus');

t = templateSVM('Standardize',1,'KernelFunction','gaussian');

[Model] = fitcecoc(X,y,'Learners',t,'Cost',cost,...
    'OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',opts);

kernelscale = Model.HyperparameterOptimizationResults.XAtMinObjective.KernelScale; %now we know the optimized kernel scale
boxconstraint = Model.HyperparameterOptimizationResults.XAtMinObjective.BoxConstraint;

%% Find the loss of the optimized model.

t = templateSVM('Standardize',1,'KernelFunction','gaussian','BoxConstraint',boxconstraint,...
    'KernelScale',kernelscale);

FinalModel = fitcecoc(X,y,'Learners',t,'Cost',cost,'kfold',10);
ce = kfoldLoss(FinalModel); %inaccuracy
disp(ce)
 
%% predict 
predicted = predict(FinalModel,X);

%% Check accuracy
%confusion matrix
g1 = y; 
g2 = predicted;%predicted
C = confusionmat(g1,g2); 
ConfusionPlot(C)

save GaussianData.mat C predicted kernelscale boxconstraint cost


