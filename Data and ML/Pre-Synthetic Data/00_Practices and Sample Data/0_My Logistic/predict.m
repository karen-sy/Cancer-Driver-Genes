function p = predict(theta, X)
%Predict whether the label is 0 or 1 using learned logistic 
%regression parameters theta, using a threshold at 0.5 

m = size(X, 1); % Number of training examples
p = zeros(m, 1);
idx = (sigmoid(X*theta) >= 0.5);
p(idx) = 1;

end
