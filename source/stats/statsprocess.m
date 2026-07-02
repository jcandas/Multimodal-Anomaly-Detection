function parameters = statsprocess(methods,parameters,data)

% Upload variables
dcoeffs=parameters.ML.Output.Dcoefficients;
numcells = length(dcoeffs);
significancedcoeffs = cell(numcells,1);
levels = sort(unique(parameters.ML.datalevel), 'descend');

if parameters.stats.nest
    children = cell(numcells,1);
    % Aggregate dcoeffs into parents for combined anomaly coefficients
    for l = 1:length(levels)
        for n = 1 : numcells
            if parameters.ML.datalevel(n) == levels(l)
                parent = parameters.ML.parent(n)+1;
                if parent > 0
                    current_idx = find(parameters.ML.ind == n);
                    parent_idx = find(parameters.ML.ind == parent);
                    dcoeffs(parent_idx) = {[dcoeffs{parent_idx}, dcoeffs{current_idx}]};
                    children(parent_idx) = {[children{parent_idx}, current_idx, children{current_idx}]};
                end
            end
        end
    end
    parameters.ML.children = children;
end

for n = 1 : numcells
    parameters.stats.currentdcoeffs = dcoeffs{n};
    parameters.ML.currentcell = n;
    parameters = methods.hypothesistests(methods,parameters,data);
    significancedcoeffs{n} = parameters.stats.currentsignificance;   
end

parameters.stats.significancedcoeffs = significancedcoeffs;


