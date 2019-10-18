function [f, x] = FIGURE_Result_SyntheticML_RankCdf(allScores, trueLabels,flag)
% Plots cdf of ranks attributed to actual driver genes, correctly
% predicted by classifier

trueLabels = makeBinary(trueLabels);

% get driver scores predicted by classifier and label with rank
driverScores = sum(allScores(:,2:3),2);
[~,idx] = ismember(driverScores,sort(driverScores,'descend'));

% extract ranks of only actual driver genes
if flag == 'n' % if most ranks are all same (thus meaningless), need to attribute 'random' rank 
    idx = removeOverlap(idx);
end
driverIdx = idx(trueLabels == 1);
driverIdx = sort(driverIdx,'ascend');
 

[f, x] = ecdf(driverIdx); 

% plot
%plot(x,f, 'LineWidth', 3);]

     function vNew = removeOverlap(v)
        % convert overlapping One's to different #'s (1 1 1 1 ... --> 1 2 3 4...)
        elems = unique(v); %all unique ranks
        for i = 1:length(elems)
            ranks = find(v == elems(i));
            v(ranks) = randperm(length(ranks))+elems(i);                      
        end
      
         vNew = v;    
     end

end