function [ model , ap, c_val, cvmodel, cvid, vscore ] = train_one_action(anno, feat_type, feat_dir, action_index)

config;

% ensure reproducibility
rseed;

% cross validation parameters
c_val_list = 10.^(-3:1:2);
fold = 5;

% load mean norm file
mean_norm_file = [base_dir 'caches/mean_norm/' feat_type '.mat'];
ld = load(mean_norm_file);
mean_norm = ld.mean_norm;

% get labels
indexes = find(anno.anno_train(action_index,:));
label_value = anno.anno_train(action_index, indexes)';
label_value(label_value == -2) = -1;

% get feature files
images_name = anno.list_train(indexes);
fprintf('train on %d images, action : %d\n', length(images_name), action_index);
feature_list = cellfun(@(x)strrep(x,'.jpg','.mat'), images_name, 'UniformOutput', false);

% load feature size
s = load(fullfile(feat_dir, feature_list{1}));
data = zeros(length(feature_list), length(s.feat));

% start timer
tic;

% load feature
fprintf('loading feature ... \n');
for j = 1:length(feature_list)
    tic_print(sprintf('  %05d/%05d\n',j,numel(feature_list)));
    % load feature
    s = load(fullfile(feat_dir, feature_list{j}));
    % Normalization factor is picked by the average features norm
    % during training. The range of C is experimentally set using
    % this normalization factor
    data(j,:) = double(s.feat) ./ mean_norm;
end
fprintf('load data complete: %6.2f sec\n',toc);

% cross validation
fprintf('performing cross validation ... \n');
c_val = 0.1;
ap = 0;
cvmodel = [];
cvid    = [];
vscore  = [];
if sum(label_value == 1) >= fold
    ap_list     = zeros(1,length(c_val_list));
    cvmodel_all = cell(1,length(c_val_list));
    cvid_all    = cell(1,length(c_val_list));
    vscore_all  = cell(1,length(c_val_list));
    for k = 1:length(c_val_list)
        [ap_list(k), cvmodel_all{k}, cvid_all{k}, vscore_all{k}] = cross_valid( ...
            label_value, data, fold, c_val_list(k), true, 1);
    end
    ap      = max(ap_list);
    c_val   = c_val_list(ap_list == ap);
    c_val   = c_val(1);
    cvmodel = cvmodel_all(ap_list == ap);
    cvmodel = cvmodel{1};
    cvid    = cvid_all(ap_list == ap);
    cvid    = cvid{1};
    vscore  = vscore_all(ap_list == ap);
    vscore  = vscore{1};
end
fprintf('cross validation complete: %6.2f\n',toc);

% training
par = sprintf('-s %d -c %.6f', 1, c_val);
model = train(label_value, sparse(data), par);
fprintf('train %03d done: %6.2f\n', action_index, toc);

clearvars data;

end
