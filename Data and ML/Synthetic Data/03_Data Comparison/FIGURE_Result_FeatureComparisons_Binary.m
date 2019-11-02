function FIGURE_Result_FeatureComparisons_Binary(ConsensusX,ConsensusY,SyntheticX,SyntheticY)
%% FIGURE_Result_FeatureComparisons.m
%FIGURE_Result_FeatureComparisons creates plots of probability density estimates
%of one feature taken from the inputs: feature matrices from two datasets
%and their corresponding class labels

% setup
close all
clc
categories =({'Silent Fraction' 'Nonsense Fraction' 'Missense Fraction' ...
    'Nonsense to Missense Ratio' 'Missense to Silent Ratio' 'Nonsilent to Silent Ratio'...
    'Sample Count Fraction' 'Missense Entropy' 'Mutation Entropy'...
    'Missense p-value' 'Nonsense p-value' 'Silent p-value'});

%%%% PLOTTING
for i = 1:length(categories)
    %%%%% Figure Properties
    fig_height = 15;
    fig_width = 15;
    
   
    fig_Name = 'Figure_FeatureComparisons';
    h1 = figure('units','inches','OuterPosition',[2 0 fig_width fig_height],'Name',fig_Name,'Color','w');
    %%%%% Plotting Panel
    pan1 = uipanel('Parent',h1,'pos',[0 .5 1 .5],'BackgroundColor','w','BorderType','none','HighlightColor','r');
    pan2 = uipanel('Parent',h1,'pos',[0 0 1 .5],'BackgroundColor','w','BorderType','none','HighlightColor','g');
    
    
    %%%%% Axis Properties
    % Ax1: Synthetic Gene Feature
    ax1_height = 0.70;
    ax1_width = 0.90;
    ax1_x = 0.075;
    ax1_y = 0.20;
    ax1_Pos = [ax1_x,ax1_y,ax1_width,ax1_height];
    ax1 = axes('Parent',pan1,'Position',ax1_Pos,'box','off');
    
    % Ax2: Consensus Gene Feature
    ax2_height = ax1_height;
    ax2_width = ax1_width;
    ax2_x = ax1_x;
    ax2_y = ax1_y;
    ax2_Pos = [ax2_x,ax2_y,ax2_width,ax2_height];
    ax2 = axes('Parent',pan2,'Position',ax2_Pos,'box','off');
    
    % Organize data and plot
    A1 = SyntheticX(SyntheticY==1,i);
    B1 = SyntheticX(SyntheticY~=1,i);
    A2 = ConsensusX(ConsensusY==1,i);
    B2 = ConsensusX(ConsensusY~=1,i);
    
    [f1,xi1] = ksdensity(A1(A1~= Inf)); 
    [f2,xi2] = ksdensity(B1(B1~= Inf));
    
    XLim1 = get(ax1,'XLim');
    XLim1 = XLim1 + [min([A1;B1]) max([A1;B1])] * 0.01 * diff(XLim1);
    plot(xi1,f1,xi2,f2,'LineWidth',1,'Parent',ax1);
    lgd1 = legend(ax1,{'passenger gene', 'oncogene'},'Box','off');
    xlab1 = xlabel([categories(i)],'Parent',ax1);
    ylab1 = ylabel('Estimated $$ f(x) $$','Parent',ax1,'Interpreter','latex');
    
    [f21,xi21] = ksdensity(A2(A2~= Inf));
    [f22,xi22] = ksdensity(B2(B2~= Inf));
    
    XLim2 = get(ax2,'XLim');
    XLim2 = XLim2 + [min([A2;B2]) max([A2;B2])] * 0.01 * diff(XLim2);
    plot(xi21,f21,xi22,f22,'LineWidth',1,'Parent',ax2);
    lgd2 = legend(ax2,{'passenger gene', 'oncogene'},'Box','off');
    xlab2 = xlabel([categories(i)],'Parent',ax2);
    ylab2 = ylabel('Estimated $$ f(x) $$','Parent',ax2,'Interpreter','latex');
    
    if i == 9 || i == 10 %these two have unusual data ranges; rearrange
        lgd1.Location = 'NorthWest';
        lgd2.Location = 'NorthWest';
    end
    
    if i == 8
        ax1.XLim = [-2000 14000];
    else
        linkaxes([ax1,ax2],'x');
    end
    
    % refine appearances of plot
    set(ax1,'FontName','Times New Roman','FontSize',20), set([xlab1,ylab1],'Fontsize',20);
    t_ax1 = text(0.5, 1,['Synthetic Dataset: ', categories{i}],'Units','Normalized','FontName','Times New Roman',...
        'FontSize',20,'Parent',ax1,'HorizontalAlignment','Center','VerticalAlignment','bottom','FontWeight','bold');
   
    set(ax2,'FontName','Times New Roman','FontSize',20), set([xlab2,ylab2],'Fontsize',20);
    t_ax2 = text(0.5, 1,['Consensus Dataset: ', categories{i}],'Units','Normalized','FontName','Times New Roman',...
        'FontSize',20,'Parent',ax2,'HorizontalAlignment','Center','VerticalAlignment','bottom','FontWeight','bold');
    
    
    export_fig (sprintf('%d_%s',i,categories{i}),'-r300',  '-png');
    
end
end