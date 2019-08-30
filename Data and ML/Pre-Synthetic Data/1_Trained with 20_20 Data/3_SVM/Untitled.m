
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