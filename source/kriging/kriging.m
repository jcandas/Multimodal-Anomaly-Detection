% Load data
load rs_data.mat
load days


savedata = ts;
savedata(ts<0) = NaN;
%savedata(ts>10) = NaN;



%save('Rdata.mat','savedata');


sample = squeeze(ts(12,9,:,8));
%intdata = interp1(days,sample,[1:max(days)],'linear');

ind = find(sample>0);
sample = sample(ind);
days = days(ind);

S = days';
Y = sample';
theta = 2;
lub = 1;
upb = 300;
%X = [1:max(days)]';
X = gridsamp([min(days) max(days)]',10000);

[dmodel,perf] = dacefit(S(:,1), Y, @regpoly0, @correxp, theta,lub,upb);

[YX MSE] = predictor(X, dmodel);

[YX2 MSE2] = predictor(S(:,1), dmodel);



figure;
autocorr(YX,5000)

figure;
plot(X,YX);
hold on;
plot(days,sample,'r.','MarkerSize',10);



