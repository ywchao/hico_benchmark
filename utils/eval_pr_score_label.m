function [ rec, prec, ap ] = eval_pr_score_label( score, label, npos, draw )
% input
%   score:  [N x 1]     Classification score. N is the number of data (VN pair)
%   label:  [N x 1]     Ground-truth labels of the data; should be a vector of 1s and -1s
%   npos:   [1]         Number of ground-truth positives. This is independent of 
%                       classification. Get this from the ground-truth label.
%   draw:   [1]         draw the figure or not.
%

if nargin < 4
    draw = false;
end


ulabel = unique(label);
assert(numel(ulabel) == 2 && (ulabel(1) == -1) && (ulabel(2) == 1));

% sort classifcation by decreasing score
[~,si]=sort(score,'descend');
lb = label(si);

% assign tp/fp
nd = length(score);
tp = zeros(nd,1);
fp = zeros(nd,1);

for d = 1:nd
    if lb(d) == 1
        tp(d) = 1;
    else
        fp(d) = 1;
    end
end

% compute precision/recall
fp   = cumsum(fp);
tp   = cumsum(tp);
rec  = tp/npos;
prec = tp./(fp+tp);

% compute average precision

ap=0;
for t=0:0.1:1
    p=max(prec(rec>=t));
    if isempty(p)
        p=0;
    end
    ap=ap+p/11;
end

if draw
    % plot precision/recall
    plot(rec,prec,'-');
    grid;
    xlabel 'recall'
    ylabel 'precision'
    % title(sprintf('class: %s, subset: %s, AP = %.3f',cls,VOCopts.testset,ap));

    axis([0 1 0 1]);
end

end

