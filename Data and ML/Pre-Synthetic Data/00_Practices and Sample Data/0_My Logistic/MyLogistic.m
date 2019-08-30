%% logistic regression: Initialize
clear; close all; clc

%% Load Data, Create Features
LoadDataFeatures

%% Classifier 1: Passenger or Not? 
% 1) Cost and Gradient


%setup of data matrix; ones added for intercept terms
[m, n] = size(X); 
X = [ones(m,1) X];

%initialize fitting parameters
initial_theta = zeros(n + 1, 1);

%compute initial cost and gradient
[cost_0,grad_0] = costFcn(initial_theta, X, y0); 

% 2) Optimize
options = optimoptions(@fminunc,'SpecifyObjectiveGradient', true); %gradient: costfcn must return the gradient vector g(x) in the second output argument.

[theta_0, cost_0] = fminunc(@(t)(costFcn(t, X, y0)), initial_theta, options);


p = predict(theta_0, X);
score = sum(p == y0) / length(y0);

%% NOTE
Add bias units / regularize? 
note the problems i had (to include in presentation?)

