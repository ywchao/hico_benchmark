
base_dir = [fileparts(mfilename('fullpath')) '/'];

% HICO image directory
im_dir = [base_dir './external/hico_20150920/images/'];

% HICO annotation file
%
%   anno_iccv.mat is identical to anno.mat (i.e. the annotation file come with
%   HICO) with only one difference. In anno_iccv.mat, we provide our sampled
%   'unknown' images that we use as extra ground-truth negatives for each
%   action class (e.g. images do not contain 'bicycles' for action 'ridining a
%   bicycle'). This sampling is necessary for exact replication of our results
%   (in the default setting) in the paper.
%
%   See data/generate_anno_iccv.m for more details.
%
anno_file     = [base_dir './data/hico_anno/anno_iccv.mat'];
anno_sep_file = [base_dir './data/hico_anno/anno_sep.mat'];  

% The MATLAB code will use parfor for training HOI classifiers. Uncomment the
% following line and set the poolsize according to your need. Leave the line
% commented out if you want MATLAB to set the poolsize automatically.

% poolsize = 10;
