function mean_norm = get_mean_norm( feat_dir )

config;

anno = load(anno_file);

l2norm = zeros(numel(anno.list_train),1);

for i = 1:numel(anno.list_train)
    tic_print(sprintf('  %05d/%05d\n',i,numel(anno.list_train)));
    feat_file = [feat_dir strrep(anno.list_train{i},'.jpg','.mat')];
    ld = load(feat_file);
    data = double(ld.feat);
    l2norm(i) = norm(data);
end

mean_norm = mean(l2norm);




