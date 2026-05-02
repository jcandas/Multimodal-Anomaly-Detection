function [parameters] = KLWeinerSphereVec(parameters);

% Initialize Eigenspace
l = parameters.KL.l;
coord = parameters.KL.coord;
Mx = [];
My = [];
Mz = [];

numsteps = parameters.KL.numsteps;


% Compute eigenvalues
ht = @(x,n) acos(x) .* Pn(n,x);
for k = 0 : l,
     lambda(k + 1) = integral(@(x) ht(x,k),-1,1,'AbsTol',1e-6,'RelTol',1e-3);
end

maxlambda = max(abs(lambda));
tol = 1e-10;

% Create eigenfunctions
for k = 1 : l
    if (abs(lambda(k+1)) / maxlambda) > tol
        for m = -k:k
            
            vharm = VSphHarmonic(k,m,Parity.Complex,numsteps);
            Y0 = vharm.Yln_sph(1,1);
            Yx  = vharm.M.Mx_sph(:) - Y0;
            Yy  = vharm.M.My_sph(:) - Y0;
            Yz  = vharm.M.Mz_sph(:) - Y0;
                        
            Mx  = [Mx Yx];        
            My  = [My Yy];        
            Mz  = [Mz Yz];        
            
        end
    end
end

M = cat(3,Mx,My,Mz);
Mt = cat(3,Mx',My',Mz');

parameters.KL.lambda = lambda;
parameters.KL.M = real(M) + imag(M);
parameters.KL.Mt = Mt;
parameters.KL.tol = tol;

end

% Legendre
function output = Pn(n,x)
    output = double(legendreP(n,x));
end

