function parameters = spatialpcaeval(methods,parameters,data)


% Input variables
maxnumeigen = parameters.data.maxtime;

% Load covariance data
reshapedata = data.landsat.reshapedata;
reshapedata = reshapedata(data.landsat.pos,:);

% Compute mean
E = mean(reshapedata','omitnan');


if isfield(methods,'snapshots')
    
    results = methods.snapshots(reshapedata,E);
    
else
    tic;
    % Remove mean
    CX = reshapedata' - E;
    CX = CX';

    % Covariance matrix
    tic;
    C = CX * CX';
    toc;

    parameters.KL.empty = false;

    tic;
    [U,D,V] = svd(C);
    toc;

    % Can use linear algebra trick to compute eigenvectors, values faster
    % tic;
    % C = CX' * CX;
    % [U,D,Q] = svd(C);
    % Q = CX * Q;
    % [V,R] = qr(Q,0);
    % V = normc(V);
    % toc;

end

% Check orthogonality
relativebasiserror = norm(V'*V - eye(size(V'*V)));
TOL = 1e-8;
if relativebasiserror > TOL
    fprintf("Orthogonality Error ---------------------------- \n");
    fprintf("Relative Error = %e \n", relativebasiserror);
     fprintf("\n"); 
end


[lambda, pos] = sort(diag(D),'descend');

lambda = lambda(1:maxnumeigen);
V = V(:,pos(1:maxnumeigen));

% If numeigen is <=0, find mean and std of projections
if parameters.KL.numEigen <= 0
    N = size(reshapedata,2);
    means = [];
    stds = [];
    for i = 1:size(V,2)
        V_ = repmat(V(:,i),1,N);
        proj_coeffs = sum(reshapedata.*V_,1);
        means = cat(1, means, mean(proj_coeffs));
        stds = cat(1, stds, std(proj_coeffs));
    end

    parameters.KL.projmeans = means;
    parameters.KL.projstds = stds;
end

parameters.KL.lambda = lambda;
parameters.KL.M = V;

%parameters.KL.M = OrthogonalBasis;
parameters.KL.mean = E;
parameters.KL.totallamba = lambda;