load('rs_data.mat');


M = 10;

maxtime = 95;
removedata1 = 35;
removedata2 = 52;

% Set missing data
ts(ts == -9999) = nan;

timedata = [1:(removedata1 -1), (removedata1 + 1) : (removedata2 - 1), (removedata2 + 1)   :   maxtime];

% Data EVI
data = squeeze(ts(:,:, timedata,8));
reshapedata = reshape(data,[size(data,1) * size(data,2) size(data,3)]);

% Compute mean
E = mean(reshapedata','omitnan');

% Compute covariance matrix
S = cov(reshapedata','partialrows');

% Remove mean
CX = reshapedata' - E;
CX = CX';

% Remove contributions of NaN
CX(isnan(CX)) = 0;
CXnz = (CX ~=0 );
CXnz = CXnz * CXnz';

% Covariance matrix
C = CX * CX' ./ CXnz;

% Eigenvalues and Eigenvectors
[V,D] = eig(C);

[lambda pos] = sort(diag(D),'descend');

eigenV = lambda(1:M);
EigenF = V(:,pos(1:M));
