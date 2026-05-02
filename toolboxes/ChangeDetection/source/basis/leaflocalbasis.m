function [Scfun, Wavefun, Cwave, Dwave] = leaflocalbasis(datapoints, coords, polymodel,degree)

% Create local Hierarchical Basis with vanishing moments
% with respect to the polynomial model

coords = coords(datapoints,:);
[n,m] = size(coords);

% Create local momement matrix
Q = PolynomialMonomials(degree, coords, polymodel, datapoints);
p = size(Q,3);


% Initial basis 
% V = eye(n) / sqrt(p);
% V = repmat(V,p,1);
V = eye(n * p);

Qt = permute(Q,[2 1 3]);
Qt = reshape(Qt, [size(Qt,1) size(Qt,2) * p]);
M = conj(Qt) * V;

% obtain HB basis
[Scfun, Wavefun, Cwave, Dwave] = computewave(M,V,n);
