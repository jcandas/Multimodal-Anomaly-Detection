function [parameters,data] = LandsatProcessAllDataVec(parameters,methods);


% Extract raw data
[data,parameters] = methods.processdata(methods,parameters);
maxtime = parameters.data.maxtime;
maxdata = size(data.landsat.rawdata,3);

% Placeholder for results
[i,j,k,d] = size(data.landsat.rawdata);
collectresults = nan(i,j,k - maxtime, d);
indcollectresults = nan(k - maxtime,1);
colorslides = cell(k-maxtime,1);

for k = maxtime + 1 : maxdata
       
    fprintf("Test Slide = %d -------------------------------- \n",k);
    fprintf("\n");
     
    % Set current test frame  
    parameters.data.testdata = k;

    % Load and clean data
    % data = methods.processdata(methods,parameters);

    % Construct domain of test slice
    [parameters,data] = methods.domaindata(methods,parameters,data);

    % Build KL eigenspace 
    parameters = methods.KLeigenspace(methods,parameters,data);

    % Perform 
    if parameters.KL.empty == false 
    
        % Create Multilevel Basis
        parameters = methods.KLmultilevel(parameters,methods);

        %Transfrom input to ML
        parameters = methods.MLtransform(parameters);

        % Process statistics
        parameters = methods.statsprocess(methods,parameters,data);
    
        % Anomaly map
        parameters = methods.MLinvtransform(parameters,data);
    
        % Collect results
        collectresults(:,:,k - maxtime,:) = permute(parameters.ML.Output.AnomalyReconstruction,[1 2 4 3]);
        colorslides{k-maxtime} = data.landsat.testslicecolor;
        indcollectresults(k - maxtime) = 1;
    end
        
end

data.landsat.Output.collectresults = collectresults;
data.landsat.Output.indcollectresults = indcollectresults;
data.landsat.Output.colorslides = colorslides;





