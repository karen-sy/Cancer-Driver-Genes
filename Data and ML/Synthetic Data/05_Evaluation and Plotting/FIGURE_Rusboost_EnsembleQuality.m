function FIGURE_Rusboost_EnsembleQuality (ensemble, validationPredictors, validationResponse)
% FIGURE_Rusboost_EnsembleQuality is a subfunction that goes with
% RUSBoostClassifier.m in the Machine Learning folder. 
% Plots the ensemble quality of the random forest model as tuning progresses

figure;

%on **TCGA**: test set
loadXY; 
plot(loss(ensemble,ConsensusX,ConsensusY,'mode','cumulative'),'LineWidth',5);

%on subset of **synthetic** data: validation set
hold on;
plot(loss(ensemble,validationPredictors,validationResponse,'mode','cumulative'),'r','LineWidth',5);
hold off;
xlabel('Number of trees');
ylabel('Classification error');
legend('Test','Cross-validation','Location','NE');
set(gca,'FontSize',12,'FontName', 'Times New Roman');
% export_fig -r300 -transparent RUSensembleQuality.png;
end