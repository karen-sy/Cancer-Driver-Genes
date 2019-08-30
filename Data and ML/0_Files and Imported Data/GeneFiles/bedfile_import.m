clear
close all
clc

filename = 'snvboxGenes.txt'; % A tab delimited file
%% Import; Table --> Cell
% HINT
%{
\t represents a tab

To make the file size more managable read up on the function textscan
and how to use 'Format' to create a table that only has
Gene and Variant_Classification

%s - string, %u - unsigned integer, %* - skip this column
%}

bedfile = readtable(filename,'Delimiter', '\t', 'HeaderLines', 0, 'Format', '%s %u %u %s %*u %*s %*u %*u %*u %u %s %s');
%chromosome, startpos, endpos,genename,exoncount,wideness,whereonchrom
bedfile = table2cell(bedfile);  %convert to cell
%% Sort alphabetically by gene name
bedfile = sortrows(bedfile,4);

%% Save
save bedfile.mat bedfile %save
