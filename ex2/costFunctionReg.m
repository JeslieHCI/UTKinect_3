function [J, grad] = costFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

m = length(y); % number of training examples

J = 0;
grad = zeros(size(theta));

[J, grad] = costFunction(theta, X, y);

thetaFiltered = [0; theta(2:end)];

J = J + ((lambda / (2*m)) * (thetaFiltered' * thetaFiltered));

grad = grad + ((lambda / m) * thetaFiltered)';

end