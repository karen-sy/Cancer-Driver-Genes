function loadResults
clc; clear; 
load logitResults.mat validationResponse validationPredictions
[~,k1,s1,m1,n1] = Hypergeometric_pvalue(validationResponse, validationPredictions);  
%p = 1

load treeResults.mat validationResponse validationPredictions;
[~,k2,s2,m2,n2] = Hypergeometric_pvalue(validationResponse, validationPredictions);  
%p = 5.585721358481817e-43

load polySVMResults.mat validationResponse validationPredictions;
[~,k3,s3,m3,n3] = Hypergeometric_pvalue(validationResponse, validationPredictions);  
%p = 1.695467488512681e-41

load forestResults.mat validationResponse validationPredictions;
[~,k4,s4,m4,n4] = Hypergeometric_pvalue(validationResponse, validationPredictions);  
%p = 3.474567360735496e-27

load RUSsyntheticResults.mat validationResponse validationPredictions 
[~,k5,s5,m5,n5] = Hypergeometric_pvalue(validationResponse, validationPredictions);  
%p = 2.466850161042697e-08

end