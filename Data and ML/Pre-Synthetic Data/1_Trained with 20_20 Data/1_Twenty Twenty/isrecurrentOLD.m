function [r_count] = isrecurrent (CurrentGeneName, GeneNameBed, MutStart,GeneStart,ExonSize,ExonStart)
% ISRECURRENT counts the recurrent occurrences of a type of mutation for a
% given gene. OLD VERSION

%MutStart is passed in as a vector of either 0 or a nonzero scalar. Get rid of the zeros. 
MutStart = MutStart(MutStart~=0);  

%0. Given the Gene Name from the mut file, match with bed file 
Geneid = (GeneNameBed==CurrentGeneName); %index into bed file?
GeneStart = GeneStart(Geneid); %start locations of genes that contain the mutations ('0' if at start of exon)
ExonSize = cell2mat(ExonSize(Geneid));   %cell: sizes of exons that contain the mutations
ExonStart = cell2mat(ExonStart(Geneid)); %cell: start locations (in relation to gene) of exons that contain the mutations


%1. Bedfile: get matrix of [exonstart1,exonend1;exonstart2,exonend2; .... ]
exon_list = [(GeneStart+ExonStart)', (GeneStart+ExonStart+ExonSize)'];   %[start,end], #s now match with mut file 


%2. for EACH mutation, find out which exon that mutation happens in
exonmut_table = zeros(length(MutStart),length(exon_list)); %create a mut#-by-exon# logical matrix  
for i = 1:length(MutStart) 
    exonmut_table(i,:) = ((MutStart(i)> exon_list(:,1)) .* (MutStart(i) < exon_list(:,2))); %0 if it doesn't "fit" btn exon start~exon end, 1 if it does 
        %row = same mutation (one '1'--the exon it is in--per row)
        %col = same exon (possibly more than one '1' per col)
end

%3. for EACH EXON that has MORE THAN ONE corresponding mutation...
recurrentnum = zeros(1,size(exonmut_table,2));
for i = 1: size(exonmut_table,2) %loop over all such exons
    if sum(exonmut_table(:,i)) > 1 %if exon (column) has more than one mutation
        MutStartList = MutStart(logical(exonmut_table(:,i))); %vector stores the start locations of muts from that exon
        AminoId = floor((MutStartList-GeneStart)/3); %figure out which 'amino acid' each mutation goes in
        [~,~,idx] = unique(AminoId);  
        [count, ~] = hist(idx, unique(idx)); %array: 'count' occurrence of each unique protein change type
        recurrentnum(i) = sum(count(count>1)); %get total number of mutations in "clusters" (>1 mutation within same amino acid)
    end
end

r_count = sum(recurrentnum);      




end