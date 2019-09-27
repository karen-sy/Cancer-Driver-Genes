%Sample figure creation, done by Seth

clear all
close all
clc

%%%%% Figure Properties
fig_height = 20;
fig_width = 18;
fig_Name = 'Steady_State';
h1 = figure('units','centimeters','pos',[2 -10 fig_width fig_height],'Name',fig_Name,'Color','w');
%%%%% Plotting Panel
pan1 = uipanel('Parent',h1,'pos',[0 .25 1 .75],'BackgroundColor','w','BorderType','etchedin','HighlightColor','r');
pan2 = uipanel('Parent',h1,'pos',[0 0 2/3 .25],'BackgroundColor','w','BorderType','none');
pan3 = uipanel('Parent',h1,'pos',[2/3 0 1/3 .25],'BackgroundColor','w','BorderType','none');


%%%%% Axis Properties
%%% Ax1: No press early
ax1_height = 1/3;
ax1_width = 1/3;
ax1_x = 0;
ax1_y = 2/3;
ax1_Pos = [ax1_x,ax1_y,ax1_width,ax1_height];
ax1 = axes('Parent',pan1,'OuterPosition',ax1_Pos);

%%% Ax2: No press mid
ax2_height = 1/3;
ax2_width = 1/3;
ax2_x = 1/3;
ax2_y = 2/3;
ax2_Pos = [ax2_x,ax2_y,ax2_width,ax2_height];
ax2 = axes('Parent',pan1,'OuterPosition',ax2_Pos);

%%% Ax3: No press late
ax3_height = 1/3;
ax3_width = 1/3;
ax3_x = 2/3;
ax3_y = 2/3;
ax3_Pos = [ax3_x,ax3_y,ax3_width,ax3_height];
ax3 = axes('Parent',pan1,'OuterPosition',ax3_Pos);

%%% Ax4: press early
ax4_height = 1/3;
ax4_width = 1/3;
ax4_x = 0;
ax4_y = 1/3;
ax4_Pos = [ax4_x,ax4_y,ax4_width,ax4_height];
ax4 = axes('Parent',pan1,'OuterPosition',ax4_Pos);

%%% Ax5: press mid
ax5_height = 1/3;
ax5_width = 1/3;
ax5_x = 1/3;
ax5_y = 1/3;
ax5_Pos = [ax5_x,ax5_y,ax5_width,ax5_height];
ax5 = axes('Parent',pan1,'OuterPosition',ax5_Pos);

%%% Ax6: Press late
ax6_height = 1/3;
ax6_width = 1/3;
ax6_x = 2/3;
ax6_y = 1/3;
ax6_Pos = [ax6_x,ax6_y,ax6_width,ax6_height];
ax6 = axes('Parent',pan1,'OuterPosition',ax6_Pos);

%%% Ax7: No press graph
ax7_height = 1/3;
ax7_width = 1/3;
ax7_x = 0;
ax7_y = 0;
ax7_Pos = [ax7_x,ax7_y,ax7_width,ax7_height];
ax7 = axes('Parent',pan1,'OuterPosition',ax7_Pos);

%%% Ax8: Press graph
ax8_height = 1/3;
ax8_width = 1/3;
ax8_x = 1/3;
ax8_y = 0;
ax8_Pos = [ax8_x,ax8_y,ax8_width,ax8_height];
ax8 = axes('Parent',pan1,'OuterPosition',ax8_Pos);

%%% Ax9: Press late
ax9_height = 1/3;
ax9_width = 1/3;
ax9_x = 2/3;
ax9_y = 0;
ax9_Pos = [ax9_x,ax9_y,ax9_width,ax9_height];
ax9 = axes('Parent',pan1,'OuterPosition',ax9_Pos);

%%% Ax10: No press graph
ax10_height = 1;
ax10_width = 1/2;
ax10_x = 0;
ax10_y = 0;
ax10_Pos = [ax10_x,ax10_y,ax10_width,ax10_height];
ax10 = axes('Parent',pan2,'OuterPosition',ax10_Pos);

%%% Ax11: Press graph
ax11_height = 1;
ax11_width = 1/2;
ax11_x = 1/2;
ax11_y = 0;
ax11_Pos = [ax11_x,ax11_y,ax11_width,ax11_height];
ax11 = axes('Parent',pan2,'OuterPosition',ax11_Pos);

%%% Ax12: Line Legend
ax12_height = 1/2;
ax12_width = 1;
ax12_x = 0;
ax12_y = 0;
ax12_Pos = [ax12_x,ax12_y,ax12_width,ax12_height];
ax12 = axes('Parent',pan3,'OuterPosition',ax12_Pos,'Visible','off');

%%% Ax13 colorbar legend
ax13_height = 1/2;
ax13_width = 1;
ax13_x = 0;
ax13_y = 1/2;
ax13_Pos = [ax13_x,ax13_y,ax13_width,ax13_height];
ax13 = axes('Parent',pan3,'OuterPosition',ax13_Pos,'Visible','off');

% The nutrients of the tissue, have 1 of low, middle, high flat. 1 of low,
% middle, high with rete ridges.
% Flat low
load('C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_5\testing nutrition\flat_2\flat_2_200.mat')
xflat_low = x;
yflat_low = yy;
flat_low = morph_2;

%Flat mid
load('C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_5\testing nutrition\flat_6\flat_6_200.mat')
xflat_mid = x;
yflat_mid = yy;
flat_mid = morph_2;

% Flat high
load('C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_5\testing nutrition\flat_10\flat_10_200.mat')
xflat_high = x;
yflat_high = yy;
flat_high = morph_2;

% rete2 low
load('C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_6\testingNutrition\rete2_3_2\rete2_3_2_200.mat')
xr_low = x;
yr_low = yy;
r_low = morph_2;

%rete2 mid
load('C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_6\testingNutrition\rete2_3_6\rete2_3_6_200.mat')
xr_mid = x;
yr_mid = yy;
r_mid = morph_2;

% rete2 high
load('C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_6\testingNutrition\rete2_3_10\rete2_3_10_200.mat')
xr_high = x;
yr_high = yy;
r_high =morph_2;

% rete3 low
load('C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_6\testingNutrition\rete3_3_2\rete3_3_2_200.mat')
xr3_low = x;
yr3_low = yy;
r3_low = morph_2;

%rete3 mid
load('C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_6\testingNutrition\rete3_3_6\rete3_3_6_200.mat')
xr3_mid = x;
yr3_mid = yy;
r3_mid = morph_2;

% rete3 high
load('C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_6\testingNutrition\rete3_3_10\rete3_3_10_200.mat')
xr3_high = x;
yr3_high = yy;
r3_high = morph_2;

%%%% PLOTTING
%%% Flat Low
surf(xflat_low,yflat_low,flat_low,'Parent',ax1)
shading(ax1,'interp'), colormap(ax1),  axis(ax1,[0 1 -.3 1]),caxis(ax1,[0 1])
grid(ax1,'off'),box(ax1,'on')

surf(xr_low,yr_low,r_low,'Parent',ax2)
shading(ax2,'interp'), colormap(ax2),  axis(ax2,[0 1 -.3 1]),caxis(ax2,[0 1])
grid(ax2,'off'),box(ax2,'on')

surf(xr3_low,yr3_low,r3_low,'Parent',ax3)
shading(ax3,'interp'), colormap(ax3),  axis(ax3,[0 1 -.3 1]),caxis(ax3,[0 1])
grid(ax3,'off'),box(ax3,'on')

surf(xflat_mid,yflat_mid,flat_mid,'Parent',ax4),caxis([0 1])
shading(ax4,'interp'), colormap(ax4),  axis(ax4,[0 1 -.3 1]),caxis(ax4,[0 1])
grid(ax4,'off'),box(ax4,'on')

surf(xr_mid,yr_mid,r_mid,'Parent',ax5)
shading(ax5,'interp'), colormap(ax5),  axis(ax5,[0 1 -.3 1]),caxis(ax5,[0 1])
grid(ax5,'off'),box(ax5,'on')

surf(xr3_mid,yr3_mid,r3_mid,'Parent',ax6)
shading(ax6,'interp'), colormap(ax6),  axis(ax6,[0 1 -.3 1]),caxis(ax6,[0 1])
grid(ax6,'off'),box(ax6,'on')

surf(xflat_high,yflat_high,flat_high,'Parent',ax7),caxis([0 1])
shading(ax7,'interp'), colormap(ax7),  axis(ax7,[0 1 -.3 1]),caxis(ax7,[0 1])
grid(ax7,'off'),box(ax7,'on')

surf(xr_high,yr_high,r_high,'Parent',ax8)
shading(ax8,'interp'), colormap(ax8),  axis(ax8,[0 1 -.3 1]),caxis(ax8,[0 1])
grid(ax8,'off'),box(ax8,'on')

surf(xr3_high,yr3_high,r3_high,'Parent',ax9)
shading(ax9,'interp'), colormap(ax9),  axis(ax9,[0 1 -.3 1]),caxis(ax9,[0 1])
grid(ax9,'off'),box(ax9,'on')

ii = 2:2:10;
for istat = 1:length(ii)
    
    %%% Flat BNDRY
    load(['C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_5\testing nutrition\Flat_' num2str(ii(istat)) '/Flat_' num2str(ii(istat)) '_200'])
    
    param(istat) = dermProd(2);
    
    % Area of tissue
    tArea(istat) = sum(yy(end,:)-yy(1,:))*dx;
    tSurface(istat) = sum(sqrt((yy(1,2:end)-yy(1,1:end-1)).^2+dx^2));
    
    
    
    
    %%% Two Rete Ridges 1
    load(['C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_5\testing nutrition\rete2_1_' num2str(ii(istat)) '\rete2_1_' num2str(ii(istat)) '_200.mat'])
    % Area of tissue
    tArea2_1(istat) = sum(yy(end,:)-yy(1,:))*dx;
    tSurface2_1(istat) = sum(sqrt((yy(1,2:end)-yy(1,1:end-1)).^2+dx^2));
    
    %%% Two Rete Ridges 2
    load(['C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_5\testing nutrition\rete2_2_' num2str(ii(istat)) '\rete2_2_' num2str(ii(istat)) '_200.mat'])
    % Area of tissue
    tArea2_2(istat) = sum(yy(end,:)-yy(1,:))*dx;
    tSurface2_2(istat) = sum(sqrt((yy(1,2:end)-yy(1,1:end-1)).^2+dx^2));
    
    %%% Two Rete Ridges 3
    load(['C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_5\testing nutrition\rete2_3_' num2str(ii(istat)) '\rete2_3_' num2str(ii(istat)) '_200.mat'])
    % Area of tissue
    tArea2_3(istat) = sum(yy(end,:)-yy(1,:))*dx;
    tSurface2_3(istat) = sum(sqrt((yy(1,2:end)-yy(1,1:end-1)).^2+dx^2));
    
    
    %%% Two Rete Ridges 4
    load(['C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_5\testing nutrition\rete2_4_' num2str(ii(istat)) '\rete2_4_' num2str(ii(istat)) '_200.mat'])
    % Area of tissue
    tArea2_4(istat) = sum(yy(end,:)-yy(1,:))*dx;
    tSurface2_4(istat) = sum(sqrt((yy(1,2:end)-yy(1,1:end-1)).^2+dx^2));
    
    
    %%% Two Rete Ridges 5
    load(['C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_5\testing nutrition\rete2_5_' num2str(ii(istat)) '\rete2_5_' num2str(ii(istat)) '_200.mat'])
    % Area of tissue
    tArea2_5(istat) = sum(yy(end,:)-yy(1,:))*dx;
    tSurface2_5(istat) = sum(sqrt((yy(1,2:end)-yy(1,1:end-1)).^2+dx^2));
    
    
    %%% Two Rete Ridges 6
    load(['C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_5\testing nutrition\rete2_6_' num2str(ii(istat)) '\rete2_6_' num2str(ii(istat)) '_200.mat'])
    % Area of tissue
    tArea2_6(istat) = sum(yy(end,:)-yy(1,:))*dx;
    tSurface2_6(istat) = sum(sqrt((yy(1,2:end)-yy(1,1:end-1)).^2+dx^2));
    
    %%% Three Rete Ridges 1
    load(['C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_5\testing nutrition\rete3_1_' num2str(ii(istat)) '\rete3_1_' num2str(ii(istat)) '_200.mat'])
    % Area of tissue
    tArea3_1(istat) = sum(yy(end,:)-yy(1,:))*dx;
    tSurface3_1(istat) = sum(sqrt((yy(1,2:end)-yy(1,1:end-1)).^2+dx^2));
    
    %%% Three Rete Ridges 2
    load(['C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_5\testing nutrition\rete3_2_' num2str(ii(istat)) '\rete3_2_' num2str(ii(istat)) '_200.mat'])
    % Area of tissue
    tArea3_2(istat) = sum(yy(end,:)-yy(1,:))*dx;
    tSurface3_2(istat) = sum(sqrt((yy(1,2:end)-yy(1,1:end-1)).^2+dx^2));
    
    %%% Three Rete Ridges 3
    load(['C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_5\testing nutrition\rete3_3_' num2str(ii(istat)) '\rete3_3_' num2str(ii(istat)) '_200.mat'])
    % Area of tissue
    tArea3_3(istat) = sum(yy(end,:)-yy(1,:))*dx;
    tSurface3_3(istat) = sum(sqrt((yy(1,2:end)-yy(1,1:end-1)).^2+dx^2));
    
    
    %%% Three Rete Ridges 4
    load(['C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_5\testing nutrition\rete3_4_' num2str(ii(istat)) '\rete3_4_' num2str(ii(istat)) '_200.mat'])
    % Area of tissue
    tArea3_4(istat) = sum(yy(end,:)-yy(1,:))*dx;
    tSurface3_4(istat) = sum(sqrt((yy(1,2:end)-yy(1,1:end-1)).^2+dx^2));
    
    
    %%% Three Rete Ridges 5
    load(['C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_5\testing nutrition\rete3_5_' num2str(ii(istat)) '\rete3_5_' num2str(ii(istat)) '_200.mat'])
    % Area of tissue
    tArea3_5(istat) = sum(yy(end,:)-yy(1,:))*dx;
    tSurface3_5(istat) = sum(sqrt((yy(1,2:end)-yy(1,1:end-1)).^2+dx^2));
    
    
    %%% Three Rete Ridges 6
    load(['C:\Users\Seth\Google Drive\Research\Tissue Models\Epithelial 2Boundary Models\PaperResults\PaperSimulations\n_5\testing nutrition\rete3_6_' num2str(ii(istat)) '\rete3_6_' num2str(ii(istat)) '_200.mat'])
    % Area of tissue
    tArea3_6(istat) = sum(yy(end,:)-yy(1,:))*dx;
    tSurface3_6(istat) = sum(sqrt((yy(1,2:end)-yy(1,1:end-1)).^2+dx^2));
    
end


surf0 = tSurface(3);
area0 = tArea(3);
surf2 = [tSurface2_1(3) tSurface2_2(3) tSurface2_3(3) tSurface2_4(3) tSurface2_5(3) tSurface2_6(3)];
area2 = [tArea2_1(3) tArea2_2(3) tArea2_3(3) tArea2_4(3) tArea2_5(3) tArea2_6(3)];
surf3 = [tSurface3_1(3) tSurface3_2(3) tSurface3_3(3) tSurface3_4(3) ];
area3 = [tArea3_1(3) tArea3_2(3) tArea3_3(3) tArea3_4(3) ];


plot(param, tArea,'b',param,tArea2_4,'r--', param, tArea3_4,'-.k','linewidth',2,'Parent',ax10);
% axis([0.2 1 0 1.5])

plot(surf2,area2,'r--',surf3,area3,'k-.','linewidth',2,'Parent',ax11)
% axis([1 3 0.5 1])

%%%% LEGENDS
plot(1, 1,'b',1,1,'r--', 1, 1,'-.k','linewidth',2,'Parent',ax12);
axis(ax12,'off')
legend(ax12,{'No Rete-Ridges','Two Rete-Ridges', 'Three Rete-Ridges'});

surf([1 1;1 1],[1 1;1 1],[1 1;1 1],'Parent',ax13),colormap(ax13)
axis(ax13,'off'), caxis(ax13,[0 1])
col = colorbar(ax13);
col.Location = 'south';
title(col,'Nutrition')

%% Figure box letters
set(ax1,'FontName','Ariel','FontSize',12)
t_ax1 = text(-.1, 1,'A','Units','Normalized','FontName','Ariel','FontSize',16,'Parent',ax1,'HorizontalAlignment','Right','VerticalAlignment','bottom');
ax1.Position = set_position(ax1,t_ax1);

set(ax2,'FontName','Ariel','FontSize',12)
t_ax2 = text(-.1, 1,'B','Units','Normalized','FontName','Ariel','FontSize',16,'Parent',ax2,'HorizontalAlignment','Right','VerticalAlignment','bottom');
ax2.Position = set_position(ax2,t_ax2);

set(ax3,'FontName','Ariel','FontSize',12)
t_ax3 = text(-.1, 1,'C','Units','Normalized','FontName','Ariel','FontSize',16,'Parent',ax3,'HorizontalAlignment','Right','VerticalAlignment','bottom');
ax3.Position = set_position(ax3,t_ax3);

set(ax4,'FontName','Ariel','FontSize',12)
t_ax4 = text(-.1, 1,'D','Units','Normalized','FontName','Ariel','FontSize',16,'Parent',ax4,'HorizontalAlignment','Right','VerticalAlignment','bottom');
ax4.Position = set_position(ax4,t_ax4);

set(ax5,'FontName','Ariel','FontSize',12)
t_ax5 = text(-.1, 1,'E','Units','Normalized','FontName','Ariel','FontSize',16,'Parent',ax5,'HorizontalAlignment','Right','VerticalAlignment','bottom');
ax5.Position = set_position(ax5,t_ax5);

set(ax6,'FontName','Ariel','FontSize',12)
t_ax6 = text(-.1, 1,'F','Units','Normalized','FontName','Ariel','FontSize',16,'Parent',ax6,'HorizontalAlignment','Right','VerticalAlignment','bottom');
ax6.Position = set_position(ax6,t_ax6);

set(ax7,'FontName','Ariel','FontSize',12)
t_ax7 = text(-.1, 1,'G','Units','Normalized','FontName','Ariel','FontSize',16,'Parent',ax7,'HorizontalAlignment','Right','VerticalAlignment','bottom');
ax7.Position = set_position(ax7,t_ax7);

set(ax8,'FontName','Ariel','FontSize',12)
t_ax8 = text(-.1, 1,'H','Units','Normalized','FontName','Ariel','FontSize',16,'Parent',ax8,'HorizontalAlignment','Right','VerticalAlignment','bottom');
ax8.Position = set_position(ax8,t_ax8);

set(ax9,'FontName','Ariel','FontSize',12)
t_ax9 = text(-.1, 1,'I','Units','Normalized','FontName','Ariel','FontSize',16,'Parent',ax9,'HorizontalAlignment','Right','VerticalAlignment','bottom');
ax9.Position = set_position(ax9,t_ax9);

set(ax10,'FontName','Ariel','FontSize',12)
t_ax10 = text(-.1, 1,'J','Units','Normalized','FontName','Ariel','FontSize',16,'Parent',ax10,'HorizontalAlignment','Right','VerticalAlignment','bottom');
ylabel(ax10,'Tissue Area','FontName','Ariel','FontSize',10)
xlabel(ax10,'$\beta_0$','FontName','Ariel','FontSize',10, 'Interpreter','Latex')
ax10.Position = set_position(ax10,t_ax10);

set(ax11,'FontName','Ariel','FontSize',12)
t_ax11 = text(-.1, 1,'K','Units','Normalized','FontName','Ariel','FontSize',16,'Parent',ax11,'HorizontalAlignment','Right','VerticalAlignment','bottom');
ylabel(ax11,'Tissue Area','FontName','Ariel','FontSize',10)
xlabel(ax11,'Boundary Length','FontName','Ariel','FontSize',10)
ax11.Position = set_position(ax11,t_ax11);

%%%% TEXT
% export_fig fig2.png -r300
