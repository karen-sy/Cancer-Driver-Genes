function [AUC, aucvec] = RUN_ROC_curve(scores, correctLabel, cut)
loadXY; close all
%% rank and sum
[~, rank] = sort(sum(scores(:,2:3),2),'descend');
correctLabel = makeBinary(correctLabel(rank));
%predLabel = predLabel(rank);

%ROC_data = ROC_curve(correctLabel(1:cut),predLabel(1:cut));
aucvec = zeros(1,cut);
for i = 100:cut
    [X,Y,~,AUC] = perfcurve(correctLabel(1:i),scores(rank(1:i),2)+scores(rank(1:i),3),1);
    aucvec(i) = (AUC);
    %hold on; plot(X,Y,'Linewidth', 3)
    disp(i)
end
end
