% Test of vectorial multilevel basis on
% a spherical harmonic type KL expansion 



%% Methods
methods.initialization = @initKLSPVec;
methods.KLeigenspace = @KLWeinerSphereVec;
methods.KLmultilevel = @multilevelHB;
methods.MLtest = @testtransformVec;
methods.KLRealization = @KLSPrealization;
methods.MLtransform = @mltransform;
%methods.KLMLplot = @plotKLSP;
%methods.KLMLtest = @testKLSP;

%% Initialize parameters
parameters = methods.initialization();

% Create Eigenvectors of Wiener process on a sphere
% spherical harmonics
parameters = methods.KLeigenspace(parameters);

% Create Multilevel Basis and test transform
parameters = methods.KLmultilevel(parameters,methods);

