%% FunctionSimulateX.m
% FunctionSimulateX creates X matrix from simulated maf file (see
% createSimMAF_Synthetic.m).

% Setup
clc
%load synthMutFile.mat; % mutations.txt; cell, abc-sorted by gene name
load geneSeq.mat;

callName = ["simulateMutFile1.mat","simulateMutFile2.mat",...
    "simulateMutFile3.mat","simulateMutFile4.mat",...
    "simulateMutFile5.mat","simulateMutFile6.mat",...
    "simulateMutFile7.mat","simulateMutFile8.mat"];

uniqueGeneName = 1:10000; %unique genes
totalCount = length(uniqueGeneName);

%-------Initialize counters----------------------
MutationCount = zeros(totalCount,1);
NonsenseCount = zeros(totalCount,1); SilentCount = zeros(totalCount,1);
MissenseCount = zeros(totalCount,1); R_MissenseCount = zeros(totalCount,1);
MissenseEntropy = zeros(totalCount,1); MutationEntropy = zeros(totalCount,1);
geneCountFraction = zeros(totalCount,1);

% Counts, Gene Characteristics
for j = 1:8
    
    simulateMutFile = load(callName(j)); simulateMutFile = simulateMutFile.simulateMutFile;
    %--------Synthetic Mutation File----------
    %gene, variant type, nucleotide, nucleotide change, protein change
    geneName = cell2mat(simulateMutFile(:,1)) + 1; %3-4 digit #; +1 for matlab format
    patientId = string(simulateMutFile(:,2));
    mutStart = cell2mat(simulateMutFile(:,3)) +1;
    variant = string(simulateMutFile(:,5));  %ex: Missense_Mutation / Splice_Site / Silent / Frame_Shift_Indel
    
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
        
        disp(i);
    end
    
    
    % Fractions
    % all Nx1 arrays, where N is # of unique gene names
    
    geneLength = strlength(geneSeq);     %8. gene length
    SilFrac = SilentCount./MutationCount; %1. silent fraction
    NonFrac = NonsenseCount./MutationCount; %2. nonsense fraction
    MisFrac = MissenseCount./MutationCount; %3. missense fraction
    NonToMis = NonsenseCount./(MissenseCount+1);
    MisToSil =  MissenseCount./(SilentCount+1); %5. missense to silent (pseudo count added to silent to avoid divide by 0)
    NonSilToSil = (MutationCount-SilentCount)./(SilentCount+1); % 6. non-silent to silent ratio (pseudo count added)
    
    % save
    X = [SilFrac NonFrac MisFrac NonToMis MisToSil NonSilToSil geneCountFraction geneLength MissenseEntropy MutationEntropy]; %feature vector
        %p-vals appended manually later (for comparison purposes, but
        %addition is essentially optional)
    
    if j == 1
        save simulateData1.mat X
     elseif j == 2
        save simulateData2.mat X
     elseif j == 3
        save simulateData3.mat X
     elseif j == 4
        save simulateData4.mat X
     elseif j == 5
        save simulateData5.mat X
     elseif j == 6
        save simulateData6.mat X
     elseif j == 7
        save simulateData7.mat X
     elseif j == 8
        save simulateData8.mat X
         
    end
    
end

clearvars -except X y %clear to declutter workspace

