function parameters = evalgaussian(parameters,data)

multileveltree = parameters.ML.multilevetree;
nodeindex = parameters.ML.Output.nodeindex;
leveltree = [multileveltree{:,5}]';
coord = parameters.KL.coord;
significancedcoeffs = parameters.stats.significancedcoeffs;
testsliceColor = data.landsat.testslicecolor;

numlevel = parameters.ML.plot.numlevel;
maxlevel = parameters.ML.plot.maxlevel;

sig = parameters.stats.significance;
idx = parameters.test.index;

gauss = data.test_gauss(:,:,idx);
gauss_height = data.gauss_height(idx);

if all(gauss(:) == 0)
    is_gauss = 0;
else
    is_gauss = 1;
    coord_gauss = flip(round(gauss(:,1)'.*size(testsliceColor(:,:,1))));
    size_gauss = flip(round(gauss(:,2)'.*size(testsliceColor(:,:,1))));

    gauss_x = -floor(size_gauss(2)/sqrt(2)):floor(size_gauss(2)/sqrt(2));
    gauss_x = gauss_x + coord_gauss(2);

    gauss_y = -floor(size_gauss(1)/sqrt(2)):floor(size_gauss(1)/sqrt(2));
    gauss_y = gauss_y + coord_gauss(1);

    gauss_coords = combvec(gauss_y, gauss_x)';
end

row = cell(1,2+(maxlevel+1)*2);
row{1,1} = idx;
row{1,2} = gauss_height;

for level = maxlevel : -1 : max(maxlevel - numlevel,0)
    detect = 0;
    localize = 0;
    for n = 1 : length(leveltree)
        if leveltree(n) == level       
            listI = nodeindex(n);
            listI = listI{1};
            pval = significancedcoeffs{n};
            selectcoord = coord(listI,:);

            if pval < sig
                detect = 1;
                if is_gauss
                    if max(ismember(selectcoord, gauss_coords, 'rows')) > 0
                        localize = 1;
                    end
                end
            end
        end
    end

    row{1,2*level+3} = detect;
    row{1,2*level+4} = localize;
end

if mod(idx,10) == 1
    disp(row)
end
parameters.test.table(idx,:) = row;