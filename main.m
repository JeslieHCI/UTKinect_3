clear
clc

%% start timer
tic

%% classification
for class = 1:3
    skeletal_action_classification(1, 5, class);
end

%%
% load the data
arm = load('body_model_arm_experiments\SE3_lie_algebra_relative_pairs\results\classification_results.mat');
leg = load('body_model_leg_experiments\SE3_lie_algebra_relative_pairs\results\classification_results.mat');
spine = load('body_model_spine_experiments\SE3_lie_algebra_relative_pairs\results\classification_results.mat');

arm_labels = arm.test_labels;
arm_prediction_prob = arm.test_prediction_prob;
leg_labels = leg.test_labels;
leg_prediction_prob = leg.test_prediction_prob;
spine_labels = spine.test_labels;
spine_prediction_prob = spine.test_prediction_prob;

% compute the weight
arm_total_accuracy = compute_weight_accyracy( arm_labels(1:4), arm_prediction_prob(1:4) );
leg_total_accuracy = compute_weight_accyracy( leg_labels(1:4), leg_prediction_prob(1:4) );
spine_total_accuracy = compute_weight_accyracy( spine_labels(1:4), spine_prediction_prob(1:4) );

accuracy = [arm_total_accuracy, leg_total_accuracy, spine_total_accuracy];

weight = compute_weight(arm, leg, spine);

% compute the last accuracy
[ total_prob ] = compute_total_accuracy( weight,...
    arm_labels, arm_prediction_prob,...
    leg_labels, leg_prediction_prob,...
    spine_labels, spine_prediction_prob);

total_accuracy = zeros(10, 1);
confusion_matrix = zeros(10, 10);
index = cell(10, 1);

for n = 1:10
    [~, index{n}] = max(total_prob{n});
    
    for k = 1:10
        confusion_matrix(n, k) = length(find(index{n} == k))/length(index{n});
    end
    total_accuracy(n) = length(find(index{n} == n))/length(index{n});
end

imagesc(confusion_matrix)

textStrings = num2str(confusion_matrix(:),'%0.2f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding

idx = find(strcmp(textStrings(:), '0.00'));
textStrings(idx) = {'   '};

[x,y] = meshgrid(1:10);   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center');

set(gca,'YTick',1:10,...
        'YTickLabel',{'walk','sit down','stand up','pick up','carry','throw','push','pull','wave','clap'},...
        'TickLength',[0 0]);  

set(gca,'XTick',1:10,'XTickLabel','') 
% Define the labels 
lab = [{'walk'};{'sit down'};{'stand up'};{'pick up'};{'carry'};{'throw'};...
           {'push'};{'pull'};{'wave'};{'clap'}];
% Estimate the location of the labels based on the position 
% of the xlabel
hx = get(gca,'XLabel');  % Handle to xlabel
set(hx,'Units','data');
pos = get(hx,'Position');
y = pos(2);
% Place the new labels
X = 1:10;
for i = 1:size(lab,1)
    t(i) = text(X(i),y,lab(i,:));
end
set(t,'Rotation',45,'HorizontalAlignment','right')

% stop timer
toc

% accuracy = 0.9765