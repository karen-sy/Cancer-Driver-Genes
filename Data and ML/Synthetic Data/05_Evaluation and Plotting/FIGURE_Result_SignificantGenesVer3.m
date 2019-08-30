function FIGURE_Result_SignificantGenesVer3
% plot NCBI search hits instead
% 

%% setup
close all; clc; clear

load uniqueGeneNames.mat
load Colorectal.mat CancerIdx; colon = ismember(uniqueGeneNames, CancerIdx);
load Melanoma.mat CancerIdx; melanoma = ismember(uniqueGeneNames, CancerIdx);
load Breast.mat CancerIdx; breast = ismember(uniqueGeneNames, CancerIdx);
load Pancreatic.mat CancerIdx; pancrea = ismember(uniqueGeneNames, CancerIdx);

load ColonDriversNamesPredicted.mat colonDriverintersect
load MelanomaDriversNamesPredicted.mat  melanomaDriverintersect
load PancreaDriversNamesPredicted.mat  pancreaDriverintersect
load BreastDriversNamesPredicted.mat  breastDriverintersect

load CancerSearchCount.mat PancreaticSearchCount ColorectalSearchCount MelanomaSearchCount BreastSearchCount


%%% figure name
fig_Name = ["driver ncbi search hits_cross-validated CGC Genes_top10"];

%%%%% Figure Properties
fig_height = 10;
fig_width = 12.5;
h1 = figure('units','inches','PaperPositionMode','auto','pos',[2 -5 fig_width fig_height],'Name',fig_Name,'Color','w');
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
y = [cell2mat(ColorectalSearchCount(end:-1:1,2))];
barh(y,'Parent',currentAx); % stacks values in each row of y together
box(ax1,'off');
ax1.XLim = [10 inf];
set(ax1,'FontName','Times New Roman','FontSize',18);
yticklabels(currentAx,colonDriverintersect(15:-1:1));
set(ax1.YAxis,'FontSize',14);
set(ax1.XAxis,'FontWeight','bold');
title('Colon Cancer','Parent',currentAx,'FontSize',20);


%Ax2: breast cancer
currentAx = ax2;
y = [cell2mat(BreastSearchCount(end-3:-1:1,2))];
barh(y,'Parent',currentAx); % stacks values in each row of y together
yticklabels(currentAx,breastDriverintersect(15-3:-1:1));
ax2.XLim = [10 inf];
box(ax2,'off');
set(ax2,'FontName','Times New Roman','FontSize',18);
set(ax2.YAxis,'FontSize',14);
set(ax2.XAxis,'FontWeight','bold');
title('Breast Cancer','Parent',currentAx,'FontSize',20);

%Ax3: pancrea cancer
currentAx = ax3;
y = [cell2mat(PancreaticSearchCount(end-3:-1:1,2))];
barh(y,'Parent',currentAx); % stacks values in each row of y together
yticklabels(currentAx,pancreaDriverintersect(15-3:-1:1));
ax3.XLim = [10 inf];
box(ax3,'off');
set(ax3,'FontName','Times New Roman','FontSize',18);
set(ax3.XAxis,'FontWeight','bold');
set(ax3.YAxis,'FontSize',14);
title('Pancreatic Cancer','Parent',currentAx,'FontSize',20);


%Ax4: melanoma
currentAx = ax4;
y = [cell2mat(MelanomaSearchCount(end-1:-1:1,2))];
barh(y,'Parent',currentAx); % stacks values in each row of y together
yticklabels(currentAx,melanomaDriverintersect(15-1:-1:1));
ax4.XLim = [10 inf];
box(ax4,'off');
set(ax4,'FontName','Times New Roman','FontSize',18);
set(ax4.XAxis,'FontWeight','bold');
set(ax4.YAxis,'FontSize',14);
title('Melanoma','Parent',currentAx,'FontSize',20);

%% Figure box letters
t_ax1 = text(-.15, 0.975,'1','Units','Normalized','FontName','Times New Roman','FontSize',28,'Parent',ax1,'HorizontalAlignment','Right','VerticalAlignment','bottom');

t_ax3 = text(-.15, 0.975,'2','Units','Normalized','FontName','Times New Roman','FontSize',28,'Parent',ax2,'HorizontalAlignment','Right','VerticalAlignment','bottom');

t_ax5 = text(-.15, 0.975,'3','Units','Normalized','FontName','Times New Roman','FontSize',28,'Parent',ax3,'HorizontalAlignment','Right','VerticalAlignment','bottom');

t_ax7 = text(-.15, 0.975,'4','Units','Normalized','FontName','Times New Roman','FontSize',28,'Parent',ax4,'HorizontalAlignment','Right','VerticalAlignment','bottom');


export_fig (sprintf(fig_Name),'-r300',  '-png', '-nocrop');




end
