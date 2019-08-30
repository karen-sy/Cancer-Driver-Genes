%fixP uses the Benjamini-Hochberg false discovery rate to fix the p-values
%in multiple hypothesis testing. It takes a vector p of size at least 2. 

function pAdj = adjustP(p)
    
    [pSorted, ind] = sort(p);
    m = length(p);
    pAdj = pSorted;
    
    for rank = m-1:-1:1
       pCurrent = pSorted(rank)*(m/rank);
       pAdj(rank) = min(pCurrent,pAdj(rank+1));
    end
    pAdj(ind) = pAdj;
end