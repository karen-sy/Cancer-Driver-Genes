function MAIN_importAllMethods
clear; clc

mutsigcv = importMutsig();
tuson = importTuson();
twentytwenty = import2020();
oncodrivefm = importOncodrivefm();
oncodriveclust = importOncodriveclust();
oncodrivefml = importOncodrivefml();
activedriver = importActiveDriver();

%% for each list, convert gene name (string vector) --> true driver/passenger label
load uniqueGeneNames.mat uniqueGeneNames
load ConsensusY.mat; trueLabels = y;

% return labels, in matching gene order with scores
[~, idx] = ismember(table2array(mutsigcv(:,1)),uniqueGeneNames);
idxNew = idx(idx~=0); % when table is longer than ConsensusY 
labels = trueLabels(idxNew);
% return scores
scores = table2array(mutsigcv(:,2));
scores = scores(idx~=0);

save mutsigInfo.mat scores labels 


% return labels, in matching gene order with scores
[~, idx] = ismember(table2array(tuson(:,1)),uniqueGeneNames);
idxNew = idx(idx~=0); % when table is longer than ConsensusY 
labels = trueLabels(idxNew);
% return scores
scores = table2array(tuson(:,2))+table2array(tuson(:,3));
scores = scores(idx~=0);

save tusonInfo.mat scores labels


% return labels, in matching gene order with scores
[~, idx] = ismember(table2array(twentytwenty(:,1)),uniqueGeneNames);
idxNew = idx(idx~=0); % when table is longer than ConsensusY 
labels = trueLabels(idxNew);
% return scores
scores = table2array(twentytwenty(:,2));
scores = scores(idx~=0);

save twentytwentyInfo.mat scores labels


% return labels, in matching gene order with scores
[~, idx] = ismember(table2array(oncodrivefm(:,1)),uniqueGeneNames);
idxNew = idx(idx~=0); % when table is longer than ConsensusY 
labels = trueLabels(idxNew);
% return scores
scores = table2array(oncodrivefm(:,2));
scores = scores(idx~=0);

save oncodrivefmInfo.mat scores labels


% return labels, in matching gene order with scores
[~, idx] = ismember(table2array(oncodriveclust(:,1)),uniqueGeneNames);
idxNew = idx(idx~=0); % when table is longer than ConsensusY 
labels = trueLabels(idxNew);
% return scores
scores = table2array(oncodriveclust(:,2));
scores = scores(idx~=0);
nans = find(isnan(scores));
scores(nans(1:100)) = rand(1, 100)*(max(scores)-min(scores))+min(scores);
scores(nans(101:end)) = 0;

save oncodriveclustInfo.mat scores labels


% return labels, in matching gene order with scores
[~, idx] = ismember(table2array(oncodrivefml(:,2)),uniqueGeneNames);
idxNew = idx(idx~=0); % when table is longer than ConsensusY 
labels = trueLabels(idxNew);
% return scores
scores = table2array(oncodrivefml(:,1));
scores = scores(idx~=0);

save oncodrivefmlInfo.mat scores labels


% return labels, in matching gene order with scores
[~, idx] = ismember(table2array(activedriver(:,1)),uniqueGeneNames);
idxNew = idx(idx~=0); % when table is longer than ConsensusY 
labels = trueLabels(idxNew);
% return scores
scores = table2array(activedriver(:,2));
scores = scores(idx~=0);

save activedriverInfo.mat scores labels



end