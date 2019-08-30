%ver.2: use bed file to count 'recurrent' mutations, instead of looking at
%protein changes

clear;clc

%% Load Data, Get information
GetInformation

%%
%these two variables are set up differently for later use
MisIdx = ismember(Variant, 'Missense_Mutation'); %vector of logicals, 1 for all 'missense' mutations
InframeIndelIdx = ismember(Variant, 'In_Frame_Indel');
TSGList3 = []; %initialize identification matrix
TSGCurateList3 = []; 
OncogeneList3 = [];
        
%% 
for i = 1:length(U_GeneName)
    CurrentGeneName = U_GeneName(i); %testing which gene?
    Geneid = (GeneNameBed==CurrentGeneName);%to use to find same name in bedfile
    if strlength(CurrentGeneName) > 1 && sum(Geneid) == 1   
        %Count mutations, excluding melanoma
        MutIdx = ismember(GeneName,U_GeneName(i));  %logical vector; 1 when gene appears in mutation list
        MutationCount(i) = sum(MutIdx); %count
        
        if sum(ismember(CancerType(MutIdx), ["Pancreatic Adenocarcinoma", "Liver Hepatocellular carcinoma",...
                "Stomach Adenocarcinoma", "Melanoma", "Colorectal", "Endometrial Carcinoma"])) > sum(MutIdx)/2 %20/20 ver.3
            continue;
        end
        
        %==============TSG===============
        SilentCount(i) = sum(ismember(Variant(MutIdx), 'Silent'));
        NonsenseCount(i) = sum(ismember(Variant(MutIdx), 'Nonsense_Mutation')); %# of nonsense?
        IndelCount(i) = sum(ismember(Variant(MutIdx), 'Frame_Shift_Indel')); %# of indel?
        SpliceCount(i) = sum(ismember(Variant(MutIdx), 'Splice_Site'));  %# of splice?
        NonstopCount(i) = sum(ismember(Variant(MutIdx), 'Nonstop_Mutation')); %# of nonstop?
        %==============Onco===============
        %1) missense, same amino acid
        MissenseCount(i) = sum(MutIdx.*MisIdx); %# of total missense mutations for the gene
        R_MissenseCount(i) = isrecurrent(CurrentGeneName, GeneNameBed, MutStart.*MisIdx.*MutIdx, GeneStart,ExonSize,ExonStart);
                             %feed indices corresponding to missense mutations of that gene
        
        %identical, in-frame indels
        InframeCount(i) = sum(InframeIndelIdx); %# of inframe indel counts
        R_InframeCount(i) = isrecurrent(CurrentGeneName, GeneNameBed, MutStart.*InframeIndelIdx.*MutIdx,GeneStart,ExonSize,ExonStart);
        
        
        %% ============Scoring================
        
        ClusteredCount = R_MissenseCount + R_InframeCount;
        InactivatingCount = NonsenseCount+IndelCount+SpliceCount+NonstopCount;
        
        OncoScore(i) = (ClusteredCount(i))/MutationCount(i);
        TSGScore(i) = (InactivatingCount(i))/MutationCount(i); %if >20% gene is tsg
        
        %note 0.2->0.15
        if (OncoScore(i) >= 0.15) && (ClusteredCount(i)) > 10 && TSGScore(i) < 0.05
            OncogeneList3 = [OncogeneList3; string(U_GeneName(i))]; %add oncogene to list
            fprintf('%s is an Oncogene \n', string(U_GeneName(i)));
        elseif ((OncoScore(i) >= 0.2) && (ClusteredCount(i) > 10) && (TSGScore(i) >= 0.5)) || (OncoScore(i) < 0.2)
            if (TSGScore(i) >= 0.2) && (InactivatingCount(i) >=7)
                if InactivatingCount(i) > 20 %certainly a TSG
                    fprintf('%s is a TSG \n', string(U_GeneName(i)));
                    TSGList3 = [TSGList3; string(U_GeneName(i))]; %add TSG gene to list
                else %In those cases in which 7~20 inactivating mutations were recorded in the COSMIC database, manual curation was performed.
                    %fprintf('%s is a TSG (Manually curate.) \n', string(U_GeneName(i)));
                    fprintf('%s may be a TSG \n',string(U_GeneName(i)));
                    TSGCurateList3 = [TSGCurateList3; string(U_GeneName(i))]; %add TSG gene to list
                end
            end
        end
    end
end

save OncogeneList3.mat OncogeneList3 %save list of driver genes
save TSGList3.mat TSGList3
save TSGListCurate.mat TSGCurateList3


save 20_20_Data.mat U_GeneName MutationCount SilentCount NonsenseCount ...
    IndelCount SpliceCount NonstopCount ...
    MissenseCount R_MissenseCount ...
    InframeCount R_InframeCount
