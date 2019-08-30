%% Tune Random Forest Using Quantile Error and Bayesian Optimization
% This example shows how to implement Bayesian optimization to tune the
% hyperparameters of a random forest of regression trees using quantile
% error.  Tuning a model using quantile error, rather than mean squared
% error, is appropriate if you plan to use the model to predict conditional
% quantiles rather than conditional means.
%% Load and Preprocess Data
loadXY;
X = SyntheticX ;
y = SyntheticY;
rng('default'); % For reproducibility
%% Specify Tuning Parameters
% Consider tuning:
% 
% * The complexity (depth) of the trees in the forest.  Deep trees tend to
% over-fit, but shallow trees tend to underfit.  Therefore, specify that
% the minimum number of observations per leaf be at most 20. 
% * When growing the trees, the number of predictors to sample at each
% node.  Specify sampling from 1 through all of the predictors.
%

maxMinLS = max(2,floor(size(X,1))/2);
minLeaf = optimizableVariable('minLeaf',[1,maxMinLS],'Type','integer');
maxSplits = optimizableVariable('maxSplits',[1,size(X,2)-1],'Type','integer');
bestRate = optimizableVariable('bestRate',[1e-3,5e-1],'Type','real');
numCycles = optimizableVariable('numCycles',[10,500],'Type','integer');
hyperparametersRF = [minLeaf;maxSplits;bestRate;numCycles];
 
%% Minimize Objective Using Bayesian Optimization
results = bayesopt(@(params)oobErrRF(params,X,y),hyperparametersRF,...
    'AcquisitionFunctionName','expected-improvement-plus','Verbose',0);
%%
% |results| is a <docid:stats_ug.bvbcr44 BayesianOptimization> object
% containing, among other things, the minimum of the objective function and
% the optimized hyperparameter values.
%%
% Display the observed minimum of the objective function and the optimized
% hyperparameter values.
bestOOBErr = results.MinObjective
bestHyperparameters = results.XAtMinObjective
%% Train Model Using Optimized Hyperparameters
% Train a random forest using the entire data set and the optimized
% hyperparameter values.
Mdl = fitcensemble(X,y,'Learners', 'tree','Method','RUSBoost','MinLeafSize',bestHyperparameters.minLeaf,...
    'MaxNumSplits',bestHyperparameters.maxSplits,'LearnRate',bestHyperparameters.bestRate,...
    'NumLearningCycles',bestHyperparameters.numCycles,'RatiotoSmallest',[2 1 1],'nprint',100);
 
%%
function oobErr = oobErrRF(params,X,y)
randomForest = fitcensemble(X,y,'Learners','tree','Method','RUSBoost','MinLeafSize',params.minLeaf,...
    'MaxNumSplits',params.maxSplits,'LearnRate',params.bestRate,...
    'NumLearningCycles',params.numCycles,'RatiotoSmallest',[2 1 1],'nprint',100);
oobErr = oobLoss(randomForest);
end

