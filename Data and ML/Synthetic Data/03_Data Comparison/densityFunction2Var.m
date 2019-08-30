function densityFunction2Var(X,y)
%densityFunction2Var creates 3-D plots of probability density estimates 
%of two features taken from the input feature matrix X

%% setup
%close all; clc
yPass = find(y == 1);
yOnco = find(y == 2);
yTSG = find(y == 3);

categories =({'SilFrac' 'NonFrac' 'MisFrac' 'R_MisFrac' 'MisToSil' 'NonSilToSil' 'geneCountFract' 'geneLength' 'MissenseEntropy' 'MutationEntropy' 'MisPval' 'NonPval' 'SilPval'});

%% which features?
%j = [3 3 9 6 7 1 3 2]; %testing feature 1
%i = [1 2 5 6 7 10 11 12]; %testing feature 2

j = [4 8 ]; %testing feature 1
i = [4 8 ]; %testing feature 2


for idx = 1:length(i)
    plotDensity(X(:,j(idx)),X(:,i(idx)),X(yOnco,j(idx)),X(yOnco,i(idx)),X(yTSG,j(idx)),X(yTSG,i(idx)));  %plot comparison between two variables
end



%% actual plot function
    function plotDensity(A1,B1,A2,B2,A3,B3)
        figure;
        ksdensity([A1, B1]);colorbar('EastOutside');
        title([categories{j(idx)}, ' to ' , categories{i(idx)}]);
                
        figure;
        ksdensity([A2,B2]);colorbar('EastOutside');
        title([categories{j(idx)}, ' to ' , categories{i(idx)} , ' oncogene']);
                
        figure;
        ksdensity([A3,B3]);colorbar('EastOutside');
        title([categories{j(idx)}, ' to ' , categories{i(idx)} , ' tsg']);
        
    end
end