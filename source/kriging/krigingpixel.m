function parameters = krigingpixel(parameters,methods);

% Use kriging to fill in missing time data

%X = 0 : max(parameters.GIS.landsat.data.days);

X = 0 : parameters.GIS.landsat.maxday;

sample = squeeze(parameters.kriging.data);

ind = find(isnan(sample) ~= 1);
sample = sample(ind);
dias = parameters.GIS.landsat.data.days(ind);

S = dias';
Y = sample';

[dmodel,perf] = dacefit(S(:,1), Y, parameters.kriging.regmodel, parameters.kriging.corrmodel, ...
     parameters.kriging.theta, parameters.kriging.lub, parameters.kriging.upb);

[YX MSE] = predictor(X', dmodel);

parameters.kriging.filleddata = YX;

