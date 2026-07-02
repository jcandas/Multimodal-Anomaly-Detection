% Initialize landsat anomaly detection
function parameters = initpcatestfull;

% Satellite data parameters
parameters.data.maxtime = 100;

parameters.data.fulltestdata = true; 

% Number of eigenfunctions
parameters.KL.numEigen = 85;

% Patch size%
parameters.data.patchsizeJ = 1:100;
parameters.data.patchsizeI = 1:100;


% Data file
parameters.data.file = '../data/gaussian_test/train_L0.25_Lp0.25_m10.mat';
parameters.data.test_file = '../data/gaussian_test/test_L0.25_Lp0.25_m10.mat';
parameters.data.out_file = '../data/gaussian_test/test_PCA.csv';
parameters.data.thresh_file = '../data/gaussian_test/pca_thresh.mat';

%stats parameters
parameters.stats.significance = 0.05;