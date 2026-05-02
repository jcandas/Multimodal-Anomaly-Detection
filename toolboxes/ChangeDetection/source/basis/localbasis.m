function [Scfun, Wavefun, Cwave, Dwave] = localbasis(Vleft, left_idxs, Vright, right_idxs, idxs, coords, polymodel, degree);

% Create local Hierarchical Basis with vanishing moments
% with respect to the polynomial model. Use vectors from
% previous level on the tree

coords = coords(idxs,:);
[n,m] = size(coords);

% Create local momement matrix
Q = PolynomialMonomials(degree, coords, polymodel,idxs);
d = size(Q,3);
Qt = permute(Q,[2 1 3]);
Qt = reshape(Qt, [size(Qt,1) size(Qt,2) * d]);

% Convert matrix data into ndarray
Vleft  = matrixnd(Vleft,d);
Vright = matrixnd(Vright,d);

% Join both input scaling functions
V = blkdngNd(Vleft,Vright);

% sort V
[~, key] = sort([left_idxs  right_idxs]);
V = V(key,:,:);

% Reshape to matrix list
V = ndmatrix(V);
% V = num2cell(V,[1 2]);
% V = blkdiag(V{:});

% Form M matrix
M = conj(Qt) * V;

% obtain HB basis
[Scfun, Wavefun, Cwave, Dwave] = computewave(M,V,n);

end




























% Debug material
%k = 1: 3*3*3;
%r1 = reshape(k, [3 3 3]);
%Vleft = reshape(r1,[3 3*3]);
%Vleft = Vleft'

%k = 1: 108;
%r2 = reshape(k, [4 9 3]);
%Vright = reshape(r2,[4 27]);
%Vright = Vright'


%keyleft = 1 : nleft+nright : (nleft+nright) * (d - 1) + 1;
%keyleft = ones(nleft,1) * keyleft + [0 : nleft-1]' * ones(1,d);
%keyleft = keyleft(:);
%keyright = nleft + 1 : nleft+nright : (nleft+nright) * (d);
%keyright = ones(nright,1) * keyright + [0 : nright-1]' * ones(1,d);
%keyright = keyright(:);

%V = [[Vleft zeros(size(Vleft,1), size(Vright,2), d)];
%    [zeros(size(Vright,1), size(Vleft,2), d), Vright]
%   ];



% Initial basis 
% V = [[r1 zeros(size(r1,1), size(r2,2), d)];
%    [zeros(size(r2,1), size(r1,2), d), r2]
%   ];














