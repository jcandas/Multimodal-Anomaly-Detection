function parameters = initKLSPVec;

% Close all figures
close all

% Initialize parameters for spherical harmonic expansion of Weiner process
parameters.KL.l = 10;
%numofpoints = 10000; 

numsteps = 10;

% Compute grid
vharm = VSphHarmonic(parameters.KL.l,-1,Parity.Complex,numsteps);
coord = [vharm.x_sph(:) vharm.y_sph(:) vharm.z_sph(:)];

parameters.KL.n = size(coord,1);
parameters.KL.coord = coord;
parameters.KL.plotrealization = true; % Plot a spherical realization
parameters.KL.numsteps = numsteps;

% Plot realizations
tol = 1e-4;
%tol = 1e-5;
numlevel = 2; %Choose maximal level
parameters.ML.plot.tol = tol;
parameters.ML.plot.numlevel = numlevel;
