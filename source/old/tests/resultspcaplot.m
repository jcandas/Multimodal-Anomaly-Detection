T = readtable("../data/gaussian_test/test_PCA.csv");

heights = unique(T{:,"gauss_height"});
%heights = heights(2:end);
accs = [];
locs = [];

for i = 1:length(heights)
    height = heights(i);

    detect = T{T.gauss_height == height,"detect"};
    if height > 0
        acc = sum(detect)/length(detect);
    else
        acc = sum(detect)/length(detect);
        %acc = sum(~detect)/length(detect);
    end

    accs = cat(1, accs, acc);
end

figure('Name', "Figure 1", 'Units', 'Pixels', 'Position', [100 100 500 375]);

dline = plot(heights, accs);
set(dline, 'Marker', 'o',...
        'LineWidth', 1.5);
title("Detection Rate vs. Gaussian Height");
xlim([0,0.2]);
xscale("log");
ylim([-0.05,1.05]);
xlabel("Gaussian Height");
ylabel("Detection Rate");


%T = T(T.gauss_height <= 0.1,:);

spe = T{:,"spe"};
len = 200;

figure('Name', "Figure 2", 'Units', 'Pixels', 'Position', [100 100 700 525]);
hold("on");
last = size(T,1)/len;
last = 2;
for i = 1:last
    scatter(1+(i-1)*len:i*len, spe(1+(i-1)*len:i*len));
end
yline(0.1293);
title("Squared Prediction Error against Threshold");
xlabel("Test Samples");
ylabel("SPE");


figure('Name', "Figure 3", 'Units', 'Pixels', 'Position', [100 100 500 375]);
hold("on");
spes = [];
heights = [];
for i = 1:size(T,1)/len
    spes = cat(2, spes, spe(1+(i-1)*len:i*len));
    heights = cat(1, heights, T{i*len, "gauss_height"});
end
boxplot(spes, heights);
yline(0.1293);
title("Squared Prediction Error against Threshold");
xlabel("Gaussian Height");
ylabel("SPE");


figure('Name', "Figure 4", 'Units', 'Pixels', 'Position', [100 100 500 375]);
hold("on");
means = [];
stds = [];
heights = [];
for i = 1:size(T,1)/len
    means = cat(1, means, mean(spe(1+(i-1)*len:i*len)));
    stds = cat(1, stds, std(spe(1+(i-1)*len:i*len)));
    heights = cat(1, heights, T{i*len, "gauss_height"});
end
eb = errorbar(heights, means, stds);
yline(0.1293);
title("Squared Prediction Error against Threshold");
xlabel("Gaussian Height");
ylabel("SPE");
xscale("log");
set(eb, 'LineStyle', 'none',...
    'Marker', 'o',...
    'LineWidth', 1.2);