
config;

% set feature type
%   'imagenet' is the default. You can select another feature type by
%   uncommenting the line.

feat_type = 'imagenet';
% feat_type = 'ft_verb';
% feat_type = 'ft_object';
% feat_type = 'ft_action';

% load annotation
anno = load(anno_file);

% start evaluation
fprintf('start evaluation\n');
fprintf('setting:   default\n');
fprintf('feat_type: %s\n',feat_type);
fprintf('num_class: %03d\n\n',numel(anno.list_action));

% evaluate vo classification
res_vo = eval_vo(feat_type, 0);

% print evaluation results
fprintf('evaluation done.\n');
fprintf('----------------\n');
fprintf('setting:   default\n');
fprintf('feat_type: %s\n',feat_type);
fprintf('num_class: %03d\n\n',numel(anno.list_action));
fprintf('mAP:\n');
fprintf('  VO: %6.2f\n',mean(res_vo(:,6)) * 100);
