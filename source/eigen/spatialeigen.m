function parameters = spatialeigen(methods,parameters,data)


% Input variables
numeigen = parameters.KL.numEigen;
maxnumeigen = parameters.data.maxtime - parameters.data.num_remove;

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

    if ~parameters.KL.transpose
        tic;
        % [V,D] = eig(C);
        [U,D,V] = svd(C);
        toc;

    else
        % Can use linear algebra trick to calculate eigenvectors, values faster
        tic;
        C = CX' * CX;
        [U,D,Q] = svd(C);
        Q = CX * Q;
        [V,R] = qr(Q,0);
        V = normc(V);
        toc;
    end

end

% Check orthogonality
relativebasiserror = norm(V'*V - eye(size(V'*V)));
TOL = 1e-8;
if isfield(parameters.ML.plot,'nodisplay') == true
    if parameters.ML.plot.nodisplay == false
        fprintf("Orthogonality Error ---------------------------- \n");
        fprintf("Relative Error = %e \n", relativebasiserror);
        fprintf("\n"); 
    end
end
if relativebasiserror > TOL
    fprintf("Orthogonality Error ---------------------------- \n");
    fprintf("Relative Error = %e \n", relativebasiserror);
     fprintf("\n"); 
end
    
     


[lambda, pos] = sort(diag(D),'descend');
resid_lambda = lambda(numeigen+1:maxnumeigen);
resid_V = V(:,pos(numeigen+1:maxnumeigen));
sum(resid_lambda)

lambda = lambda(1:maxnumeigen);
V = V(:,pos(1:maxnumeigen));


eigenV = lambda(1:numeigen);
EigenF = V(:,1:numeigen);

% Can plot eigenvalues
if parameters.KL.plotEigs
    ploteigs(lambda, numeigen)
end


parameters.KL.lambda = eigenV;
parameters.KL.M = EigenF;

parameters.KL.resid_lambda = resid_lambda;
parameters.KL.resid_M = resid_V;
parameters.KL.mean = E;
parameters.KL.totallamba = lambda;

% Remove mean from data input
parameters.ML.input = parameters.ML.input - E';