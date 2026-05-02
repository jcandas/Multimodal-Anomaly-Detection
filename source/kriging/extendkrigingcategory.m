function parameters = extendkrigingcategory(parameters,methods)

% Load data from folder
files = dir([parameters.GIS.landsat.file.data.path,'/*.mat']);
numfiles = size(files,1);

for n = 1 : numfiles

    load([parameters.GIS.landsat.file.data.path,'/',files(n).name]);

    savedata = ts;
    savedata(ts == -9999) = NaN;

    parameters.GIS.landsat.data.ts = savedata; 
    


    [xmax,timemax,dimmax] = size(parameters.GIS.landsat.data.ts);
    X = 0 : parameters.GIS.landsat.maxday;

    % Create new output data with filled
    tsfilled = ones(xmax,length(X),dimmax) * -9999;

    tic;
    for x = 1 : xmax
        for dim = 2 : dimmax
   
            %disp([x,dim]);
            
            %if x == 5 & dim == 9 keyboard; end;
            
            parameters.kriging.data = squeeze(parameters.GIS.landsat.data.ts(x,:,dim));
            parameters.GIS.landsat.data.days = squeeze(parameters.GIS.landsat.data.ts(x,:,1));
            parameters = methods.GIS.kriging(parameters,methods);
            tsfilled(x,:,dim) = parameters.kriging.filleddata;
            
        end
    end
    toc;

    parameters.GIS.landsat.data.tsfilled = tsfilled;

    % Save the filled data
    save([parameters.GIS.landsat.file.data.path,'/filled/filled_',files(n).name],'tsfilled');

end