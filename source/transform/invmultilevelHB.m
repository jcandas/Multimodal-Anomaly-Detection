function parameters = invmultilevelHB(parameters,data);


% Upload variables
dimdata = parameters.ML.dimdata;
multileveltree = parameters.ML.multilevetree;
dcoeffs=parameters.ML.Output.Dcoefficients;
ccoeffs=parameters.ML.Output.Ccoefficients;
coeffs=parameters.ML.Output.coefficients;
ind = parameters.ML.ind;
datacell = parameters.ML.datacell;
datalevel = parameters.ML.datalevel;
coord = parameters.KL.coord;

numofpoints = size(coord,1);
zeroedccoeffs = zeros(size(ccoeffs));


% Construction of the anomaly
reconstruction = invhbtrans(dcoeffs, zeroedccoeffs, multileveltree, ind, datacell, datalevel, numofpoints, dimdata);


% Place reconstruction in the original square domain
sizes = size(data.landsat.rawtestslice);
A = nan(sizes);
A((coord(:,2) - 1)*sizes(1) + coord(:,1)) = reconstruction;

% Output
parameters.ML.Output.AnomalyReconstruction = A;