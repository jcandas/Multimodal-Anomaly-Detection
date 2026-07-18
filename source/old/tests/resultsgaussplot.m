T = readtable("../data/gaussian_test/results_L0.25_Lp0.25_m10.csv");

heights = unique(T{:,"gauss_height"});
%heights = heights(2:end);
for level = 0:6
    accs = [];
    locs = [];
    figure('Name', "Figure "+level, 'Units', 'Pixels', 'Position', [100 100 500 375]);

    for i = 1:length(heights)
        height = heights(i);

        detect = T{T.gauss_height == height,"detect_"+level};
        localize = T{T.gauss_height == height,"local_"+level};
        if height > 0
            acc = sum(detect)/length(detect);
            loc = sum(localize)/length(localize);
        else
            acc = sum(detect)/length(detect);
            loc = sum(localize)/length(localize);
            %acc = sum(~detect)/length(detect);
            %loc = sum(~localize)/length(localize);
        end

        accs = cat(1, accs, acc);
        locs = cat(1, locs, loc);
    end

    hold on;
    dline = plot(heights, accs, '-o');
    set(dline, 'Marker', 'o',...
        "DisplayName", "Detection",...
        'LineWidth', 1.5);
    lline = plot(heights, locs, '-o');
    set(lline, 'Marker', 'o',...
        "DisplayName", "Localization",...
        'LineWidth', 1.5);
    ptitle = title("Figure "+level, "Detection Rate at level "+level);
    xlim([0,0.2]);
    xscale("log");
    ylim([-0.05,1.05]);
    pxlabel = xlabel("Gaussian Height");
    pylabel = ylabel("Detection Rate");
    hold off;
    legend('Location', 'southeast');
end