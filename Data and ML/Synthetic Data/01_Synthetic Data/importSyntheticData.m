%% importSyntheticData.m
% importSyntheticData imports raw synthetic data (gene information and a 
% list of drivers)

clear
close all
clc

filename = 'synthMutation.txt'; % A tab delimited file
filename2 = 'oncDriver.fasta.txt';
filename3 = 'tsgDriver.fasta.txt';

% Import file as a table using readtable.
%gene, variant type, nucleotide, nucleotide change, protein change
synthMutFile = readtable(filename, 'Delimiter', '\t', 'Format', '%u %s %u %u %s %s %s %s','HeaderLines', 1,'ReadVariableNames', 1 );
synthMutFile = table2cell(synthMutFile); %convert to cell
 
synthOncs = readtable(filename2); synthOncs = table2cell(synthOncs);
synthTsgs = readtable(filename3); synthTsgs = table2cell(synthTsgs);

% 
synthMutFile = sortrows(synthMutFile,1);% Sort the table alphabetically by gene name
synthOncs = cell2mat(synthOncs(1:2:end,2));
synthTsgs = cell2mat(synthTsgs(:,2));
 
%
save synthMutFile.mat synthMutFile
save synthDrivers.mat synthOncs synthTsgs