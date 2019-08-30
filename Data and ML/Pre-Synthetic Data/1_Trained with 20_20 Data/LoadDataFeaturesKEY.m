% LOADDATAFEATURESkey Loads features from my 20/20 AND loads the 20/20 'answer key' of driver genes (list of
% passenger/onco/tsg). It then creates features to be fed into other
% classification methods.

%% Load Data
% Training set (60%), Cross-Validation set (20% of the original data set), Test set (20% of the original data set)
load ('mutfile.mat'); %will predict on this set
load ('DriverListKey'); % KEY (manually curated and everyting) from 20/20 classification

%% Create Features
% all Nx1 arrays, where N is # of unique gene names

load 20_20_Data.mat;

SilFrac = SilentCount./MutationCount; %1. silent fraction
NonFrac = NonsenseCount./MutationCount; %2. nonsense fraction
SplFrac = SpliceCount./MutationCount; %3. splice site fraction 
MisFrac = MissenseCount./MutationCount; %4. missense fraction
R_MisFrac = R_MissenseCount./MutationCount; %5. recurrent missense fraction
IndelFrac = IndelCount./MutationCount; %6.frameshift indel fraction
In_IndFrac = InframeCount./MutationCount; %7. Inframe indel fraction
MisToSil =  MissenseCount./(SilentCount+1); %8. missense to silent (pseudo count added to silent to avoid divide by 0)
NonSilToSil = (MutationCount-SilentCount)./(SilentCount+1); % 9. non-silent to silent ratio (pseudo count added)

%% 
X = [SilFrac NonFrac SplFrac MisFrac R_MisFrac IndelFrac In_IndFrac MisToSil NonSilToSil]; %feature vector
y0 = (~ismember(U_GeneName,[OncoListKEY; TSGListKEY])); %passenger mutations =1
y1 = (ismember(U_GeneName,OncoListKEY)); %oncogenes = 2
y2 = (ismember(U_GeneName,TSGListKEY));   %TSGs = 3
y = y0+2*y1+3*y2; y(y==5) = 2;


save X.mat X
save y.mat y y0 y1 y2

