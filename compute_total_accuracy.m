function [ total_prob ] = compute_total_accuracy( weight,...
    arm_labels, arm_prediction_prob,...
    leg_labels, leg_prediction_prob,...
    spine_labels, spine_prediction_prob)

n_splits = length(arm_labels);
arm = cell(n_splits, 1);
leg = cell(n_splits, 1);
spine = cell(n_splits, 1);
total_prob = cell(n_splits, 1);

for n = 5:n_splits
    n_instances = length(arm_labels{n});
    for i = 1:n_instances
        arm{arm_labels{n}(i)} = [arm{arm_labels{n}(i)}, arm_prediction_prob{n}(:, i)];
        leg{leg_labels{n}(i)} = [leg{leg_labels{n}(i)}, leg_prediction_prob{n}(:, i)];
        spine{spine_labels{n}(i)} = [spine{spine_labels{n}(i)}, spine_prediction_prob{n}(:, i)];
    end
end

for n = 1:n_splits
    total_prob{n} = repmat(weight(:, 1), 1, length(arm{n})) +...
        arm{n}.*repmat(weight(:, 2), 1, length(arm{n})) +...
        leg{n}.*repmat(weight(:, 3), 1, length(leg{n})) +...
        spine{n}.*repmat(weight(:, 4), 1, length(spine{n}));
end

end

