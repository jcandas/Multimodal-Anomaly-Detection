% Initialize landsat anomaly detection
function parameters = initgaussiantesteval;

% Satellite data parameters
parameters.data.maxtime = 100;

parameters.data.fulltestdata = true; 

parameters.data.num_remove = 0;

% Number of eigenfunctions
% parameters.KL.numEigen = 29;
parameters.KL.numEigen = 85;

%parameters.KL.saveeigen = false;
%parameters.KL.loadeigen = false;

% Patch size%
parameters.data.patchsizeJ = 1:100;
parameters.data.patchsizeI = 1:100;


% Data file
parameters.data.file = '../data/gaussian_test/data100_L0.25_Lp0.25_m200.mat';
%parameters.data.test_file = '../data/gaussian_test/data100_L0.25_Lp0.25_heights0.05-0.5.mat';
%parameters.data.test_file = '../data/gaussian_test/data100_L0.25_Lp0.25_heights0.01-0.05.mat';
parameters.data.test_file = '../data/gaussian_test/data100_L0.25_Lp0.25_m200_testall.mat';

 
% Ploting parameters
parameters.ML.plot.tol = 1;
parameters.ML.plot.maxlevel = 6;
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

%test parameters
parameters.test.significance = 0.05;