%% getTCGApredictedNames.m
% getTCGApredictedNames.m compiles lists of names of driver genes predicted by classifier and/or implicated in
% CGC, given list of indices from getTCGApredictedIndices.m.
% 
% clear;
% load ColonDriversIndexPredicted.mat
% load MelanomaDriversIndexPredicted.mat
% load PancreaDriversIndexPredicted.mat
% load BreastDriversIndexPredicted.mat
% 
% load uniqueGeneNames.mat uniqueGeneNames

colon = find(colon); %index in uniqueGeneNames in which colon cancer occurs
melanoma = find(melanoma);
pancrea = find(pancrea);
breast = find(breast);

colonOG = uniqueGeneNames(colon(colonOG));
colonTSG = uniqueGeneNames(colon(colonTSG));
colonDriver = uniqueGeneNames(colon(colonDriver));
colonOGintersect = uniqueGeneNames(colon(colonOGintersect));
colonTSGintersect = uniqueGeneNames(colon(colonTSGintersect));
colonDriverintersect = uniqueGeneNames(colon(colonDriverintersect));

melanomaOG = uniqueGeneNames(melanoma(melanomaOG));
melanomaTSG = uniqueGeneNames(melanoma(melanomaTSG));
melanomaDriver = uniqueGeneNames(melanoma(melanomaDriver));
melanomaOGintersect = uniqueGeneNames(melanoma(melanomaOGintersect));
melanomaTSGintersect = uniqueGeneNames(melanoma(melanomaTSGintersect));
melanomaDriverintersect = uniqueGeneNames(melanoma(melanomaDriverintersect));

pancreaOG = uniqueGeneNames(pancrea(pancreaOG));
pancreaTSG = uniqueGeneNames(pancrea(pancreaTSG));
pancreaDriver = uniqueGeneNames(pancrea(pancreaDriver));
pancreaOGintersect = uniqueGeneNames(pancrea(pancreaOGintersect));
pancreaTSGintersect = uniqueGeneNames(pancrea(pancreaTSGintersect));
pancreaDriverintersect = uniqueGeneNames(pancrea(pancreaDriverintersect));

breastOG = uniqueGeneNames(breast(breastOG));
breastTSG = uniqueGeneNames(breast(breastTSG));
breastDriver = uniqueGeneNames(breast(breastDriver));
breastOGintersect = uniqueGeneNames(breast(breastOGintersect));
breastTSGintersect = uniqueGeneNames(breast(breastTSGintersect));
breastDriverintersect = uniqueGeneNames(breast(breastDriverintersect));

%
%saveNames;


