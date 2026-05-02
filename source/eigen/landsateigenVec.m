function parameters = landsateigenVec(methods,parameters,data)


% Input variables
dimdata = size(data.landsat.rawtestslice,3);
numeigen = parameters.KL.numEigen;
maxnumeigen = parameters.data.maxtime;

% Load covariance data
reshapedata = data.landsat.covariance;
%reshapedata = reshapedata(data.landsat.pos,:);

% Compute mean
E = mean(reshapedata','omitnan');
tic;
% Remove mean
CX = reshapedata' - E;
CX = CX';

% Remove contributions of NaN
CX(isnan(CX)) = 0;
CXnz = double((CX ~=0 ));
CXnz = CXnz * CXnz';

% Covariance matrix
C = CX * CX' ./ CXnz;
C(CXnz == 0) = 0;
toc;   

% Eigenvalues and Eigenvectors


%if parameters.KL.loadeigen == true
%   fprintf("Load Eigenstructure from file -------------------\n");
%   fprintf("\n");
%   load(['Eigendata_',parameters.data.file]);
%else    
   % Compute covariance matrix

%tic;
%S = cov(reshapedata','partialrows'); 
% S = C;
%toc;

% Return if empty or two small
if isempty(C) == true || (size(C,1) < dimdata * maxnumeigen ) ...
        || size(C,1) < (dimdata * parameters.KL.numEigen);
     parameters.KL.empty = true;
    return;
else
    parameters.KL.empty = false;
end;

tic;
[U,D,V] = svds(C,maxnumeigen);
toc;

% Check orthogonality and other errors
relativebasiserror = norm(V'*V - eye(size(V'*V)));
eigenerror = norm(C*V(:,numeigen) - D(numeigen,numeigen)*V(:,numeigen));

TOL = 1e-8;
if isfield(parameters.ML.plot,'nodisplay') == true
    if parameters.ML.plot.nodisplay == false
        fprintf("Orthogonality Error ---------------------------- \n");
        fprintf("Relative Error = %e \n", relativebasiserror);
        fprintf("\n"); 
    end
end
fprintf("Eigenspace Error ---------------------------- \n");
fprintf("Relative Error = %e \n", eigenerror);
fprintf("\n"); 
    
if relativebasiserror > TOL
    fprintf("Orthogonality Error ---------------------------- \n");
    fprintf("Relative Error = %e \n", relativebasiserror);
    fprintf("\n"); 
end
    
% Sort 
[lambda pos] = sort(diag(D),'descend');
lambda = lambda(1:maxnumeigen);
V = V(:,pos(1:maxnumeigen));

% Extract Eigenspace for the number of eigenvalues requested
eigenV = lambda(1:numeigen);
EigenF = V(:,1:numeigen);

% Include mean in Vo basis functions 
% and orthogonalize the basis
V = [E' EigenF];
[Q,R] = qr(V,0);
OrthogonalBasis = Q(:,1 : size(V,2));

M = reshape(OrthogonalBasis, [size(data.landsat.coords,1) size(data.landsat.rawtestslice,3), numeigen + 1]);
M = permute(M,[1 3 2]);

parameters.KL.lambda = eigenV;
%parameters.KL.M = EigenF;
parameters.KL.M = M;
parameters.KL.mean = E;
parameters.KL.totallamba = lambda;





















