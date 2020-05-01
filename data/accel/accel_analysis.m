load sensorlog_20200501_114226.mat
yh = Acceleration.Y;
Nh = length(yh)
% 4700; 47 s at 100 Hz
th = 1:Nh' * 1/100;

load sensorlog_20200501_114325.mat
yt = Acceleration.Y;
Nt = length(yt)
tt = 1:Nt' * 1/100;

% pick out middle 10s from each and send to R for AOV
Y = array2table([(1:(10*100))' yh(2351:3350) yt(2351:3350)]);
Y.Properties.VariableNames = {'n' 'Yheel' 'Ytoe'};
writetable(Y,'accel-data-100hz.csv');

% make plot
close all

f1 = figure('Units','inches','Position',[0 0 3 2]);
ax1 = axes(f1);
s1 = subplot(2,1,1,'XLim',[0 10],'YLim',[-10 40],'NextPlot','add');
plot(s1,Y.n*1/100, Y.Yheel,'b');
xlabel('time, s','FontSize',8);
ylabel('a_Y, m/s^2','FontSize',8);
grid on
s2 = subplot(2,1,2,'XLim',[0 10],'YLim',[-10 40],'NextPlot','add');
plot(s2,Y.n*1/100, Y.Ytoe,'b');
xlabel('time, s','FontSize',8);
h=ylabel('a_Y, m/s^2','FontSize',8);
grid on
exportgraphics(f1,'accelerations-raw.png','Resolution',300)
exportgraphics(f1,'accelerations-raw.pdf','ContentType','vector')

