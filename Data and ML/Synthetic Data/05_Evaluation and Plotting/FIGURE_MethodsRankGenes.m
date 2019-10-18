function [indivRank, enrichment] = FIGURE_MethodsRankGenes(allScores, trueLabels, flag)
% Plots cdf of ranks attributed to actual driver genes, correctly
% predicted by classifier

trueLabels = makeBinary(trueLabels);

% get driver scores predicted by classifier and retrieve rank
if size(allScores,2) > 1
    driverScores = sum(allScores(:,end-1:end),2);
else
    driverScores = allScores;
end

if flag == ("pval") %if sorted by score not p-val
    [~,ranks] = sort(driverScores,'ascend');
else
    [~,ranks] = sort(driverScores,'descend');
end

% arrange true labels in rank order (visualize which are ranked "on top")
orderedLabels = trueLabels(ranks);


indivRank = [1:length(ranks)]';
enrichment = cumsum(orderedLabels)./indivRank;


end