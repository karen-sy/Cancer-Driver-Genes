function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1); 
X = [ones(m,1)  X];
h = @(X, theta) sigmoid(X*theta);

eye_matrix = eye(num_labels);
y_matrix = eye_matrix(y,:);
         

% =========================================================
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. 

a_2 = h(X, Theta1');
a_2 = [ones(size(a_2,1),1) a_2];

a_3 = h(a_2, Theta2'); %a(3) is the same as h(x)

matrix_full = (log(a_3)' * y_matrix + log(1-a_3)' * (1-y_matrix)) ; 
matrix_diag = matrix_full .* eye(size(matrix_full,1)); 

J = -1/m * sum(sum(matrix_diag));


% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
d_3 = a_3 - y_matrix; %5000 x 10
z_2 = X * Theta1'; %5000 x 25

d_2 = d_3 * Theta2(:,2:end).* sigmoidGradient(z_2); %(5000 x 10) .x (10 x 25) x (5000 x 25)  = 5000 x 25 

Delta1 = d_2' * X;
Delta2 = d_3' * a_2;

Theta1_grad = 1/m * Delta1;
Theta2_grad = 1/m * Delta2;



% Part 3: Implement regularization with the cost function and gradients.
Theta1(:,1) = 0 ; Theta2(:,1) = 0;

reg_cost = (lambda/(2*m))*((sum(sum(Theta1.^2)) + sum(sum(Theta2.^2))));
J = J + reg_cost;


Theta1_grad = Theta1_grad + (lambda/m)*(Theta1);
Theta2_grad = Theta2_grad + (lambda/m)*(Theta2);


% -------------------------------------------------------------

% =========================================================================
% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
