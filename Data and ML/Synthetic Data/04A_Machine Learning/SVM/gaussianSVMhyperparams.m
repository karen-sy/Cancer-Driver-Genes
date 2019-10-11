function  gaussianSVMhyperparams (data)

%% Fit a classification model
clc
y = data(:,end);
X = data(:,1:(end-1));
 

%Set up a partition for cross-validation. This step fixes the train and test sets that the optimization uses at each step.
c = cvpartition(length(y),'KFold',10);


%To find a good fit, meaning one with a low cross-validation loss, set options to use Bayesian optimization. Use the same cross-validation partition c in all optimizations.
%For reproducibility, use the 'expected-improvement-plus' acquisition function.
opts = struct('Optimizer','bayesopt','ShowPlots',true,'CVPartition',c,...
    'AcquisitionFunctionName','expected-improvement-plus');

t = templateSVM('Standardize',1,'KernelFunction','gaussian');

%[Model] = fitcecoc(X,y,'Learners',t,...
%    'OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',opts);

%kernelscale = Model.HyperparameterOptimizationResults.XAtMinObjective.KernelScale; %now we know the optimized kernel scale
%boxconstraint = Model.HyperparameterOptimizationResults.XAtMinObjective.BoxConstraint;

% results
boxconstraint = 1.1124;
kernelscale = 16.72;

%% Find the loss of the optimized model.

t = templateSVM('Standardize',1,'KernelFunction','gaussian','BoxConstraint',boxconstraint,...
    'KernelScale',kernelscale);

FinalModel = fitcecoc(X,y,'Learners',t);
 
%% predict on TCGA
loadXY;
predicted = predict(FinalModel,ConsensusX);

%% Check accuracy on TCGA
%convert to binary classification for now
Y = makeBinary(ConsensusY); 
predictedY = makeBinary(predicted);
  
[TCGAfullResult, TCGAfullReferenceResult] = runAllStats(1-Y,1-predictedY);

TCGAfullResult.p_value = 1 - Hypergeometric_pvalue(Y, predictedY);

%save GaussianData.mat C predicted kernelscale boxconstraint cost

end


