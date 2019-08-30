function [ModelFinal, predicted, C] = SVMLinear
% SVMLINEAR a linear SVM model, modified cost function, trained on 80% of 
% data, tested on the remaining 20% of data
%% initialize
clear; close all; clc

load X.mat 
load y.mat 

%% Setup 
X = normalize(X,'range'); 
%% Fit a classification model

%customize the cost function 
p = sum(y == 1);
og = sum(y == 2);
tsg = sum(y == 3);

cost = [0, 1+(og/p), 1+tsg/p; 1+p/og, 0, 1+tsg/og; 1+p/tsg, 1+og/tsg,0]; %inverse of frequency


t = templateSVM('Standardize',1,'KernelFunction','linear');
[ModelFinal] = fitcecoc(X(1:15000,:),y(1:15000),'Learners',t, 'Cost',cost);
 
%% predict 
predicted = predict(ModelFinal,X(15000:end,:)); %test on ~20% of data
%% Check accuracy
%confusion matrix
g1 = y(15000:end); 
g2 = predicted;%predicted
C = confusionmat(g1,g2); 
ConfusionPlot(C);

save GaussianData.mat C predicted


