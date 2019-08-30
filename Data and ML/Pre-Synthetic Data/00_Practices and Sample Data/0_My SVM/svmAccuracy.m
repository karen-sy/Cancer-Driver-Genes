function [accu1,accu2] = svmAccuracy(model, X, y)
% to return the accuracy of predictions made by trained svm 

% Data 
m = size(X, 1);
p = zeros(m, 1);
pred = zeros(m, 1);

%linear kernel
p = X * model.w + model.b;

%% passenger accuracy
% Convert predictions into 0 / 1
pred(p >= 0) =  1;
pred(p <  0) =  0;  


%% mutation accuracy
accu1 = sum((pred == y) / length(y)) ;
accu2 = sum((1-pred).*(1-y)/sum(1-y)); %only if both = 1 it counts

end

