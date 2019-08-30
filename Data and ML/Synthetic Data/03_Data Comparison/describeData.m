load ('ComparableInformation.mat')

MisEntropy1 = statsSummary(MissenseEntropy1);
MisEntropy2 = statsSummary(MissenseEntropy2);

MisFrac1 = statsSummary(MissenseFraction1);
MisFrac2 = statsSummary(MissenseFraction2);

MisSil1 = statsSummary(MissenseToSilent1);
MisSil2 = statsSummary(MissenseToSilent2);

NonsilFrac1 = statsSummary(NonsilentFraction1);
NonsilFrac2 = statsSummary(NonsilentFraction2);

NonsilSil1 = statsSummary(NonsilentToSilent1);
NonsilSil2 = statsSummary(NonsilentToSilent2);

RecurrMisFrac1 = statsSummary(RecurrentMissenseFraction1);
RecurrMisFrac2 = statsSummary(RecurrentMissenseFraction2);

SilFrac1 = statsSummary(SilentFraction1);
SilFrac2 = statsSummary(SilentFraction2);


save Compare_Features_StatsSummaries.mat MisEntropy1 MisFrac1 MisSil1 NonsilFrac1 NonsilSil1 RecurrMisFrac1 SilFrac1...
    MisEntropy2 MisFrac2 MisSil2 NonsilFrac2 NonsilSil2 RecurrMisFrac2 SilFrac2

function summary = statsSummary(X)
X = X(~isnan(X));

meanVal = mean(X);
medianVal = median(X);
modeVal = mode(X);
stdVal = std(X);
varVal = var(X); %variance
maxVal = max(X);
minVal = min(X);

summary = ([meanVal medianVal modeVal stdVal varVal maxVal minVal]);
end
