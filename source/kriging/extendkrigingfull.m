function parameters = extendkrigingfull(parameters,methods)

% Load data and process missing
load(parameters.GIS.landsat.file.data.load);
dias = load(parameters.GIS.landsat.file.day);
savedata = ts;
savedata(ts==-9999) = NaN;

parameters.GIS.landsat.data.ts = savedata; 
parameters.GIS.landsat.data.days = dias.days;

[xmax,ymax,timemax,dimmax] = size(parameters.GIS.landsat.data.ts);
X = 0 : max(parameters.GIS.landsat.data.days);

% Create new output data with filled
tsfilled = ones(xmax,ymax,length(X),dimmax);
%tsfilledvar = ones(xmax,ymax,length(X),dimmax);

parameters.GIS.landsat.xmax = xmax;
parameters.GIS.landsat.ymax = ymax;
parameters.GIS.landsat.Xmax = length(X);
parameters.GIS.landsat.dimmax = dimmax;

fprintf("\n");
tic;

for dim = 1 : dimmax
    
     fprintf("Kriging dimension %d \n",dim);
     t1 = toc;
     parameters.GIS.landsat.data.datadimslice = squeeze(savedata(:,:,:,dim)); 
     parameters = methods.GIS.kriging(parameters,methods);
     tsfilled(:,:,:,dim) = parameters.kriging.filleddata;
     %tsfilledvar(:,:,:,dim) = parameters.kriging.filleddatavar;
     t2 = toc;
     fprintf("Processing Time =  %f seconds \n",t2-t1);
     fprintf("\n");
end

save


% Save the filled data
save(parameters.GIS.landsat.file.data.save,'tsfilled');
