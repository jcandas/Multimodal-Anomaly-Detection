% Second data test
% Analyze the landsat data according
% to terrain type


%filename='landsat_forest.mat';
%filename='landsat_bare.mat';
%filename='landsat_herbaceous.mat';
%filename='landsat_developed.mat';
%filename='landsat_shrub.mat';
filename='landsat_water.mat';


data2015 = load(['../data/LandSat/2015/',filename]);
data2016 = load(['../data/LandSat/2016/',filename]);
data2017 = load(['../data/LandSat/2017/',filename]);

ts = [data2015.ts;data2016.ts;data2017.ts];

[n,m,p] = size(ts);

days = reshape(ts(:,:,1),[n m]);
val = reshape(ts(:,:,8),[n m]);

days = days(:);
val = val(:);

% Extract out missing data
days = days(days ~= -9999);
val  = val(val ~= -9999 );

% Plot qqplot 
cutoff = 4;
figure;
subplot(2,1,1);
qqplot(val);
subplot(2,1,2);
histogram(val(abs(val)<cutoff),160);
title(filename(9:end))
hold on


% 2D histogram
figure;
indval = abs(val)<cutoff;
valcutoff = val(indval);
dayscutoff = days(indval);
histogram2(dayscutoff,valcutoff,[4 40]);
title(filename(9:end))
xlabel('Time');
ylabel('Intensity');