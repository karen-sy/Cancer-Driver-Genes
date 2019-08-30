function consensus_file_edit(ConsensusFileOriginal)
%% ConsensusFileOriginal.m
%this creates ConsensusFileOverlap, ConsensusFileUnique, and ConsensusFile2.
%for both files, 'fusion' is edited out. 
%ConsensusFileOverlap: Documents genes labeled as {'onco,tsg,fusion'} or
%{'onco,tsg'} (in more than 1 class)
%ConsensusFileUnique: Documents all other genes, in a unique class. 
%ConsensusFile2: Documents genes classified only as 'onco' or 'tsg'
%(input: the imported consensus file from consensus_import.m)

% get indices
clear;clc
ConsensusFileCopy = ConsensusFileOriginal; %create copy
types = unique(ConsensusFileCopy(:,4));  
cell_length = [1:length(ConsensusFileCopy)]';

idx1 = ismember(ConsensusFileCopy(:,4), types([1,2,3,4,6])); %combination of tsg,onco,fus
idx2 = ismember(ConsensusFileCopy(:,4),types([5,7])); %only tsg, onco

overlapidx = (cell_length(idx1));
uniqueidx = (cell_length(idx2));

% convert indices to names
ConsensusAll = ConsensusFileCopy(uniqueidx,:);
OncoConsensus = ConsensusAll((string(ConsensusAll(:,4)) == {'oncogene'}) , :);
TSGConsensus = ConsensusAll((string(ConsensusAll(:,4)) == {'TSG'}) , :);

ConsensusFileOverlap = ConsensusFileCopy(overlapidx,:); %in more than one class (or 'fusion')

save ConsensusFile.mat ConsensusAll OncoConsensus TSGConsensus %save only the good versions to use
save ConsensusFileOriginal.mat ConsensusFileOriginal ConsensusFileOverlap 