function parameters = spatialeigenVec(methods,parameters,data)


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
  
% Covariance matrix
C = CX * CX';
toc;

if ~parameters.KL.transpose
    tic;
    [U,D,V] = svds(C,maxnumeigen);
    toc;

else
    % Can use linear algebra trick to calculate eigenvectors, values faster
    tic;
    C = CX' * CX;
    [U,D,V] = svds(C,maxnumeigen);
    V = CX * V;
    V = normc(V);
    toc;
end

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

% Check orthogonality and other errors
relativebasiserror = norm(V'*V - eye(size(V'*V)));
% eigenerror = norm(C*V(:,numeigen) - D(numeigen,numeigen)*V(:,numeigen));

TOL = 1e-8;
if isfield(parameters.ML.plot,'nodisplay') == true
    if parameters.ML.plot.nodisplay == false
        fprintf("Orthogonality Error ---------------------------- \n");
        fprintf("Relative Error = %e \n", relativebasiserror);
        fprintf("\n"); 
    end
end
% fprintf("Eigenspace Error ---------------------------- \n");
% fprintf("Relative Error = %e \n", eigenerror);
% fprintf("\n"); 
    
if relativebasiserror > TOL
    fprintf("Orthogonality Error ---------------------------- \n");
    fprintf("Relative Error = %e \n", relativebasiserror);
    fprintf("\n"); 
end
    
% Sort 
[lambda pos] = sort(diag(D),'descend');
resid_lambda = lambda(numeigen+1:end);
resid_V = V(:,pos(numeigen+1:end));

lambda = lambda(1:maxnumeigen);
V = V(:,pos(1:maxnumeigen));

% Extract Eigenspace for the number of eigenvalues requested
eigenV = lambda(1:numeigen);
EigenF = V(:,1:numeigen);

% Can plot eigenvalues
if parameters.KL.plotEigs
    ploteigs(lambda, numeigen)
end

% Include mean in Vo basis functions 
% and orthogonalize the basis
% V = [E' EigenF];
% [Q,R] = qr(V,0);
% OrthogonalBasis = Q(:,1 : size(V,2));

% M = reshape(OrthogonalBasis, [size(data.landsat.coords,1), size(data.landsat.rawtestslice,3), numeigen + 1]);
% M = permute(M,[1 3 2]);

M = reshape(EigenF, [size(data.landsat.coords,1), size(data.landsat.rawtestslice,3), numeigen]);
M = permute(M,[1 3 2]);

resid_V = reshape(resid_V, [size(data.landsat.coords,1), size(data.landsat.rawtestslice,3), maxnumeigen-numeigen]);

parameters.KL.lambda = eigenV;
parameters.KL.resid_lambda = resid_lambda;
parameters.KL.resid_M = resid_V;
parameters.KL.M = M;
parameters.KL.mean = E;

E = reshape(E, size(parameters.ML.input));

parameters.KL.totallamba = lambda;

% Remove mean from data input
parameters.ML.input = parameters.ML.input - E;





















