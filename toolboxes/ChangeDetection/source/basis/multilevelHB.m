function parameters = multilevelHB(parameters,methods)

% Input eigenspace
polymodel.M = parameters.KL.M;

% Number of columns in the design matrix
params.indexsetsize = size(parameters.KL.M,2);
coord = parameters.KL.coord;
degree = []; %Dummy variable, not used.

% Create Multilevel Binary tree
fprintf('\n');
fprintf('Create KDd tree ---------------------------------\n');
tic;
[datatree, sortdata] = make_tree(coord,@split_KD,params);
toc;

% Create multilevel basis
fprintf('\n');
fprintf('Create multilevel basis ------------------------\n');
tic;
[multileveltree, ind, datacell, datalevel, parent]  = multilevelbasis(datatree, sortdata, degree, polymodel);
toc;

% Clear data tree to save memory
clear datatree;

parent(1) = -1;

parameters.ML.multilevetree = multileveltree;
parameters.ML.ind = ind;
parameters.ML.datacell = datacell;
parameters.ML.datalevel = datalevel;
parameters.ML.parent = parent;


% Test transform
parameters = methods.MLtest(parameters,methods);



