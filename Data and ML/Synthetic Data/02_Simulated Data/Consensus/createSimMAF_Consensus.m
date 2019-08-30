%% returns simulated (permuted) dataset given an original set of SYNTHETIC DATA
%% ignores mutation types other than non, mis, sil

%% Setup
clc; clear; rng('shuffle')

load geneSeqConsensus.mat geneSeqConsensus
load bedfile.mat; % snvboxGenes.txt; cell, abc-sorted by gene name
load gene2amino.mat gene2amino
load mutfile_final.mat

%% Load information on original mut file
simulateConsensusMAF = mutfile_final(:,1:7);

geneName = (string(mutfile_final(:,1)));
patientNames = string(mutfile_final(:,2));
mutStart = double(cell2mat(mutfile_final(:,3)));
mutEnd = double(cell2mat(mutfile_final(:,4))) ;
variant = string(mutfile_final(:,5));
oldNucleotide = mutfile_final(:,6) ;
newNucleotide = mutfile_final(:,7) ;
gene2amino = string(gene2amino);
geneLength = strlength(geneSeqConsensus(:,2));

%%
for j = 1:7
    for i = 1:length(simulateConsensusMAF) %go through each mutation
        %% ***skip if original variant type is not mis/non/sil
        %% identify gene (and its sequence)
        geneid = find(geneSeqConsensus(:,1) == geneName(i));
        if isempty(geneid) == 1
            simulateConsensusMAF{i,5} = "N/A";
            
        elseif (~ismember(variant{i},["Missense_Mutation", "Nonsense_Mutation", "Silent"]))
            simulateConsensusMAF{i,5} = "N/A";
        else
            
            %% modify gene sequence
            %where to mutate?
            if length(newNucleotide{i}) == 1
                pick = 1;
            else %if more than one possible mutation
                pick = [1 3]; pick = pick(round(rand + 1)); %1st or 2nd choice (index in string)
            end
            
            if strlength(oldNucleotide{i}) > 1
                simulateConsensusMAF{i,5} = "N/A"; %" ONLY COUNTING SINGLE_NUCLEOTIDE VARIATIONS " 
            else
                possibleLocations = find(geneSeqConsensus{geneid,2}(1:end-3) == oldNucleotide{i}(:)); %poss. locations in the same gene
                
                if numel(possibleLocations) == 0
                    simulateConsensusMAF{i,5} = "N/A"; %not missense/nonsense/silent
                else
                    mutLocation = datasample(possibleLocations,1); %mutation location in simulated genes
                    % old amino acid?
                    aaIdx = floor((mutLocation-0.001) / 3) +1;
                    oldAmino = gene2amino(gene2amino(:,1) == geneSeqConsensus{geneid,2}([3*aaIdx-2 3*aaIdx-1 3*aaIdx]) , 2);
                    
                    %change gene sequence
                    geneSeqConsensus{geneid,2}(mutLocation) = newNucleotide{i}(pick);
                    
                    % get new amino acid based on new sequence
                    newAmino = gene2amino(gene2amino(:,1) == geneSeqConsensus{geneid,2}([3*aaIdx-2 3*aaIdx-1 3*aaIdx]) , 2);
                    
                    
                    %% update the simulated mutations file
                    simulateConsensusMAF{i,3} = mutLocation; %if mutlocation = 10, this means 10th in EXON SEQUENCE
                    simulateConsensusMAF{i,4} = mutLocation;
                    
                    if numel(newAmino) == 0
                        simulateConsensusMAF{i,5} = "N/A";
                    elseif newAmino == '*'  
                        simulateConsensusMAF{i,5} = "Nonsense_Mutation";
                    elseif newAmino == oldAmino
                        simulateConsensusMAF{i,5} = 'Silent';
                    elseif newAmino ~= oldAmino
                        simulateConsensusMAF{i,5} = 'Missense_Mutation';
                    end
                    simulateConsensusMAF{i,7} = newNucleotide{i}(pick);
                    
                    fprintf('\n %d\iteration / %d\gene \n', j , i);
                end
            end
        end
    end
    fprintf('done')
    
    
    %% save
    if j == 1
        save simulateConsensusMAF1.mat simulateConsensusMAF
    elseif j == 2
        save simulateConsensusMAF2.mat simulateConsensusMAF
    elseif j == 3
        save simulateConsensusMAF3.mat simulateConsensusMAF
    elseif j == 4
        save simulateConsensusMAF4.mat simulateConsensusMAF
    elseif j == 5
        save simulateConsensusMAF5.mat simulateConsensusMAF
    elseif j == 6
        save simulateConsensusMAF6.mat simulateConsensusMAF
    elseif j == 7
        save simulateConsensusMAF7.mat simulateConsensusMAF
    elseif j == 8
        save simulateConsensusMAF8.mat simulateConsensusMAF
    end
    
    simulateConsensusMAF = mutfile_final(:,1:7); %reset for next iteration
end