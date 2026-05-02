function parameters = KL1Dcreategauss(parameters)


% Generate realization of 1D stochastic process
lambda = parameters.KL.lambda;
M = parameters.KL.M;
l = parameters.KL.l;
x = parameters.KL.coord;

imgs = [];
ctes = [];
fns = [];
gauss_all = [];

% Realization of stochastic process with
% truncated KL expansion
cte1 = sqrt(3) * 2 * (rand(l,1) - 1/2);
output1 = 1 + M * (cte1 .* lambda);

cte2 = sqrt(3) * 2 * (rand(l,1) - 1/2);
output2 = 1 + M * (cte2 .* lambda);

img = output2 * output1';
cte = [cte1, cte2];
fn = [output1, output2];

imgs = cat(3, imgs, img);
ctes = cat(3, ctes, cte);
fns = cat(3, fns, fn);
gauss_all = cat(3, gauss_all, [0,0;0,0]);

% Define the grid parameters
numpts = 100; % Size of the square matrix (e.g., 101x101)
mu_x = numpts/4 + (numpts/2)*rand(1);      % Center x-coordinate
mu_y = numpts/4 + (numpts/2)*rand(1);      % Center y-coordinate
sigma = numpts/20;     % Standard deviation

% Create the grid of x and y values
[X, Y] = meshgrid(1:numpts); %

% Calculate the 2D Gaussian function
% Z = A * exp(-0.5 * (((X - mu_x) / sigma).^2 + ((Y - mu_y) / sigma).^2));
% For a simple normalized Gaussian (A=1)
Z = exp(-0.5 * (((X - mu_x) / sigma).^2 + ((Y - mu_y) / sigma).^2));

if false;
    surf(X, Y, Z/2);
    shading interp;
    title('2D Gaussian Distribution');
    xlabel('X-axis');
    ylabel('Y-axis');
    zlabel('Amplitude');
end

img = img + 0.2*Z;
gauss = [mu_x/numpts sigma/numpts; mu_y/numpts, sigma/numpts];

imgs = cat(3, imgs, img);
ctes = cat(3, ctes, cte);
fns = cat(3, fns, fn);
gauss_all = cat(3, gauss_all, gauss);

save("../data/gaussian_test/data100_L0.25_Lp0.25_paper.mat", "imgs", "fns", "ctes", "gauss_all")