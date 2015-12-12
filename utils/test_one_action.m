function [ label_value, predicted_label, accuracy , prob_estimates ] = test_one_action(anno, feat_type, feat_dir, model, action_index)

config;

% load mean norm file
mean_norm_file = [base_dir 'caches/mean_norm/' feat_type '.mat'];
ld = load(mean_norm_file);
mean_norm = ld.mean_norm;

% get labels
indexes = find(anno.anno_test(action_index,:));
label_value = anno.anno_test(action_index, indexes)';
label_value(label_value == -2) = -1;

% get feature files
images_name = anno.list_test(indexes);
fprintf('test on %d images. action: %d\n',length(images_name), action_index);
feature_list = cellfun(@(x)strrep(x,'.jpg','.mat'), images_name, 'UniformOutput', false);

% start timer
tic;

% strat prediction
predicted_label = zeros(length(feature_list),1);
accuracy = zeros(length(feature_list),1);
prob_estimates = zeros(length(feature_list),1);

for j = 1:length(feature_list)
    % load feature
    s = load(fullfile(feat_dir, feature_list{j}));   
    % Normalization factor is picked by the average features norm
    % during training. The range of C is experimentally set using
    % this normalization factor
    data = double(s.feat) ./ mean_norm;
    % prediction
    [one_predicted_label, ~, one_prob_estimates] = predict(label_value(j), sparse(data), model, '-b 0 -q');
    predicted_label(j) = one_predicted_label;
    prob_estimates(j) = one_prob_estimates;
    clearvars data;
end

fprintf('test %03d done: %6.2f\n', action_index, toc);

end
