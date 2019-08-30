%% importFasta.m
% imports synthetic data's fasta file (gene sequence) for use in simulated
% data creation

clear
close all
clc

filename = 'humanGeneCode.txt'; 
filename2 = 'genome.fasta.txt';


% Import file as a table using readtable.
%gene, variant type, nucleotide, nucleotide change, protein change
gene2amino = readtable(filename,'Delimiter', '\t', 'Format', '%s %s');
gene2amino = table2cell(gene2amino); %convert to cell
geneSeq = readtable(filename2); geneSeq = table2cell(geneSeq);
geneSeq = geneSeq(2:2:end,1);


% save
save geneSeq.mat geneSeq
save gene2amino.mat gene2amino