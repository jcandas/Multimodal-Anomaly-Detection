function parameters = extendkrigingfulltop(parameters,methods)

% Load data and process missing
load(parameters.GIS.landsat.file.data.load);
dias = load(parameters.GIS.landsat.file.day);
savedata = ts;
savedata(ts==-9999) = NaN;
blocksize = parameters.kriging.timeblock;

[n,m,time] = size(savedata);

numtime = ceil( time / blocksize );


for i = 1 : numtime - 1
   
    parameters.GIS.landsat.data.ts  = savedata(:,:, (i-1)*blocksize + 1 : i * blocksize );
    parameters.GIS.landsat.data.days = dias.days( (i-1)*blocksize + 1 : i * blocksize );
    
    
    tsfilled = 
    
end












[xmax,ymax,timemax,dimmax] = size(parameters.GIS.landsat.data.ts);
X = 0 : max(parameters.GIS.landsat.data.days);

% Create new output data with filled
tsfilled = ones(xmax,ymax,length(X),dimmax);

parameters.GIS.landsat.xmax = xmax;
parameters.GIS.landsat.ymax = ymax;
parameters.GIS.landsat.Xmax = length(X);
parameters.GIS.landsat.dimmax = dimmax;

for dim = 1 : dimmax
     parameters.GIS.landsat.data.datadimslice = squeeze(savedata(:,:,:,dim)); 
     parameters = methods.GIS.kriging(parameters,methods);
     tsfilled(x,y,:,dim) = parameters.kriging.filleddata;
end


% Save the filled data
save(parameters.GIS.landsat.file.data.save,'tsfilled');
