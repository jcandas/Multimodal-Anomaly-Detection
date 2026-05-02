% Initialize landsat anomaly detection
function parameters = initlandsat2;

% Landsat data parameters
parameters.data.maxtime = 80;
parameters.data.testdata = 110; 


% Evi remove filter
parameters.data.minfilter = -3;
parameters.data.maxfilter =  3;

% Data modality (EVI)
parameters.data.modality = 8;

% Number of eigenfunctions
parameters.KL.numEigen = 40;
%parameters.KL.saveeigen = false;
%parameters.KL.loadeigen = false;

% Data file
parameters.data.file = 'landsat_ts_95_08.mat';

% Ploting parameters
parameters.ML.dimdata = 1;
parameters.ML.plot.tol = 0;
parameters.ML.plot.numlevel = 8;
parameters.ML.plot.maxlevel = 3;
parameters.graphics.figtitle = true;
parameters.graphics.print = true;


%stats parameters
parameters.stats.significance = 0.01;
