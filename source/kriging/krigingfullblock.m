function parameters = krigingfullblock(parameters,methods);

% Use kriging to fill in all missing data

data = parameters.GIS.landsat.data.datadimslice; 
dias = parameters.GIS.landsat.data.days;

xmax = parameters.GIS.landsat.xmax;
ymax = parameters.GIS.landsat.ymax;
lengthX = parameters.GIS.landsat.Xmax;

[indx,indy,indtime] = findND(~isnan(data));
indtime = dias(indtime);

ind = ~isnan(data);
Y = data(ind);
Y = Y(:);

S = [indx(:) indy(:) indtime(:)];

[dmodel,perf] = dacefit(S, Y, parameters.kriging.regmodel, parameters.kriging.corrmodel, ...
     parameters.kriging.theta * [1 1 1], parameters.kriging.lub * [1 1 1], ...
     parameters.kriging.upb * [1 1 1]);

 
 
% Compute per block
%% Observation locations
% Observation locations
%[X Y Z] = meshgrid([1:xmax],[1:ymax],[0:lengthX-1]);
%X = [Y(:) X(:) Z(:)];

[X Y Z] = findND(ones(xmax,ymax,lengthX));
X = [X(:) Y(:) Z(:) - 1];



blocksize = parameters.kriging.timeblock;
numtime = ceil( size(X,1) / blocksize );
YX = [];

for i = 1 : numtime - 1
       
    %disp(i);
    %tic;
    XB = X( (i - 1) * blocksize + 1 : i * blocksize, :);   
    [YXB MSE] = predictor(XB, dmodel);
    YX = [YX; YXB];
    %toc;
    
end

if isempty(i) == true i = 0; end;

XB = X( i * blocksize + 1 : end, :);   
[YXB MSE] = predictor(XB, dmodel);
YX = [YX; YXB];


%%


parameters.kriging.filleddata = reshape(YX, [xmax ymax lengthX] );
%parameters.kriging.filleddatavar = reshape(MSE, [xmax ymax lengthX] );












