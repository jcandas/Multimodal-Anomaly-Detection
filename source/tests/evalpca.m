function parameters = evalpca(parameters)

thresh = parameters.test.threshold;
spe = parameters.stats.spe;

parameters.test.table.trunc(:) = parameters.KL.numEigen;
parameters.test.table.spe(:) = spe;
parameters.test.table.detect = spe > thresh;

writetable(parameters.test.table,parameters.data.out_file)
save(parameters.data.thresh_file, "thresh");