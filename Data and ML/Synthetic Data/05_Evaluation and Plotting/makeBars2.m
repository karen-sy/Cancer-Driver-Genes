loadOrder = ["knnResults.mat", "logisticResults.mat", "linearSVMResults.mat", "GaussianResults.mat",  "treeResults.mat"];

precision = zeros(5,1);
recall = zeros(5,1);
for i = 1:5
    load(loadOrder(i)); %prec, rec
    precision(i) = mean(prec);
    recall(i) = mean(rec);
end
precRec = [precision recall];
b = bar(categorical(["k-nearest neighbor" "logistic regression" "linear SVM" "gaussian SVM" "decision tree"]), precRec)
set(gca,'FontSize',15,'FontName', 'Garamond');
ylim([0 0.7])

title('Precision and Recall Scores of Naive Machine Learning Algorithms');
legend('Precision', 'Recall');

