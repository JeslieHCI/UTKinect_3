function [ theta ] = compute_weight(arm, leg, spine)

% new variable
posiSample = cell(10, 1);
negaSample = cell(10, 1);

% sample: data whose label i -> classifier j, [i = j]
%         positive sample of classifier j
%         data whose label i -> classifier j, [i ~= j]
%         negative sample of classifier j

% choose the 4/10 test data as the train data of logistic regression
for seg = 1:4
    % obtain the length of current instance
    loopLen = length(arm.test_labels{seg});
    for num = 1:loopLen
        label = arm.test_labels{seg}(num);
        
        for actionNum = 1:10
            if actionNum == label
                posiSample{actionNum} = [posiSample{actionNum}; ...
                            arm.test_prediction_prob{seg}(actionNum, num), ...
                            leg.test_prediction_prob{seg}(actionNum, num), ...
                            spine.test_prediction_prob{seg}(actionNum, num)];
            else
                negaSample{actionNum} = [negaSample{actionNum}; ...
                            arm.test_prediction_prob{seg}(actionNum, num), ...
                            leg.test_prediction_prob{seg}(actionNum, num), ...
                            spine.test_prediction_prob{seg}(actionNum, num)];
            end
        end
    end
end

%% logistic regression
addpath(genpath('./ex2'))

theta = [];

for actionNum = 1:10
    % obtain the data size
    [instance, ~] = size(posiSample{actionNum});
    posi = [posiSample{actionNum}, ones(instance, 1)];
    [instance, ~] = size(negaSample{actionNum});
    nega = [negaSample{actionNum}, zeros(instance, 1)];
     
%     figure()
%     hold on
%     plot3(posi(:, 1), posi(:, 2), posi(:, 3), 'k+', 'LineWidth', 2, 'MarkerSize', 7);
%     plot3(nega(:, 1), nega(:, 2), nega(:, 3), 'ko', 'MarkerFaceColor', 'y', 'MarkerSize', 7);
%     hold off
    
    % preprocess data, divide into the positive and negative part
    data = [posi; nega];
    [~, dem] = size(data);
    X = data(:, 1:(dem - 1)); y = data(:, dem);
    
    %  Setup the data matrix appropriately, and add ones for the intercept term
    [m, n] = size(X);

    % Add intercept term to x and X_test
    X = [ones(m, 1) X];

    % Initialize fitting parameters
    initial_theta = zeros(n + 1, 1);

    % Compute and display initial cost and gradient
    [cost, grad] = costFunction(initial_theta, X, y);
    
    %  Set options for fminunc
    options = optimset('GradObj', 'on', 'MaxIter', 400);

    %  Run fminunc to obtain the optimal theta
    %  This function will return theta and the cost 
    [thetaLocal, cost] = ...
        fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);
    
    theta = [theta; thetaLocal'];
end

end

