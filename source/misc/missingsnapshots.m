%Construct eigenfunction by using eigenvectors
function results = missingsnapshots(reshapedata, E);

cx = reshapedata - E';
datamx = size(cx,2);

% Remove contributions of NaN
cx(isnan(cx)) = 0;
cxnz = double((cx ~=0 ));
cxnz = cxnz' * cxnz;




% Compute eigenvectors and eigenvalues of covariance matrice
k = parameters.KL.numEigen; %number of eigenvalues
M = size(cx,2);


% Run SVD to compute eigenvalues and eigenvectors
C = (cx' * cx); %Covariance Matrix
[u,s,v] = svd(C);

s = diag(s);
results.totaleigenvalues = s;
s = s(1 : k);
u = u(:,1 : k);

results.covariance = C;
results.eigenvalues = s;
results.eigenvectors = u;

% Normalize eigenfunction
xefun = results.eigenvectors' * cx' ./sqrt(s)/sqrt(M);
results.eigenfunction = xefun;

end



