function NaN_Consensus_X_y
% Many of the Consensus file genes are not in the .bed file, so the default
% function Consensus_X_y_Comparable.m returns half or whole rows of NaN
% values. This imports nanIdx.mat, which has the row numbers from the
% existing feature vector X created by that default function. All such rows
% are re-evaluated here so that select features (that are computable
% without the bedfile information)are computed as values that are not NaN's
%
clear;
clc;
load nanIdx.mat nanIdx1  
load bedfile.mat; % snvboxGenes.txt; cell, abc-sorted by gene name
load mutfile_final.mat; % mutations.txt; cell, abc-sorted by gene name
load patientNames.mat patientNames;
%%
%--------Mutation File--------------
totalPatients = length(unique(patientNames));
GeneName = string(mutfile_final(:,1)); %ex: IVL
U_GeneName = unique(GeneName);
Variant = string(mutfile_final(:,5));  %ex: Missense_Mutation / Splice_Site / Silent / Frame_Shift_Indel

%---------BedFile--------------------
GeneNameBed = string(bedfile(:,4)); %ex: IVL
GeneStart = double(cell2mat(bedfile(:,2)));   %ex: 58858171
GeneEnd = double(cell2mat(bedfile(:,3)));     %ex: 58864865
ExonCount = double(cell2mat(bedfile(:,5)));
ExonSize = (cellfun(@str2num,bedfile(:,6),'UniformOutput',0)); %returns a multirow cell, each row looks like {[1877,141,74]}
ExonStart = (cellfun(@str2num,bedfile(:,7),'UniformOutput',0)); %same as above

%-------Initialize counters----------------------
U_GeneName = unique(GeneName); %unique gene names in the Mutation file; counting purposes
MutationCount = zeros(length(U_GeneName),1); SilentCount = zeros(length(U_GeneName),1);
NonsenseCount = zeros(length(U_GeneName),1); MutationEntropy = zeros(length(U_GeneName),1);
MissenseCount = zeros(length(U_GeneName),1); MissenseEntropy = zeros(length(U_GeneName),1);
geneCountFraction = zeros(length(U_GeneName),1);

%%
for ii = 1:length(nanIdx1) %the bedfile gene does not exist
    i = nanIdx1(ii) + 2;
    CurrentGeneName = U_GeneName(i); %testing which gene?
    MutIdx = ismember(GeneName,U_GeneName(i));  %matrix of logicals, 1 when gene appears in mutation list
%     
%     MutationCount(i) = sum(MutIdx); %how many times does mutation happen?
%     SilentCount(i) = sum(ismember(Variant(MutIdx), 'Silent'));
%     NonsenseCount(i) = sum(ismember(Variant(MutIdx), 'Nonsense_Mutation')); %# of nonsense?
%     
%     %missense, same amino acid
%     MisIdx = ismember(Variant, 'Missense_Mutation'); %matrix of logicals, 1 when any mutation is 'missense'
%     MissenseCount(i) = sum(MutIdx.*MisIdx); %# of total missense mutations
%     
    geneCountFraction(i) = length(unique(patientNames(MutIdx)))/totalPatients;%fraction of patients gene shows up in
    disp(ii)
end

%% Create Features (X)
% all Nx1 arrays, where N is # of unique gene names

SilFrac = SilentCount./MutationCount; %1. silent fraction
NonFrac = NonsenseCount./MutationCount; %2. nonsense fraction
MisFrac = MissenseCount./MutationCount; %4. missense fraction
MisToSil =  MissenseCount./(SilentCount+1); %8. missense to silent (pseudo count added to silent to avoid divide by 0)
NonSilToSil = (MutationCount-SilentCount)./(SilentCount+1); % 9. non-silent to silent ratio (pseudo count added)
