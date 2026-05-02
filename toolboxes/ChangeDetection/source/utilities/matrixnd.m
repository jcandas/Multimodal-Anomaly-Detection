function V = matrixnd(V,d);

% Convert list matrix format into nd array with dimension d
m = size(V,1) / d;
n = size(V,2);

V = transpose(V);
V = reshape(V, [n, m, d]);
V = permute(V,[2 1 3]);

