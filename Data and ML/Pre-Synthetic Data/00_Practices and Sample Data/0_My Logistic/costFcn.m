function [J, grad] = costFcn(theta, X, y)
%COSTFUNCTION Compute cost and gradient for logistic regression
%   J = COSTFUNCTION(theta, X, y) computes the cost of using theta as the
%   parameter for logistic regression and the gradient of the cost
%   with respect to the parameters theta.

m = length(y); % number of training examples
h = @(X) sigmoid(X*theta); %result is m by 1 vector

J = (1/m)*(-y' * log(h(X)) - (1-y)' * log(1-h(X))) + lambda/(2*m) * sum(theta(2:end).^2); %cost

grad =(1/m)*(h(X)-y)' * X;

% =============================================================

end
