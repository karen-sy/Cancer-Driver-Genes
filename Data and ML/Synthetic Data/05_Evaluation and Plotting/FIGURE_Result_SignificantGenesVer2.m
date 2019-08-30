function FIGURE_Result_SignificantGenes

%% setup
%close all; clc; clear

load uniqueGeneNames.mat
load Colorectal.mat CancerIdx; colon = ismember(uniqueGeneNames, CancerIdx);
load Melanoma.mat CancerIdx; melanoma = ismember(uniqueGeneNames, CancerIdx);
load Breast.mat CancerIdx; breast = ismember(uniqueGeneNames, CancerIdx);
load Pancreatic.mat CancerIdx; pancrea = ismember(uniqueGeneNames, CancerIdx);

load ColonDriversNamesPredicted.mat colonDriverintersect
load MelanomaDriversNamesPredicted.mat  melanomaDriverintersect
load PancreaDriversNamesPredicted.mat  pancreaDriverintersect
load BreastDriversNamesPredicted.mat  breastDriverintersect

load ColonDriversIndexPredicted.mat colonScore
load MelanomaDriversIndexPredicted.mat melanomaScore
load PancreaDriversIndexPredicted.mat pancreaScore
load BreastDriversIndexPredicted.mat breastScore



%%%%% Figure Properties
fig_height = 40;
fig_width = 40;
fig_Name = ["driver scores_cross-validated CGC Genes_top10"];
h1 = figure('units','centimeters','pos',[2 -5 fig_width fig_height],'Name',fig_Name,'Color','w');
%%%%% Plotting Panel
%row 1
pan1_col1 = uipanel('Parent',h1,'pos',[0 .525 1/2 .47],'BackgroundColor','w','BorderType','none','HighlightColor','k');
pan1_col2 = uipanel('Parent',h1,'pos',[1/2 .525 1/2 .47],'BackgroundColor','w','BorderType','none','HighlightColor','k');


%row 2
pan2_col1 = uipanel('Parent',h1,'pos',[0 0 1/2 .47],'BackgroundColor','w','BorderType','none','HighlightColor','k');
pan2_col2 = uipanel('Parent',h1,'pos',[1/2 0 1/2 .47],'BackgroundColor','w','BorderType','none','HighlightColor','k');

%% %%% Axis Properties
%-------------------Col 1: Ax 1-2-----------------------
%%% Ax1: Colon Cancer
ax1_height = 0.80;
ax1_width = 0.75;
ax1_x = 0.20;
ax1_y = 0.10;
ax1_Pos = [ax1_x,ax1_y,ax1_width,ax1_height];
ax1 = axes('Parent',pan1_col1,'Position',ax1_Pos);


%%% Ax2: Breast Cancer
ax2_Pos = [ax1_x,ax1_y,ax1_width,ax1_height];
ax2 = axes('Parent',pan2_col1,'Position',ax2_Pos);


%-------------------Col 2: Ax 3-4-----------------------
%%% Col 2 Ax1: Pancreatic Cancer
ax3_Pos = [ax1_x,ax1_y,ax1_width,ax1_height];
ax3 = axes('Parent',pan1_col2,'Position',ax3_Pos);


%%% Col 2 Ax2: Melanoma
ax4_Pos = ax3_Pos;
ax4 = axes('Parent',pan2_col2,'Position',ax4_Pos);



%% PLOT; Set limits, labels
%Ax1: colon cancer
currentAx = ax1;
[~,~,ib] = intersect(colonDriverintersect,uniqueGeneNames(colon),'stable');
y = [colonScore(ib(10:-1:1),2),colonScore(ib(10:-1:1),3)];
barh(y,'Parent',currentAx,'Stacked'); % stacks values in each row of y together
box(ax1,'off');
ax1.XLim = [12 inf];
set(ax1,'FontName','Times New Roman','FontSize',14);
yticklabels(currentAx,colonDriverintersect(10:-1:1));
set(ax1.YAxis,'FontSize',18);
title('Colon Cancer','Parent',currentAx,'FontSize',24);


%Ax2: breast cancer
currentAx = ax2;
[~,~,ib] = intersect(breastDriverintersect,uniqueGeneNames(breast),'stable');
y = [breastScore(ib(10:-1:1),2),breastScore(ib(10:-1:1),3)];
barh(y,'Parent',currentAx,'Stacked'); % stacks values in each row of y together
yticklabels(currentAx,breastDriverintersect(10:-1:1));
ax2.XLim = [12 inf];
box(ax2,'off');
set(ax2,'FontName','Times New Roman','FontSize',14);
set(ax2.YAxis,'FontSize',18);
title('Breast Cancer','Parent',currentAx,'FontSize',24);

%Ax3: pancrea cancer
currentAx = ax3;
[~,~,ib] = intersect(pancreaDriverintersect,uniqueGeneNames(pancrea),'stable');
y = [pancreaScore(ib(10:-1:1),2),pancreaScore(ib(10:-1:1),3)];
barh(y,'Parent',currentAx,'Stacked'); % stacks values in each row of y together
yticklabels(currentAx,pancreaDriverintersect(10:-1:1));
ax3.XLim = [12 inf];
box(ax3,'off');
set(ax3,'FontName','Times New Roman','FontSize',14);
set(ax3.YAxis,'FontSize',18);
title('Pancreatic Cancer','Parent',currentAx,'FontSize',24);


%Ax4: melanoma
currentAx = ax4;
[~,~,ib] = intersect(melanomaDriverintersect,uniqueGeneNames(melanoma),'stable');
y = [melanomaScore(ib(10:-1:1),2), melanomaScore(ib(10:-1:1),3)];
barh(y,'Parent',currentAx,'Stacked'); % stacks values in each row of y together
yticklabels(currentAx,melanomaDriverintersect(10:-1:1));
ax4.XLim = [12 inf];
box(ax4,'off');
set(ax4,'FontName','Times New Roman','FontSize',14);
set(ax4.YAxis,'FontSize',18);
title('Melanoma','Parent',currentAx,'FontSize',24);

%% Figure box letters
t_ax1 = text(-.15, 0.975,'1','Units','Normalized','FontName','Times New Roman','FontSize',28,'Parent',ax1,'HorizontalAlignment','Right','VerticalAlignment','bottom');

t_ax3 = text(-.15, 0.975,'2','Units','Normalized','FontName','Times New Roman','FontSize',28,'Parent',ax2,'HorizontalAlignment','Right','VerticalAlignment','bottom');

t_ax5 = text(-.15, 0.975,'3','Units','Normalized','FontName','Times New Roman','FontSize',28,'Parent',ax3,'HorizontalAlignment','Right','VerticalAlignment','bottom');

t_ax7 = text(-.15, 0.975,'4','Units','Normalized','FontName','Times New Roman','FontSize',28,'Parent',ax4,'HorizontalAlignment','Right','VerticalAlignment','bottom');


%export_fig (sprintf(fig_Name),'-r300',  '-png');




pause;
end
