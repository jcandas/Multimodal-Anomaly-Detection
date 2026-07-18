% Initialize landsat anomaly detection
function parameters = initgaussiantest;

% Satellite data parameters
parameters.data.maxtime = 100;

parameters.data.fulltestdata = true; 

parameters.data.num_remove = 0;

% Number of eigenfunctions
% parameters.KL.numEigen = 29;
parameters.KL.numEigen = 85;
parameters.KL.plotEigs = false;
parameters.KL.transpose = false;
%parameters.KL.saveeigen = false;
%parameters.KL.loadeigen = false;

% Patch size%
parameters.data.patchsizeJ = 1:100;
parameters.data.patchsizeI = 1:100;


% Data file
parameters.data.file = '../data/gaussian_test/train_L0.25_Lp0.25_m10.mat';
parameters.data.test_file = '../data/gaussian_test/test_L0.25_Lp0.25_m10.mat';
parameters.data.test_idx = 5001;

 
% Ploting parameters
parameters.ML.plot.tol = 1;
parameters.ML.plot.maxlevel = 3;
parameters.ML.plot.numlevel = 8;
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
parameters.stats.significance = 0.05;
parameters.ML.dimdata = 1;
parameters.stats.nest = false;