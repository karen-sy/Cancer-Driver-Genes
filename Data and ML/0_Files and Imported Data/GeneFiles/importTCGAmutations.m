%% importTCGAmutations
% imports MAF ("mutations") file, converts into cell that can be
% manipulated in Matlab. Produces three different versions containing
% different information from original raw data.

clear
close all
clc

filename = 'mutations.txt'; % A tab delimited file

% Import file as a table using readtable.
%gene, variant type, protein change --> 20/20 Ver 1
mutfile = readtable(filename, 'Delimiter', '\t', 'Format', '%s %s %s %s %u %u %s %s %s %s','HeaderLines', 1,'ReadVariableNames', 1 );
mutfile = table2cell(mutfile); %convert to cell

% version 2
%gene, chromosome, start pos, end pos, variant type, reference allele,
%tumor allele --> 20/20 ver 2 (for use with bedfile)
mutfile2 = readtable(filename, 'Delimiter', '\t', 'Format', '%s %*s %*s %s %u %u %s %s %s %*s','HeaderLines', 1,'ReadVariableNames', 1 );
mutfile2 = table2cell(mutfile2); %convert to cell

% version 3
%gene, variant type, protein change --> 20/20 Ver 2, TO EXCLUDE cancers
%with high mutation rates, etc.
mutfile3 = readtable(filename, 'Delimiter', '\t', 'Format', '%s %*s %s %s %u %u %s %s %s %*s','HeaderLines', 1,'ReadVariableNames', 1 );
mutfile3 = table2cell(mutfile3(:,[1,3,4,5,6,7,8,2])); %convert to cell


% Sort the table alphabetically by gene name
mutfile = sortrows(mutfile,1);
mutfile2 = sortrows(mutfile2,1);

% Use the function unique to get a list of all the gene names
%U = unique(T(:,1),'rows'); % The names of all the genes

save mutfile.mat mutfile
save mutfile2.mat mutfile2
save mutfile3.mat mutfile3