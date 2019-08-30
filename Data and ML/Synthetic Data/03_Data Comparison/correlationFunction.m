function [synCorr, conCorr] = correlationFunction(SyntheticX,ConsensusX,SyntheticY,ConsensusY)
%CORRELATIONFUNCTION returns the linear correlation coefficient r between
%variables in two datasets: the Synthetic data feature vector and the
%Consensus data feature vector.

% yPassConsensus = find(ConsensusY == 1);
% yOncoConsensus = find(ConsensusY == 2);
% yTSGConsensus = find(ConsensusY == 3);
% 
% yPassSynthetic = find(SyntheticY == 1);
% yOncoSynthetic = find(SyntheticY == 2);
% yTSGSynthetic = find(SyntheticY == 3);
% 
% 
% categories =({'SilFrac' 'NonFrac' 'MisFrac' 'R_MisFrac' 'MisToSil' 'NonSilToSil' 'geneCountFract' 'geneLength' 'MissenseEntropy' 'MutationEntropy' 'MisPval' 'NonPval' 'SilPval'});

i = [1 2 5 6 7 10 11 12]; %testing feature 1
j = [3 3 9 6 7 1 2 3]; %testing feature 2
 
for idx = 1:length(i)
    synCorr(idx) = corr(SyntheticX(:,i(idx)),SyntheticX(:,j(idx)), 'rows', 'complete'); %find correlation coefficient for synthetic data
    conCorr(idx) = corr(ConsensusX(:,i(idx)),ConsensusX(:,j(idx)), 'rows', 'complete'); %find correlation coefficient for consensus data    
end
 
save correlationCoefficients.mat synCorr conCorr

end