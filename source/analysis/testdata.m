% First data test

load('../data/LandSat/2017/landsat_forest.mat')
%load('../data/LandSat/2017/landsat_herbaceous.mat')
%load('../data/LandSat/2017/landsat_developed.mat')
%load('../data/LandSat/2017/landsat_shrub.mat')
%load('../data/LandSat/2017/landsat_water.mat')



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
figure(1);
subplot(2,1,1);
qqplot(val);
subplot(2,1,2);
hist(val(abs(val)<cutoff),40);


% 2D histogram
figure(2);
indval = abs(val)<cutoff;
valcutoff = val(indval);
dayscutoff = days(indval);
histogram2(dayscutoff,valcutoff,40);