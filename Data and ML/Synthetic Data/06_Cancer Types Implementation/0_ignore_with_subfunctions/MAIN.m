function MAIN(classifier)
% MAIN is the main script that executes three functions which: (1) retrieves lists of genes' 
% indices to TCGA, (2) converts indices to names, and (3) exports name 
% lists to excel.


time = clock;
newfolder = sprintf('Results_%d_%d_%d_%d_%d',time(1:5));
mkdir (newfolder); cd (newfolder);

getTCGApredictedIndices(classifier);
getTCGApredictedNames;
exportAllCancerAllGenes;

end