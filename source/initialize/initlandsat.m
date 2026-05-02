% Initialize landsat anomaly detection

function parameters = initlandsat;

% Landsat data parameters
parameters.data.maxtime = 65; % Up to this sample of data for training the covariance matrix
parameters.data.removedata1 = 35; % Ignore this sample
parameters.data.removedata2 = 52; % Ignore this sample
parameters.data.num_remove = 2;

%parameters.data.testdata = 67; % Day 1304
%parameters.data.testdata = 70; % Day 1336
parameters.data.testdata = 72; % Day 1352

% Evi remove filter
parameters.data.minfilter = -3;
parameters.data.maxfilter = 5;

% Data modality (EVI)
parameters.data.modality = 8;

% Number of eigenfunctions
parameters.KL.numEigen = 55;
parameters.KL.saveeigen = true;
parameters.KL.loadeigen = false;

% Data file
parameters.data.file = 'rs_data.mat';

% Ploting parameters
parameters.ML.plot.tol = 1;
parameters.ML.plot.maxlevel = 0;
parameters.ML.plot.numlevel = 4;
parameters.graphics.figtitle = false;
parameters.graphics.print = false;

parameters.graphics.maxbarslice = 4;
parameters.graphics.maxbaranomaly = 1.25;
parameters.graphics.dilation = 1000;
parameters.graphics.markersize = 0.25;
parameters.graphics.normvalrescale = 1;
parameters.graphics.rawimagestight = 0.01;
parameters.graphics.coeffstight = 0.01;

%stats parameters
parameters.stats.significance = 0.01;
parameters.ML.dimdata = 1;
parameters.stats.nest = false;