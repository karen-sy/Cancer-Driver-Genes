%seth's answer key

clear 
close all
clc

filename = 'mutations.txt'; % A tab delimited file
%% Import file as a table using readtable

T = readtable(filename,'Delimiter','\t','HeaderLines',0,'Format', '%s %*s %*s %*s %*u %*u %s %*s %*s %*s');

%% Sort the table alphabetically by gene name 

T = sortrows(T,1);

%% Use the function unique to get a list of all the gene names

U = unique(T(:,1)); % The names of all the genes

%% Count how many times each of the first 5 genes in your list appear in the table

geneCount = zeros(1,5);
tic
for i= 1:5
    t = sum(ismember(T(:,1),U(i,1))); % Get groups of genes
    geneCount(i) = t;
end
toc
disp(geneCount)

%% Advanced: Count the fraction of the above genes that have Silent mutations

silentCount = zeros(1,5);
Variant_Classification = {'Silent'};
silentTable = table(Variant_Classification);
tic
for i= 1:5
    t = T(ismember(T(:,1),U(i,1)),2); % Get groups of genes
    silentCount(i) = sum(ismember(t(:,1),silentTable));
end
toc
disp(silentCount./geneCount)

%% Smarter Code: 
% Change the tables into arrays
U = table2array(unique(T(:,1)));
G = table2array(T(:,1));
V = table2array(T(:,2));
geneCount = zeros(1,5);
tic
for i= 1:5
    t = sum(ismember(G,U(i))); % Get groups of genes
    geneCount(i) = t;
end
toc
disp(geneCount)

silentCount = zeros(1,5);
tic
for i= 1:5
    t = V(ismember(G,U(i))); % Get groups of genes
    silentCount(i) = sum(ismember(t,{'Silent'}));
end
toc
disp(silentCount./geneCount)


%% Have you looked carefully at the data? What is wrong with some of the genes?
% Some entries have no gene names. These should be removed

