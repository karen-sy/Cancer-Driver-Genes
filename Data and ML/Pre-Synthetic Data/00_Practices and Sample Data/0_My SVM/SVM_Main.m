%% Initialize
clear; close all; clc

load 20_20_Data.mat; load OncogeneList.mat; load TSGList.mat;
% all Nx1 arrays, where N is # of unique gene names:
SilFrac = SilentCount./MutationCount; %1. silent fraction
NonFrac = NonsenseCount./MutationCount; %2. nonsense fraction
SplFrac = SpliceCount./MutationCount; %3. splice site fraction 
MisFrac = MissenseCount./MutationCount; %4. missense fraction
R_MisFrac = R_MissenseCount./MutationCount; %5. recurrent missense fraction
IndelFrac = IndelCount./MutationCount; %6.frameshift indel fraction
In_IndFrac = InframeCount./MutationCount; %7. Inframe indel fraction
MisToSil =  MissenseCount./(SilentCount+1); %8. missense to silent (pseudo count added to silent to avoid divide by 0)
NonSilToSil = (MutationCount-SilentCount)./(SilentCount+1); % 9. non-silent to silent ratio (pseudo count added)

X = [SilFrac NonFrac SplFrac MisFrac R_MisFrac IndelFrac In_IndFrac MisToSil NonSilToSil]; %feature vector
clearvars -except X U_GeneName OncogeneList TSGList; %declutter workspace
y0 = ~ismember(U_GeneName,[OncogeneList; TSGList]); %passenger mutations (logicals; 1 entry per gene name)
y1 = ismember(U_GeneName,OncogeneList); %oncogenes
y2 = ismember(U_GeneName,TSGList);   %TSGs

%% 
C = 400; %?

load ex6data1.mat

fprintf('training......')
model = mySVMtrain(X,y,C, 1e-3);  
[accu1,accu2] = svmAccuracy(model,X,y);


