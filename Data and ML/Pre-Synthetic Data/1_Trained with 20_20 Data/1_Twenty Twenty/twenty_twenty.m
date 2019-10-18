%% twenty_twenty.m
% implementation of the 20/20 method (Vogelstein et al.), to observe logic 
% flow and shortcomings

% logistic regression: Initialize 
clear; close all; clc

% Load Data
load bedfile.mat; 
load mutfile.mat; % mutations.txt; cell, abc-sorted by gene name

% Read Information from files
%--------Mutation File--------------
GeneName = mutfile(:,1); %ex: IVL
Variant = mutfile(:,2);  %ex: Missense_Mutation / Splice_Site / Silent / Frame_Shift_Indel
ProteinChange = mutfile(:,3); %ex: p.Q248R

%convert to string, omit short ones (like 'p.?')
ProteinChange = string(ProteinChange); ProteinChange = ProteinChange(strlength(ProteinChange) > 3); 


%-------Initialize counters----------------------
U_GeneName = unique(GeneName); %unique gene names in the Mutation file; counting purposes

MutationCount = zeros(length(U_GeneName),1); SilentCount = zeros(length(U_GeneName),1);
NonsenseCount = zeros(length(U_GeneName),1); IndelCount = zeros(length(U_GeneName),1);
SpliceCount = zeros(length(U_GeneName),1); NonstopCount = zeros(length(U_GeneName),1);
MissenseCount = zeros(length(U_GeneName),1); R_MissenseCount = zeros(length(U_GeneName),1);
InframeCount = zeros(length(U_GeneName),1); R_InframeCount = zeros(length(U_GeneName),1);


TSGScore = zeros(1,length(U_GeneName)); %scores matrix
OncoScore = zeros(1,length(U_GeneName));


% TSG and Oncogene Counter
%missense mutations at the same amino acid
%identical in-frame insertions or deletions

%initialize identification matrices
labels = zeros(length(U_GeneName),1);
totalscore = zeros(length(U_GeneName),1);


for i = 1:length(U_GeneName)
MutIdx = ismember(GeneName,U_GeneName(i));  %matrix of logicals, 1 when gene appears in mutation list
MutationCount(i) = sum(MutIdx); %how many times does mutation happen?


%==============TSG===============
SilentCount(i) = sum(ismember(Variant(MutIdx), 'Silent'));
NonsenseCount(i) = sum(ismember(Variant(MutIdx), 'Nonsense_Mutation')); %# of nonsense?
IndelCount(i) = sum(ismember(Variant(MutIdx), 'Frame_Shift_Indel')); %# of frameshift indel?
SpliceCount(i) = sum(ismember(Variant(MutIdx), 'Splice_Site'));  %# of splice?
NonstopCount(i) = sum(ismember(Variant(MutIdx), 'Nonstop_Mutation')); %# of nonstop? 



%==============Onco===============
%1) missense, same amino acid
MisIdx = ismember(Variant(MutIdx), 'Missense_Mutation'); %matrix of logicals, 1 when the gene's mutation is 'missense'
MisProtein = ProteinChange(MisIdx); %all protein changes (strings) for missense mutation of that gene; make string array for parsing
MisProtein = extractBetween(MisProtein,(3*ones(length(MisProtein),1)),(strlength(MisProtein)-1)); %p.X123Y --> X123

[~,~,idx1] = unique(MisProtein); %Use the third output of Unique to generate numeric values from the cell array of strings
[count1, ~] = hist(idx1, unique(idx1)); %array: 'count' occurrence of each unique protein change type

MissenseCount(i) = sum(MisIdx); %# of total missense mutations
R_MissenseCount(i) = sum(count1(count1 > 1)); %sum all RECURRENT missense mutation on one amino acid (more than 1)


%identical, in-frame indels 
InframeIndel = ismember(Variant(MutIdx), 'In_Frame_Indel');%matrix of logicals, 1 when the gene's mutation is 'inframe indel'
IndelProtein = ProteinChange(InframeIndel); %protein changes
IndelProtein = extractBetween(IndelProtein,(3*ones(length(IndelProtein),1)),(strlength(IndelProtein)-1)); %p.X123Y --> X123


[~,~,idx2] = unique(IndelProtein); %Use the third output of Unique to generate numeric values from the cell array of strings
[count2, ~] = hist(idx2, unique(idx2)); %array: 'count' occurrence of each unique protein change type

InframeCount(i) = sum(InframeIndel); %# of inframe indel counts
R_InframeCount(i) = sum(count2(count2> 1));%sum all RECURRENT/identical inframe indel mutation on one protein


% ============Scoring================
ClusteredCount = R_MissenseCount + R_InframeCount;
InactivatingCount = NonsenseCount+IndelCount+SpliceCount+NonstopCount;

OncoScore(i) = (ClusteredCount(i))/MutationCount(i);
TSGScore(i) = (InactivatingCount(i))/MutationCount(i); %if >20% gene is tsg

 
if (OncoScore(i) >= 0.2) && (ClusteredCount(i)) > 10 && TSGScore(i) < 0.05
    labels(i) = 1;
    fprintf('%s is an Oncogene \n', string(U_GeneName(i))); 
elseif ((OncoScore(i) >= 0.2) && (ClusteredCount(i) > 10) && (TSGScore(i) >= 0.5)) || (OncoScore(i) < 0.2)
    if (TSGScore(i) >= 0.2) && (InactivatingCount(i) >=7) 
                if InactivatingCount(i) > 20 %certainly a TSG
                    fprintf('%s is a TSG \n', string(U_GeneName(i)));
                  	labels(i) = 1;
                else %In those cases in which 7~20 inactivating mutations were recorded in the COSMIC database, manual curation was performed.
                    labels(i) = 1; %OR zero (manual)
                end
    end
end
totalscore(i) = OncoScore(i) + TSGScore(i);
disp(i)
end

save twentytwentyResults.mat labels totalscore;