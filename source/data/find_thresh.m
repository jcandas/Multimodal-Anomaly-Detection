function [best_thresh] = find_thresh(T_pca, height)

spe_0 = T_pca{T_pca.gauss_height==0, "spe"};
spe_1 = T_pca{T_pca.gauss_height==height, "spe"};

spe_all = sort(cat(1, spe_0, spe_1));

best_thresh = 0;
best_0 = 0;
best_1 = 0;
best_acc = 0;

for i = 1:length(spe_all)-1
    thresh = mean([spe_all(i), spe_all(i+1)]);
    acc_0 = mean(spe_0 <= thresh);
    acc_1 = mean(spe_1 > thresh);
    acc = mean([acc_0, acc_1]);
    
    if acc > best_acc
        best_thresh = thresh;
        best_acc = acc;
        best_0 = acc_0;
        best_1 = acc_1;
    end
end