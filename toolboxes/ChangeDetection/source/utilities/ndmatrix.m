function V = ndmatrix(V);

% Convert nd array with dimension d to list

d = size(V,3);
V = permute(V,[2 1 3]);
V = reshape(V, [size(V,1) size(V,2) * d]);
V = transpose(V);
