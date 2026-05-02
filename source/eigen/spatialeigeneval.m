function parameters = spatialeigeneval(methods,parameters,data)


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
    %tic;
    %C = CX * CX';
    %toc;

    parameters.KL.empty = false;

    %tic;
    %[U,D,V] = svd(C);
    %toc;

    tic;
    C = CX' * CX;
    [U,D,Q] = svd(C);
    Q = CX * Q;
    [V,R] = qr(Q,0);
    V = normc(V);
    toc;

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
resid_lambda = lambda(numeigen+1:end);
resid_V = V(:,pos(numeigen+1:end));
sum(resid_lambda)

lambda = lambda(1:maxnumeigen);
V = V(:,pos(1:maxnumeigen));

%end

%if parameters.KL.saveeigen == true
%    fprintf("Save Eigenstructure from file ------------------ \n");
%    fprintf("\n"); 
%    save(['Eigendata_',parameters.data.file],'lambda','V');
%end


% [lambda pos] = sort(diag(D),'descend');
eigenV = lambda(1:numeigen);
EigenF = V(:,1:numeigen);

filtered_lambda = lambda(lambda > 1e-8);
scatter(1:length(filtered_lambda), filtered_lambda);
yscale("log");

% Old
%[lambda pos] = sort(diag(D),'descend');
%eigenV = lambda(1:numeigen);
%EigenF = V(:,pos(1:numeigen));


% Include mean in Vo basis functions 
% and orthogonalize the basis
%V = [E' EigenF];
%[Q,R] = qr(V,0);
%OrthogonalBasis = Q(:,1 : size(V,2));


parameters.KL.lambda = eigenV;
parameters.KL.M = EigenF;

parameters.KL.resid_lambda = resid_lambda;
parameters.KL.resid_M = resid_V;
%parameters.KL.M = OrthogonalBasis;
parameters.KL.mean = E;
parameters.KL.totallamba = lambda;