function parameters = krigingfull(parameters,methods);

% Use kriging to fill in all missing data

data = parameters.GIS.landsat.data.datadimslice; 
dias = parameters.GIS.landsat.data.days;

xmax = parameters.GIS.landsat.xmax;
ymax = parameters.GIS.landsat.ymax;
lengthX = parameters.GIS.landsat.Xmax;

% Observation locations
[X Y Z] = meshgrid([1:xmax],[1:ymax],[0:lengthX-1]);
X = [X(:) Y(:) Z(:)];

[indx,indy,indtime] = findND(~isnan(data));
indtime = dias(indtime);

ind = ~isnan(data);
Y = data(ind);
Y = Y(:);

S = [indx(:) indy(:) indtime(:)];

[dmodel,perf] = dacefit(S, Y, parameters.kriging.regmodel, parameters.kriging.corrmodel, ...
     parameters.kriging.theta * [1 1 1], parameters.kriging.lub * [1 1 1], parameters.kriging.upb * [1 1 1]);

 
[YX MSE] = predictor(X, dmodel);




