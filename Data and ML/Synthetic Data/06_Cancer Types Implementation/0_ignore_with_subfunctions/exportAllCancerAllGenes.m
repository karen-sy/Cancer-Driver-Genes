%% exportAllCancerAllGenes.m

% exportAllCancerAllGenes.m concatenates and exports to excel lists of
% all predicted and tcga cross-verified og/tsg's across cancer types. 

names = ["colonOG" "colonTSG" "colonDriver" "colonOGintersect" ...
    "colonTSGintersect" "colonDriverintersect" "melanomaOG" ...
    "melanomaTSG" "melanomaDriver" "melanomaOGintersect"...
    "melanomaTSGintersect" "melanomaDriverintersect"...
    "pancreaOG" "pancreaTSG" "pancreaDriver" "pancreaOGintersect" ...
    "pancreaTSGintersect" "pancreaDriverintersect"...
    "breastOG" "breastTSG" "breastDriver" "breastOGintersect" ...
    "breastTSGintersect" "breastDriverintersect"];


allGeneNames = strings(2000,length(names));

for i = 1:length(names)
    if ismember(i,[1:6])
        current = load('ColonDriversNamesPredicted','-mat',names(i));
    elseif ismember(i,[7:12])
        current = load('MelanomaDriversNamesPredicted','-mat',names(i));
    elseif ismember(i,[13:18])
        current = load('PancreaDriversNamesPredicted','-mat',names(i));
    else
        current = load('BreastDriversNamesPredicted','-mat',names(i));
    end
    list = current.(names(i));
    allGeneNames(1:length(list)+1,i) = [names(i); list];
    
end


%export to excel
filename = 'allPredictedGeneNames2.xlsx';
xlswrite(filename,allGeneNames(:,1:6),'Colon');
xlswrite(filename,allGeneNames(:,7:12),'Melanoma');
xlswrite(filename,allGeneNames(:,13:18),'Pancrea');
xlswrite(filename,allGeneNames(:,19:24),'Breast');
