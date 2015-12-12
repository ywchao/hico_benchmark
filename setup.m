
config;

% add paths
addPaths;

% generate anno_iccv.mat
generate_anno_iccv;

% download liblinear
if ~exist('./3rd_party/liblinear-1.96','dir')
    fprintf('downloading liblinear ... \n');
    system('wget https://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-1.96.tar.gz -P 3rd_party');
    system('tar -zxvf 3rd_party/liblinear-1.96.tar.gz -C 3rd_party');
    fprintf('done.\n\n');
end

% build liblinear
if ~exist('./3rd_party/liblinear-1.96/matlab/train.mexa64','file') ...
        || ~exist('./3rd_party/liblinear-1.96/matlab/predict.mexa64','file')
    fprintf('building liblinear ... \n');
    cd ./3rd_party/liblinear-1.96/matlab;
    make;
    cd ../../../;
    fprintf('done.\n\n');
end

% add paths for downloaded codes
addPaths;
