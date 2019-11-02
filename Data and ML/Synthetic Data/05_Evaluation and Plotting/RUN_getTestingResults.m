function RUN_getTestingResults(trainedClassifier, Y, X)

load('Breast.mat')
[breastfullResult, breastfullResult_top100] = getTestingResults(trainedClassifier, Y(breastIdx==1), X(find(breastIdx),:));

load('Colorectal.mat')
[colorectalfullResult, colorectalfullResult_top100] = getTestingResults(trainedClassifier, Y(colorectalIdx==1), X(find(colorectalIdx),:));

load('Melanoma.mat')
[melanomafullResult, melanomafullResult_top100] = getTestingResults(trainedClassifier, Y(melanomaIdx==1), X(find(melanomaIdx),:));

load('Pancreatic.mat')
[pancreaticfullResult, pancreaticfullResult_top100] = getTestingResults(trainedClassifier, Y(pancreaIdx==1), X(find(pancreaIdx),:));

 


save results.mat breastfullResult breastfullResult_top100 colorectalfullResult ...
    colorectalfullResult_top100 melanomafullResult melanomafullResult_top100 ...
    pancreaticfullResult pancreaticfullResult_top100




end