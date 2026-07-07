function parameters = hypothesistests(methods,parameters,data)

numEigen = parameters.KL.numEigen;
abscoeffs = abs(parameters.stats.currentdcoeffs);
totallambda = parameters.KL.totallamba;

% p-values for multilevel coefficients

% Compute tail of eigenvalues. Ignore negative 
eigentail = totallambda(totallambda > 0);
sumeigentail = sum(eigentail(numEigen + 1: end));

% Use M + 1 eigenvalue as dominant
% sumeigentail = eigentail(numEigen + 1);
% sumeigentail = eigentail(numEigen);
significance = sumeigentail ./ (abscoeffs.^2);

%significance(significance > 1) = 1;
parameters.stats.currentsignificance = significance;

