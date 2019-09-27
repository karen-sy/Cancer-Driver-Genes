function p = Hypergeometric_pvalue(Y, predictedY)

%% relevant counts
% count genes and drivers in TCGA
Passenger = sum(Y == 1);
Onco = sum(Y == 2); Tsg = sum(Y == 3);
Driver = Onco + Tsg;

% count overlaps
PredictedOnco = sum(predictedY == 2); PredictedTsg = sum(predictedY == 3);
totalPredictedDrivers = PredictedOnco + PredictedTsg;
correctDrivers = length(intersect(find(Y ~= 1), find(predictedY ~= 1)));

%% 
p = hygecdf(correctDrivers, Passenger + Driver, Driver, totalPredictedDrivers); 
%likelihood of drawing 0 to [correctDrivers] driver genes if
%[totalPredictedDrivers] genes is selected at random



end