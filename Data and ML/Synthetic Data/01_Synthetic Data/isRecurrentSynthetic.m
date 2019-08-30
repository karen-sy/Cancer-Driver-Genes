function [E,r_count] = isRecurrentSynthetic (MutStart)
% ISRECURRENTSYNTHETIC counts the recurrent occurrences of a type of mutation for a
% given gene. Shorter than the isRecurrent function because there are no
% intron/exon indices to care about.

MutStart = double(MutStart);
if isempty(MutStart)
    E = 1; r_count = 0;
else
        
    %1. Get "which number codon" each case of mutation goes in
    CodonId = floor((MutStart+1)/3); %add one because starting index of each gene is zero
    
    count = hist(CodonId,unique(CodonId)); %returns vector, # of mutation in each codon that has at least 1 mutation
    recurrentnum = sum(count(count>1)); %get total number of mutations in "clusters" (>1 mutation within same amino acid)
    
    
    E = -sum((count./sum(count)).*log2(count/sum(count)))/log2(sum(count)); %normalized missense entropy
    r_count = sum(recurrentnum);
    
 
end

end
