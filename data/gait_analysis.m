%% Heel strike data
% load heel data
heel = readtable('heel_xypts.csv');
heel.frame = [1:length(heel.pt1_cam1_X)]';
heel.stance = zeros(size(heel.pt1_cam1_X));
heel.stance([1:12,22:32,42:52,62:71,82:91,102:111,122:131,142:151,162:171, ...
    182:192,203:212,223:233,243:252,263:272,283:292,303:312,323:332,344:348]) = 1;
heel.t = heel.frame/29.97;

% compute PCA and use Hilbert transform to obtain phase the Shai Revzen way
X = table2array(heel(:,1:12));
[coeffs,score] = pca(X);
hib = hilbert(score(:,1));
heel.phi = angle(hib); % adjust to get phase from 0 to 2 pi
heel.phi = rem(heel.phi + (2*pi-heel.phi(1)), 2*pi);

% compute joint angles for hip, knee, and foot
foot = atan2(-heel.pt1_cam1_Y + heel.pt2_cam1_Y, -heel.pt1_cam1_X + heel.pt2_cam1_X); 
% y reversed because of Ty Hedrick
% x reversed to flip from going left to going right using atan2
% positive is dorsoflexion, negative is plantarflexion
ankle = atan2(-heel.pt6_cam1_Y + heel.pt3_cam1_Y, -heel.pt6_cam1_X + heel.pt3_cam1_X);
thigh = atan2(-heel.pt3_cam1_Y + heel.pt4_cam1_Y, -heel.pt3_cam1_X + heel.pt4_cam1_X); 
heel.foot = foot-ankle-pi/2; 
heel.knee = thigh-ankle;
heel.hip = pi/2+thigh;
heel.ankle = ankle+pi/2; 

% angle of contact point to hip
heel.contact = atan2(-heel.pt2_cam1_Y + heel.pt4_cam1_Y, -heel.pt2_cam1_X + heel.pt4_cam1_X)+pi/2;
heel.pushoff = atan2(-heel.pt1_cam1_Y + heel.pt4_cam1_Y, -heel.pt1_cam1_X + heel.pt4_cam1_X)+pi/2; 

% get contact angle at heel strike
heel_deg_at_heel_strike = heel.contact([1,22,42,62,82,102,122,142,162,182,203,223,243,263,283,303,323,344])*180/pi;
heel_ankle_at_heel_strike = heel.ankle([1,22,42,62,82,102,122,142,162,182,203,223,243,263,283,303,323,344])*180/pi;
heel_deg_at_toe_up = [heel.pushoff([12,32,52,71,91,111,131,151,171,192,212,233,252,272,292,312,332])*180/pi; NaN];
heel_contact = [heel_deg_at_heel_strike heel_ankle_at_heel_strike heel_deg_at_toe_up];
heel_contact_table = array2table(heel_contact);
heel_contact_table.Properties.VariableNames={'contact.deg','shin.deg','liftoff.deg'};
writetable(heel_contact_table,'heel-contact.csv');

% make plots
close all
f1=figure('Units','inches','OuterPosition',[0 0 4 3]); 
ax1=axes(f1,'XLim',[0 100],'YLim',[-50 50],'NextPlot','add','XGrid','on','YGrid','on','YMinorGrid','on','FontSize',8); 
rectangle('Position',[0,-50,46.3,100],'FaceColor',[0 0 1 0.2],'LineStyle','none');
plot(ax1,[0 100],[0 0],'k');
plot(ax1,(heel.phi/2/pi*100),heel.foot*180/pi,'b.');
xlabel('percent stride','FontSize',8);
ylabel('foot angle, deg','FontSize',8);
text(2,50,'dorsiflexion','VerticalAlignment','top','FontSize',8);
text(2,-50,'plantar flexion','VerticalAlignment','bottom','FontSize',8);
text(23.15,55,'stance','HorizontalAlignment','center','FontSize',8);
text(73.15,55,'swing','HorizontalAlignment','center','FontSize',8);

f2=figure('Units','inches','OuterPosition',[0 0 4 3]);
ax2=axes(f2,'XLim',[0 100],'YLim',[10 110],'NextPlot','add','XGrid','on','YGrid','on','YMinorGrid','on','FontSize',8); 
rectangle('Position',[0,10,46.3,100],'FaceColor',[0 0 1 0.2],'LineStyle','none');
plot(ax2,[0 100],[0 0],'k'); 
plot(ax2,(heel.phi/2/pi*100),heel.knee*180/pi,'b.');
xlabel('percent stride','FontSize',8);
ylabel('knee angle, deg','FontSize',8);
text(2,110,'flexion','VerticalAlignment','top','FontSize',8);
text(2,10,'extension','VerticalAlignment','bottom','FontSize',8);
text(23.15,115,'stance','HorizontalAlignment','center','FontSize',8);
text(73.15,115,'swing','HorizontalAlignment','center','FontSize',8);

f3=figure('Units','inches','OuterPosition',[0 0 4 3]);
ax3=axes(f3,'XLim',[0 100],'YLim',[-50 50],'NextPlot','add','XGrid','on','YGrid','on','YMinorGrid','on','FontSize',8); 
rectangle('Position',[0,-50,46.3,100],'FaceColor',[0 0 1 0.2],'LineStyle','none');
plot(ax3,[0 100],[0 0],'k');
plot(ax3,(heel.phi/2/pi*100),heel.hip*180/pi,'b.'); 
xlabel('percent stride','FontSize',8);
ylabel('hip angle, deg','FontSize',8);
text(2,50,'flexion','VerticalAlignment','top','FontSize',8);
text(2,-50,'extension','VerticalAlignment','bottom','FontSize',8);
text(23.15,55,'stance','HorizontalAlignment','center','FontSize',8);
text(73.15,55,'swing','HorizontalAlignment','center','FontSize',8);







%% Toe strike data
% load toe data
toe = readtable('toe_xypts.csv');
toe.frame = [1:length(toe.pt1_cam1_X)]';
toe.stance = zeros(size(toe.pt1_cam1_X));
toe.stance([2:9, 21:28, 40:48, 60:68, 79:87, 98:106, 118:126, 137:145, 157:164 ...
    176:184, 196:203, 215:223, 234:242, 253:261, 272:280, 292:299, 310:317 ...
    329:337, 349:256, 368:375, 387:395, 406:414]) = 1;
toe.t = toe.frame/30.0;

% compute PCA and use Hilbert transform to obtain phase the Shai Revzen way
X = table2array(toe(:,1:12));
[coeffs,score] = pca(X);
hib = hilbert(score(:,1));
toe.phi = angle(hib); % adjust to get phase from 0 to 2 pi
toe.phi = rem(toe.phi + (2*pi-toe.phi(2)), 2*pi);

% compute joint angles for hip, knee, and foot
foot = atan2(-toe.pt1_cam1_Y + toe.pt2_cam1_Y, -toe.pt1_cam1_X + toe.pt2_cam1_X); 
% y reversed because of Ty Hedrick
% x reversed to flip from going left to going right using atan2
% positive is dorsoflexion, negative is plantarflexion
ankle = atan2(-toe.pt6_cam1_Y + toe.pt3_cam1_Y, -toe.pt6_cam1_X + toe.pt3_cam1_X);
thigh = atan2(-toe.pt3_cam1_Y + toe.pt4_cam1_Y, -toe.pt3_cam1_X + toe.pt4_cam1_X); 
toe.foot = foot-ankle-pi/2; 
toe.knee = thigh-ankle;
toe.hip = pi/2+thigh;
toe.ankle = ankle+pi/2; 

% angle of contact point to hip
toe.contact = atan2(-toe.pt1_cam1_Y + toe.pt4_cam1_Y, -toe.pt1_cam1_X + toe.pt4_cam1_X)+pi/2;
toe.pushoff = atan2(-toe.pt1_cam1_Y + toe.pt4_cam1_Y, -toe.pt1_cam1_X + toe.pt4_cam1_X)+pi/2; 

% get contact angle at heel strike
toe_deg_at_toe_strike = toe.contact([2,21,40,60,79,98,118,137,157,176,196,...
    215,235,253,272,292,310,329,349,368,387,406])*180/pi;
toe_ankle_at_toe_strike = toe.ankle([2,21,40,60,79,98,118,137,157,176,196,...
    215,235,253,272,292,310,329,349,368,387,406])*180/pi;
toe_deg_at_toe_up = toe.pushoff([9,28,48,68,87,106,126,145,164,184,203,223,...
    242,261,280,299,317,337,356,375,395,414])*180/pi;
toe_contact = [toe_deg_at_toe_strike toe_ankle_at_toe_strike toe_deg_at_toe_up];
toe_contact_table = array2table(toe_contact);
toe_contact_table.Properties.VariableNames={'contact.deg','shin.deg','liftoff.deg'};
writetable(toe_contact_table,'toe-contact.csv');

% make plots
f4=figure('Units','inches','OuterPosition',[0 0 4 3]); 
ax4=axes(f4,'XLim',[0 100],'YLim',[-50 50],'NextPlot','add','XGrid','on','YGrid','on','YMinorGrid','on','FontSize',8); 
rectangle(ax4,'Position',[0,-50,39.6,100],'FaceColor',[1 0 0 0.2],'LineStyle','none');
plot(ax4,[0 100],[0 0],'k');
plot(ax4,(toe.phi/2/pi*100),toe.foot*180/pi,'r.');
xlabel('percent stride','FontSize',8);
ylabel('foot angle, deg','FontSize',8);
text(2,50,'dorsiflexion','VerticalAlignment','top','FontSize',8);
text(2,-50,'plantar flexion','VerticalAlignment','bottom','FontSize',8);
text(19.8,55,'stance','HorizontalAlignment','center','FontSize',8);
text(69.8,55,'swing','HorizontalAlignment','center','FontSize',8);

f5=figure('Units','inches','OuterPosition',[0 0 4 3]);
ax5=axes(f5,'XLim',[0 100],'YLim',[10 110],'NextPlot','add','XGrid','on','YGrid','on','YMinorGrid','on','FontSize',8); 
rectangle(ax5,'Position',[0,10,39.6,100],'FaceColor',[1 0 0 0.2],'LineStyle','none');
plot(ax5,[0 100],[0 0],'k'); 
plot(ax5,(toe.phi/2/pi*100),toe.knee*180/pi,'r.');
xlabel('percent stride','FontSize',8);
ylabel('knee angle, deg','FontSize',8);
text(2,110,'flexion','VerticalAlignment','top','FontSize',8);
text(2,10,'extension','VerticalAlignment','bottom','FontSize',8);
text(19.8,115,'stance','HorizontalAlignment','center','FontSize',8);
text(69.8,115,'swing','HorizontalAlignment','center','FontSize',8);

f6=figure('Units','inches','OuterPosition',[0 0 4 3]);
ax6=axes(f6,'XLim',[0 100],'YLim',[-50 50],'NextPlot','add','XGrid','on','YGrid','on','YMinorGrid','on','FontSize',8); 
rectangle(ax6,'Position',[0,-50,39.6,100],'FaceColor',[1 0 0 0.2],'LineStyle','none');
plot(ax6,[0 100],[0 0],'k');
plot(ax6,(toe.phi/2/pi*100),toe.hip*180/pi,'r.'); 
xlabel('percent stride','FontSize',8);
ylabel('hip angle, deg','FontSize',8);
text(2,50,'flexion','VerticalAlignment','top','FontSize',8);
text(2,-50,'extension','VerticalAlignment','bottom','FontSize',8);
text(19.8,55,'stance','HorizontalAlignment','center','FontSize',8);
text(69.8,55,'swing','HorizontalAlignment','center','FontSize',8);

% Export pretty graphics
exportgraphics(f1,'heel-foot-angle.png','Resolution',300);
exportgraphics(f2,'heel-knee-angle.png','Resolution',300);
exportgraphics(f3,'heel-hip-angle.png','Resolution',300);
exportgraphics(f4,'toe-foot-angle.png','Resolution',300);
exportgraphics(f5,'toe-knee-angle.png','Resolution',300);
exportgraphics(f6,'toe-hip-angle.png','Resolution',300);
exportgraphics(f1,'heel-foot-angle.pdf');
exportgraphics(f2,'heel-knee-angle.pdf');
exportgraphics(f3,'heel-hip-angle.pdf');
exportgraphics(f4,'toe-foot-angle.pdf');
exportgraphics(f5,'toe-knee-angle.pdf');
exportgraphics(f6,'toe-hip-angle.pdf');


%% Finally make eye candy figure
