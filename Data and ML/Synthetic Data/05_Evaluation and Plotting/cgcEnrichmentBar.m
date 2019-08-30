function cgcEnrichmentBar
% Displays enrichment of putative driver genes.
%

%% cgcEnrichmentBar.m
close all;
cancerNames(1,1) = "Colorectal";
cancerNames(2,1) = "Pancreatic";
cancerNames(3,1) = "Breast";
cancerNames(4,1) = "Melanoma"; 

enrichment = [70.00 33.30 24.00; ...
              50.00 20.00 18.00; ...
              70.00 33.30 26.00;...
              60.00 30.00 24.00];
bar(enrichment); xticks(1:1:4);
set(gca,'FontSize',12,'FontName', 'Garamond');
set(gca,'YLim',[0 100]);
xticklabels(cancerNames(end:-1:1));
yticklabels(0:10:100);
xlabel('cancer type');
ylabel('Recall (%)')
title("CGC Enrichment")
legend({"top 10 genes", "top 30 genes", "top 50 genes"},'Location','southoutside','Orientation','horizontal') 
box(gca,'off');

export_fig -r300 -transparent Fig_Enrichment.png

end