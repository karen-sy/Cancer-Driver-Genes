function g = sigmoid(z)
%Compute sigmoid function

g = zeros(size(z));
g = 1./(1+exp(-z)); %sigmoid of each value of z 

end