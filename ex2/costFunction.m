function [J, grad] = costFunction(theta, X, y)

m = length(y); % number of training examples

J = 0;
grad = zeros(size(theta));

z = X*theta;
J = -1/m*( y'*log(sigmoid(z)) + (1 - y)'*log(1-sigmoid(z)) );

grad = 1/m*(sigmoid(z) - y)'*X;

end
