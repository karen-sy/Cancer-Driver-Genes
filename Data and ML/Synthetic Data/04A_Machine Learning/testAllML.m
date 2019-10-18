function testAllML
loadXY;

%time = clock;
%newfolder = sprintf('testAllML_%d_%d_%d_%d_%d',time(1:5));
%mkdir (newfolder); cd (newfolder)

knnClassifier(SyntheticX, SyntheticY); disp("----knn finished----");
logisticRegression(SyntheticX, SyntheticY); disp("----logit finished----");
decisionTree(SyntheticX, SyntheticY); disp("----tree finished----");
polynomialSVM(SyntheticX, SyntheticY); disp("----svm finished----");
randomForest(SyntheticX, SyntheticY); disp("----forest finished----");
%RUSBoostClassifier(SyntheticX, SyntheticY); disp("----rus finished----");



end