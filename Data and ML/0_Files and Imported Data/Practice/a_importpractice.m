clear
close all
clc

filename = 'mutations.txt'; % A tab delimited file
%% Import file as a table using readtable.
% HINT


T = readtable(filename, 'Delimiter', '\t', 'HeaderLines', 0, 'Format', '%s %*s %*s %*s %*u %*u %s %*s %*s %*s');
 
%% Sort the table alphabetically by gene name
tic;
T = sortrows(T,'RowNames');
toc;
%% Use the function unique to get a list of all the gene names
tic;
U = unique(T(:,1),'rows'); % The names of all the genes
toc;
%% Count how many times each of the first 5 genes in your list appear in the table
% HINT
%{
 Use a for loop and ismember
%}
tic
geneCount = zeros(1,5);
T_cell = table2cell(T);
for i = 1:5
    count_gene = ismember(T_cell(:,1),T_cell(i,1));
    geneCount(i) = nnz(count_gene);
end
disp(geneCount)
toc
%% Advanced: Count the fraction of the above genes that have Silent mutations
tic
silentCount = zeros(1,5);
T_5 = table2cell(T(count_gene,2)); %all have one of the 5 first names

for i = 1:5
    count_silent = ismember(T_5,'Silent');
    silentCount(i) = nnz(count_silent);
end
disp(silentCount./geneCount);
toc
%% Smarter Code:
% Besides loading the file, what is the slowest part of the code? You can
% use the run and time option to figure out where the code is slowest. Can
% you make the code faster?
 % sloweset -->counting silent mutations 


%% Have you looked carefully at the data? What is wrong with some of the genes?
