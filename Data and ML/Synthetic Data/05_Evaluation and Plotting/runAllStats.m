function [Result,ReferenceResult]  = runAllStats(actual,predict)
% runAllStats runs the file allStats, returning stats results from 
% input of the actual class and the predicted class:
%%%%%%%%1.accuracy
%%%%%%%%2.error
%%%%%%%%3.Sensitivity (Recall or True positive rate)
%%%%%%%%4.Specificity
%%%%%%%%5.Precision
%%%%%%%%6.FPR-False positive rate
%%%%%%%%7.F_score
%%%%%%%%8.MCC-Matthews correlation coefficient
%%%%%%%%9.kappa-Cohen's kappa
% Results is averaged from ReferenceResult


%% Multiclass demo
disp('Running Stats')
[~,Result,ReferenceResult]= allStats.getMatrix(actual,predict,0);

end


