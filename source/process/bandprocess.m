function bandestimate = bandprocess(data,band,dataApos,dataBpos);

dataAval = data(:,:,dataApos, band);
dataBval    = data(:,:,dataBpos, band);

nanmap = dataAval + dataBval;

dataAval(isnan(nanmap)) = nan;
dataBval(isnan(nanmap)) = nan;

dataAval = dataAval(~isnan(dataAval));
dataBval    = dataBval(~isnan(dataBval));


%% Display regression model

figure;
subplot(1,2,1);
maxval = max([dataAval;dataBval]);
scatter(dataAval,dataBval,'.');
xlim([0 maxval]);
ylim([0 maxval]);
xlabel('landsat');
ylabel('Sentinel');
title(['Band ',num2str(band)]); 
grid

mdl = fitlm(dataAval,dataBval,'quadratic')
%coefCI(mdl)

Xnew = [0 : maxval]';
[ypred,yci] = predict(mdl,Xnew);
hold on;
plot(Xnew,ypred,'r');
plot(Xnew,yci(:,1),'r--');
plot(Xnew,yci(:,2),'r--');

subplot(1,2,2);
histogram2(dataAval,dataBval);
xlabel('landsat');
ylabel('Sentinel');
xlim([0 maxval]);
ylim([0 maxval]);
title(['Band ',num2str(band)]); 

% Conversion
dataAval = data(:,:,dataApos, band);
Xnew = dataAval(:);
[ypred,yci] = predict(mdl,Xnew);
bandestimate = reshape(ypred,size(dataAval));




