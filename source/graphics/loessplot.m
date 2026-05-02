function loessplot(data,results,x,y);    

% Number of Points
N = 100;

% Plot LOESS and Robust LOESS onto anomaly map
dataloess = [data.dias(~isnan(results)), results(~isnan(results))];
smoothed = smooth(dataloess(:,1),dataloess(:,2),5,'lowess');
smoothedR = smooth(dataloess(:,1),dataloess(:,2),5,'rlowess');

% Spline representation
h =  abs(min(dataloess(:,1) - max(dataloess(:,1)))) / (N - 1);
xx = min(dataloess(:,1)) : h : max(dataloess(:,1));
yy = spline(dataloess(:,1),smoothedR,xx);
dyy = diff(yy)/h;
dyy(dyy>0) = max(abs(dataloess(:,2)));
dyy(dyy<=0) = 0;

hold on; 
%plot(dataloess(:,1),smoothed,'linewidth',3); 
plot(dataloess(:,1),smoothedR,'Color',[0.502, 0.502, 0],'linewidth',3); 
% plot(xx(2:end),dyy,'--','linewidth',1); 
hold off



% hold on; plot(dataloess(:,1),smoothed,'linewidth',3); 
% plot(dataloess(:,1),smoothedR,'Color',[0.502, 0.502, 0],'linewidth',3); 
% hold off
