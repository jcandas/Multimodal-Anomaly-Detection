% Initialize landsat anomaly detection
function parameters = initpcatesteval;

% Satellite data parameters
parameters.data.maxtime = 100;

parameters.data.fulltestdata = true; 

% Number of eigenfunctions
parameters.KL.numEigen = 85;

% Patch size%
parameters.data.patchsizeJ = 1:100;
parameters.data.patchsizeI = 1:100;


% Data file
parameters.data.file = '../data/gaussian_test/data100_L0.25_Lp0.25_m200.mat';
%parameters.data.test_file = '../data/gaussian_test/data100_L0.25_Lp0.25_test200.mat';
%parameters.data.test_file = '../data/gaussian_test/data100_L0.25_Lp0.25_heights0.05-0.5.mat';
parameters.data.test_file = '../data/gaussian_test/data100_L0.25_Lp0.25_m200_testall.mat';

%stats parameters
parameters.stats.significance = 0.05;

%test parameters
parameters.test.significance = 0.05;