% 1. We sample 'unknown' images as extra ground-truth negatives for the default
%    setting. Please refer to the paper for details.
%
% 2. These extra ground-truth negatives are labeled -2 in the newly-generated 
%    annotation file (i.e. anno_iccv.mat). 
%
% 3. For the training set, we control the number of samples such that for each 
%    HOI class, (number of +1) + (number of -1) + (number of -2) = 5000. For 
%    the test set, we treat all 'unknowns' as extra ground-truth negatives.
%
% 4. Different from anno.mat, anno_iccv.mat has the following possible 
%    annotations:
%
%       +1:  positive
%       -1:  negative
%        0:  ambiguous or no annotation
%       -2:  sampled negative
%

anno_org  = './external/hico_20150920/anno.mat';
anno_iccv = './data/hico_anno/anno_iccv.mat';
extra_neg = './data/hico_anno/extra_neg.mat';

if ~exist(anno_iccv, 'file')
    fprintf('generating anno_iccv.mat ... \n');
    
    % load default annotation
    anno = load(anno_org);
    
    % load sampled 'unknowns' of the training set
    extra_neg = load(extra_neg);
    assert(numel(extra_neg.train) == numel(anno.list_action));
    for i = 1:numel(anno.list_action)
        ind = extra_neg.train{i};
        assert(all(isnan(anno.anno_train(i, ind))) == 1);
        anno.anno_train(i, ind) = -2;
        assert(sum(anno.anno_train(i, :) == 1 ...
            | anno.anno_train(i, :) == -1 ...
            | anno.anno_train(i, :) == -2) == 5000);
        % set all NaN to 0
        anno.anno_train(i, isnan(anno.anno_train(i,:))) = 0;
    end
    
    % set all 'unknowns' in the test set to be extra
    anno.anno_test(isnan(anno.anno_test)) = -2;
    
    % save to new file
    save(anno_iccv, '-struct', 'anno');
    
    fprintf('done.\n\n');
end
