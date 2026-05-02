T = readtable("../data/gaussian_test/data100_L0.25_Lp0.25_test200_M90_level6.csv");

gauss = logical(T{:,"gauss"});
for level = 0:6
    detect = T{:,"detect_"+level};
    localize = T{:,"local_"+level};

    disp("Detection results for level "+level+":")
    disp("True Positives: "+sum(detect(gauss))+"/"+sum(gauss)+" with "+sum(localize(gauss))+"/"+sum(gauss)+" localization")
    disp("True Negatives: "+(sum(~gauss)-sum(detect(~gauss)))+"/"+sum(~gauss))
    disp("False Positives: "+sum(detect(~gauss))+"/"+sum(~gauss))
    disp("False Negatives: "+(sum(gauss)-sum(detect(gauss)))+"/"+sum(gauss)+newline)
end