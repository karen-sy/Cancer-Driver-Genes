%% Consensus_X_y_Comparable.m
%creates X and y based on consensus file, features equalling that of the feature vectors created by Synthetic_X_y.m.
%result can be directly compared with the synthetic-dataset-based X and y.
%Features:
%[SilFrac NonFrac MisFrac R_MisFrac MisToSil NonSilToSil geneCountFraction geneLength MissenseMissenseEntropy MutationMissenseEntropy pval pval pval]

% Setup
clc;
load bedfile.mat; % snvboxGenes.txt; cell, abc-sorted by gene name
load mutfile_final.mat; % mutations.txt; cell, abc-sorted by gene name
load patientNames.mat patientNames;

cancerIdx = strcmp(mutfile_final(:,8), 'Breast Adenocarcinoma');
mutfile_final = mutfile_final(cancerIdx,:);
%--------Mutation File--------------
totalPatients = length(unique(patientNames));
GeneName = string(mutfile_final(:,1)); %ex: IVL
U_GeneName = unique(GeneName);
Variant = string(mutfile_final(:,5));  %ex: Missense_Mutation / Splice_Site / Silent / Frame_Shift_Indel
MutStart = double(cell2mat(mutfile_final(:,3)));
MutEnd = double(cell2mat(mutfile_final(:,4)));

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
NonsenseCount = zeros(length(U_GeneName),1);
MissenseCount = zeros(length(U_GeneName),1); R_MissenseCount = zeros(length(U_GeneName),1);
R_InframeCount = zeros(length(U_GeneName),1);
MissenseEntropy = zeros(length(U_GeneName),1); MutationEntropy = zeros(length(U_GeneName),1);
geneLength = zeros(length(U_GeneName),1); geneCountFraction = zeros(length(U_GeneName),1);
run = zeros(length(U_GeneName),1);

% Get data
for i = 1:length(U_GeneName)
    CurrentGeneName = U_GeneName(i); %testing which gene?
    Geneid = find(GeneNameBed==CurrentGeneName);%to use to find same name in bedfile
   if strlength(CurrentGeneName) > 1 && ~isempty(Geneid)
        run(i) = 1;
        
        MutIdx = ismember(GeneName,U_GeneName(i));  %matrix of logicals, 1 when gene appears in mutation list
        
        MutationCount(i) = sum(MutIdx); %how many times does mutation happen?
        SilentCount(i) = sum(ismember(Variant(MutIdx), 'Silent'));
        NonsenseCount(i) = sum(ismember(Variant(MutIdx), 'Nonsense_Mutation')); %# of nonsense?
        
        %missense, same amino acid
        MisIdx = ismember(Variant, 'Missense_Mutation'); %matrix of logicals, 1 when any mutation is 'missense'
        MissenseCount(i) = sum(MutIdx.*MisIdx); %# of total missense mutations
        [MissenseEntropy(i),R_MissenseCount(i)] = isrecurrent2(Geneid, MutStart(logical(MutIdx.*MisIdx)),GeneStart,ExonSize,ExonStart); %sum all RECURRENT missense mutation on one amino acid (more than 1)
                
        %MutationEntropy
        [MutationEntropy(i),~] = isrecurrent2(Geneid, MutStart(logical(MutIdx)),GeneStart,ExonSize,ExonStart);
       geneCountFraction(i) = length(unique(patientNames(MutIdx)))/totalPatients;%fraction of patients gene shows up in
    end
    disp(i)
end

% Create Features (X)
% all Nx1 arrays, where N is # of unique gene names

SilFrac = SilentCount./MutationCount; %1. silent fraction
NonFrac = NonsenseCount./MutationCount; %2. nonsense fraction
MisFrac = MissenseCount./MutationCount; %4. missense fraction
R_MisFrac = R_MissenseCount./MutationCount; %5. recurrent missense fraction
MisToSil =  MissenseCount./(SilentCount+1); %8. missense to silent (pseudo count added to silent to avoid divide by 0)
NonSilToSil = (MutationCount-SilentCount)./(SilentCount+1); % 9. non-silent to silent ratio (pseudo count added)
NonToMis = NonsenseCount./(MissenseCount+1);

X = [SilFrac NonFrac MisFrac R_MisFrac MisToSil NonSilToSil geneCountFraction geneLength MissenseEntropy MutationEntropy]; %feature vector

% Create y
load DriverKey.mat OncoKey TSGKey

y0 = (~ismember(U_GeneName,[OncoKey(:,1); TSGKey(:,1)])); %passenger mutations = 1
y1 = (ismember(U_GeneName,OncoKey(:,1))); %oncogenes = 2
y2 = (ismember(U_GeneName,TSGKey(:,1)));   %TSGs = 3
y = y0+2*y1+3*y2;

% % Clean & save
% X = X(run == 1, :); %omit entries with unknown or wrong ("?") gene names
% y = y(run == 1, :); y0 = y0(run == 1, :); y1 = y1(run == 1, :); y2 = y2(run == 1, :);
% 
% save X.mat X
% save y.mat y y0 y1 y2
% save information.mat SilFrac NonFrac MisFrac R_MisFrac MisToSil NonSilToSil ...
%     MissenseEntropy MutationEntropy

clearvars -except X y %clear to declutter workspace

