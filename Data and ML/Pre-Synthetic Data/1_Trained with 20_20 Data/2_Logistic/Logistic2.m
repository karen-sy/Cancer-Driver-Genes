function Logistic2
%linear classification model, WITH SUBSAMPLING APPROACH
% --> inefficient
%% logistic regression: Initialize
clear; clf; clc; rng default

load no_nan_X.mat 
load no_nan_y.mat 
 
%% Setup 
Lambda = logspace(-10,10,20); %Create a set of 11 logarithmically-spaced regularization strengths from 1e-6 to 1e-0.5
X = zscore(X); 
%% Fit a classification model

%customize the cost function 
cost = [0 50 50; 500 0 1; 500 1 0];

%logistic template
t = templateLinear('learner','logistic','Lambda',Lambda);


% subsampling approach, in which passenger genes are sampled at a 1:1 ratio to OGs plus TSGs
pass = (y==1); %total > 19000
data = [X y];

datamod = [datasample(data(pass,:),200);data(~pass,:)]; %x modified
Xmod = datamod(:,1:9);
ymod = datamod(:,10);

%For each regularization strength, train a classification model 
%using the entire data set and the same options as when you cross-validated the models. 
%[Model] = fitcecoc(Xmod,ymod,'Learners',t,'cvpartition',c,'Cost',cost);

Model = fitcecoc(Xmod,ymod,'Learners',t,'Cost',cost);
ca = sum(predict(Model,X) == y)/length(y); %classification accuracy
disp(max(ca))


%Identify the regularization strength that minimizes the generalization error over the grid.
maxLambda = find(ca == max(ca));

t = templateLinear('Learner','logistic',...
    'Lambda',Lambda(maxLambda(1)));
 
ModelFinal = fitcecoc(Xmod,ymod,'Learners',t,'Cost',cost); %make final model using sampled data

%% predict 
predicted = predict(ModelFinal,Xmod); %predict on full set --> turns out to be inaccurate

%% Check accuracy
%confusion matrix
g1 = ymod; 
g2 = predicted;%predicted
C = confusionmat(g1,g2);
ConfusionPlot(C)

save LogisticData2.mat C predicted


