function classifykmeans
%% setup
rng default  % For reproducibility
load no_isnan_X.mat ; load no_isnan_y.mat

X = zscore(X);
%% subsampling
% subsampling approach, in which passenger genes are sampled at a 1:1 ratio to OGs plus TSGs
pass = (y==1); %total > 19000
data = [X y];
datamod = [datasample(data(pass,:),200); data(~pass,:)];
Xmod = datamod(:,1:9);
ymod = datamod(:,10);

%run kmeans
idx3 = kmeans(Xmod,3,'MaxIter',50000); 

%accuracy
C = confusionmat(ymod,idx3);
ConfusionPlot(C)

%visualize
figure
[s,h] = silhouette(Xmod,idx3,'cityblock');
h = gca;
h.Children.EdgeColor = [.8 .8 1];
xlabel 'Silhouette Value'
ylabel 'Cluster'

silvals = silhouette(Xmod,idx3,'cityblock');
silhvals_avg = mean(silvals); %mean silihouette vals



end