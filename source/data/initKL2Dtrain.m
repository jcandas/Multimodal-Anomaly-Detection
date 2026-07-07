function parameters = initKL2Dtrain;

% Initialize 1D KL problem

% Close all figures
close all

% Define 1D domain
numofpoints = 100;
d = 1;
coord = linspace(0,d,numofpoints)';

% Number of eigenfunctions
parameters.KL.l = 200;

% Parameters of covariance function
Lc = 0.01;
%Lp = max(d,2 * Lc);
Lp = 1/4;
L = 1/4;
%L  = Lc / Lp;

% Output parameters
parameters.KL.Lc = Lc;
parameters.KL.Lp = Lp;
parameters.KL.L = L;

parameters.KL.n = size(coord,1);
parameters.KL.coord = coord;

% Plotting parameters
numlevel = 2; %Choose maximal level
parameters.KL.plotrealization = false; % Plot a relization
parameters.ML.plot.level = numlevel;

% Dataset parameters
parameters.dataset.numexamples = 100;
parameters.dataset.gaussmin = 0.1;
parameters.dataset.gaussmax = 0.9;
parameters.dataset.gaussstd = 0.05;
parameters.dataset.outfile = '../data/gaussian_test/train_L0.25_Lp0.25_m10.mat';
parameters.dataset.gaussheights = 0;