%% createSimMAF_Synthetic.m
% createSimMAF_Synthetic creates simulated (permuted) dataset of some
% MAF file.

clc; clear;  rng('shuffle')

load geneSeq.mat geneSeq
load gene2amino.mat gene2amino
load synthMutFile.mat
 
%
simulateMutFile = repmat(synthMutFile,1,1);
geneName = double(cell2mat(synthMutFile(:,1))) +1; %made in python
mutStart = double(cell2mat(synthMutFile(:,3))) +1;
mutEnd = double(cell2mat(synthMutFile(:,4))) +1;
oldNucleotide = synthMutFile(:,6) ;
newNucleotide = synthMutFile(:,7) ;
gene2amino = string(gene2amino);
geneSeq = char(geneSeq);

for j = 0
    for i = 1:length(synthMutFile) %go through each mutation
        
        % modify gene sequence-------------
        
        %where to mutate?
        if length(newNucleotide{i}) == 1
            pick = 1;
        else %if more than one possible mutation
            pick = [1 3]; pick = pick(round(rand + 1)); %1st or 2nd choice (index in string)
        end
        possibleLocations = find(geneSeq(geneName(i),:) == oldNucleotide{i}); %poss. locations in the same gene
        
        if numel(possibleLocations) == 0
            continue;
        end
        mutLocation = datasample(possibleLocations,1); %mutation location in simulated genes
        
        
        % old amino acid?
        aaIdx = floor((mutLocation-0.001) / 3) +1;
        oldAmino = gene2amino(gene2amino(:,1) == geneSeq(geneName(i),[3*aaIdx-2 3*aaIdx-1 3*aaIdx]),2);
        
        %change gene sequence
        geneSeq(geneName(i),mutLocation) = newNucleotide{i}(pick);
        
        % get new amino acid based on new sequence---------
        newAmino = gene2amino(gene2amino(:,1) == geneSeq(geneName(i),[3*aaIdx-2 3*aaIdx-1 3*aaIdx]),2);
        
        % update the simulated mutations file------------
        simulateMutFile{length(synthMutFile)*j+i,3} = mutLocation;
        simulateMutFile{length(synthMutFile)*j+i,4} = simulateMutFile{length(synthMutFile)*j+i,3};
        
        if newAmino == '*'
            simulateMutFile{length(synthMutFile)*j+i,5} = "Nonsense_Mutation";
        elseif newAmino == oldAmino
            simulateMutFile{length(synthMutFile)*j+i,5} = 'Silent';
        elseif newAmino ~= oldAmino
            simulateMutFile{length(synthMutFile)*j+i,5} = 'Missense_Mutation';
        end
        simulateMutFile{length(synthMutFile)*j+i,7} = newNucleotide{i}(pick);
        simulateMutFile{length(synthMutFile)*j+i,8} = string(['p.',(oldAmino),(aaIdx),(newAmino)]); %store as two chars
         
        disp(length(synthMutFile)*j+i)
    end
    fprintf('done')
end
save simulateMutFile8.mat simulateMutFile