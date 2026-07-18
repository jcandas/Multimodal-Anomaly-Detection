function parameters = initKL2Dtest;

% Initialize 1D KL problem

% Close all figures
close all

% Define 1D domain
numofpoints = 100;
d = 1;
coord = linspace(0,d,numofpoints)';

% Number of eigenfunctions
parameters.KL.l = 10;

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
parameters.dataset.gaussmin = 0.1;
parameters.dataset.gaussmax = 0.9;
parameters.dataset.gaussstd = 0.05;
parameters.dataset.outfile = '../data/gaussian_test/test_L0.25_Lp0.25_m10.mat';

orders = [1e-4, 1e-3, 1e-2];
spacing = 2;
heights = zeros(1, 9*length(orders)+2);
idx = 2;

for i = 1:length(orders)
    order = orders(i);
    if i == 1
        heights(idx) = order*spacing;
        idx = idx + 1;
    end

    for j = 2:10
        heights(idx) = j*order*spacing;
        idx = idx + 1;
    end
end

parameters.dataset.numexamples = 200;
parameters.dataset.gaussheights = heights;

% Use these parameters if you want a much smaller test set
% parameters.dataset.numexamples = 10;
% parameters.dataset.gaussheights = [0,1e-3, 1e-2, 1e-1];