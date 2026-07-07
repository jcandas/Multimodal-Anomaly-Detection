function parameters = gaussiantestloop(methods, parameters,data)

if parameters.data.start_idx > 0
    start = parameters.data.start_idx;
else
    start = 1;
end

if parameters.data.end_idx > 0
    last = parameters.data.end_idx;
else
    last = size(data.test_imgs, 3);
end


for i = start:last
    % Construct domain of test slice
    [parameters,data] = methods.domaindata(methods,parameters,data,i);
    
    % Transfrom input to ML
    parameters = methods.MLtransform(parameters);
    
    % Process statistics
    parameters = methods.statsprocess(methods,parameters,data);
    
    % Evaluate Gaussian tests
    parameters = methods.eval(parameters,data);
end

writetable(parameters.test.table,parameters.data.out_file)