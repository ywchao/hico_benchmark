function [  ] = parallel_train(start_index, end_index, exp_type, feat_type, feat_dir)

config;

fprintf('start %d to %d\n', start_index, end_index);

switch exp_type
    case {'sep_vb', 'sep_nn'}
        % % load sep annotation
        % anno_sep = load_var(anno_sep_file);
        %
        % % set output dir
        % if strcmp(exp_type,'sep_vb') == 1
        %     anno = anno_sep.anno_vb;
        %     save_dir       = [base_dir 'cache/svm_separate_vb' postfix '/mode_' feat_type '/train_test/'];
        %     save_model_dir = [base_dir 'cache/svm_separate_vb' postfix '/mode_' feat_type '/trained_model/'];
        % end
        % if strcmp(exp_type,'sep_nn') == 1
        %     anno = anno_sep.anno_nn;
        %     save_dir       = [base_dir 'cache/svm_separate_nn' postfix '/mode_' feat_type '/train_test/'];
        %     save_model_dir = [base_dir 'cache/svm_separate_nn' postfix '/mode_' feat_type '/trained_model/'];
        % end
        % makedir(save_dir);
        % makedir(save_model_dir);
        %
        % parfor j = start_index:end_index
        %     [model, ap, c_val, cvmodel, cvid, vscore] = train_one_action_sep(anno, feat_type, feat_dir, j, postfix);
        %     model_name = sprintf('model_a_%d.mat', j);
        %
        %     save_model_sep(fullfile(save_model_dir, model_name), model, ap, c_val, cvmodel, cvid, vscore);
        %
        %     [label_value, predicted_label, accuracy, prob_estimates] = test_one_action_sep(anno, feat_type, feat_dir, model, j, postfix);
        %     result_name = sprintf('action_%d.mat', j);
        %     save_file = fullfile(save_dir, result_name);
        %     save_struct(save_file, label_value, predicted_label, accuracy, prob_estimates);
        % end
    case {'vo'}
        anno = load(anno_file);
        
        % set output dir
        save_test_dir  = [base_dir 'caches/svm_vo/mode_' feat_type '/train_test/'];
        save_model_dir = [base_dir 'caches/svm_vo/mode_' feat_type '/trained_model/'];
        makedir(save_test_dir);
        makedir(save_model_dir);
        
        % start svm training and prediction parallelly
        parfor j = start_index:end_index
            [model, ap, c_val, cvmodel, cvid, vscore] = train_one_action(anno, feat_type, feat_dir, j);
            model_name = sprintf('model_a_%d.mat', j);
            save_model(fullfile(save_model_dir, model_name), model, ap, c_val, cvmodel, cvid, vscore);
            
            [label_value, predicted_label, accuracy, prob_estimates] = test_one_action(anno, feat_type, feat_dir, model, j);
            result_name = sprintf('action_%d.mat', j);
            save_file = fullfile(save_test_dir, result_name);
            save_pred(save_file, label_value, predicted_label, accuracy, prob_estimates);
        end
end

end
