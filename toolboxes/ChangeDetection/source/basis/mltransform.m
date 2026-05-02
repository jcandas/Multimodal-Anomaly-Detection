function parameters = mltransform(parameters)

% Perform multilevel transform
multileveltree = parameters.ML.multilevetree;
ind = parameters.ML.ind;
datacell = parameters.ML.datacell;
datalevel = parameters.ML.datalevel;

% Run transform on realization
Q = permute(parameters.ML.input,[1 3 2]);

[coeff, levelcoeff, dcoeffs, ccoeffs, nodeindex] = hbtrans(Q, multileveltree, ind, datacell, datalevel);

parameters.ML.Output.coefficients = coeff;
parameters.ML.Output.levelcoefficients = levelcoeff;
parameters.ML.Output.Dcoefficients = dcoeffs;
parameters.ML.Output.Ccoefficients = ccoeffs;
parameters.ML.Output.nodeindex = nodeindex;

