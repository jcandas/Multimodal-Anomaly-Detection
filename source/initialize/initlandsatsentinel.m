% Initialize landsat anomaly detection
function parameters = initlandsatsentinel;

% Satellite data parameters
parameters.data.maxday = 3214;
%parameters.data.testdata = 121; % day 3704
parameters.data.testdata = 104; % day 3484
parameters.data.testdata = 82; % day 3344
%parameters.data.fulltestdata = true; 

parameters.data.num_remove = 0;


% Evi remove filter
parameters.data.minfilter = -3;
parameters.data.maxfilter =  3;
%parameters.data.maxfilter =  3; 


% Data modality (EVI)
parameters.data.modality = 6;

% For vectorial only
% parameters.data.modality = 7;


% Number of eigenfunctions
% parameters.KL.numEigen = 29;
parameters.KL.numEigen = 60;

%parameters.KL.saveeigen = false;
%parameters.KL.loadeigen = false;


% Type of data
%parameters.data.type = 0; % Landsat
parameters.data.type = 1; % Sentinel
%parameters.data.type = 2; % Both

% Patch size%
parameters.data.patchsize = 50:125;
%parameters.data.patchsizeJ = 1:150;
%parameters.data.patchsizeI = 1:150;
parameters.data.patchsizeJ = 50:125;
parameters.data.patchsizeI = 50:125;


% Data file
parameters.data.file = '../data/Combined/recalibratedData_Landsat_Sentinel2.mat';

 
% Ploting parameters
parameters.ML.dimdata = 1;
parameters.ML.plot.tol = 1;
parameters.ML.plot.numlevel = 8;
parameters.ML.plot.maxlevel = 3;
parameters.ML.plot.nodisplay = true;
parameters.graphics.figtitle = true;
parameters.graphics.print = true;

parameters.graphics.maxbarslice = 4;
parameters.graphics.maxbaranomaly = 1.25;
parameters.graphics.dilation = 1000;
parameters.graphics.markersize = 0.25;
parameters.graphics.normvalrescale = 1;
parameters.graphics.rawimagestight = 0.01;
parameters.graphics.coeffstight = 0.01;

%stats parameters
parameters.stats.significance = 0.05;
parameters.stats.nest = false;