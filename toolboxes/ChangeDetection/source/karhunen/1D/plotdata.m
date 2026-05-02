load("../data/gaussian_test/data100_L0.25_Lp0.25_paper.mat");

plot_idx = 1;
img = imgs(:, :, plot_idx);
fn = fns(:,:,plot_idx);
gauss = gauss_all(:,:,plot_idx);

if all(gauss(:) == 0)
    plot_gauss = false;
else
    plot_gauss = true;
    coord_gauss = gauss(:,1)'.*size(img);
    size_gauss = gauss(:,2)'.*size(img);
end

rescaled_img = rescale(img, 0, 1);
R = rescaled_img;
G = zeros(size(img));
B = 1 - rescaled_img;

RGB = cat(3, R, G, B);

figure(1);
imshow(RGB);
if plot_gauss
    viscircles(coord_gauss, size_gauss(1), 'Color', 'g');
end

x = linspace(0, 1, length(fn(:,1)));

figure(2);
plot(x,fn(:,1));
ylim([0,2.5]);

figure(3);
plot(x,fn(:,2));
ylim([0,2.5]);
view([-90,-90]);

figure(4);
mesh(img)