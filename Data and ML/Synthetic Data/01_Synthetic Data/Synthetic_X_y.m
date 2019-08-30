function [X, y] = Synthetic_X_y(syntheticMutFile)
%% Synthetic_X_y.m
% input: synthetic mutation file (MAF);
% output: feature vector X and corresponding class labels y

% Setup
clc
load synthDrivers.mat synthOncs synthTsgs; %vector list of driver gene names
load geneSeq.mat geneSeq; %gene sequence (originally a FASTA file)

%--------Synthetic Mutation File----------
%gene, variant type, nucleotide, nucleotide change, protein change
geneName = cell2mat(syntheticMutFile(:,1)) + 1; %3-4 digit #; +1 for matlab indexing
patientId = string(syntheticMutFile(:,2));
mutStart = cell2mat(syntheticMutFile(:,3)) +1;
mutEnd = cell2mat(syntheticMutFile(:,4)) +1;
variant = string(syntheticMutFile(:,5));  %ex: Missense_Mutation / Splice_Site / Silent / Frame_Shift_Indel
newNucleotide = syntheticMutFile(:,7);

geneSeq = string(geneSeq);

uniqueGeneName = double(unique(geneName));

%-------Initialize counters----------------------
MutationCount = zeros(length(uniqueGeneName),1);
NonsenseCount = zeros(length(uniqueGeneName),1); SilentCount = zeros(length(uniqueGeneName),1);
MissenseCount = zeros(length(uniqueGeneName),1); R_MissenseCount = zeros(length(uniqueGeneName),1);
MissenseEntropy = zeros(length(uniqueGeneName),1); geneCountFraction = zeros(length(geneSeq),1);
MutationEntropy = zeros(length(uniqueGeneName),1);

% Counts, Gene Characteristics
for i = 1:length(uniqueGeneName)
    CurrentGeneName = uniqueGeneName(i); %testing which gene?
    mutIdx = ismember(geneName,CurrentGeneName);  %matrix of logicals, 1 when gene appears in mutation list
    MutationCount(i) = nnz(mutIdx); %how many times does mutation happen?
    
    SilentCount(i) = sum(ismember(variant(mutIdx), 'Silent'));
    NonsenseCount(i) = sum(ismember(variant(mutIdx), 'Nonsense_Mutation'));
    
    %missense entropy, recurrent count
    misIdx = ismember(variant(mutIdx), 'Missense_Mutation'); %matrix of logicals, 1 when the gene's mutation is 'missense'
    [MissenseEntropy(i), ~] = isRecurrentSynthetic (mutStart(misIdx));
    [MutationEntropy(i), ~] = isRecurrentSynthetic (mutStart(mutIdx));
    
    MissenseCount(i) = nnz(misIdx);
    
    geneCountFraction(i) = length(unique(patientId(geneName == i)))/length(unique(patientId));%fraction of patients gene shows up in
    
end

%gene length
geneLength = strlength(geneSeq);


% Fractions
% all Nx1 arrays, where N is # of unique gene names
%
SilFrac = SilentCount./MutationCount; %1. silent fraction
NonFrac = NonsenseCount./MutationCount; %2. nonsense fraction
MisFrac = MissenseCount./MutationCount; %4. missense fraction
R_MisFrac = R_MissenseCount./MutationCount; %5. recurrent missense fraction
MisToSil =  MissenseCount./(SilentCount+1); %8. missense to silent (pseudo count added to silent to avoid divide by 0)
NonSilToSil = (MutationCount-SilentCount)./(SilentCount+1); % 9. non-silent to silent ratio (pseudo count added)

% create X
X = [SilFrac NonFrac MisFrac R_MisFrac MisToSil NonSilToSil geneCountFraction geneLength MissenseEntropy MutationEntropy]; %feature vector; add three p-vals later

% Create y
y0 = (~ismember(uniqueGeneName,[synthOncs; synthTsgs])); %passenger mutations = 1
y1 = (ismember(uniqueGeneName,synthOncs)); %oncogenes = 2
y2 = (ismember(uniqueGeneName,synthTsgs));   %TSGs = 3
y = y0+2*y1+3*y2;

% Clean & save
save syn_X.mat X
save syn_y.mat y y0 y1 y2
save syn_Information.mat SilFrac NonFrac MisFrac R_MisFrac MisToSil...
    NonSilToSil geneCountFraction geneLength MissenseEntropy


