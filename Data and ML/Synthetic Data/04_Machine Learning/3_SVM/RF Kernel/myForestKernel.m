function Kernel = myForestKernel(allPaths)
% a main function for the svm Random Forest Kernel
% calls constructPaths.m and kernelRF.m
% SAVE THIS TO MATLAB PATH; svm call syntax:
% Mdl1 = fitcsvm(X,Y,'KernelFunction','myForestKernel','Standardize',true);

%%
% load mdl;
% allPaths = constructPaths(mdl); %unnecessary if struct already created for finalized model
Kernel = kernelRF(allPaths);
save RFKernel.mat Kernel
end
