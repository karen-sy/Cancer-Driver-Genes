function FIGURE_Result_SignificantGenes 
Creates plots of probability density estimates
of one feature taken from the inputs: feature matrices from two datasets
and their corresponding class labels
% setup
close all; clc; clear

load uniqueGeneNames.mat
load Colorectal.mat CancerIdx; colon = ismember(uniqueGeneNames, CancerIdx);
load Melanoma.mat CancerIdx; melanoma = ismember(uniqueGeneNames, CancerIdx);
load Breast.mat CancerIdx; breast = ismember(uniqueGeneNames, CancerIdx);
load Pancreatic.mat CancerIdx; pancrea = ismember(uniqueGeneNames, CancerIdx);

load ColonDriversNamesPredicted.mat colonOG colonTSG colonOGintersect colonTSGintersect colonDriverintersect
load MelanomaDriversNamesPredicted.mat  melanomaOG melanomaTSG melanomaOGintersect melanomaTSGintersect melanomaDriverintersect
load PancreaDriversNamesPredicted.mat  pancreaOG pancreaTSG pancreaOGintersect pancreaTSGintersect pancreaDriverintersect
load BreastDriversNamesPredicted.mat  breastOG breastTSG breastOGintersect breastTSGintersect breastDriverintersect

load ColonDriversIndexPredicted.mat colonOGscores colonTSGscores colonDriverscores colonPredicted colonScore  
load MelanomaDriversIndexPredicted.mat melanomaOGscores melanomaTSGscores melanomaDriverscores melanomaPredicted melanomaScore  
load PancreaDriversIndexPredicted.mat  pancreaOGscores pancreaTSGscores pancreaDriverscores pancreaPredicted pancreaScore  
load BreastDriversIndexPredicted.mat  breastOGscores breastTSGscores breastDriverscores breastPredicted breastScore      



%%%% Figure Properties
fig_height = 20;
fig_width = 36;
fig_Name = ["Top Cancer Genes"];
h1 = figure('units','centimeters','pos',[2 -5 fig_width fig_height],'Name',fig_Name,'Color','w');
%%%% Plotting Panel
row 1
pan1_col1 = uipanel('Parent',h1,'pos',[0 .525 1/2 .47],'BackgroundColor','w','BorderType','none','HighlightColor','k');
pan1_col2 = uipanel('Parent',h1,'pos',[1/2 .525 1/2 .47],'BackgroundColor','w','BorderType','none','HighlightColor','k');


row 2
pan2_col1 = uipanel('Parent',h1,'pos',[0 0 1/2 .47],'BackgroundColor','w','BorderType','none','HighlightColor','k');
pan2_col2 = uipanel('Parent',h1,'pos',[1/2 0 1/2 .47],'BackgroundColor','w','BorderType','none','HighlightColor','k');

% %%% Axis Properties
-------------------Col 1: Ax 1-2-----------------------
%% Ax1: Colon Cancer
ax1_height = 0.80;
ax1_width = 0.35;
ax1_x = 0.20;
ax1_y = 0.10;
ax1_Pos = [ax1_x,ax1_y,ax1_width,ax1_height];
ax1 = axes('Parent',pan1_col1,'Position',ax1_Pos,'box','off');
Ax1-2: Colon cancer part 2
ax12_height = 0.80;
ax12_width = 0.35;
ax12_x = 0.55;
ax12_y = 0.10;
ax12_Pos = [ax12_x,ax12_y,ax12_width,ax12_height];
ax12 = axes('Parent',pan1_col1,'Position',ax12_Pos,'box','off');


%% Ax2: Breast Cancer
ax2_Pos = [ax1_x,ax1_y,ax1_width,ax1_height];
ax2 = axes('Parent',pan2_col1,'Position',ax2_Pos,'box','off');
ax22_Pos = [ax12_x,ax12_y,ax12_width,ax12_height];
ax22 = axes('Parent',pan2_col1,'Position',ax22_Pos,'box','off');

-------------------Col 2: Ax 3-4-----------------------
%% Col 2 Ax1: Pancreatic Cancer
ax3_Pos = [0.1,ax1_y,ax1_width,ax1_height];
ax3 = axes('Parent',pan1_col2,'Position',ax3_Pos,'box','off');
ax32_Pos = [0.45,ax12_y,ax12_width,ax12_height];
ax32 = axes('Parent',pan1_col2,'Position',ax32_Pos,'box','off');


%% Col 2 Ax2: Melanoma
ax4_Pos = ax3_Pos;
ax4 = axes('Parent',pan2_col2,'Position',ax4_Pos,'box','off');
ax42_Pos = ax32_Pos;
ax42 = axes('Parent',pan2_col2,'Position',ax42_Pos,'box','off');



% PLOT; Set limits, labels
Ax1: colon cancer
currentAx = ax1;
[~,~,ib] = intersect(colonDriverintersect,uniqueGeneNames(colon),'stable');
y = [colonScore(ib(10:-1:1),2)];
barh(y,'Parent',currentAx); % stacks values in each row of y together
set(ax1, 'Xdir', 'reverse')
set(ax1, 'YAxisLocation', 'Right')
title('OG Score','Parent',currentAx);

currentAx = ax12;
y = [colonScore(ib(10:-1:1),3)];
barh(y,'Parent',currentAx,'FaceColor','r'); % stacks values in each row of y together
set(currentAx, 'YAxisLocation', 'Right')
 yticklabels(currentAx,colonDriverintersect(10:-1:1));
title('TSG Score','Parent',currentAx);
 

Ax2: breast cancer
currentAx = ax2;
[~,~,ib] = intersect(breastDriverintersect,uniqueGeneNames(breast),'stable');
y = [breastScore(ib(10:-1:1),2)];
barh(y,'Parent',currentAx); % stacks values in each row of y together
set(ax2, 'Xdir', 'reverse')
set(ax2, 'YAxisLocation', 'Right')
title('OG Score','Parent',currentAx);
 yticklabels(currentAx,breastDriverintersect(10:-1:1));
 
currentAx = ax22;
y = [breastScore(ib(10:-1:1),3)];
barh(y,'Parent',currentAx,'FaceColor','r'); % stacks values in each row of y together
set(currentAx, 'YAxisLocation', 'Right')
yticklabels(currentAx,breastDriverintersect(10:-1:1));
title('TSG Score','Parent',currentAx);

Ax3: pancrea cancer
currentAx = ax3;
[~,~,ib] = intersect(pancreaDriverintersect,uniqueGeneNames(pancrea),'stable');
y = [pancreaScore(ib(10:-1:1),2)];
set(currentAx, 'YAxisLocation', 'Right')
barh(y,'Parent',currentAx); % stacks values in each row of y together
set(currentAx,'Xdir','reverse')
set(currentAx, 'YAxisLocation', 'Left')
yticklabels(currentAx,'');
title('OG Score','Parent',currentAx);

currentAx = ax32;
y = [pancreaScore(ib(10:-1:1),3)];
barh(y,'Parent',currentAx,'FaceColor','r'); % stacks values in each row of y together
set(currentAx, 'YAxisLocation', 'Right')
 yticklabels(currentAx,pancreaDriverintersect(10:-1:1));
title('TSG Score','Parent',currentAx);

Ax4: melanoma
currentAx = ax4;
[~,~,ib] = intersect(melanomaDriverintersect,uniqueGeneNames(melanoma),'stable');
y = [melanomaScore(ib(10:-1:1),2)];
set(currentAx, 'YAxisLocation', 'Right')
barh(y,'Parent',currentAx); % stacks values in each row of y together
set(currentAx,'Xdir','reverse')
set(currentAx, 'YAxisLocation', 'Left')
yticklabels(currentAx,'');
title('OG Score','Parent',currentAx);
 
currentAx = ax42;
y = [melanomaScore(ib(10:-1:1),3)];
barh(y,'Parent',currentAx,'FaceColor','r'); % stacks values in each row of y together
set(currentAx, 'YAxisLocation', 'Right')
 yticklabels(currentAx,melanomaDriverintersect(10:-1:1));
title('TSG Score','Parent',currentAx);

% Revise font, etc.

set(ax1,'FontName','Times New Roman','FontSize',10), set(ax12,'FontName','Times New Roman','FontSize',10); 
set(ax2,'FontName','Times New Roman','FontSize',10), set(ax22,'FontName','Times New Roman','FontSize',10); 
set(ax3,'FontName','Times New Roman','FontSize',10), set(ax32,'FontName','Times New Roman','FontSize',10);
set(ax4,'FontName','Times New Roman','FontSize',10), set(ax42,'FontName','Times New Roman','FontSize',10);



% Figure box letters
t_ax1 = text(-.1, 0.9,'1','Units','Normalized','FontName','Times New Roman','FontSize',24,'Parent',ax1,'HorizontalAlignment','Right','VerticalAlignment','bottom');

t_ax3 = text(-.1, 0.9,'2','Units','Normalized','FontName','Times New Roman','FontSize',24,'Parent',ax2,'HorizontalAlignment','Right','VerticalAlignment','bottom');

t_ax5 = text(-.1, 0.9,'3','Units','Normalized','FontName','Times New Roman','FontSize',24,'Parent',ax3,'HorizontalAlignment','Right','VerticalAlignment','bottom');

t_ax7 = text(-.1, 0.9,'4','Units','Normalized','FontName','Times New Roman','FontSize',24,'Parent',ax4,'HorizontalAlignment','Right','VerticalAlignment','bottom');


export_fig (sprintf(fig_Name),'-r300',  '-png');




pause;
end
 