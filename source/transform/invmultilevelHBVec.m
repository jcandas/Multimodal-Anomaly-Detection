function parameters = invmultilevelHBVec(parameters,data);

% Inverse multilevel for vectorial data
dimdata = size(data.landsat.rawdata,4);

% Upload variables
dimdata = size(data.landsat.rawdata,4);
multileveltree = parameters.ML.multilevetree;
dcoeffs=parameters.ML.Output.Dcoefficients;
ccoeffs=parameters.ML.Output.Ccoefficients;
coeffs=parameters.ML.Output.coefficients;
ind = parameters.ML.ind;
datacell = parameters.ML.datacell;
datalevel = parameters.ML.datalevel;
coord = parameters.KL.coord;
testslicedata = squeeze(data.landsat.rawdata(:,:,parameters.data.testdata,:));

numofpoints = size(coord,1);
zeroedccoeffs = zeros(size(ccoeffs));

% Construction of the anomaly
reconstruction = squeeze(invhbtrans(dcoeffs, zeroedccoeffs, multileveltree, ind,datacell, datalevel, numofpoints, dimdata));

% Place reconstruction in the original square domain
sizes = size(testslicedata);
anomaly = nan(sizes);
lengthimage = size(testslicedata,1) * size(testslicedata,2);
for k = 1 : dimdata;
    anomaly((coord(:,2) - 1)*sizes(1) + coord(:,1) + lengthimage * (k - 1)) = reconstruction(:,k);
    anomaly = abs(anomaly);
end


% Output
parameters.ML.Output.AnomalyReconstruction = anomaly;