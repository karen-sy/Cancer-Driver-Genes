function [J, grad] = costFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples
h = @(X) sigmoid(X*theta); %result is m by 1 vector

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta


J = (1/m)*(-y' * log(h(X)) - (1-y)' * log(1-h(X))) + lambda/(2*m) * (theta(2)^2 + theta(3)^2); 

grad =((1/m)*(h(X)-y)' * X);
grad(2:end) = grad(2:end) + (lambda / m) * theta(2:end)'; 


% =============================================================

end
