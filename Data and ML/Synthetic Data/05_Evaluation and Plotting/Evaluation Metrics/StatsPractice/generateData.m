clear all
close all
clc

%%
rng(1)
NoGenes = 2000; %# of genes considered
affectedPercent = 0.01; % Percentage of Genes affected by drug
q = 0.1;
affectedGenes = sort(randperm(NoGenes,floor(affectedPercent*NoGenes)))
NoCases = 10; %case count per gene
rangeMean = [100,1000];
rangeStd = [0.25 0.5];

%create control data
ctrlMean = rand(1,NoGenes)*(rangeMean(2)-rangeMean(1))+rangeMean(1);
ctrlStd = ctrlMean.*(rand(1,NoGenes)*(rangeStd(2)-rangeStd(1))+rangeStd(1));
ctrl = randn(NoCases,NoGenes).*ctrlStd+ctrlMean;

%create experimental gene data
affectedMean = ctrlMean;
affectedMean(affectedGenes) = rand(1,length(affectedGenes))*(rangeMean(2)-rangeMean(1))+rangeMean(1);
affectedStd = ctrlStd;
affectedStd(affectedGenes) = affectedMean(affectedGenes).*(rand(1,length(affectedGenes))*(rangeStd(2)-rangeStd(1))+rangeStd(1));
experiment = randn(NoCases,NoGenes).*affectedStd+affectedMean;

%% 
[~,pttest] = ttest2(ctrl,experiment);

p = permutationTest(5000,ctrl,experiment);


pAdj = adjustP(p);

[iTtest] = find(pttest<=q); %what t-test returns as 'significant' (under thresh p)
[iP] = find(p<=q); %what perm test returns
[ipAdj] = find(pAdj<=q); %same as above, but after b-h
