function MAIN2(classifier)
time = clock;
newfolder = sprintf('Results_%d_%d_%d_%d_%d',time(1:5));
mkdir (newfolder); cd (newfolder);

%%
loadXY;
load uniqueGeneNames.mat uniqueGeneNames
 
%colon cancer
load Colorectal.mat CancerIdx; colon = ismember(uniqueGeneNames, CancerIdx);
colonX = ConsensusX(colon,:); colonY = ConsensusY(colon,:); %189 OG, 199 tsg

%melanoma 
load Melanoma.mat CancerIdx; melanoma = ismember(uniqueGeneNames, CancerIdx);
melanomaX = ConsensusX(melanoma,:); melanomaY = ConsensusY(melanoma,:); %222 og, 216 tsg

%breast cancer
load Breast.mat CancerIdx; breast = ismember(uniqueGeneNames, CancerIdx);
breastX = ConsensusX(breast,:); breastY = ConsensusY(breast,:); %206 og, 212 tsg

%pancreatic cancer
load Pancreatic.mat CancerIdx; pancrea = ismember(uniqueGeneNames, CancerIdx);
pancreaX = ConsensusX(pancrea,:); pancreaY = ConsensusY(pancrea,:); %78 og, 114 tsg


% ------ Find and rank driver genes predicted by classifier.
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
 
colonOGintersect = intersect(colonOG,find(colonY == 2),'stable');  
colonTSGintersect = intersect(colonTSG,find(colonY == 3),'stable'); 
colonDriverintersect = intersect(colonDriver, find(colonY ~= 1), 'stable'); 
colonDriverNonintersect = setdiff(colonDriver, find(colonY ~=1), 'stable');  

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
melanomaTSGintersect = intersect(melanomaTSG,find(melanomaY == 3),'stable'); 
melanomaDriverintersect = intersect(melanomaDriver, find(melanomaY ~= 1),'stable'); 
melanomaDriverNonintersect = setdiff(melanomaDriver, find(melanomaY ~= 1),'stable'); 
 
  

%breast
[breastPredicted,breastScore]  = classifier.predictFcn([breastX]);
breastOG = find(breastPredicted == 2); 
breastTSG = find(breastPredicted == 3); 
breastDriver = [breastOG;breastTSG]; 
[~,orderOG] = sort(breastScore(breastOG,2),'descend'); %rank gene scores
[~,orderTSG] = sort(breastScore(breastTSG,3),'descend'); %rank gene scores
[~,orderDriver] = sort((breastScore(breastDriver,2)+ ... 
                        breastScore(breastDriver,3)),'descend');
breastOG = breastOG(orderOG);
breastTSG = breastTSG(orderTSG); 
breastDriver = breastDriver(orderDriver);
 
breastOGintersect = intersect(breastOG,find(breastY == 2),'stable');
breastTSGintersect = intersect(breastTSG,find(breastY == 3),'stable'); 
breastDriverintersect = intersect(breastDriver, find(breastY ~= 1), 'stable'); 
breastDriverNonintersect = setdiff(breastDriver, find(breastY ~= 1), 'stable'); 
  
 
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
pancreaTSGintersect = intersect(pancreaTSG,find(pancreaY == 3),'stable'); 
pancreaDriverintersect = intersect(pancreaDriver, find(pancreaY ~= 1), 'stable'); 
pancreaDriverNonintersect = setdiff(pancreaDriver, find(pancreaY ~= 1), 'stable'); 
 


%% 
%% getTCGApredictedNames.m

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
colonDriverNonintersect = uniqueGeneNames(colon(colonDriverNonintersect));

melanomaOG = uniqueGeneNames(melanoma(melanomaOG));
melanomaTSG = uniqueGeneNames(melanoma(melanomaTSG));
melanomaDriver = uniqueGeneNames(melanoma(melanomaDriver));
melanomaOGintersect = uniqueGeneNames(melanoma(melanomaOGintersect));
melanomaTSGintersect = uniqueGeneNames(melanoma(melanomaTSGintersect));
melanomaDriverintersect = uniqueGeneNames(melanoma(melanomaDriverintersect));
melanomaDriverNonintersect = uniqueGeneNames(melanoma(melanomaDriverNonintersect));

pancreaOG = uniqueGeneNames(pancrea(pancreaOG));
pancreaTSG = uniqueGeneNames(pancrea(pancreaTSG));
pancreaDriver = uniqueGeneNames(pancrea(pancreaDriver));
pancreaOGintersect = uniqueGeneNames(pancrea(pancreaOGintersect));
pancreaTSGintersect = uniqueGeneNames(pancrea(pancreaTSGintersect));
pancreaDriverintersect = uniqueGeneNames(pancrea(pancreaDriverintersect));
pancreaDriverNonintersect = uniqueGeneNames(pancrea(pancreaDriverNonintersect));

breastOG = uniqueGeneNames(breast(breastOG));
breastTSG = uniqueGeneNames(breast(breastTSG));
breastDriver = uniqueGeneNames(breast(breastDriver));
breastOGintersect = uniqueGeneNames(breast(breastOGintersect));
breastTSGintersect = uniqueGeneNames(breast(breastTSGintersect));
breastDriverintersect = uniqueGeneNames(breast(breastDriverintersect));
breastDriverNonintersect = uniqueGeneNames(breast(breastDriverNonintersect));

%%
%% exportAllCancerAllGenes.m

% exportAllCancerAllGenes.m concatenates and exports to excel lists of
% all predicted and tcga cross-verified og/tsg's across cancer types. 

names = ["colonOG" "colonTSG" "colonDriver" "colonOGintersect" ...
    "colonTSGintersect" "colonDriverintersect" "colonDriverNonintersect" ... 
    "melanomaOG" "melanomaTSG" "melanomaDriver" "melanomaOGintersect"...
    "melanomaTSGintersect" "melanomaDriverintersect" "melanomaDriverNonintersect"...
    "pancreaOG" "pancreaTSG" "pancreaDriver" "pancreaOGintersect" ...
    "pancreaTSGintersect" "pancreaDriverintersect" "pancreaDriverNonintersect"...
    "breastOG" "breastTSG" "breastDriver" "breastOGintersect" ...
    "breastTSGintersect" "breastDriverintersect" "breastDriverNonintersect"];


allGeneNames = strings(2000,length(names));

for i = 1:length(names)
    if ismember(i,[1:7])
        current = eval(names(i));
    elseif ismember(i,[8:14])
        current = eval(names(i));
    elseif ismember(i,[15:21])
        current = eval(names(i));
    else
        current = eval(names(i));
    end
    %list = current.(names(i));
    allGeneNames(1:length(current)+1,i) = [names(i); current];
    
end


%export to excel
filename = 'allPredictedGeneNames2.xlsx';
xlswrite(filename,allGeneNames(:,1:7),'Colon');
xlswrite(filename,allGeneNames(:,8:14),'Melanoma');
xlswrite(filename,allGeneNames(:,15:21),'Pancrea');
xlswrite(filename,allGeneNames(:,22:28),'Breast');

end
