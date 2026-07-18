T = readtable("../data/gaussian_test/data100_L0.25_Lp0.25_test200_PCA_M85.csv");

gauss = T{:,"gauss_height"}>0;
detect = T{:,"detect"};
spe = T{:,"spe"};
len = length(spe);

spe_base = spe(1:len/2);
spe_anom = spe(len/2+1:end);

disp("True Positives: "+sum(detect(gauss))+"/"+sum(gauss))
disp("True Negatives: "+(sum(~gauss)-sum(detect(~gauss)))+"/"+sum(~gauss))
disp("False Positives: "+sum(detect(~gauss))+"/"+sum(~gauss))
disp("False Negatives: "+(sum(gauss)-sum(detect(gauss)))+"/"+sum(gauss)+newline)

hold("on");
scatter(1:len/2, spe_base);
scatter(len/2+1:len, spe_anom);
yline(0.1293);