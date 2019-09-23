function classifykmeans(data)
%% Classifykmeans.m
% classifykmeans.m performs a simple k-means classification. 


%% probably no need to use because cannot transfer learn
% so limit to supervised learning algorithms.

%%
% subsampling
%subsampling approach, in which passenger genes are sampled at a 1:1 ratio to OGs plus TSGs
X = data(:,1:end-1);
y = data(:,end);

% run kmeans
idx3 = kmeans(X,3,'MaxIter',50000); 

% accuracy
C = confusionmat(y,idx3);
ConfusionPlot(C); title('kmeans');

% visualize - silhouette
figure
[s,h] = silhouette(X,idx3,'cityblock');
h = gca;
h.Children.EdgeColor = [.8 .8 1];
xlabel 'Silhouette Value'
ylabel 'Cluster'

silvals = silhouette(X,idx3,'cityblock');
silhvals_avg = mean(silvals); %mean silihouette vals


% save
figure
[kmeansResult,kmeansReferenceResult] = runAllStats(y,idx3);
    save kmeansResults.mat kmeansResult kmeansReferenceResult