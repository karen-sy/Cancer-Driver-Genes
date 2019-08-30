%% indexCancerTypes.m
% indexCancerTypes takes in full MAF file and returns N index vectors,
% where N is the number of types of cancer documented in the file.
% each vector contains the index into MAF file, on which gene mutation
% occurs in the cancer.

load mutfile_final.mat mutfile_final; 
uniqueGeneNames = string(unique(mutfile_final(:,1)));

cancerTypes = {'ALL' 'Astrocytoma' 'Bladder Urothelial Carcinoma' ...
    'Breast Adenocarcinoma' 'CARC' 'CLL' 'Cervical Carcinoma' ...                   
    'Colorectal' 'DLBCL' 'Endometrial Carcinoma' 'Esophageal Adenocarcinoma'...
    'Glioblastoma Multiforme' 'Head and Neck Squamous Cell Carcinoma'...
    'Kidney Chromophobe' 'Kidney Clear Cell Carcinoma' 'Kidney Papillary Cell Carcinoma'...
    'LAML' 'Liver Hepatocellular carcinoma' 'Low Grade Glioma'...
    'Lung Adenocarcinoma' 'Lung Small Cell Carcinoma' 'Lung Squamous Cell Carcinoma'...
    'Lymphoma B-cell' 'MM' 'Medulloblastoma'...
    'Melanoma' 'Neuroblastoma' 'Ovarian' ...
    'Pancreatic Adenocarcinoma' 'Prostate Adenocarcinoma' 'RHAB' ...
    'Soft Tissue Sarcoma' 'Stomach Adenocarcinoma' 'Thyroid Carcinoma'};                    
cancerGeneIdx = cell(length(cancerTypes),2);
cancerGeneIdx(:,1) = cancerTypes';
    for i = 1:length(cancerTypes)
        findCancer = ismember(mutfile_final(:,8),cancerTypes(i));
        cancerGeneIdx{i,2}(:) = unique(string(mutfile_final(findCancer,1)));
    end
    
    save cancerGeneIdx.mat cancerGeneIdx
    
    
    





 

