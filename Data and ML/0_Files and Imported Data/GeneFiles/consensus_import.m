%% consensus_import.m
% consensus_import imports the CGC list and converts it to a cell,
% and extracts the names of the driver genes.

clear
close all
clc

filename = 'ConsensusGenes.txt'; % A tab delimited file

% Import; Table --> Cell
ConsensusFile = readtable(filename, 'Format', '%s %*s %*u %s %*u %*s %s %*s %*s %*s %*s %*s %*s %*s %s %s %*s %*s %*s %*s');
ConsensusFile = table2cell(ConsensusFile);  %convert to cell

% Get a list of all the gene names
ConsensusGenes = unique(ConsensusFile(:,1),'rows'); % The names of all the genes

% Save
save consensusfile.mat ConsensusFile ConsensusGenes %save


