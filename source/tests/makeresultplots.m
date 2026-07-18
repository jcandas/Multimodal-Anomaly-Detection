% Plotting for KL, PCA tests

%% Methods

% Initialization
methods.initialization = @initplotting;

% Plotting
methods.plot = @plotresults;


%% Modules

% Initialize parameters
parameters = methods.initialization();

% Plot the results
parameters = methods.plot(parameters);