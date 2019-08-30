%% initialize
clc; 
load MutFile.mat MutFile
callName = ["simulateConsensusMAF1.mat","simulateConsensusMAF2.mat","simulateConsensusMAF3.mat","simulateConsensusMAF4.mat",...
    "simulateConsensusMAF5.mat","simulateConsensusMAF6.mat","simulateConsensusMAF7.mat","simulateConsensusMAF8.mat"];
%% count, original file
%counters
totalCount = length(unique(MutFile(:,1)));
MissenseCount1 = zeros(totalCount,1);
NonsenseCount1 = zeros(totalCount,1);
SilentCount1 = zeros(totalCount,1);

MissenseCount2 = zeros(totalCount,1);
NonsenseCount2 = zeros(totalCount,1);
SilentCount2 = zeros(totalCount,1);

MissensePval = zeros(totalCount,1);
NonsensePval = zeros(totalCount,1);
SilentPval = zeros(totalCount,1);
%%
for j = 1:8
    %load
    simulateConsensusMAF = load(callName(j)); simulateConsensusMAF = simulateConsensusMAF.simulateConsensusMAF;
    geneName = string(simulateConsensusMAF(:,1)); %same as in original mutation file
    uniqueGeneName = unique(geneName);
    
    variant1 = string(MutFile(:,5));
    variant2 = string(simulateConsensusMAF(:,5));  %ex: Missense_Mutation / Splice_Site / Silent / Frame_Shift_Indel
    
    for i = 3:totalCount %length of gene list
        mutIdx = ismember(geneName,uniqueGeneName(i));  %matrix of logicals, 1 when gene appears in mutation list
        SilentCount1(i) = sum(ismember(variant1(mutIdx), 'Silent'));
        NonsenseCount1(i) = sum(ismember(variant1(mutIdx), 'Nonsense_Mutation'));
        MissenseCount1(i) = sum(ismember(variant1(mutIdx), 'Missense_Mutation'));
        
        SilentCount2(i) = sum(ismember(variant2(mutIdx), 'Silent'));
        NonsenseCount2(i) = sum(ismember(variant2(mutIdx), 'Nonsense_Mutation'));
        MissenseCount2(i) = sum(ismember(variant2(mutIdx), 'Missense_Mutation'));
        fprintf('\n iteration %d/8, %d genes completed',j,i-1)
    
        
    end
    MissensePval = MissensePval + double(MissenseCount2>=MissenseCount1);
    SilentPval   = SilentPval   + double(SilentCount2>=SilentCount1);
    NonsensePval = NonsensePval + double(NonsenseCount2>=NonsenseCount1);
    fprintf('done \n');
    
end

MissensePval = (MissensePval(3:end)+1) / (length(callName)+1);
NonsensePval = (NonsensePval(3:end)+1) / (length(callName)+1);
SilentPval = (SilentPval(3:end)+1) / (length(callName)+1);

save pvals.mat MissensePval NonsensePval SilentPval