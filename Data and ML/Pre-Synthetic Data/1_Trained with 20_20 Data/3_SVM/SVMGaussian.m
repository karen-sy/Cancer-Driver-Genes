function [Model, predicted, C] = SVMGaussian
%% logistic regression: Initialize
clear; close all; clc; rng default

load no_nan_X.mat 
load no_nan_y.mat 

%% Fit a classification model
%1) subsampling
pass = (y==1); %total > 19000
data = [X y];
datamod = [datasample(data(pass,:),200); data(~pass,:)];
Xmod = datamod(:,1:9);
ymod = datamod(:,10);

%customize the cost function 
cost = [0 50 50; 500 0 1; 500 1 0];


[C,gamma] = meshgrid((-5:2:15),(-15:2:3));

ce = zeros(numel(C),1);minIdx = zeros(numel(C),1); 

for j = 1:120
    %resample
datamod = [datasample(data(pass,:),200,'Replace',false); data(~pass,:)];
Xmod = datamod(:,1:9);
ymod = datamod(:,10);   
    
    
for i = 1:numel(C)
 t = templateSVM('Standardize',1,'KernelFunction','gaussian','BoxConstraint',2^(C(i)),'KernelScale',2^(gamma(i)));
Model = (fitcecoc(Xmod,ymod,'Learners',t,'Cost',cost,'kfold',10));

ce(i) = kfoldLoss(Model); 
end


fprintf('=================')
minIdx(j) = find((ce == min(ce)),1); %index into C
disp(ce(minIdx(j)))
end
disp(minIdx);
idx = find(ce == min(ce));

%% predict, using full set 
[C,gamma] = meshgrid((-5:2:15),(-15:2:3));
boxconstraint = 2^(C(idx));
kernelscale = 2^(gamma(idx));

t = templateSVM('Standardize',1,'KernelFunction','gaussian','BoxConstraint',boxconstraint,'KernelScale',kernelscale);

Model = fitcecoc(X,y,'Learners',t, 'Cost',cost,'kfold',10);
loss = kfoldLoss(Model);
predicted = kfoldPredict(Model);

%% Check accuracy
%confusion matrix
g1 = y;
g2 = predicted;%predicted
Conf = confusionmat(g1,g2); 
ConfusionPlot(Conf)
save GaussianData.mat Conf predicted cost boxconstraint kernelscale idx


