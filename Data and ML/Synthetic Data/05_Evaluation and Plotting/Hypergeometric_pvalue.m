function [correctDrivers, totalPredictedDriver, totalTrueDriver, totalSize] = Hypergeometric_pvalue(Y, predictedY)
% https://systems.crump.ucla.edu/hypergeometric/index.php
%% relevant counts

% count genes and drivers in TCGA
totalSize = numel(Y); % N
Passenger = sum(Y == 1);
Onco = sum(Y == 2); Tsg = sum(Y == 3);
totalTrueDriver = Onco + Tsg; % M

% count overlaps
PredictedOnco = sum(predictedY == 2); PredictedTsg = sum(predictedY == 3);
totalPredictedDriver = PredictedOnco + PredictedTsg; % s
correctDrivers = length(intersect(find(Y ~= 1), find(predictedY ~= 1))); % k 

%% 
%p = hygecdf(correctDrivers, Passenger + totalTrueDriver, totalTrueDriver, totalPredictedDriver); 
%likelihood of drawing 0 to [correctDrivers] driver genes if
%[totalPredictedDrivers] genes is selected at random



end