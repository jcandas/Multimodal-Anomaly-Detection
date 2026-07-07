function parameters = createKL2D(parameters)

% Generate realization of 1D stochastic process
lambda = parameters.KL.lambda;
M = parameters.KL.M;
l = parameters.KL.l;
x = parameters.KL.coord;
numex = parameters.dataset.numexamples;
heights = parameters.dataset.gaussheights;
min = parameters.dataset.gaussmin;
max = parameters.dataset.gaussmax;
std = parameters.dataset.gaussstd;

imgs = [];
ctes = [];
fns = [];
gauss_all = [];
gauss_heights = [];

for j = 1:length(heights)
    height = heights(j);
    for i = 1:numex
        % Realization of stochastic process with
        % truncated KL expansion
        cte1 = sqrt(3) * 2 * (rand(l,1) - 1/2);
        output1 = 1 + M * (cte1 .* lambda);
    
        cte2 = sqrt(3) * 2 * (rand(l,1) - 1/2);
        output2 = 1 + M * (cte2 .* lambda);
    
        img = output2 * output1';
        cte = [cte1, cte2];
        fn = [output1, output2];

        if height == 0
            gauss = [0, 0; 0, 0];
            gauss_height = 0;
        else
            % Define the grid parameters
            numpts = 100; % Size of the square matrix (e.g., 101x101)
            mu_x = numpts*min + (numpts*(max-min))*rand(1);      % Center x-coordinate
            mu_y = numpts*min + (numpts*(max-min))*rand(1);      % Center y-coordinate
            sigma = numpts*std;     % Standard deviation
            
            % Create the grid of x and y values
            [X, Y] = meshgrid(1:numpts); %
            
            % Calculate the 2D Gaussian function
            Z = height*exp(-0.5 * (((X - mu_x) / sigma).^2 + ((Y - mu_y) / sigma).^2));
            
            img = img + Z;
            gauss = [mu_x/numpts sigma/numpts; mu_y/numpts, sigma/numpts];
            gauss_height = height;
        end;
    
        imgs = cat(3, imgs, img);
        ctes = cat(3, ctes, cte);
        fns = cat(3, fns, fn);
        gauss_all = cat(3, gauss_all, gauss);
        gauss_heights = cat(1,gauss_heights, gauss_height);
    end;
end;

% Plot Figures
if parameters.KL.plotrealization == true;
    figure(1);
    plot(x,output1);
    ylim([0,2]);
    title('KL Realization');
end

size(imgs)
size(gauss_heights)

if any(heights)
    save(parameters.dataset.outfile, "imgs", "fns", "ctes", "gauss_heights", "gauss_all")
else
    save(parameters.dataset.outfile, "imgs", "fns", "ctes")
end