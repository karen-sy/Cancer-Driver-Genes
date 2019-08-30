function CorrelationPlot(X,y)
clc;
% yPassenger = find(y == 1);
% yOnco = find(y == 2);
% yTSG = find(y == 3);

figure;
categories = char({'SilFrac' 'NonFrac' 'MisFrac' 'NonToMis' 'MisToSil' 'NonSilToSil' 'geneCountFract' 'geneLength' 'MissenseEntropy' 'MutationEntropy' 'MisPval' 'NonPval' 'SilPval'});
% gplotmatrix(X([yPassenger(1:200);yOnco;yTSG],:),[],y([yPassenger(1:200);yOnco;yTSG],:),[],[],4,0,[],categories,categories);
gplotmatrix(X,[],y,['rgb'],[],4,0,[],categories,categories);
set(gca,'FontSize',12,'FontName', 'Times New Roman');

 legend('Passenger', 'Oncogene' ,'Tumor Suppressor', 'Location', 'NorthEastOutside');
end

 