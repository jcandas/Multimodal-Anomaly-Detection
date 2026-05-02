function parameters = evalpca(parameters)

thresh = parameters.test.threshold;
spe = parameters.stats.spe;

parameters.test.table.trunc(:) = parameters.KL.numEigen;
parameters.test.table.spe(:) = spe;
parameters.test.table.detect = spe > thresh;
thresh

writetable(parameters.test.table,"../data/gaussian_test/data100_L0.25_Lp0.25_test200_PCA_M85_.csv")