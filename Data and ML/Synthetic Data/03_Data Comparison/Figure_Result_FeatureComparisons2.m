function Figure_Result_FeatureComparisons2(ConsensusX,ConsensusY,SyntheticX,SyntheticY)
%Creates plots of probability density estimates
%of one feature taken from the inputs: feature matrices from two datasets
%and their corresponding class labels. 1 FIG = 4 FEATURES TOTAL

%% setup

close all
clc

%%
%%%% PLOTTING
categories =({'Missense Fraction' 'Nonsilent to Silent Ratio'...
    'Mutation Entropy' 'Missense p-value'});

%%%%% Figure Properties
fig_height = 60;
fig_width = 45;


fig_Name = [categories{1},categories{2},categories{3},categories{4}];
h1 = figure('units','centimeters','pos',[2 0 fig_width fig_height],'Name',fig_Name,'Color','w');
%%%%% Plotting Panel
%row 1
pan1_col1 = uipanel('Parent',h1,'pos',[0 .7625 1/2 .2375],'BackgroundColor','w','BorderType','none','HighlightColor','k');
pan2_col1 = uipanel('Parent',h1,'pos',[0 .525 1/2 .2375],'BackgroundColor','w','BorderType','none','HighlightColor','k');

pan1_col2 = uipanel('Parent',h1,'pos',[1/2 .7625 1/2 .2375],'BackgroundColor','w','BorderType','none','HighlightColor','k');
pan2_col2 = uipanel('Parent',h1,'pos',[1/2 .525 1/2 .2375],'BackgroundColor','w','BorderType','none','HighlightColor','k');


%row 2
pan1_col1_row2 = uipanel('Parent',h1,'pos',[0 .2375 1/2 .2375],'BackgroundColor','w','BorderType','none','HighlightColor','k');
pan2_col1_row2 = uipanel('Parent',h1,'pos',[0 0 1/2 .2375],'BackgroundColor','w','BorderType','none','HighlightColor','k');

pan1_col2_row2 = uipanel('Parent',h1,'pos',[1/2 .2375 1/2 .2375],'BackgroundColor','w','BorderType','none','HighlightColor','k');
pan2_col2_row2 = uipanel('Parent',h1,'pos',[1/2 0 1/2 .2375],'BackgroundColor','w','BorderType','none','HighlightColor','k');

%% %%% Axis Properties: Row 1
%-------------------Col 1-----------------------
%%% Ax1: Synthetic Gene Feature
ax1_height = 0.70;
ax1_width = 0.80;
ax1_x = 0.175;
ax1_y = 0.15;
ax1_Pos = [ax1_x,ax1_y,ax1_width,ax1_height];
ax1 = axes('Parent',pan1_col1,'Position',ax1_Pos,'box','off');

%%% Ax2: Consensus Gene Feature
ax2_Pos = [ax1_x,ax1_y,ax1_width,ax1_height];
ax2 = axes('Parent',pan2_col1,'Position',ax2_Pos,'box','off');

%-------------------Col 2: Ax 3-4-----------------------
%%% Col 2 Ax1: Synthetic Gene Feature
ax3_Pos = [ax1_x,ax1_y,ax1_width,ax1_height];
ax3 = axes('Parent',pan1_col2,'Position',ax3_Pos,'box','off');

%%% Col 2 Ax2: Consensus Gene Feature
ax4_Pos = [ax1_x,ax1_y,ax1_width,ax1_height];
ax4 = axes('Parent',pan2_col2,'Position',ax4_Pos,'box','off');


%% %%% Axis Properties: Row 2
%-------------------Col 1-----------------------
%%% Ax1: Synthetic Gene Feature
ax5_Pos = [ax1_x,ax1_y,ax1_width,ax1_height];
ax5 = axes('Parent',pan1_col1_row2,'Position',ax5_Pos,'box','off');

%%% Ax2: Consensus Gene Feature
ax6_Pos = [ax1_x,ax1_y,ax1_width,ax1_height];
ax6 = axes('Parent',pan2_col1_row2,'Position',ax6_Pos,'box','off');

%-------------------Col 2-----------------------
%%% Col 2 Ax1: Synthetic Gene Feature
ax7_Pos = [ax1_x,ax1_y,ax1_width,ax1_height];
ax7 = axes('Parent',pan1_col2_row2,'Position',ax7_Pos,'box','off');

%%% Col 2 Ax2: Consensus Gene Feature
ax8_Pos = [ax1_x,ax1_y,ax1_width,ax1_height];
ax8 = axes('Parent',pan2_col2_row2,'Position',ax8_Pos,'box','off');



%% Features, get estimated pdf
Ax1List = [ax1 ax3 ax5 ax7];
Ax2List = [ax2 ax4 ax6 ax8];

FeatIdxList = [3 6 10 12];
for i = 1:4 %4 features
    
    Feat1 = SyntheticX(SyntheticY==1,FeatIdxList(i));
    Feat12 = SyntheticX(SyntheticY==2,FeatIdxList(i));
    Feat13 = SyntheticX(SyntheticY==3,FeatIdxList(i));
    Feat21 = ConsensusX(ConsensusY==1,FeatIdxList(i));
    Feat22 = ConsensusX(ConsensusY==2,FeatIdxList(i));
    Feat23 = ConsensusX(ConsensusY==3,FeatIdxList(i));
    
    [f1,xi1] = ksdensity(Feat1(Feat1~= Inf));
    [f2,xi2] = ksdensity(Feat12(Feat12~= Inf));
    [f3,xi3] = ksdensity(Feat13(Feat13~= Inf));
    [f21,xi21] = ksdensity(Feat21(Feat21~= Inf));
    [f22,xi22] = ksdensity(Feat22(Feat22~= Inf));
    [f23,xi23] = ksdensity(Feat23(Feat23~= Inf));
    
    
    %% Plot pdf; Set limits, labels
    
    currentAx1 = Ax1List(i);
    currentAx2 = Ax2List(i);
    
    XLim1 = get(currentAx1,'XLim');
    plot(xi1,f1,xi2,f2,xi3,f3,'lineWidth',4,'Parent',currentAx1);
    %lgd1 = legend(currentAx1,{'passenger gene', 'oncogene', 'tumor suppressor gene'},'Box','off');
    %xlab1 = xlabel([categories(i)],'Parent',currentAx1);
    %ylab1 = ylabel('Estimated $$ f(x) $$','Parent',currentAx1,'Interpreter','latex');
    
    XLim2 = get(currentAx2,'XLim');
    plot(xi21,f21,xi22,f22,xi23,f23,'lineWidth',4,'Parent',currentAx2);
    %lgd2 = legend(currentAx2,{'passenger gene', 'oncogene', 'tumor suppressor gene'},'Box','off');
    %xlab2 = xlabel([categories(i)],'Parent',currentAx2);
    %ylab2 = ylabel('Estimated $$ f(x) $$','Parent',currentAx2,'Interpreter','latex');
    
    linkaxes([currentAx1,currentAx2],'x');
    
    
    %% Revise font, etc.
    
    set(currentAx1,'FontName','Times New Roman','FontSize',16),% set([xlab1,ylab1],'Fontsize',13);
    t_ax1 = text(0.5, 1,['Synthetic Dataset: ', categories{i}],'Units','Normalized','FontName','Times New Roman',...
        'FontSize',24,'Parent',currentAx1,'HorizontalAlignment','Center','VerticalAlignment','bottom','FontWeight','bold');
    
    set(currentAx2,'FontName','Times New Roman','FontSize',16), %set([xlab2,ylab2],'Fontsize',13);
    t_ax2 = text(0.5, 1,['TCGA Dataset: ', categories{i}],'Units','Normalized','FontName','Times New Roman',...
        'FontSize',24,'Parent',currentAx2,'HorizontalAlignment','Center','VerticalAlignment','bottom','FontWeight','bold');
    
    
end

%% Figure box letters
t_ax1 = text(-.1, 0.9,'A','Units','Normalized','FontName','Times New Roman','FontSize',40,'Parent',ax1,'HorizontalAlignment','Right','VerticalAlignment','bottom');

t_ax3 = text(-.1, 0.9,'B','Units','Normalized','FontName','Times New Roman','FontSize',40,'Parent',ax3,'HorizontalAlignment','Right','VerticalAlignment','bottom');

t_ax5 = text(-.1, 0.9,'C','Units','Normalized','FontName','Times New Roman','FontSize',40,'Parent',ax5,'HorizontalAlignment','Right','VerticalAlignment','bottom');

t_ax7 = text(-.1, 0.9,'D','Units','Normalized','FontName','Times New Roman','FontSize',40,'Parent',ax7,'HorizontalAlignment','Right','VerticalAlignment','bottom');


  export_fig (sprintf('featureComparison'),'-r300',  '-png','-nocrop');

end