function parameters = statspca(parameters,data)

V = parameters.KL.M;
r = parameters.KL.numEigen;
P = V(:,1:r);

C_t = eye(size(P,1))-P*P';

testslice = data.landsat.rawtestslice;
reshapedata = reshape(testslice,[size(testslice,1) * size(testslice,2) size(testslice,3)]);
data_mean = parameters.KL.mean;
reshapedata = reshapedata - data_mean';

projs = C_t*reshapedata;
SPE = sum(projs.^2, 1);

parameters.stats.spe = SPE';