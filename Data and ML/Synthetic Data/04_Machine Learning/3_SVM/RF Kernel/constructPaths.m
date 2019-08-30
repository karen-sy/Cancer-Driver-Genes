function allPaths = constructPaths(mdl)
% constructPaths returns a struct with n fields, where n is the number of 
% trees in the classification ensemble defined by mdl.
% Each field represents one classification tree, which is a m-by-1 cell
% that contains m vectors. Each vector is the path that one gene takes down
% the tree.
%% setup
clc; clearvars -except mdl;
loadXY;
X = SyntheticX; %may change to consensusx,y

%% construct all gene paths in all trees
allPaths = struct();
tag = cell(length(mdl.ClassificationEnsemble.Trained),1); %one tag for each tree
genePath = cell(length(X),1); %one subcell for each tree; one subcell row for each gene


for i = 1:length(mdl.ClassificationEnsemble.Trained)%for each tree in ensemble
    [~, ~, node] = mdl.ClassificationEnsemble.Trained{i}.predict(X); %node: totalGeneNumber-by-1 list of all final nodes
    allParents = mdl.ClassificationEnsemble.Trained{i}.Parent;
    
    for j = 1:length(X) %total number of genes
        currentNodeParent = allParents(node(j)); %parent for final node
        genePath{j} = [currentNodeParent; node(j)]; %set up path
        
        while str2double(string(genePath{j}(1))) ~= 0
            currentNodeParent = allParents(currentNodeParent); %go "up" nodes in path
            genePath{j} = [currentNodeParent ;genePath{j}];
        end
    end
    allPaths.(['tree',char(num2str(i))]) = genePath(:);
    fprintf("\n tree %d done", i);
end
fprintf("All paths constructed and saved into struct");
end
