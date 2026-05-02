function parameters = hypothesistestsprojnest(methods,parameters,data)

numEigen = parameters.KL.numEigen;
abscoeffs = abs(parameters.stats.currentdcoeffs);
totallambda = parameters.KL.totallamba;
currentcell = parameters.ML.currentcell;

resid_M = parameters.KL.resid_M;
resid_lambda = parameters.KL.resid_lambda;

localparameters = parameters;

total_resid = 0;

% Can use locations to make sure points are in cell
for k = 1 : length(parameters.KL.resid_lambda)
    if ismatrix(resid_M)
        localparameters.ML.input = resid_M(:,k);
    else
        localparameters.ML.input = resid_M(:,:,k);
    end
    localparameters = methods.MLtransform(localparameters);

    total_resid = total_resid + sum((localparameters.ML.Output.Dcoefficients{currentcell}).^2) * resid_lambda(k);
end

if parameters.stats.nest
    for j = 1 : length(parameters.ML.children{currentcell})
        child = parameters.ML.children{currentcell}(j);
        for k = 1 : length(parameters.KL.resid_lambda)
            localparameters.ML.input = resid_M(:,k);
            localparameters = methods.MLtransform(localparameters);
        
            total_resid = total_resid + sum((localparameters.ML.Output.Dcoefficients{child}).^2) * resid_lambda(k);
        end
    end
end

% p-values for multilevel coefficients

% Compute tail of eigenvalues. Ignore negative 
%eigentail = totallambda(totallambda > 0);
%sumeigentail = sum(eigentail(numEigen + 1: end));

% Use M + 1 eigenvalue as dominant
% sumeigentail = eigentail(numEigen + 1);
% sumeigentail = eigentail(numEigen);
significance = total_resid / sum(abscoeffs.^2);

%significance(significance > 1) = 1;
parameters.stats.currentsignificance = significance;

