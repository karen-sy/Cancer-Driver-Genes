gausgiven the simulated maf file (corresponding to CONSENSUS), create the X.

%% Setup
clc; clear

load bedfile.mat;
load geneSeqConsensus.mat;
callName = ["simulateConsensusMAF1.mat","simulateConsensusMAF2.mat","simulateConsensusMAF3.mat","simulateConsensusMAF4.mat",...
    "simulateConsensusMAF5.mat","simulateConsensusMAF6.mat","simulateConsensusMAF7.mat","simulateConsensusMAF8.mat"];

load simulateConsensusMAF1.mat simulateConsensusMAF %for initialization
uniqueGeneName = unique(simulateConsensusMAF(:,1)); % num of unique genes
uniqueGeneName = uniqueGeneName(3:end); %take out invalid names
totalCount = 19319; %19319 genes

%--------Synthetic Mutation File----------
%gene, variant type, nucleotide, nucleotide change, protein change
geneName = string(simulateConsensusMAF(:,1));
patientId = string(simulateConsensusMAF(:,2));
mutStart = double(string(simulateConsensusMAF(:,3)));
variant = string(simulateConsensusMAF(:,5));  %ex: Missense_Mutation / Silent / N/A

%---------BedFile--------------------
GeneNameBed = string(bedfile(:,4)); %ex: IVL
GeneStart = double(cell2mat(bedfile(:,2)));   %ex: 58858171
GeneEnd = double(cell2mat(bedfile(:,3)));     %ex: 58864865
ExonCount = double(cell2mat(bedfile(:,5)));
ExonSize = (cellfun(@str2num,bedfile(:,6),'UniformOutput',0)); %returns a multirow cell, each row looks like {[1877,141,74]}
ExonStart = (cellfun(@str2num,bedfile(:,7),'UniformOutput',0)); %same as above


%% -------Initialize counters----------------------
MutationCount = zeros(totalCount,1);
NonsenseCount = zeros(totalCount,1); SilentCount = zeros(totalCount,1);
MissenseCount = zeros(totalCount,1); R_MissenseCount = zeros(totalCount,1);
MissenseEntropy = zeros(totalCount,1); MutationEntropy = zeros(totalCount,1);
geneCountFraction = zeros(totalCount,1); geneLength = zeros(totalCount,1);

%% Counts, Gene Characteristics
for j = 4:8
    simulateConsensusMAF = load(callName(j)); simulateConsensusMAF = simulateConsensusMAF.simulateConsensusMAF;
    for i = 3:length(uniqueGeneName)
        CurrentGeneName = uniqueGeneName(i); %testing which gene?
        mutIdx = find(geneName==CurrentGeneName);  %matrix of logicals, 1 when gene appears in mutation list
        Geneid = find(GeneNameBed==CurrentGeneName);%to use to find same name in bedfile
        
        %         MutationCount(i) = nnz(mutIdx); %how many times does mutation happen?
        
        %         SilentCount(i) = sum(ismember(variant(mutIdx), 'Silent'));
        NonsenseCount(i) = sum(ismember(variant(mutIdx), 'Nonsense_Mutation'));
        
        %missense entropy, recurrent count
        misIdx = mutIdx(variant(mutIdx)=='Missense_Mutation'); %matrix of logicals, 1 when the gene's mutation is 'missense'
        MissenseCount(i) = nnz(misIdx);
        
        %entropies
        [MissenseEntropy(i), ~] = isRecurrentSynthetic(mutStart(misIdx));
        [MutationEntropy(i), ~] = isRecurrentSynthetic(mutStart(mutIdx));
        
        
        %         geneCountFraction(i) = length(unique(patientId(geneName == CurrentGeneName)))/length(unique(patientId));%fraction of patients gene shows up in
        
        %         if isempty(geneSeqConsensus((string(geneSeqConsensus(:,1)) == CurrentGeneName)))
        %             geneLength(i) = NaN;
        %         else
        %             geneLength(i) = strlength(geneSeqConsensus((string(geneSeqConsensus(:,1)) == CurrentGeneName),2));     %8. gene length
        %         end
        %
        fprintf('\n %d/8: %d genes completed',j,i)
    end
    
    
    %% Fractions
    % all Nx1 arrays, where N is # of unique gene names
    %
    %     SilFrac = SilentCount./MutationCount; %1. silent fraction
    %     NonFrac = NonsenseCount./MutationCount; %2. nonsense fraction
    %     MisFrac = MissenseCount./MutationCount; %3. missense fraction
    NonToMis = NonsenseCount./(MissenseCount+1);
    %     MisToSil =  MissenseCount./(SilentCount+1); %5. missense to silent (pseudo count added to silent to avoid divide by 0)
    %     NonSilToSil = (MutationCount-SilentCount)./(SilentCount+1); % 6. non-silent to silent ratio (pseudo count added)
    %
    %% save
    %     X = [SilFrac NonFrac MisFrac NonToMis MisToSil NonSilToSil geneCountFraction geneLength MissenseEntropy MutationEntropy]; %feature vector
    
    if j == 1
        %         save simulateX1.mat
        save fixSimulateX1.mat NonToMis MissenseEntropy MutationEntropy
    elseif j == 2
        %         save simulateX2.mat X
        save fixSimulateX2.mat NonToMis MissenseEntropy MutationEntropy
    elseif j == 3
        %         save simulateX3.mat X
        save fixSimulateX3.mat NonToMis MissenseEntropy MutationEntropy
    elseif j == 4
        %         save simulateX4.mat X
        save fixSimulateX4.mat NonToMis MissenseEntropy MutationEntropy
    elseif j == 5
        %         save simulateX5.mat X
        save fixSimulateX5.mat NonToMis MissenseEntropy MutationEntropy
    elseif j == 6
        %         save simulateX6.mat X
        save fixSimulateX6.mat NonToMis MissenseEntropy MutationEntropy
    elseif j == 7
        %         save simulateX7.mat X
        save fixSimulateX7.mat NonToMis MissenseEntropy MutationEntropy
    elseif j == 8
        %         save simulateX8.mat X
        save fixSimulateX8.mat NonToMis MissenseEntropy MutationEntropy
    end
    
end

clearvars -except X y %clear to declutter workspace

