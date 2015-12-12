
% addpath('3rd_party/matlab_central/rotateXLabels/');
% addpath('3rd_party/matlab_central/distinguishable_color/');
% 
% if exist('3rd_party/kpmf','dir')
%     addpath('3rd_party/kpmf/');
% end
% 
% addpath('collab_filt/');
% addpath('common/');
% addpath('evaluation/');
% addpath('vn_predict/');
% addpath('wn_similarity/');
% addpath('utils/');
% addpath('visualize/');

addpath('common');
addpath('data');
addpath('experiments');
addpath('evaluation');
addpath('utils');

if exist('./3rd_party/liblinear-1.96/matlab', 'dir')
    addpath('./3rd_party/liblinear-1.96/matlab');
end
