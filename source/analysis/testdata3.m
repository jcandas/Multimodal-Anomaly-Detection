% Second data test
% Analyze the landsat and radar data according
% to terrain type


%filename='combined_forest.mat';
filename='combined_bare.mat';
%filename='combined_herbaceous.mat';
%filename='combined_developed.mat';
%filename='combined_shrub.mat';
%filename='combined_water.mat';

data2017 = load(['../data/combined/2017/',filename]);

ts = [data2017.ts];

[n,m,p] = size(ts);

days = reshape(ts(:,:,1),[n m]);
landsatval = reshape(ts(:,:,7),[n m]);
radarval = reshape(ts(:,:,11),[n m]);

landsatval = landsatval(:);
radarval   = radarval(:);


% Extract out missing data
indsat = (landsatval ~= -9999 );
indrad = (radarval ~= -9999 );

indcombined = indsat & indrad;

% Plot qqplot 
cutoff = 10;
figure;
val = landsatval(indsat);
subplot(4,1,1);
qqplot(val);
subplot(4,1,2);
Hland = histogram(val(abs(val)<cutoff),160);
title(['landsat ',filename(10:end)])

Hlandval = Hland.Values / sum(Hland.Values);
Hlandbin = Hland.BinEdges;

subplot(4,1,3);
cutoff = 400;
val = radarval(indrad);
qqplot(val);
subplot(4,1,4);
Hrad = histogram(val(abs(val)<cutoff),160);
title(['Radar ',filename(10:end)])

Hradval = Hrad.Values / sum(Hrad.Values);
Hradbin = Hrad.BinEdges;


% Artificial 2D
[X,Y] = meshgrid(Hlandbin(1 : end - 1), Hradbin(1 : end -1));
Z = Hlandval'*Hradval;

figure;
lr = -50;
ur = 0;
ll = -2;
ul = 10;

%[XB,YB] = meshgrid([lr : ur], [ll : ul]);
%ZB = zeros(size(XB));
%mesh(XB,YB,ZB);
%hold on

mesh(X,Y,Z);
title(filename(10:end))
colorbar;
xlabel('Landsat');
ylabel('Radar');
ylim([lr ur]);
xlim([ll ul]);

% 2D histogram
%figure;
%histogram2(landsatval(indcombined), radarval(indcombined),[160 40]);
%xlim([0 4]);
%title(filename(10:end))
%xlabel('Landsat');
%ylabel('Radar');