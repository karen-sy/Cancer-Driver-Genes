function [pre,rec,score] = fScore(M)
  pre = diag(M) ./ sum(M,2);
  rec = diag(M) ./ sum(M,1)';

  
  f1 = 2*(pre.*rec)./(pre+rec);
  score = mean(f1); %multiclass; take mean
end