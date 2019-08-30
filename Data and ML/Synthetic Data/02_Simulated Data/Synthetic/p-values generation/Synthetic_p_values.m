%% Synthetic_p_values.m
% Synthetic_p_values creates vectors of p values per gene in the simulated
% MAF file.

% initialize
load Counts.mat MissenseCount SilentCount NonsenseCount %from original synthetic file
callName = ["simulateMutFile1.mat","simulateMutFile2.mat",...
    "simulateMutFile3.mat","simulateMutFile4.mat",...
    "simulateMutFile5.mat","simulateMutFile6.mat",...
    "simulateMutFile7.mat","simulateMutFile8.mat"];
% count, original file
%counters
MissenseCount2 = zeros(10000,1);
NonsenseCount2 = zeros(10000,1);
SilentCount2 = zeros(10000,1);

MissensePval = zeros(10000,1);
NonsensePval = zeros(10000,1);
SilentPval = zeros(10000,1);

% get p value using calculations from each simulated dataset
for j = 1:8
    simulateMutFile = load(callName(j)); simulateMutFile = simulateMutFile.simulateMutFile;
    variant = string(simulateMutFile(:,5));  %ex: Missense_Mutation / Silent_Mutation / Nonsense_Mutation
    geneName = double(cell2mat(simulateMutFile(:,1)));
    for i = 1:10000 %length of gene list
        mutIdx = ismember(geneName,i);  %matrix of logicals, 1 when gene appears in mutation list
        SilentCount2(i) = sum(ismember(variant(mutIdx), 'Silent'));
        NonsenseCount2(i) = sum(ismember(variant(mutIdx), 'Nonsense_Mutation'));
        MissenseCount2(i) = sum(ismember(variant(mutIdx), 'Missense_Mutation'));
        disp(i)
    end
    MissensePval = MissensePval + double(MissenseCount2>=MissenseCount);
    SilentPval   = SilentPval   + double(SilentCount2>=SilentCount);
    NonsensePval = NonsensePval + double(NonsenseCount2>=NonsenseCount);
    fprintf('done \n');    
   end 
    
    MissensePval = (MissensePval+1) / (length(callName)+1);
    NonsensePval = (NonsensePval+1) / (length(callName)+1); 
    SilentPval = (SilentPval+1) / (length(callName)+1);
    
   save pvals.mat MissensePval NonsensePval SilentPval