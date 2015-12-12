function [ap, cvmodel, cvid, vscore] = cross_valid(label, data, fold, c_value, flag_vscore, weight)
    if nargin < 5
        flag_vscore = false;
    end

    if flag_vscore
        cvmodel = cell(fold,1);
        cvid    = zeros(size(data,1),1);
        vscore  = zeros(size(data,1),1);
    end

    pos_index = find(label == 1);
    neg_index = find(label ~= 1);
    pos_corss_indexes = crossvalind( 'Kfold',length(pos_index),  fold);
    neg_corss_indexes = crossvalind( 'Kfold',length(neg_index),  fold);
    ap_list = zeros(1,fold);
    for i = 1:fold
        pos_valid_index = pos_index((pos_corss_indexes == i) == 1);
        neg_valid_index = neg_index((neg_corss_indexes == i) == 1);

        valid_label = [label(pos_valid_index); label(neg_valid_index) ];
        valid_data = [data(pos_valid_index , :) ; data(neg_valid_index , :)];

        train_label = [label(pos_index((pos_corss_indexes == i) ~= 1)); label(neg_index((neg_corss_indexes == i) ~= 1)) ];
        train_data = [data(pos_index((pos_corss_indexes == i) ~= 1) , :) ; data(neg_index((neg_corss_indexes == i) ~= 1) , :)];

        if (weight == 1)
            par = sprintf('-s %d -c %6f', 1, c_value);
        else
            par = sprintf('-s %d -c %6f -w1 %2.2f -w-1 1', 1, c_value, weight);
        end
        model = train(train_label, sparse(train_data), par);
        [~, ~, prob_estimates] = predict(valid_label, sparse(valid_data), model, '-b 0');
        [~, ~, one_ap] = eval_pr_score_label(prob_estimates, valid_label, sum(valid_label == 1), 0);
        ap_list(i) = one_ap;

        % save score for validation set
        if flag_vscore
            assert(isempty(cvmodel{i}));
            assert(all(cvid([pos_valid_index; neg_valid_index]) == 0));
            assert(all(vscore([pos_valid_index; neg_valid_index]) == 0));
            
            cvmodel{i} = model;
            cvid([pos_valid_index; neg_valid_index])   = i;
            vscore([pos_valid_index; neg_valid_index]) = prob_estimates;
        end
    end
    ap = mean(ap_list);
end
