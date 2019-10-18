function RUN_FIGURE_MethodsRankGenes
%% get information

load tusonInfo.mat scores labels;
[x1, f1] = FIGURE_MethodsRankGenes(scores, labels,"pval");

load oncodriveclustInfo.mat scores labels;
[x2, f2] = FIGURE_MethodsRankGenes(scores, labels, "score");

load activedriverInfo.mat scores labels;
[x3, f3] = FIGURE_MethodsRankGenes(scores, labels, "pval");

load twentytwentyInfo.mat scores; loadXY;
[x4, f4] = FIGURE_MethodsRankGenes(scores(3:end), ConsensusY, "score");

load predictedY.mat predictedYscores;
[x5, f5] = FIGURE_MethodsRankGenes(predictedYscores, ConsensusY, "mine_score");


%% plot
figure; hold on;

plot(x1(1:100), f1(1:100),'Linewidth', 1);
ylim([0 1]); %disp(trapz(x1(1:100), f1(1:100)));

plot(x2(1:100), f2(1:100),'Linewidth', 1);
ylim([0 1]);

plot(x3(1:100), f3(1:100),'Linewidth', 1);
ylim([0 1]);

plot(x4(1:100), f4(1:100),'Linewidth', 1);
ylim([0 1]);

plot(x5(1:100), f5(1:100),'Linewidth', 2);
ylim([0 1]);


legend("tuson", "oncoclust", "activedriver", "20/20", "mine");

title('Methods Comparison or whatever');
xlabel('Gene rank or whatveer');
ylabel('Enrichment or whatvevr the PAPER said');

export_fig -r300 -transparent FIGURE_Result_MethodsRankGenes.png;

end