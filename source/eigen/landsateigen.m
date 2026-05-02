function parameters = landsateigen(methods,parameters,data)


% Input variables
numeigen = parameters.KL.numEigen;
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

    % Remove contributions of NaN
    CX(isnan(CX)) = 0;
    CXnz = double((CX ~=0 ));
    CXnz = CXnz * CXnz';

    % Covariance matrix
    C = CX * CX' ./ CXnz;
    C(CXnz == 0) = 0;
    toc;   

    
    % Return if empty or two small
    if isempty(C) == true || (size(C,1) < maxnumeigen ) ...
            || size(C,1) < (3 * parameters.KL.numEigen);
        parameters.KL.empty = true;
        return;
    else
        parameters.KL.empty = false;
    end;

    tic;
    [V,D] = eigs(C,maxnumeigen);
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
    
     


[lambda pos] = sort(diag(D),'descend');
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

% Old
%[lambda pos] = sort(diag(D),'descend');
%eigenV = lambda(1:numeigen);
%EigenF = V(:,pos(1:numeigen));


% Include mean in Vo basis functions 
% and orthogonalize the basis
V = [E' EigenF];
[Q,R] = qr(V,0);
OrthogonalBasis = Q(:,1 : size(V,2));


parameters.KL.lambda = eigenV;
parameters.KL.M = EigenF;
parameters.KL.M = OrthogonalBasis;
% parameters.KL.mean = E;
parameters.KL.totallamba = lambda;

% Remove mean from data input
parameters.ML.input = parameters.ML.input - E';
%parameters.ML.input = parameters.ML.input;