function parameters = pcathreshold(parameters)

significance = parameters.stats.significance;
lambdas = parameters.KL.lambda;
r = parameters.KL.numEigen;

Psi = zeros(3,1);
for i = 1:3
    Psi(i) = sum(lambdas(r+1:end).^i);
end

h0 = 1 - 2*Psi(1)*Psi(3)/(3*Psi(2)^2);
Q1 = norminv(1-significance)*sqrt(2*Psi(2)*h0^2)/Psi(1);
Q2 = Psi(2)*h0*(h0-1)/Psi(1)^2;
Q = Psi(1)*(Q1 + 1 + Q2)^(1/h0);

parameters.test.threshold = Q;