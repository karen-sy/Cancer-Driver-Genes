
clear all
close all
clc

%%%%% Figure Properties
fig_height = 20;
fig_width = 30;
fig_Name = 'Feature name';
h1 = figure('units','centimeters','pos',[2 -5 fig_width fig_height],'Name',fig_Name,'Color','w');
%%%%% Plotting Panel
pan1 = uipanel('Parent',h1,'pos',[0 .5 1 .5],'BackgroundColor','w','BorderType','etchedin','HighlightColor','r');
pan2 = uipanel('Parent',h1,'pos',[0 0 1 .5],'BackgroundColor','w','BorderType','etchedin','HighlightColor','g');


%%%%% Axis Properties
%%% Ax1: Synthetic Gene Feature
ax1_height = 13/15;
ax1_width = 1;
ax1_x = 0;
ax1_y = 1/15;
ax1_Pos = [ax1_x,ax1_y,ax1_width,ax1_height];
ax1 = axes('Parent',pan1,'OuterPosition',ax1_Pos,'box','off');

%%% Ax2: Consensus Gene Feature
ax2_height = ax1_height;
ax2_width = ax1_width;
ax2_x = ax1_x;
ax2_y = ax1_y;
ax2_Pos = [ax2_x,ax2_y,ax2_width,ax2_height];
ax2 = axes('Parent',pan2,'OuterPosition',ax2_Pos,'box','off');

%%%% PLOTTING
for i = 1:13
    A1 = XConsensus(:,i(idx));
    B1 = XConsensus(yConsensus==2,i(idx));
    C1 = XConsensus(yConsensus==3,i(idx));
    A2 = XSynthetic(:,i(idx));
    B2 = XSynthetic(ySynthetic==2,i(idx));
    C2 = XSynthetic(ySynthetic==3,i(idx));
   
    [f1,xi1] = ksdensity(A1);
    [f2,xi2] = ksdensity(B1);
    [f3,xi3] = ksdensity(C1);
    plot(xi1,f1,xi2,f2,xi3,f3,'LineWidth',1,'Parent',ax1);
    lgd1 = legend(ax1,{'passenger gene', 'oncogene', 'tumor suppressor gene'},'Box','off');
    xlab1 = xlabel('Whatever','Parent',ax1); ylab1 = ylabel('Probability Density','Parent',ax1);
    
    [f21,xi21] = ksdensity(A2);
    [f22,xi22] = ksdensity(B2);
    [f23,xi23] = ksdensity(C2);
    plot(xi21,f21,xi22,f22,xi23,f23,'LineWidth',1,'Parent',ax2);
    lgd2 = legend(ax2,{'passenger gene', 'oncogene', 'tumor suppressor gene'},'Box','off');
    xlab2 = xlabel('Whatever2','Parent',ax2); ylab2 = ylabel('Whatevs2','Parent',ax2);
end

%% Figure box letters
set(ax1,'FontName','Times New Roman','FontSize',10), set([xlab1,ylab1],'Fontsize',12);
t_ax1 = text(0.5, 1,'Synthetic Dataset: Feature ---','Units','Normalized','FontName','Times New Roman','FontSize',13,'Parent',ax1,'HorizontalAlignment','Center','VerticalAlignment','bottom');

set(ax2,'FontName','Times New Roman','FontSize',10), set([xlab2,ylab2],'Fontsize',12);
t_ax2 = text(0.5, 1,'Consensus Dataset: Feature ---','Units','Normalized','FontName','Times New Roman','FontSize',13,'Parent',ax2,'HorizontalAlignment','Center','VerticalAlignment','bottom');

%%%% TEXT
export_fig fig2.png -r300
