function [pOG, pTSG] = permutationTest(m,X,mdl,y)
%input: scalar m, vector X, struct mdl. m is the number of
% permuatations to iterate over. X is the data set we are testing
% the p value for.
% Each “simulated” gene scored with the [ML] already trained on the original synthetic dataset.
% The resulting OG, TSG, and driver scores for all simulated genes were used as an empirical null distribution

%callName = ["simulateData1.mat","simulateData2.mat","simulateData3.mat",...
    %"simulateData4.mat","simulateData5.mat","simulateData6.mat","simulateData7.mat","simulateData8.mat"];
callName = ["simulateX1.mat","simulateX2.mat","simulateX3.mat",...
    "simulateX4.mat","simulateX5.mat","simulateX6.mat","simulateX7.mat","simulateX8.mat"];

    
    %calls monte carlo simulated feature vectors

 
simxScoreFinal = zeros(19319,m); score = zeros(19319,m);
[~,xScore] = mdl.predictFcn(X);
xOGScore = xScore(:,2);
xTSGScore = xScore(:,3);



for i = 1:m
    loadData = load(callName(i));
    simX = loadData.X;
    [~,simxScore] = mdl.predictFcn(simX); %scores for simul. genes, from above trained model; 'null distribution'
    simxOGScore = simxScore(:,2);
    simxTSGScore = simxScore(:,3);
    scoreOG(:,i) = (simxOGScore-xOGScore);
    scoreTSG(:,i) = (simxTSGScore-xTSGScore);
    
end

%pOG = (sum(scoreOG'>=0)+1)./(m+1); %score>0 means that the driver scores for the dataset, compared to the simulated ones, is more significant
%pTSG = (sum(scoreTSG'>=0)+1)./(m+1); 
end