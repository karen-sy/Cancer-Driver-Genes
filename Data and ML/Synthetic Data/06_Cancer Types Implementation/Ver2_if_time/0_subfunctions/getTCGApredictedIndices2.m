function getTCGApredictedIndices2(classifier)
%% getTCGApredictedIndices.m
% getTCGApredictedIndices retrieves indices of driver genes predicted by 
% classifier and/or implicated in CGC, given information from 
% indexCancerTypes and the classifier.

close all; loadXY; 
load TCGAsubsets.mat breast_mutfile colorectal_mutfile melanoma_mutfile pancrea_mutfile
load uniqueGeneNames.mat uniqueGeneNames
 
%colon cancer
colonX = ConsensusX(ismember(ConsensusX,colon_mutfile),:); colonY = ConsensusY(colon,:); %189 OG, 199 tsg

%melanoma 
load Melanoma.mat CancerIdx; melanoma = ismember(uniqueGeneNames, CancerIdx);
melanomaX = ConsensusX(melanoma,:); melanomaY = ConsensusY(melanoma,:); %222 og, 216 tsg

%breast cancer
load Breast.mat CancerIdx; breast = ismember(uniqueGeneNames, CancerIdx);
breastX = ConsensusX(breast,:); breastY = ConsensusY(breast,:); %206 og, 212 tsg

%pancreatic cancer
load Pancreatic.mat CancerIdx; pancrea = ismember(uniqueGeneNames, CancerIdx);
pancreaX = ConsensusX(pancrea,:); pancreaY = ConsensusY(pancrea,:); %78 og, 114 tsg


%% Find and rank driver genes predicted by classifier.
%NOTE: cancerGENEintersect = TCGA and classifier agree


%colon
[colonPredicted,colonScore]  = classifier.predictFcn([colonX]);
colonOG = find(colonPredicted == 2); 
colonTSG = find(colonPredicted == 3); 
colonDriver = [colonOG;colonTSG]; 
[~,orderOG] = sort(colonScore(colonOG,2),'descend'); %rank gene scores
[~,orderTSG] = sort(colonScore(colonTSG,3),'descend'); %rank gene scores
[~,orderDriver] = sort((colonScore(colonDriver,2)+colonScore(colonDriver,3)),'descend');
colonOG = colonOG(orderOG); colonTSG = colonTSG(orderTSG); colonDriver = colonDriver(orderDriver);
 
colonOGintersect = intersect(colonOG,find(colonY == 2),'stable'); colonOGscores = colonScore(colonOGintersect,2);
colonTSGintersect = intersect(colonTSG,find(colonY == 3),'stable'); colonTSGscores = colonScore(colonTSGintersect,3);
colonDriverintersect = intersect(colonDriver, find(colonY ~= 1), 'stable'); colonDriverscores = colonScore(colonDriverintersect,2)+colonScore(colonDriverintersect,3);
 
colonOGcountReal = intersect(find(colon),find(ConsensusY == 2)); %how many og's in TCGA
colonTSGcountReal = intersect(find(colon),find(ConsensusY == 3));


%melanoma
[melanomaPredicted,melanomaScore]  = classifier.predictFcn([melanomaX]);
melanomaOG = find(melanomaPredicted == 2); 
melanomaTSG = find(melanomaPredicted == 3); 
melanomaDriver = [melanomaOG;melanomaTSG]; 
[~,orderOG] = sort(melanomaScore(melanomaOG,2),'descend'); %rank scores
[~,orderTSG] = sort(melanomaScore(melanomaTSG,3),'descend'); %rank scores
[~,orderDriver] = sort((melanomaScore(melanomaDriver,2)+ ...
                        melanomaScore(melanomaDriver,3)),'descend');
melanomaOG = melanomaOG(orderOG); 
melanomaTSG = melanomaTSG(orderTSG); 
melanomaDriver = melanomaDriver(orderDriver);
 
melanomaOGintersect = intersect(melanomaOG,find(melanomaY == 2),'stable'); 
melanomaOGscores = melanomaScore(melanomaOGintersect,2);
melanomaTSGintersect = intersect(melanomaTSG,find(melanomaY == 3),'stable'); 
melanomaTSGscores = melanomaScore(melanomaTSGintersect,3);
melanomaDriverintersect = intersect(melanomaDriver, find(melanomaY ~= 1),'stable'); 
melanomaDriverscores = melanomaScore(melanomaDriverintersect,2)+ ...
                       melanomaScore(melanomaDriverintersect,3);
 
melanomaOGcountReal = intersect(find(melanoma),find(ConsensusY == 2)); %how many og's in TCGA
melanomaTSGcountReal = intersect(find(melanoma),find(ConsensusY == 3));


%breast
[breastPredicted,breastScore]  = classifier.predictFcn([breastX]);
breastOG = find(breastPredicted == 2); 
breastTSG = find(breastPredicted == 3); 
breastDriver = [breastOG;breastTSG]; 
[~,orderOG] = sort(breastScore(breastOG,2),'descend'); %rank gene scores
  [~,orderDriver] = sort((breastScore(breastDriver,2)+ ... 
                        breastScore(breastDriver,3)),'descend');
breastOG = breastOG(orderOG);
breastDriver = breastDriver(orderDriver);breastTSG = breastTSG(orderTSG); 

 
breastOGintersect = intersect(breastOG,find(breastY == 2),'stable');
breastOGscores = breastScore(breastOGintersect,2);
breastTSGintersect = intersect(breastTSG,find(breastY == 3),'stable'); 
breastTSGscores = breastScore(breastTSGintersect,3);
breastDriverintersect = intersect(breastDriver, find(breastY ~= 1), 'stable'); 
breastDriverscores = breastScore(breastDriverintersect,2)+breastScore(breastDriverintersect,3);
 
breastOGcountReal = intersect(find(breast),find(ConsensusY == 2)); %how many og's in TCGA
breastTSGcountReal = intersect(find(breast),find(ConsensusY == 3));
 
%pancrea
[pancreaPredicted,pancreaScore]  = classifier.predictFcn([pancreaX]);
pancreaOG = find(pancreaPredicted == 2); 
pancreaTSG = find(pancreaPredicted == 3); 
pancreaDriver = [pancreaOG;pancreaTSG]; 
[~,orderOG] = sort(pancreaScore(pancreaOG,2),'descend'); %rank gene scores
[~,orderTSG] = sort(pancreaScore(pancreaTSG,3),'descend'); %rank gene scores
[~,orderDriver] = sort((pancreaScore(pancreaDriver,2)+ ... 
                        pancreaScore(pancreaDriver,3)),'descend');
pancreaOG = pancreaOG(orderOG); 
pancreaTSG = pancreaTSG(orderTSG); 
pancreaDriver = pancreaDriver(orderDriver);
 
pancreaOGintersect = intersect(pancreaOG,find(pancreaY == 2),'stable');
pancreaOGscores = pancreaScore(pancreaOGintersect,2);
pancreaTSGintersect = intersect(pancreaTSG,find(pancreaY == 3),'stable'); 
pancreaTSGscores = pancreaScore(pancreaTSGintersect,3);
pancreaDriverintersect = intersect(pancreaDriver, find(pancreaY ~= 1), 'stable'); 
pancreaDriverscores = pancreaScore(pancreaDriverintersect,2)+ ...
                      pancreaScore(pancreaDriverintersect,3);

pancreaOGcountReal = intersect(find(pancrea),find(ConsensusY == 2)); %how many og's in TCGA
pancreaTSGcountReal = intersect(find(pancrea),find(ConsensusY == 3));
 

%% Save ranked scores and indices of various types of genes 
%saveIndices;
end
