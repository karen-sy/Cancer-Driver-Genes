%Run all naive classifiers at once, put results into same folder
clc; close all
loadXY;
X = ConsensusX;
Y = ConsensusY;

logisticRegression([X,Y]);
gaussianSVMnaive([X,Y]);
knnClassifier([X,Y]);
classifykmeans([X,Y]);
decisionTree([X,Y]);
