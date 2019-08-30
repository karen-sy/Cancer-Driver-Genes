%% GetInformation.m
% GetInformation retrieves information from the imported mutation file and
% extracts information per gene.

% Read Information from files mutfile3 AND BEDFILE
load bedfile.mat; % snvboxGenes.txt; cell, abc-sorted by gene name
load mutfile3.mat; % mutations.txt; cell, abc-sorted by gene name
save mutfile3.mat; % gene, chromosome, startpos, endpos, variant, reference allele,tumor allele,Cancer type

%--------Mutation File--------------
GeneName = string(mutfile_final(:,1)); %ex: IVL
Variant = string(mutfile_final(:,5));  %ex: Missense_Mutation / Splice_Site / Silent / Frame_Shift_Indel
MutStart = double(cell2mat(mutfile_final(:,3)));
MutEnd = double(cell2mat(mutfile_final(:,4)));
CancerType = string(mutfile_final(:,end));

%---------Bed File------------------
GeneNameBed = string(bedfile(:,4)); %ex: IVL
GeneStart = double(cell2mat(bedfile(:,2)));   %ex: 58858171	
GeneEnd = double(cell2mat(bedfile(:,3)));     %ex: 58864865
ExonCount = double(cell2mat(bedfile(:,5)));  
ExonSize = (cellfun(@str2num,bedfile(:,6),'UniformOutput',0)); %returns a multirow cell, each row looks like {[1877,141,74]}
ExonStart = (cellfun(@str2num,bedfile(:,7),'UniformOutput',0)); %same as above

%-------Initialize counters----------------------
U_GeneName = unique(GeneName); %unique gene names in the Mutation file; counting purposes

MutationCount = zeros(length(U_GeneName),1); SilentCount = zeros(length(U_GeneName),1);
NonsenseCount = zeros(length(U_GeneName),1); IndelCount = zeros(length(U_GeneName),1);
SpliceCount = zeros(length(U_GeneName),1); NonstopCount = zeros(length(U_GeneName),1);
MissenseCount = zeros(length(U_GeneName),1); R_MissenseCount = zeros(length(U_GeneName),1);
InframeCount = zeros(length(U_GeneName),1); R_InframeCount = zeros(length(U_GeneName),1);


TSGScore = zeros(1,length(U_GeneName)); %scores matrix
OncoScore = zeros(1,length(U_GeneName));

TSGList = []; %initialize identification matrix
OncogeneList = []; 
