% function K = kernelRF
% kernelRF returns a random forest kernel based on the decision tree paths
% contained in struct allPaths, created by constructPaths.m.
% The similarity measure between genes are defined as
% (overlapping path) / (total path)
function K = kernelRF(idx1,idx2,allPaths,X)
%% construct matrix
% Construct gram matrix for KeRF
 K = zeros(length(idx1));
 for i = 1:length(K) %for each gene...
     for j = 1:i
         v = mKeRF(idx1(i),idx2(j)); %similarity value
         K(i,j) = v;
         K(j,i) = v;
     end
     disp(i)
 end
% 
%% Get similarity value btwn two genes
    function sim = mKeRF(g1, g2)  %g1, g2 are gene identities (g1 = 1 if g1 is gene #1, etc)   
        sharedPathCount= 0; totalPathCount = 0;
        for ii= 1:length(allPaths) %for each tree...
            %get path
            genePath1 = allPaths.(['tree',char(num2str(ii))]){g1};
            genePath2 = allPaths.(['tree',char(num2str(ii))]){g2};
            sharedPathCount = sharedPathCount + numel(intersect(genePath1, genePath2));
            totalPathCount = totalPathCount + numel(union(genePath1,genePath2));
        end
        sim = sharedPathCount/totalPathCount;
% load Kernel.mat Kernel
% sim = Kernel;
        
    end

end


