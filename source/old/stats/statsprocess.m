function parameters = statsprocess(methods,parameters,data)

% Upload variables
dcoeffs=parameters.ML.Output.Dcoefficients;
numcells = length(dcoeffs);
significancedcoeffs = cell(numcells,1);

for n = 1 : numcells  
    parameters.stats.currentdcoeffs = dcoeffs{n};
    parameters = methods.hypothesistests(methods,parameters,data);
    significancedcoeffs{n} = parameters.stats.currentsignificance;   
end

parameters.stats.significancedcoeffs = significancedcoeffs;


