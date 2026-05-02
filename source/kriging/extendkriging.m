function parameters = extendkriging(parameters,methods)

% Load data and process missing
load(parameters.GIS.landsat.file.data.load);
dias = load(parameters.GIS.landsat.file.day);
savedata = ts;
savedata(ts<0) = NaN;

parameters.GIS.landsat.data.ts = savedata; 
parameters.GIS.landsat.data.days = dias.days;


[xmax,ymax,timemax,dimmax] = size(parameters.GIS.landsat.data.ts);
X = 0 : max(parameters.GIS.landsat.data.days);

% Create new output data with filled
tsfilled = ones(xmax,ymax,length(X),dimmax);


for x = 1 : xmax,
    tic;
    for y = 1 : ymax,
        for dim = 1 : dimmax
   
            parameters.kriging.data = squeeze(parameters.GIS.landsat.data.ts(x,y,:,dim));
            parameters = methods.GIS.kriging(parameters,methods);
            tsfilled(x,y,:,dim) = parameters.kriging.filleddata;
            
        end
    end
    toc;
end


parameters.GIS.landsat.data.tsfilled = tsfilled;

% Save the filled data
save(parameters.GIS.landsat.file.data.save,'parameters');
