
function evaluate (X,y,mdl)
% %% Setup
% clc; clear
% 
% load runResults2.mat
% load mdlSVM.mat
% 
% %%
% for j = 1:5
%     if j == 1
%         mdl = mdlBoost;
%     elseif j == 2
%         mdl = mdlRUS;
%     elseif j ==3
%         mdl = mdlSVM;
%     elseif j ==4
%         mdl = mdlRUS2;
%     elseif j ==5
%         mdl = mdlBoost2;
%     end
    
    [pOG,pTSG] = permutationTest(8,X,mdl,y); %check if done right
    pDriver = pOG.*pTSG;
    qOG = adjustP(pOG); %get fdr-adjusted p score --> NOT USED FOR NOW
    qTSG = adjustP(pTSG);
    qDriver = qOG.*qTSG;
    
    

    %qthresh = 0.1; %this is a random # (what is it actually?)
    thresh = 0.15;
    
    sigIdx = (pDriver <thresh); %index of significant genes
    sigIdxQ = (qD < 0.4);
    sigGeneCount = nnz(sigIdx); %# of significant genes
    fracOverlap = numel(intersect(find(sigIdx==1),find(y ~= 1))) / 500;%# of genes that overlap with drivers (y=2, y=3)
    
    load uniqueGeneNames.mat uniqueGeneNames;
    [~,order] = sort(pOG(sigIdx)+pTSG(sigIdx));
    sigGeneNames = uniqueGeneNames(sigIdx(order));
    
    %%  Consistency
    rng default
    for i = 1:10 %repeat 10x
        idx = randperm(length(X));
        idx1 = idx(1:floor(length(X)/2)) ;
        idx2 = idx(1+floor(length(X)/2):end) ;
        X1 = X(idx1,:); %split data in half
        X2 = X(idx2,:);
        
        [~,score1] = mdl.predictFcn(X1);
        [~,score2] = mdl.predictFcn(X2);
        
        score1 = sum(score1(:,[2,3]),2); %sum out og+tsg score
        score2 = sum(score2(:,[2,3]),2);
        
        [~,order1] = sort(score1,'descend');
        [~,order2] = sort(score2,'descend');
        
        
        %"topDrop" consistency score
        d = 150; %chosen depth of interest for ranked gene list
        I = numel(intersect(order1(1:d),order2(1:2*d)));
        consistency(i) = I/d;
    end
    consistency = max(mean(consistency), median(consistency));
    
    %% save results
    if j == 1
        save mdlBoostEval.mat p q consistency sigGeneCount fracOverlap
    elseif j == 2
        save mdlRUSeval.mat p q consistency sigGeneCount fracOverlap
    elseif j == 3
        save mdlSVMeval.mat p q consistency sigGeneCount fracOverlap
    elseif j ==4
        save mdlRUS2eval.mat p q consistency sigGeneCount fracOverlap
    elseif j == 5
        save mdlBoost2eval.mat p q consistency sigGeneCount fracOverlap
    end
    
end
