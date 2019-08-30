function [E,r_count] = isrecurrent (Geneid, MutStart,GeneStart,ExonSize,ExonStart)
% isrecurrent counts the recurrent occurrences of a type of mutation for a
% given gene. 

if isempty(MutStart)
    E = NaN; r_count = 0;
else
    
    %0. Given the Gene Name from the mut file, match with bed file
    GeneStart = GeneStart(Geneid); %start locations of genes that contain the mutations ('0' if at start of exon)
    ExonSize = cell2mat(ExonSize(Geneid));   %cell: sizes of exons that contain the mutations
    ExonStart = cell2mat(ExonStart(Geneid)); %cell: start locations (in relation to gene) of exons that contain the mutations
    
    
    %1. Bedfile: get matrix of [exonstart1,exonend1;exonstart2,exonend2; .... ]
    exon_list = [(GeneStart+ExonStart)', (GeneStart+ExonStart+ExonSize)'];   %[start,end], #s now match with mut file
    exonbounds = floor((exon_list-GeneStart)/3);
    
    %2. Get "which number codon" each mutation goes in
    CodonId = floor((MutStart-GeneStart)/3);
    ExonBin = discretize(CodonId,sort(exonbounds(:))); %put each 'codon id' into a bin, where the number of bins = number of exons + introns
    
    CodonId = CodonId(~ismember(ExonBin, (2:2:(length(exonbounds(:))- 1)))); %if the 'codon id' indicates mutation is intronic, omit
    
    CodonId = CodonId(CodonId >= 0); %in cases some CodonId is negative; creates NaN values
    
    count = hist(CodonId,unique(CodonId)); %returns vector, # of mutation in each codon that has at least 1 mutation
    
    if sum(count) < 2
       E = NaN; %1 mutation cannot be a 'cluster' 
    else
    E = -sum((count./sum(count)).*log2(count/sum(count)))/(log2(sum(count))); %normalized entropy
    end
        r_count = 1; %has been removed from feature list

end


end