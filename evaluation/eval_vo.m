function [ res ] = eval_vo( feat_type, flag_obj )
% flag_obj
%   0:  use +1/-1/-2
%   1:  use +1/-1/-2 moving all -2s to the back

if nargin < 2
    flag_obj = 0;
end

config;

% load annotation
anno = load(anno_file);

% get variables and paths
num_class  = length(anno.list_action);
act_name   = cellfun(@(x,y)[x ' ' y],{anno.list_action.nname}',{anno.list_action.vname_ing}','UniformOutput',false);
op_base    = [base_dir 'caches/svm_vo/mode_' feat_type '/'];

test_base  = [op_base 'train_test/'];
model_base = [op_base 'trained_model/'];
fig_base   = [op_base 'ap_obj' num2str(flag_obj) '/'];

% make directories
makedir(fig_base);

% load results
res_file = [op_base 'res_obj' num2str(flag_obj) '.mat'];

if exist(res_file,'file')
    load(res_file);
else
    % open a new figure
    figure(1);
    % init res
    %   c, pos_tr, neg_tr, ap_tr, pos_ts, neg_ts, ap_ts
    res = zeros(num_class, 6);
    fprintf('evaluating vo ... \n');
    for i = 1:num_class
        tic_print(sprintf('  %03d/%03d\n',i,num_class));
        model_file = sprintf('%smodel_a_%d.mat',model_base,i);
        model      = load(model_file);
        test_file  = sprintf('%saction_%d.mat',test_base,i);
        test_res   = load(test_file);
        % get labels and prediction scores
        label = test_res.res.label_value;
        score = test_res.res.prob_estimates;
        % manually change scores for the 'known object (KO)' settings
        if flag_obj == 1
            ii = anno.anno_test(i,:) ~= 0;
            label_sneg = anno.anno_test(i,ii);
            score(label_sneg == -2,:) = -1e10;
        end
        % compute ap
        [rec, prec, ap] = eval_pr_score_label(score, label, sum(label == 1), 0);
        % save experiment profiles
        res(i,1) = model.res.c;
        res(i,2) = sum(anno.anno_train(i,:) ==  1);
        res(i,3) = sum(anno.anno_train(i,:) == -1);
        res(i,4) = sum(label ==  1);
        res(i,5) = sum(label == -1);
        res(i,6) = ap;
        % assertions
        assert(sum(ismember(anno.anno_test(i,:),[1])) == sum(label ==  1));
        assert(sum(ismember(anno.anno_test(i,:),[-1 -2])) == sum(label == -1));
        % plot precision/recall
        fig_file = [fig_base num2str(i,'%03d') '.jpg'];
        if ~exist(fig_file,'file')
            clf;
            plot(rec,prec,'-');
            grid;
            xlabel 'recall'
            ylabel 'precision'
            title(sprintf('class: %s, AP = %.3f',strrep(act_name{i},'_',' '),ap));
            axis([0 1 0 1]);
            print(fig_file,gcf,'-djpeg')
        end
    end
    % save results
    save(res_file,'res');
    % close figure
    close;
end

end

