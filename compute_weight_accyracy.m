function [ total_accuracy ] = compute_weight_accyracy( labels, prediction_prob )

n_classes = 10;
n_splits = length(labels);
accuracy_num = cell(10, 1);
accuracy_den = cell(10, 1);

for i = 1:n_splits
    [~, index] = max(prediction_prob{i});
    n_instances = length(index);
    
    num = zeros(n_classes, 1);
    den = zeros(n_classes, 1);
    for n = 1:n_instances
        den(labels{i}(n)) = den(labels{i}(n)) + 1;
        if labels{i}(n) == index(n)
            num(labels{i}(n)) = num(labels{i}(n)) + 1;
        end
    end
    
    accuracy_num{i} = num;
    accuracy_den{i} = den;
end

total_accuracy = zeros(10, 1);
accuracy = cell(10, 1);

for i = 1:n_splits
    accuracy{i} = accuracy_num{i} ./ accuracy_den{i};
    total_accuracy = total_accuracy + accuracy{i};
end

total_accuracy = total_accuracy / n_splits;

end

