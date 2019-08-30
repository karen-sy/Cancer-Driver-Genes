clear
close all
clc

filename = 'snvboxGenesFASTA.txt'; 


%% Import file as a table using readtable.

geneAndSequence = readtable(filename,'Delimiter', '\t', 'Format', '%s','ReadVariableNames',false);
geneAndSequence = table2cell(geneAndSequence); %convert to cell
  
%% clean up the data table, organize by exon
geneAndSequence = [geneAndSequence(1:2:end),geneAndSequence(2:2:end)]; %n-by-2
isValid = (cellfun('length',strfind(geneAndSequence(:,1),';'))) == 1; %format ofA1BG;exon0 is ok but not A1BG;exon1;5SS
geneAndSequence = geneAndSequence(isValid,:); %take out introns

geneNames = split(geneAndSequence(:,1),">"); geneNames = split(geneNames(:,2),";"); %gene Name+ exon #

geneSeqConsensusbyExon = [geneNames,geneAndSequence(:,2)]; %final version of genes split by exon; n-by-3

%% group the same-gene gene sequences together.
geneNamesUnique = unique(geneNames(:,1));
geneSeqConsensus = cell(length(geneNamesUnique),2); geneSeqConsensus(:,1) = geneNamesUnique; %n-by-2
idx = cell(length(geneNamesUnique),1);
for i = 1:length(geneNamesUnique)
    idx{i} = find(string(geneNames(:,1))==geneNamesUnique{i});
    geneSeqConsensus{i,2} = strcat(geneAndSequence{idx{i},2}); 
end



save geneSeqConsensus.mat geneSeqConsensusbyExon geneSeqConsensus