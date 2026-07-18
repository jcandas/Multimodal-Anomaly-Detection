% Initialize plotting script
function parameters = initplotting;


% Data file
parameters.data.KLfile = '../data/gaussian_test/results_L0.25_Lp0.25_m10.csv';
parameters.data.PCAfile = '../data/gaussian_test/test_PCA.csv';

% Generate a plot with detection rates
parameters.plots.detection = true;
parameters.plots.plotKL = true;
parameters.plots.plotPCA = true;

% Generate a plot with localization of KL method
parameters.plots.localization = true;

% Generate a plot with spe's from PCA method
parameters.plots.spe = true;
parameters.data.PCAthresh = '../data/gaussian_test/pca_thresh.mat';
parameters.data.bestthresh = '';
parameters.plots.bestthreshheight = 0.01;
parameters.plots.speheights = [0, 0.01, 0.1];