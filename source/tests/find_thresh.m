T = readtable("../data/gaussian_test/data100_L0.25_Lp0.25_m200_testall_PCA_M85.csv");

spe_0 = T{T.gauss_height==0, "spe"};
spe_1 = T{T.gauss_height==0.01, "spe"};

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

thresh = 0.1293;
acc_0 = mean(spe_0 <= thresh);
acc_1 = mean(spe_1 > thresh);
acc = mean([acc_0, acc_1]);
disp(acc)
disp(acc_0)
disp(acc_1)

disp(best_thresh)
disp(best_acc)
disp(best_0)
disp(best_1)