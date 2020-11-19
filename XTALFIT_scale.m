function [] = XTALFIT_scale(datax,datay,dataz)
%Specalized Multiple spectral fitting GUI - by P. Stallworth 10/16.  
%Input for n data sets, the multidata m X 2n matrix 
%(data(1,n)= angle, data(i:n)= freq array, data(i:n+1)= intensity) to be fit (SPECTset).  
%Edit 'fitfunc' (at the end) with the appropriate fitting function.
%datax, datay, dataz = x-axis, y-axis and z-axis data sets

global Minit Range dimtem
global theta ymin ymax realdatax realdatay realdataz %Orienitx Orienity Orienitz Orienitxang Orienityang Orienitzang

%Edit initial slider, max and min values = [height width Txx Tyy Tzz Txy Txz Tyz Offset];
Minit=[1 0 0;0 1 0;0 0 1]; %predefine lab-frame tensor
initvalues = [25 100 0 0 0 0 0 0 0];
maxvalues = [100 500 5000 5000 5000 2000 2000 2000 180];
minvalues = [5 10 -3000 -3000 -3000 -2000 -2000 -2000 -180];
res = 100; %resolution of reduced data set
fitres = 100; %resolution of fittings must be greater than 1
minRange=-3000;
maxRange=3000;
del=(maxRange-minRange)/(fitres-1);
Range = (minRange:del:maxRange)'; %defines the range and ppm resolution of the fit
theta=datax(1,:);
dimtem=[res 50]; %dimtemp(1) = res rows, dimtemp(2) = 50 cols
ymin = -1;
ymax = theta(length(theta))+16;
datheight = 15; %data spectral intensity adjust
n=9; %to pick-out baseline points for renormalization

%Normalize the data and add DC
tempdatax = zeros(res,50); %preallocate truncated data sets
tempdatay = zeros(res,50); %preallocate truncated data sets
tempdataz = zeros(res,50); %preallocate truncated data sets
for i = 1:25 %renormalizes intensity data to fit between 0 and 360 
    tempdatax(:,2*i-1:2*i) = SECTRES(datax(2:end,2*i-1:2*i),minRange,maxRange,res); 
    basdat = sum(tempdatax(res-n:res,2*i))/10;
    tempdatax(:,2*i) = tempdatax(:,2*i) - basdat;
    maxdat = max(tempdatax(:,2*i));
    if maxdat > 0 %conditional for cases where maxdat = 0
        tempdatax(:,2*i) = datheight*tempdatax(:,2*i)/maxdat + theta(2*i); %normalize and add DC
    else
        tempdatax(:,2*i) = datheight*tempdatax(:,2*i) + theta(2*i); %just add DC
    end
end
for i = 1:25
    tempdatay(:,2*i-1:2*i) = SECTRES(datay(2:end,2*i-1:2*i),minRange,maxRange,res);
    basdat = sum(tempdatay(res-n:res,2*i))/10;
    tempdatay(:,2*i) = tempdatay(:,2*i) - basdat;
    maxdat = max(tempdatay(:,2*i));
    if maxdat > 0 %conditional for cases where maxdat = 0
        tempdatay(:,2*i) = datheight*tempdatay(:,2*i)/maxdat + theta(2*i); %normalize and add DC
    else
        tempdatay(:,2*i) = datheight*tempdatay(:,2*i) + theta(2*i); %just add DC
    end

end
for i = 1:25
    tempdataz(:,2*i-1:2*i) = SECTRES(dataz(2:end,2*i-1:2*i),minRange,maxRange,res);
    basdat = sum(tempdataz(res-n:res,2*i))/10;
    tempdataz(:,2*i) = tempdataz(:,2*i) - basdat;
    maxdat = max(tempdataz(:,2*i));
    if maxdat > 0 %conditional for cases where maxdat = 0
        tempdataz(:,2*i) = datheight*tempdataz(:,2*i)/maxdat + theta(2*i); %normalize and add DC
    else
        tempdataz(:,2*i) = datheight*tempdataz(:,2*i) + theta(2*i); %just add DC
    end
end

realdatax=tempdatax;
realdatay=tempdatay;
realdataz=tempdataz;

%initiate the figure
%Add the components and save the handles to a structure
scrsz = get(0,'ScreenSize'); %initiate figure 
xui.fh = figure('Units','pixels','Position',[0.05*scrsz(3) 0.05*scrsz(4) 0.85*scrsz(3) 0.85*scrsz(4)],...
    'Name','XTALFIT_scale',...  %'menubar','none',...
    'Numbertitle','off','ToolBar','none','Tag','fig');
    %'ResizeFcn',@resizeuis);

fhsize = get(xui.fh,'Position');
fhheight = fhsize(4);
fhwidth = fhsize(3);
fhleft = fhsize(1);
fhbottom = fhsize(2);

%%%Adding the axes to the parent figure

%First subplot, rotation about crystal x-axis

subplot('position',[(fhleft+25)/fhwidth (fhbottom+50)/fhheight (fhwidth*0.2)/fhwidth fhheight*0.70/fhheight])
plot(realdatax(:,1),realdatax(:,2),'.k')
set(gca,'YTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360])
axis([min(Range),max(Range),ymin,ymax])
hold on %note that "hold on" and "hold off" do not produce messages in the command window

for i=2:dimtem(2)/2
    j=2*i-1;
    plot(realdatax(:,j),realdatax(:,j+1),'.k')
end

hold off
xlabel('ppm') 
ylabel('rotation angle (THETA)')
title('Rotation about Xtal X-Axis')

%Second subplot, rotation about crystal y-axis

subplot('position',[(fhleft+25+fhwidth*0.2+65)/fhwidth (fhbottom+50)/fhheight fhwidth*0.2/fhwidth fhheight*0.70/fhheight])
plot(realdatay(:,1),realdatay(:,2),'.k')
set(gca,'YTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360])
axis([min(Range),max(Range),ymin,ymax])
hold on 

for i=2:dimtem(2)/2
    j=2*i-1;
    plot(realdatay(:,j),realdatay(:,j+1),'.k')
end

hold off
xlabel('ppm') 
ylabel('rotation angle (THETA)')
title('Rotation about Xtal Y-Axis')

%Third subplot, rotation about crystal z-axis

subplot('position',[(fhleft+25+2*fhwidth*0.2+130)/fhwidth (fhbottom+50)/fhheight fhwidth*0.2/fhwidth fhheight*0.70/fhheight])
plot(realdataz(:,1),realdataz(:,2),'.k')
set(gca,'YTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360])
axis([min(Range),max(Range),ymin,ymax])
hold on 

for i=2:dimtem(2)/2
    j=2*i-1;
    plot(realdataz(:,j),realdataz(:,j+1),'.k')
end

hold off
xlabel('ppm') 
ylabel('rotation angle (THETA)')
title('Rotation about Xtal Z-Axis')

%For example, xui looks like this:
%xui = 
%
%     sl: [209.0018 2.0020 5.0020 8.0020 11.0020 14.0020 17.0020]
%    txt: [0.0020 3.0020 6.0020 9.0020 12.0020 15.0020 210.0018]
%     ed: [1.0020 4.0020 7.0020 10.0020 13.0020 16.0020 211.0018]

%%%Now adding the sliders to parent figure

    %%%Sliders 1 and 2, for height and width of fit, respectively

    %slider1 = height

    xui.txt(1) = uicontrol('Style','text','String','fit height','Units','normalized','Position',[(fhleft+25+fhwidth*0.2+65)/fhwidth (fhbottom-15)/fhheight 0.04 0.02]);
    xui.ed(1) = uicontrol('Style','edit',...
        'String',num2str(initvalues(1)),'Units','normalized','Position',[(fhleft+25+fhwidth*0.2+65+fhwidth*0.04)/fhwidth (fhbottom-15)/fhheight 0.04 0.02]);
    xui.sl(1)=uicontrol('Style','slider',...
    'units','normalized','Position',[(fhleft+25+fhwidth*0.2+65+fhwidth*0.04+fhwidth*0.04)/fhwidth (fhbottom-15)/fhheight 0.1 0.02],...
    'Sliderstep',[0.015 1],...
    'Value',initvalues(1),...%value has to be within min/max range
    'Min',minvalues(1),'Max',maxvalues(1)); 

    %slider2 = width
    xui.txt(2) = uicontrol('style','text','string','fit width','units','normalized','position',[(fhleft+25+2*fhwidth*0.2+130)/fhwidth (fhbottom-15)/fhheight 0.04 0.02]);
    xui.ed(2) = uicontrol('style','edit',...
        'string',num2str(initvalues(2)),'units','normalized','position',[(fhleft+25+2*fhwidth*0.2+130+fhwidth*0.04)/fhwidth (fhbottom-15)/fhheight 0.04 0.02]);
    xui.sl(2)=uicontrol('style','slider',...
    'units','normalized','position',[(fhleft+25+2*fhwidth*0.2+130+fhwidth*0.08)/fhwidth (fhbottom-15)/fhheight 0.1 0.02],...
    'sliderstep',[0.01 1],...
    'value',initvalues(2),...%value has to be within min/max range
    'min',minvalues(2),'max',maxvalues(2)); 


%%% Sliders 3 through 11, for rotation matrix elements

% First obtain position vector for all the xui.ax elements and use this data to
% build the sliders, pushbuttons, and text boxes

%     xui1pos = get(ax1,'Position');
ax1h = fhheight*0.70;
ax1w = fhwidth*0.2;
ax1l = fhleft+25;
ax1b = fhbottom+50;

%     xui2pos = get(ax2,'Position');
ax2h = fhheight*0.70;
ax2w = fhwidth*0.2;
ax2l = fhleft+25+fhwidth*0.2+65;
ax2b = fhbottom+50;

%     xui3pos = get(ax3,'Position');
ax3h = fhheight*0.70;
ax3w = fhwidth*0.2;
ax3l = fhleft+25+2*fhwidth*0.2+130;
ax3b = fhbottom+50;

%slider3 = Txx
xui.txt(3) = uicontrol('Style','text','String','Txx','units','normalized','Position',[(ax3l+ax3w+55)/fhwidth (ax3b+ax3h)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %,'fontsize',10);
xui.ed(3) = uicontrol('Style','edit','string',num2str(0),'units','normalized','position',[(ax3l+ax3w+55)/fhwidth (ax3b+ax3h-ax3h*0.05)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %,'fontsize',10);
xui.sl(3) = uicontrol('style','slider','units','normalized','position',[(ax3l+ax3w+55)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05)/fhheight ax3w*0.15/fhwidth ax3h*0.25/fhheight],'sliderstep',[0.005 0.1],...
'value',initvalues(3),...%value has to be within min/max range
'min',minvalues(3),'max',maxvalues(3));

%slider4 = Tyy
xui.txt(4) = uicontrol('style','text','string','Tyy','units','normalized','position',[(ax3l+ax3w+80+ax3w*0.15)/fhwidth (ax3b+ax3h)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %,'fontsize',10);
xui.ed(4) = uicontrol('style','edit','string',num2str(0),'units','normalized','position',[(ax3l+ax3w+80+ax3w*0.15)/fhwidth (ax3b+ax3h-ax3h*0.05)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %,'fontsize',10);
xui.sl(4) = uicontrol('style','slider','units','normalized','position',[(ax3l+ax3w+80+ax3w*0.15)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05)/fhheight ax3w*0.15/fhwidth ax3h*0.25/fhheight],'sliderstep',[0.005 0.1],...
'value',initvalues(4),...%value has to be within min/max range
'min',minvalues(4),'max',maxvalues(4));

%slider5 = Tzz
xui.txt(5) = uicontrol('style','text','string','Tzz','units','normalized','position',[(ax3l+ax3w+105+2*ax3w*0.15)/fhwidth (ax3b+ax3h)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %,'fontsize',10);
xui.ed(5) = uicontrol('style','edit','string',num2str(0),'units','normalized','position',[(ax3l+ax3w+105+2*ax3w*0.15)/fhwidth (ax3b+ax3h-ax3h*0.05)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %,'fontsize',10);
xui.sl(5) = uicontrol('style','slider','units','normalized','position',[(ax3l+ax3w+105+2*ax3w*0.15)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05)/fhheight ax3w*0.15/fhwidth ax3h*0.25/fhheight],'sliderstep',[0.005 0.1],...
'value',initvalues(5),...%value has to be within min/max range
'min',minvalues(5),'max',maxvalues(5));

%slider6 = Txy
xui.txt(6) = uicontrol('style','text','string','Txy','units','normalized','position',[(ax3l+ax3w+105+2*ax3w*0.15)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %,'fontsize',10);
xui.ed(6) = uicontrol('style','edit','string',num2str(0),'units','normalized','position',[(ax3l+ax3w+105+2*ax3w*0.15)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45-ax3h*0.05)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %,'fontsize',10);
xui.sl(6) = uicontrol('style','slider','units','normalized','position',[(ax3l+ax3w+105+2*ax3w*0.15)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45-ax3h*0.05-ax3h*0.25)/fhheight ax3w*0.15/fhwidth ax3h*0.25/fhheight],'sliderstep',[0.005 0.1],...
'value',initvalues(6),...%value has to be within min/max range
'min',minvalues(6),'max',maxvalues(6));

%slider7 = Txz
xui.txt(7) = uicontrol('style','text','string','Txz','units','normalized','position',[(ax3l+ax3w+80+ax3w*0.15)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %,'fontsize',10);
xui.ed(7) = uicontrol('style','edit','string',num2str(0),'units','normalized','position',[(ax3l+ax3w+80+ax3w*0.15)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45-ax3h*0.05)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %,'fontsize',10);
xui.sl(7) = uicontrol('style','slider','units','normalized','position',[(ax3l+ax3w+80+ax3w*0.15)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45-ax3h*0.05-ax3h*0.25)/fhheight ax3w*0.15/fhwidth ax3h*0.25/fhheight],'sliderstep',[0.005 0.1],...
'value',initvalues(7),...%value has to be within min/max range
'min',minvalues(7),'max',maxvalues(7));

%slider8 = Tyz
xui.txt(8) = uicontrol('style','text','string','Tyz','units','normalized','position',[(ax3l+ax3w+55)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %,'fontsize',10);
xui.ed(8) = uicontrol('style','edit','string',num2str(0),'units','normalized','position',[(ax3l+ax3w+55)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45-ax3h*0.05)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %,'fontsize',10);
xui.sl(8) = uicontrol('style','slider','units','normalized','position',[(ax3l+ax3w+55)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45-ax3h*0.05-ax3h*0.25)/fhheight ax3w*0.15/fhwidth ax3h*0.25/fhheight],'sliderstep',[0.005 0.1],...
'value',initvalues(8),...%value has to be within min/max range
'min',minvalues(8),'max',maxvalues(8));

%slider9 = xoffset
xui.txt(9) = uicontrol('style','text','string','x-offst','units','normalized','position',[(ax3l+ax3w+55)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45-ax3h*0.25-45-ax3h*0.05)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %,'fontsize',10);
xui.ed(9) = uicontrol('style','edit','string',num2str(0),'units','normalized','position',[(ax3l+ax3w+55)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45-ax3h*0.25-45-2*ax3h*0.05)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %,'fontsize',10);
xui.sl(9) = uicontrol('style','slider','units','normalized','position',[(ax3l+ax3w+55)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45-ax3h*0.25-45-2*ax3h*0.05-ax3h*0.25)/fhheight ax3w*0.15/fhwidth ax3h*0.25/fhheight],'sliderstep',[0.005 0.1],...
'value',initvalues(9),...%value has to be within min/max range
'min',minvalues(9),'max',maxvalues(9));

%slider10 = yoffset
xui.txt(10) = uicontrol('style','text','string','y-offst','units','normalized','position',[(ax3l+ax3w+80+ax3w*0.15)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45-ax3h*0.25-45-ax3h*0.05)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %,'fontsize',10);
xui.ed(10) = uicontrol('style','edit','string',num2str(0),'units','normalized','position',[(ax3l+ax3w+80+ax3w*0.15)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45-ax3h*0.25-45-2*ax3h*0.05)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %,'fontsize',10);
xui.sl(10) = uicontrol('style','slider','units','normalized','position',[(ax3l+ax3w+80+ax3w*0.15)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45-ax3h*0.25-45-2*ax3h*0.05-ax3h*0.25)/fhheight ax3w*0.15/fhwidth ax3h*0.25/fhheight],'sliderstep',[0.005 0.1],...
'value',initvalues(9),...%value has to be within min/max range
'min',minvalues(9),'max',maxvalues(9));

%slider11 = zoffset
xui.txt(11) = uicontrol('style','text','string','z-offst','units','normalized','position',[(ax3l+ax3w+105+2*ax3w*0.15)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45-ax3h*0.25-45-ax3h*0.05)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %'fontsize',10);
xui.ed(11) = uicontrol('style','edit','string',num2str(0),'units','normalized','position',[(ax3l+ax3w+105+2*ax3w*0.15)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45-ax3h*0.25-45-2*ax3h*0.05)/fhheight ax3w*0.15/fhwidth ax3h*0.05/fhheight]); %,'fontsize',10);
xui.sl(11) = uicontrol('style','slider','units','normalized','position',[(ax3l+ax3w+105+2*ax3w*0.15)/fhwidth (ax3b+ax3h-ax3h*0.25-ax3h*0.05-45-ax3h*0.25-45-2*ax3h*0.05-ax3h*0.25)/fhheight ax3w*0.15/fhwidth ax3h*0.25/fhheight],'sliderstep',[0.005 0.1],...
'value',initvalues(9),...%value has to be within min/max range
'min',minvalues(9),'max',maxvalues(9));


%%% Euler angle information boxes for each orientation

%x-angles
xui.txta(1) = uicontrol('style','text','string','alpha','units','normalized','position',[(ax1l+ax1w-0.7*ax1w)/fhwidth (ax1h+ax1b+90)/fhheight 0.25*ax1w/fhwidth 25/fhheight],'fontsize',10);
xui.txtb(1) = uicontrol('style','text','string',num2str(0),'units','normalized','position',[(ax1l+ax1w-0.5*ax1w)/fhwidth (ax1h+ax1b+90)/fhheight 0.25*ax1w/fhwidth 25/fhheight]); %,'fontsize',10);

xui.txta(2) = uicontrol('style','text','string','beta','units','normalized','position',[(ax1l+ax1w-0.7*ax1w)/fhwidth (ax1h+ax1b+65)/fhheight 0.25*ax1w/fhwidth 25/fhheight],'fontsize',10);
xui.txtb(2) = uicontrol('style','text','string',num2str(0),'units','normalized','position',[(ax1l+ax1w-0.5*ax1w)/fhwidth (ax1h+ax1b+65)/fhheight 0.25*ax1w/fhwidth 25/fhheight]); %,'fontsize',10);

xui.txta(3) = uicontrol('style','text','string','gamma','units','normalized','position',[(ax1l+ax1w-0.7*ax1w)/fhwidth (ax1h+ax1b+40)/fhheight 0.25*ax1w/fhwidth 25/fhheight],'fontsize',10);
xui.txtb(3) = uicontrol('style','text','string',num2str(0),'units','normalized','position',[(ax1l+ax1w-0.5*ax1w)/fhwidth (ax1h+ax1b+40)/fhheight 0.25*ax1w/fhwidth 25/fhheight]); %,'fontsize',10);

%y-angles
xui.txta(4) = uicontrol('style','text','string','alpha','units','normalized','position',[(ax2l+ax2w-0.7*ax2w)/fhwidth (ax2h+ax2b+90)/fhheight 0.25*ax2w/fhwidth 25/fhheight],'fontsize',10);
xui.txtb(4) = uicontrol('style','text','string',num2str(0),'units','normalized','position',[(ax2l+ax2w-0.5*ax2w)/fhwidth (ax2h+ax2b+90)/fhheight 0.25*ax2w/fhwidth 25/fhheight]); %,'fontsize',10);

xui.txta(5) = uicontrol('style','text','string','beta','units','normalized','position',[(ax2l+ax2w-0.7*ax2w)/fhwidth (ax1h+ax1b+65)/fhheight 0.25*ax2w/fhwidth 25/fhheight],'fontsize',10);
xui.txtb(5) = uicontrol('style','text','string',num2str(0),'units','normalized','position',[(ax2l+ax2w-0.5*ax2w)/fhwidth (ax1h+ax1b+65)/fhheight 0.25*ax2w/fhwidth 25/fhheight]); %,'fontsize',10);

xui.txta(6) = uicontrol('style','text','string','gamma','units','normalized','position',[(ax2l+ax2w-0.7*ax2w)/fhwidth (ax1h+ax1b+40)/fhheight 0.25*ax1w/fhwidth 25/fhheight],'fontsize',10);
xui.txtb(6) = uicontrol('style','text','string',num2str(0),'units','normalized','position',[(ax2l+ax2w-0.5*ax2w)/fhwidth (ax1h+ax1b+40)/fhheight 0.25*ax1w/fhwidth 25/fhheight]); %,'fontsize',10);

% z-angles
xui.txta(7) = uicontrol('style','text','string','alpha','units','normalized','position',[(ax3l+ax3w-0.7*ax3w)/fhwidth (ax3h+ax3b+90)/fhheight 0.25*ax3w/fhwidth 25/fhheight],'fontsize',10);
xui.txtb(7) = uicontrol('style','text','string',num2str(0),'units','normalized','position',[(ax3l+ax3w-0.5*ax3w)/fhwidth (ax3h+ax3b+90)/fhheight 0.25*ax3w/fhwidth 25/fhheight]); %,'fontsize',10);

xui.txta(8) = uicontrol('style','text','string','beta','units','normalized','position',[(ax3l+ax3w-0.7*ax3w)/fhwidth (ax3h+ax3b+65)/fhheight 0.25*ax3w/fhwidth 25/fhheight],'fontsize',10);
xui.txtb(8) = uicontrol('style','text','string',num2str(0),'units','normalized','position',[(ax3l+ax3w-0.5*ax3w)/fhwidth (ax3h+ax3b+65)/fhheight 0.25*ax3w/fhwidth 25/fhheight]); %,'fontsize',10);

xui.txta(9) = uicontrol('style','text','string','gamma','units','normalized','position',[(ax3l+ax3w-0.7*ax3w)/fhwidth (ax3h+ax3b+40)/fhheight 0.25*ax3w/fhwidth 25/fhheight],'fontsize',10);
xui.txtb(9) = uicontrol('style','text','string',num2str(0),'units','normalized','position',[(ax3l+ax3w-0.5*ax3w)/fhwidth (ax3h+ax3b+40)/fhheight 0.25*ax3w/fhwidth 25/fhheight]); %,'fontsize',10);

%x-tal orientation information
xui.txta(10) = uicontrol('style','text','string','X-tal','units','normalized','position',[(ax1l+ax1w-0.35*ax1w)/fhwidth (ax1h+ax1b+90)/fhheight 0.15*ax1w/fhwidth 25/fhheight],'fontsize',10);
xui.txta(11) = uicontrol('style','text','string','    ','units','normalized','position',[(ax1l+ax1w-0.35*ax1w+0.15*ax1w+5)/fhwidth (ax1h+ax1b+90)/fhheight 0.08*ax1w/fhwidth 25/fhheight],'BackgroundColor',[1 0.5 1],'fontsize',10);
xui.txta(12) = uicontrol('style','text','string','axis','units','normalized','position',[(ax1l+ax1w+0.08*ax1w+0.15*ax1w+10-0.35*ax1w)/fhwidth (ax1h+ax1b+90)/fhheight 0.12*ax1w/fhwidth 25/fhheight],'fontsize',10);
xui.txta(13) = uicontrol('style','text','string','|| B0 @ 0deg','units','normalized','position',[(ax1l+ax1w-0.35*ax1w+15)/fhwidth (ax1h+ax1b+65)/fhheight 0.35*ax1w/fhwidth 25/fhheight],'fontsize',10);
 
xui.txta(14) = uicontrol('style','text','string','X-tal','units','normalized','position',[(ax2l+ax2w-0.35*ax2w)/fhwidth (ax2h+ax2b+90)/fhheight 0.15*ax2w/fhwidth 25/fhheight],'fontsize',10);
xui.txta(15) = uicontrol('style','text','string','    ','units','normalized','position',[(ax2l+ax2w-0.35*ax2w+0.15*ax2w+5)/fhwidth (ax2h+ax2b+90)/fhheight 0.08*ax2w/fhwidth 25/fhheight],'BackgroundColor',[1 0.5 1],'fontsize',10);
xui.txta(16) = uicontrol('style','text','string','axis','units','normalized','position',[(ax2l+ax2w-0.35*ax2w+0.15*ax2w+5+0.08*ax2w+10)/fhwidth (ax2h+ax2b+90)/fhheight 0.12*ax2w/fhwidth 25/fhheight],'fontsize',10);
xui.txta(17) = uicontrol('style','text','string','|| B0 @ 0deg','units','normalized','position',[(ax2l+ax2w-0.35*ax2w+15)/fhwidth (ax2h+ax2b+65)/fhheight 0.35*ax2w/fhwidth 25/fhheight],'fontsize',10);

xui.txta(18) = uicontrol('style','text','string','X-tal','units','normalized','position',[(ax3l+ax3w-0.35*ax3w)/fhwidth (ax3h+ax3b+90)/fhheight 0.15*ax3w/fhwidth 25/fhheight],'fontsize',10);
xui.txta(19) = uicontrol('style','text','string','    ','units','normalized','position',[(ax3l+ax3w-0.35*ax3w+0.15*ax3w+5)/fhwidth (ax3h+ax3b+90)/fhheight 0.08*ax3w/fhwidth 25/fhheight],'BackgroundColor',[1 0.5 1],'fontsize',10);
xui.txta(20) = uicontrol('style','text','string','axis','units','normalized','position',[(ax3l+ax3w-0.35*ax3w+0.15*ax3w+5+0.08*ax3w+10)/fhwidth (ax3h+ax3b+90)/fhheight 0.12*ax3w/fhwidth 25/fhheight],'fontsize',10);
xui.txta(21) = uicontrol('style','text','string','|| B0 @ 0deg','units','normalized','position',[(ax3l+ax3w-0.35*ax3w+15)/fhwidth (ax3h+ax3b+65)/fhheight 0.35*ax3w/fhwidth 25/fhheight],'fontsize',10);


%%% Push buttons for importing and exporting fits

xui.pb(1) = uicontrol('Style','push',... 
                 'Units','pixels',...
                 'units','normalized','position',[ax1l/fhwidth (ax1b+ax1h+40+75/2)/fhheight ax1w*0.3/fhwidth 35/fhheight],...
                 'string', 'X Fit In',...
                 'fontsize',8,'BackgroundColor',[1 0.5 0],'callback',{@pb_load_xdata,xui}); %

xui.pb(2) = uicontrol('style','push',... 
                 'units','pix',...
                 'units','normalized','posit',[ax1l/fhwidth (ax1b+ax1h+40)/fhheight ax1w*0.3/fhwidth 35/fhheight],...
                 'string', 'X Fit Out',...
                 'fontsize',8,'BackgroundColor',[0 0.5 0],'callback',{@pb_dump_xdata,xui}); %

xui.pb(3) = uicontrol('style','push',... 
                 'units','pix',...
                 'units','normalized','posit',[ax2l/fhwidth (ax2b+ax2h+40+75/2)/fhheight ax2w*0.3/fhwidth 35/fhheight],...
                 'string', 'Y Fit In',...
                 'fontsize',8,'BackgroundColor',[1 0.5 0],'callback',{@pb_load_ydata,xui}); %

xui.pb(4) = uicontrol('style','push',... 
                 'units','pix',...
                 'units','normalized','posit',[ax2l/fhwidth (ax2b+ax2h+40)/fhheight ax2w*0.3/fhwidth 35/fhheight],...
                 'string', 'Y Fit Out',...
                 'fontsize',8,'BackgroundColor',[0 0.5 0],'callback',{@pb_dump_ydata,xui}); %

xui.pb(5) = uicontrol('style','push',... 
                 'units','pix',...
                 'units','normalized','posit',[ax3l/fhwidth (ax3b+ax3h+40+75/2)/fhheight ax3w*0.3/fhwidth 35/fhheight],...
                 'string', 'Z Fit In',...
                 'fontsize',8,'BackgroundColor',[1 0.5 0],'callback',{@pb_load_zdata,xui}); %

xui.pb(6) = uicontrol('style','push',... 
                 'units','pix',...
                 'units','normalized','posit',[ax3l/fhwidth (ax3b+ax3h+40)/fhheight ax3w*0.3/fhwidth 35/fhheight],...
                 'string', 'Z Fit Out',...
                 'fontsize',8,'BackgroundColor',[0 0.5 0],'callback',{@pb_dump_zdata,xui}); % 

xui.pb(7) = uicontrol('style','push',... 
                 'units','pix',...
                 'units','normalized','posit',[ax1l/fhwidth (ax1b-80)/fhheight ax1w*0.3/fhwidth 35/fhheight],...
                 'string', 'All Fits In',...
                 'fontsize',8,'BackgroundColor','c','callback',{@pb_load_alldata,xui}); %                  

xui.pb(8) = uicontrol('style','push',... 
                 'units','pix',...
                 'units','normalized','posit',[(ax1l+ax1w*0.3+10)/fhwidth (ax1b-80)/fhheight ax1w*0.3/fhwidth 35/fhheight],...
                 'string', 'All Fits Out',...
                 'fontsize',8,'BackgroundColor',[1 0.75 0],'callback',{@pb_dump_alldata,xui}); 
             
set([xui.sl;xui.txt;xui.ed],'callback',{@update_fitb,xui}); %this line does it all!

end %XTALFIT_scale
%**************************************************************************
function update_fitb(varargin)
global Minit Range dimtem
global theta ymin ymax realdatax realdatay realdataz Orienitx Orienity Orienitz Orienitxang Orienityang Orienitzang
[h,STR] = varargin{[1,3]};  % Get the [address,structure].

switch h  % Who called, editbox or slider? Gives same value to slider and editbox
    case STR.ed(1) %if 1st edit box called
        L = get(STR.sl(1),{'min','max','value'});  % Get the slider's info.
        E = str2double(get(h,'string'));  % Numerical edit string.
        if E >= L{1} && E <= L{2} % Set slider value to current edit box value.
            set(STR.sl(1),'value',E)  % E falls within range of slider.
        else
            set(h,'string',L{3}) % User tried to set edit box to value out of slider range, 
        end                      % so edit box value remains unchanged. 
    case STR.sl(1) %if slider called
        set(STR.ed(1),'string',get(h,'value')) % Set edit box value to current slider value.

    case STR.ed(2) %if 2nd edit box called
        L = get(STR.sl(2),{'min','max','value'});  % Get the slider's info.
        E = str2double(get(h,'string'));  % Numerical edit string.
        if E >= L{1} && E <= L{2} % Set slider value to current edit box value.
            set(STR.sl(2),'value',E)  % E falls within range of slider.
        else
            set(h,'string',L{3}) % User tried to set edit box to value out of slider range, 
        end                      % so edit box value remains unchanged. 
    case STR.sl(2) %if slider called
        set(STR.ed(2),'string',get(h,'value')) % Set edit box value to current slider value.
  
    case STR.ed(3) %if 3rd edit box called
        L = get(STR.sl(3),{'min','max','value'});  % Get the slider's info.
        E = str2double(get(h,'string'));  % Numerical edit string.
        if E >= L{1} && E <= L{2} % Set slider value to current edit box value.
            set(STR.sl(3),'value',E)  % E falls within range of slider.
        else
            set(h,'string',L{3}) % User tried to set edit box to value out of slider range, 
        end                      % so edit box value remains unchanged. 
    case STR.sl(3) %if slider called
        set(STR.ed(3),'string',get(h,'value')) % Set edit box value to current slider value.
 
    case STR.ed(4) %if 4th edit box called
        L = get(STR.sl(4),{'min','max','value'});  % Get the slider's info.
        E = str2double(get(h,'string'));  % Numerical edit string.
        if E >= L{1} && E <= L{2} % Set slider value to current edit box value.
            set(STR.sl(4),'value',E)  % E falls within range of slider.
        else
            set(h,'string',L{3}) % User tried to set edit box to value out of slider range, 
        end                      % so edit box value remains unchanged. 
    case STR.sl(4) %if slider called
        set(STR.ed(4),'string',get(h,'value')) % Set edit box value to current slider value.

    case STR.ed(5) %if 5th edit box called
        L = get(STR.sl(5),{'min','max','value'});  % Get the slider's info.
        E = str2double(get(h,'string'));  % Numerical edit string.
        if E >= L{1} && E <= L{2} % Set slider value to current edit box value.
            set(STR.sl(5),'value',E)  % E falls within range of slider.
        else
            set(h,'string',L{3}) % User tried to set edit box to value out of slider range, 
        end                      % so edit box value remains unchanged. 
    case STR.sl(5) %if slider called
        set(STR.ed(5),'string',get(h,'value')) % Set edit box value to current slider value.

    case STR.ed(6) %if 6th edit box called
        L = get(STR.sl(6),{'min','max','value'});  % Get the slider's info.
        E = str2double(get(h,'string'));  % Numerical edit string.
        if E >= L{1} && E <= L{2} % Set slider value to current edit box value.
            set(STR.sl(6),'value',E)  % E falls within range of slider.
        else
            set(h,'string',L{3}) % User tried to set edit box to value out of slider range, 
        end                      % so edit box value remains unchanged. 
    case STR.sl(6) %if slider called
        set(STR.ed(6),'string',get(h,'value')) % Set edit box value to current slider value.

    case STR.ed(7) %if 7th edit box called
        L = get(STR.sl(7),{'min','max','value'});  % Get the slider's info.
        E = str2double(get(h,'string'));  % Numerical edit string.
        if E >= L{1} && E <= L{2} % Set slider value to current edit box value.
            set(STR.sl(7),'value',E)  % E falls within range of slider.
        else
            set(h,'string',L{3}) % User tried to set edit box to value out of slider range, 
        end                      % so edit box value remains unchanged. 
    case STR.sl(7) %if slider called
        set(STR.ed(7),'string',get(h,'value')) % Set edit box value to current slider value.

    case STR.ed(8) %if 8th edit box called
        L = get(STR.sl(8),{'min','max','value'});  % Get the slider's info.
        E = str2double(get(h,'string'));  % Numerical edit string.
        if E >= L{1} && E <= L{2} % Set slider value to current edit box value.
            set(STR.sl(8),'value',E)  % E falls within range of slider.
        else
            set(h,'string',L{3}) % User tried to set edit box to value out of slider range, 
        end                      % so edit box value remains unchanged. 
    case STR.sl(8) %if slider called
        set(STR.ed(8),'string',get(h,'value')) % Set edit box value to current slider value.

    case STR.ed(9) %if 9th edit box called
        L = get(STR.sl(9),{'min','max','value'});  % Get the slider's info.
        E = str2double(get(h,'string'));  % Numerical edit string.
        if E >= L{1} && E <= L{2} % Set slider value to current edit box value.
            set(STR.sl(9),'value',E)  % E falls within range of slider.
        else
            set(h,'string',L{3}) % User tried to set edit box to value out of slider range, 
        end                      % so edit box value remains unchanged. 
    case STR.sl(9) %if slider called
        set(STR.ed(9),'string',get(h,'value')) % Set edit box value to current slider value.

      case STR.ed(10) %if 10th edit box called
        L = get(STR.sl(10),{'min','max','value'});  % Get the slider's info.
        E = str2double(get(h,'string'));  % Numerical edit string.
        if E >= L{1} && E <= L{2} % Set slider value to current edit box value.
            set(STR.sl(10),'value',E)  % E falls within range of slider.
        else
            set(h,'string',L{3}) % User tried to set edit box to value out of slider range, 
        end                      % so edit box value remains unchanged. 
    case STR.sl(10) %if slider called
        set(STR.ed(10),'string',get(h,'value')) % Set edit box value to current slider value.

    case STR.ed(11) %if 11th edit box called
        L = get(STR.sl(11),{'min','max','value'});  % Get the slider's info.
        E = str2double(get(h,'string'));  % Numerical edit string.
        if E >= L{1} && E <= L{2} % Set slider value to current edit box value.
            set(STR.sl(11),'value',E)  % E falls within range of slider.
        else
            set(h,'string',L{3}) % User tried to set edit box to value out of slider range, 
        end                      % so edit box value remains unchanged. 
    case STR.sl(11) %if slider called
        set(STR.ed(11),'string',get(h,'value')) % Set edit box value to current slider value.
              
    otherwise
        % Do nothing, or whatever.
end

Tenval=Minit;
div1 = get(STR.sl(1),'value'); % get the 1st    "     " = height
div2 = get(STR.sl(2),'value'); %   "  "  2nd    "     " = width
Tenval(1,1) = get(STR.sl(3),'value'); %   "  "  3rd    "     " = Txx
Tenval(2,2) = get(STR.sl(4),'value'); %   "  "  4th    "     " = Tyy
Tenval(3,3) = get(STR.sl(5),'value'); %   "  "  5th    "     " = Tzz
Tenval(1,2) = get(STR.sl(6),'value'); %   "  "  6th    "     " = Txy
Tenval(2,1) = Tenval(1,2);
Tenval(1,3) = get(STR.sl(7),'value'); %   "  "  7th    "     " = Txz
Tenval(3,1) = Tenval(1,3);
Tenval(2,3) = get(STR.sl(8),'value'); %   "  "  8th    "     " = Tyz
Tenval(3,2) = Tenval(2,3);
Offsetx = get(STR.sl(9),'value'); %   "  "  9th    "     " = Offset (THETA about x in degrees)
Offsety = get(STR.sl(10),'value'); %   "  "  10th    "     " = Offset (THETA about y in degrees)
Offsetz = get(STR.sl(11),'value'); %   "  "  11th    "     " = Offset (THETA about z in degrees)

%call the main fitting function and plot 
%create the temporary variable arrays: tempx tempy and tempz 
%use inputs = height,width,alpha,beta,gamma,offset (theta),Xorient
%Add the components and save the handles to a structure
scrsz = get(0,'ScreenSize'); %initiate figure
fhheight = 0.85*scrsz(4);
fhwidth = 0.85*scrsz(3);
fhleft = 0.05*scrsz(3);
fhbottom = 0.05*scrsz(4);


%First subplot, rotation about xtal x-axis

tempx=updatefig(Tenval,Orienitx,Orienitxang(1),Orienitxang(2),Orienitxang(3),Offsetx*pi/180,div1,div2); 
subplot('position',[(fhleft+25)/fhwidth (fhbottom+50)/fhheight (fhwidth*0.2)/fhwidth fhheight*0.70/fhheight])
plot(tempx(:,1),tempx(:,2)+theta(1),'r',realdatax(:,1),realdatax(:,2),'.k')
set(gca,'YTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360])
axis([min(Range),max(Range),ymin,ymax])
hold on

for i=2:dimtem(2)/2
    j=2*i-1;
    Thet=(theta(j)+Offsetx)*pi/180;
    tempx=updatefig(Tenval,Orienitx,Orienitxang(1),Orienitxang(2),Orienitxang(3),Thet,div1,div2);
    plot(tempx(:,1),tempx(:,2)+theta(j),'r',realdatax(:,j),realdatax(:,j+1),'.k')
end

hold off
xlabel('ppm') 
ylabel('rotation angle (THETA)')
title('Rotation about Xtal X-Axis')


%Second subplot, rotation about xtal y-axis

tempy=updatefig(Tenval,Orienity,Orienityang(1),Orienityang(2),Orienityang(3),Offsety*pi/180,div1,div2); 
subplot('position',[(fhleft+25+fhwidth*0.2+65)/fhwidth (fhbottom+50)/fhheight fhwidth*0.2/fhwidth fhheight*0.70/fhheight])
plot(tempy(:,1),tempy(:,2)+theta(1),'r',realdatay(:,1),realdatay(:,2),'.k')
set(gca,'YTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360])
axis([min(Range),max(Range),ymin,ymax])
hold on 
for i=2:dimtem(2)/2
    j=2*i-1;
    Thet=(theta(j)+Offsety)*pi/180;
    tempy=updatefig(Tenval,Orienity,Orienityang(1),Orienityang(2),Orienityang(3),Thet,div1,div2);
    plot(tempy(:,1),tempy(:,2)+theta(j),'r',realdatay(:,j),realdatay(:,j+1),'.k')
end
hold off
xlabel('ppm') 
ylabel('rotation angle (THETA)')
title('Rotation about Xtal Y-Axis')


%Third subplot, rotation about xtal z-axis

tempz=updatefig(Tenval,Orienitz,Orienitzang(1),Orienitzang(2),Orienitzang(3),Offsetz*pi/180,div1,div2); 
subplot('position',[(fhleft+25+2*fhwidth*0.2+130)/fhwidth (fhbottom+50)/fhheight fhwidth*0.2/fhwidth fhheight*0.70/fhheight])
plot(tempz(:,1),tempz(:,2)+theta(1),'r',realdataz(:,1),realdataz(:,2),'.k')
set(gca,'YTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360])
axis([min(Range),max(Range),ymin,ymax])
hold on 
for i=2:dimtem(2)/2
    j=2*i-1;
    Thet=(theta(j)+Offsetz)*pi/180;
    tempz=updatefig(Tenval,Orienitz,Orienitzang(1),Orienitzang(2),Orienitzang(3),Thet,div1,div2);
    plot(tempz(:,1),tempz(:,2)+theta(j),'r',realdataz(:,j),realdataz(:,j+1),'.k')
end
hold off
xlabel('ppm') 
ylabel('rotation angle (THETA)')
title('Rotation about Xtal Z-Axis')
end %function update_fitb

%***************************************************
function z = updatefig(Min,Orient,alf,bet,gam,thet,h,w)

I0=[1 0 0;0 1 0;0 0 1];
Ra=[cos(alf) sin(alf) 0;-sin(alf) cos(alf) 0;0 0 1]; 
Rb=[cos(bet) 0 -sin(bet);0 1 0;sin(bet) 0 cos(bet)];
Rg=[cos(gam) sin(gam) 0;-sin(gam) cos(gam) 0;0 0 1];
Rot = [1 0 0;0 cos(thet) sin(thet);0 -sin(thet) cos(thet)]; %rotations of THETA about lab x-axis

R = Rot*Rg*Rb*Ra*Orient; %transformation tensor -> fist orient - second tweek - third rotate
Minp=R*Min*(R\I0); %transformed tensor to fit data

%{
Note, the following transformation doesn't work!  It's probably obvious, but I don't see it....maybe the matrices don't commute?
R = Orient*Ra*Rb*Rg*Rot; %transformation matrix
Minp=(R\I0)*Min*R; %transformed tensor to fit data

Test: input a simple diagonal tensor, then change sliders. Do not use Euler angles (from Tensor or XTALFIT1).
Tii will change fits for axes j and k, but not i.
Tij will change fits only for axis k.
If anything else happens - there is a problem.
%}

z = SPECTfit(Minp,Minp,h,w); %set-up for two tensors.  Can do more, just edit SPECTfit to accept more tensors....
end %updatefig

%**************************************************************************
function z = SPECTfit(Ten1,Ten2,h,w) 
%Default set-up for two tensors.  Can do more, just edit to accept more tensors....

global Range
F=zeros(size(Range));

f0 = Ten1(3,3); %shift (zz component) of 1st tensor
f1 = Ten2(3,3); %shift (zz component) of 2nd tensor

for i=1:length(Range)
   F(i) = 0.3*h*exp(-(Range(i)-f0).^2/(2*w^2))+... 
          0.3*h*exp(-(Range(i)-f1).^2/(2*w^2)); %additional Gaussian broadened line   
end

z = [Range,F];
end %function SPECTfit

%***************************************************
function [] = pb_load_xdata(varargin)
%Callback for pushbutton x-data in. Gets values for alpha, beta, gamma and offset (THETA), 
%then updates the slider/editboxes with these angles (in deg) from a data structure IN_data.
global Range dimtem theta ymin ymax realdatax Orienitx Orienitxang
S = varargin{3}; % Get structure

load OUT_data %get lab-frame x-tal tensor, Euler angles and lab-frame offset angle from OUT_data

%angles in degrees - convert to radians
Orienitxang = [OUT_data.ang(1,1) OUT_data.ang(2,1) OUT_data.ang(3,1) OUT_data.ang(4,1)]*pi/180; %Euler angles (from TENSOR.rot)
Orienitx = OUT_data.orn; %initial x-tal orientation in lab frame

%update sliders and editboxes to the New Euler angles (from XTALFIT)
    set(S.sl(3),'value',OUT_data.ten(1,1));  % get the value for Txx.
    set(S.ed(3),'str',num2str(OUT_data.ten(1,1)));
    set(S.sl(4),'value',OUT_data.ten(2,2));  % get the value for Tyy.
    set(S.ed(4),'str',num2str(OUT_data.ten(2,2)));
    set(S.sl(5),'value',OUT_data.ten(3,3));  % get the value for Tzz.
    set(S.ed(5),'str',num2str(OUT_data.ten(3,3)));
    set(S.sl(6),'value',OUT_data.ten(1,2));  % get the value for Txy.
    set(S.ed(6),'str',num2str(OUT_data.ten(1,2)));
    set(S.sl(7),'value',OUT_data.ten(1,3));  % get the value for Txz.
    set(S.ed(7),'str',num2str(OUT_data.ten(1,3)));
    set(S.sl(8),'value',OUT_data.ten(2,3));  % get the value for Tyz.
    set(S.ed(8),'str',num2str(OUT_data.ten(2,3)));
    set(S.sl(9),'value',OUT_data.ang(4,1));  % get the value for lab x-offset (THETA in degrees).
    set(S.ed(9),'str',num2str(OUT_data.ang(4,1)));       
       
    set(S.txtb(1),'str',num2str(OUT_data.ang(1,1)));  %alpha
    set(S.txtb(2),'str',num2str(OUT_data.ang(2,1)));  %beta
    set(S.txtb(3),'str',num2str(OUT_data.ang(3,1)));  %gamma     

Xorlab = Olab(Orienitx);    
    if Xorlab == 7
        set(S.txta(11),'str','Z')
        else
        set(S.txta(11),'str','Y')
    end    
    
h=get(S.sl(1),'value'); % get the 1st slider value = height
w=get(S.sl(2),'value'); %   "  "  2nd    "     " = width
    
%update the figure (calculate new tensor, x,y,z plots and fits)
Fitx = updatefig(OUT_data.ten,Orienitx,Orienitxang(1),Orienitxang(2),Orienitxang(3),Orienitxang(4),h,w);

scrsz = get(0,'ScreenSize'); %initiate figure
fhheight = 0.85*scrsz(4);
fhwidth = 0.85*scrsz(3);
fhleft = 0.05*scrsz(3);
fhbottom = 0.05*scrsz(4);

subplot('position',[(fhleft+25)/fhwidth (fhbottom+50)/fhheight (fhwidth*0.2)/fhwidth fhheight*0.70/fhheight])
plot(Fitx(:,1),Fitx(:,2)+theta(1),'r',realdatax(:,1),realdatax(:,2),'.k')
set(gca,'YTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360])
axis([min(Range),max(Range),ymin,ymax])
hold on

for i=2:dimtem(2)/2
    j=2*i-1;
    THET=theta(j)*pi/180+Orienitxang(4);
    tempx=updatefig(OUT_data.ten,Orienitx,Orienitxang(1),Orienitxang(2),Orienitxang(3),THET,h,w); %call the main fitting function for each theta
    plot(tempx(:,1),tempx(:,2)+theta(j),'r',realdatax(:,j),realdatax(:,j+1),'.k')
end

hold off
xlabel('ppm') 
ylabel('rotation angle (THETA)')
title('Rotation about Xtal X-Axis')
end

%***************************************************
function [] = pb_load_ydata(varargin)
%Callback for pushbutton y-data in. Gets values for alpha, beta, gamma and offset (THETA), 
%then updates the slider/editboxes with these angles (in deg) from a data structure IN_data.
global Range dimtem theta ymin ymax realdatay Orienity Orienityang
S = varargin{3}; % Get structure

load OUT_data %get lab-frame x-tal tensor, Euler angles and lab-frame offset angle from OUT_data

%angles in degrees - convert to radians
Orienityang = [OUT_data.ang(1,1) OUT_data.ang(2,1) OUT_data.ang(3,1) OUT_data.ang(4,1)]*pi/180; %Euler angles (from TENSOR.rot)
Orienity = OUT_data.orn; %initial x-tal orientation in lab frame

%update sliders and editboxes to the New Euler angles (from XTALFIT)
    set(S.sl(3),'value',OUT_data.ten(1,1));  % get the value for Txx.
    set(S.ed(3),'str',num2str(OUT_data.ten(1,1)));
    set(S.sl(4),'value',OUT_data.ten(2,2));  % get the value for Tyy.
    set(S.ed(4),'str',num2str(OUT_data.ten(2,2)));
    set(S.sl(5),'value',OUT_data.ten(3,3));  % get the value for Tzz.
    set(S.ed(5),'str',num2str(OUT_data.ten(3,3)));
    set(S.sl(6),'value',OUT_data.ten(1,2));  % get the value for Txy.
    set(S.ed(6),'str',num2str(OUT_data.ten(1,2)));
    set(S.sl(7),'value',OUT_data.ten(1,3));  % get the value for Txz.
    set(S.ed(7),'str',num2str(OUT_data.ten(1,3)));
    set(S.sl(8),'value',OUT_data.ten(2,3));  % get the value for Tyz.
    set(S.ed(8),'str',num2str(OUT_data.ten(2,3)));
    set(S.sl(10),'value',OUT_data.ang(4,1));  % get the value for lab x-offset(THETA in degrees).
    set(S.ed(10),'str',num2str(OUT_data.ang(4,1)));        
     
    set(S.txtb(4),'str',num2str(OUT_data.ang(1,1)));  %alpha
    set(S.txtb(5),'str',num2str(OUT_data.ang(2,1)));  %beta
    set(S.txtb(6),'str',num2str(OUT_data.ang(3,1)));  %gamma    

Yorlab = Olab(Orienity);
    if Yorlab == 1
        set(S.txta(15),'str','Z')
        else
        set(S.txta(15),'str','X')
    end
        
h=get(S.sl(1),'value'); % get the 1st slider value = height
w=get(S.sl(2),'value'); %   "  "  2nd    "     " = width

%update the figure (calculate new tensor, x,y,z plots and fits)
Fity = updatefig(OUT_data.ten,Orienity,Orienityang(1),Orienityang(2),Orienityang(3),Orienityang(4),h,w);

scrsz = get(0,'ScreenSize'); %initiate figure
fhheight = 0.85*scrsz(4);
fhwidth = 0.85*scrsz(3);
fhleft = 0.05*scrsz(3);
fhbottom = 0.05*scrsz(4);

subplot('position',[(fhleft+25+fhwidth*0.2+65)/fhwidth (fhbottom+50)/fhheight fhwidth*0.2/fhwidth fhheight*0.70/fhheight])
plot(Fity(:,1),Fity(:,2)+theta(1),'r',realdatay(:,1),realdatay(:,2),'.k')
set(gca,'YTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360])
axis([min(Range),max(Range),ymin,ymax])
hold on 

for i=2:dimtem(2)/2
    j=2*i-1;
    THET=theta(j)*pi/180+Orienityang(4);
    Fity=updatefig(OUT_data.ten,Orienity,Orienityang(1),Orienityang(2),Orienityang(3),THET,h,w); %call the main fitting function for each theta
    plot(Fity(:,1),Fity(:,2)+theta(j),'r',realdatay(:,j),realdatay(:,j+1),'.k')
end

hold off
xlabel('ppm') 
ylabel('rotation angle (THETA)')
title('Rotation about Xtal Y-Axis')
end

%***************************************************
function [] = pb_load_zdata(varargin)
%Callback for pushbutton z-data in. Gets values for alpha, beta, gamma and offset (THETA), 
%then updates the slider/editboxes with these angles (in deg) from a data structure IN_data.
global Range dimtem theta ymin ymax realdataz Orienitz Orienitzang

S = varargin{3}; % Get structure

load OUT_data %get lab-frame x-tal tensor, Euler angles and lab-frame offset angle from OUT_data (structure format)

Orienitzang = [OUT_data.ang(1,1) OUT_data.ang(2,1) OUT_data.ang(3,1) OUT_data.ang(4,1)]*pi/180;
Orienitz = OUT_data.orn; %initial x-tal orientation in lab frame

%update sliders and editboxes to the New Euler angles (from XTALFIT)
    set(S.sl(3),'value',OUT_data.ten(1,1));  % get the value for Txx.
    set(S.ed(3),'str',num2str(OUT_data.ten(1,1)));
    set(S.sl(4),'value',OUT_data.ten(2,2));  % get the value for Tyy.
    set(S.ed(4),'str',num2str(OUT_data.ten(2,2)));
    set(S.sl(5),'value',OUT_data.ten(3,3));  % get the value for Tzz.
    set(S.ed(5),'str',num2str(OUT_data.ten(3,3)));
    set(S.sl(6),'value',OUT_data.ten(1,2));  % get the value for Txy.
    set(S.ed(6),'str',num2str(OUT_data.ten(1,2)));
    set(S.sl(7),'value',OUT_data.ten(1,3));  % get the value for Txz.
    set(S.ed(7),'str',num2str(OUT_data.ten(1,3)));
    set(S.sl(8),'value',OUT_data.ten(2,3));  % get the value for Tyz.
    set(S.ed(8),'str',num2str(OUT_data.ten(2,3)));
    set(S.sl(11),'value',OUT_data.ang(4,1));  % get the value for lab x-offset(THETA in degrees).
    set(S.ed(11),'str',num2str(OUT_data.ang(4,1)));        
    
    set(S.txtb(7),'str',num2str(OUT_data.ang(1,1)));  %alpha
    set(S.txtb(8),'str',num2str(OUT_data.ang(2,1)));  %beta
    set(S.txtb(9),'str',num2str(OUT_data.ang(3,1)));  %gamma
    
Zorlab = Olab(Orienitz);
    if Zorlab == -5
        set(S.txta(19),'str','X')
        else
        set(S.txta(19),'str','Y')
    end    
  
h=get(S.sl(1),'value'); % get the 1st slider value = height
w=get(S.sl(2),'value'); %   "  "  2nd    "     " = width

%update the figure (calculate new tensor, x,y,z plots and fits)
Fitz = updatefig(OUT_data.ten,Orienitz,Orienitzang(1),Orienitzang(2),Orienitzang(3),Orienitzang(4),h,w);

scrsz = get(0,'ScreenSize'); %initiate figure
fhheight = 0.85*scrsz(4);
fhwidth = 0.85*scrsz(3);
fhleft = 0.05*scrsz(3);
fhbottom = 0.05*scrsz(4);

subplot('position',[(fhleft+25+2*fhwidth*0.2+130)/fhwidth (fhbottom+50)/fhheight fhwidth*0.2/fhwidth fhheight*0.70/fhheight])
plot(Fitz(:,1),Fitz(:,2)+theta(1),'r',realdataz(:,1),realdataz(:,2),'.k')
set(gca,'YTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360])
axis([min(Range),max(Range),ymin,ymax])
hold on 

for i=2:dimtem(2)/2
    j=2*i-1;
    THET=theta(j)*pi/180+Orienitzang(4);
    Fitz = updatefig(OUT_data.ten,Orienitz,Orienitzang(1),Orienitzang(2),Orienitzang(3),THET,h,w);
    plot(Fitz(:,1),Fitz(:,2)+theta(j),'r',realdataz(:,j),realdataz(:,j+1),'.k')
end

hold off
xlabel('ppm') 
ylabel('rotation angle (THETA)')
title('Rotation about Xtal Z-Axis')
end

%**************************************************************************

function [] = pb_dump_xdata(varargin)
%update of Euler angles alpha, beta and gamma is not appropriate since they are different for
%for rotations about xtal-x orientation

global Orienitx Orienitxang

S = varargin{3}; % Get structure
delete('OUT_data.mat')

OUT_data.orn = Orienitx; %initial x-tal orientation in lab frame
OUT_data.ang(1,1) = (Orienitxang(1))*(180/pi);
OUT_data.ang(2,1) = (Orienitxang(2))*(180/pi);
OUT_data.ang(3,1) = (Orienitxang(3))*(180/pi);
OUT_data.ang(4,1) = get(S.sl(9),'value'); %updated offset (THETA)

OUT_data.ten(1,1) = get(S.sl(3),'value');
OUT_data.ten(2,2) = get(S.sl(4),'value');
OUT_data.ten(3,3) = get(S.sl(5),'value');
OUT_data.ten(1,2) = get(S.sl(6),'value');
OUT_data.ten(2,1) = get(S.sl(6),'value');
OUT_data.ten(1,3) = get(S.sl(7),'value');
OUT_data.ten(3,1) = get(S.sl(7),'value');
OUT_data.ten(2,3) = get(S.sl(8),'value');
OUT_data.ten(3,2) = get(S.sl(8),'value');

save OUT_data OUT_data %(structure format)
end

%**************************************************************************
function [] = pb_dump_ydata(varargin)
%update of Euler angles alpha, beta and gamma is not appropriate since they are different for
%for rotations about xtal-y orientation

global Orienity Orienityang

S = varargin{3}; % Get structure
delete('OUT_data.mat')

OUT_data.orn = Orienity; %initial x-tal orientation in lab frame
OUT_data.ang(1,1) = (Orienityang(1))*(180/pi);
OUT_data.ang(2,1) = (Orienityang(2))*(180/pi);
OUT_data.ang(3,1) = (Orienityang(3))*(180/pi);
OUT_data.ang(4,1) = get(S.sl(10),'value'); %updated offset (THETA)

OUT_data.ten(1,1) = get(S.sl(3),'value');
OUT_data.ten(2,2) = get(S.sl(4),'value');
OUT_data.ten(3,3) = get(S.sl(5),'value');
OUT_data.ten(1,2) = get(S.sl(6),'value');
OUT_data.ten(2,1) = get(S.sl(6),'value');
OUT_data.ten(1,3) = get(S.sl(7),'value');
OUT_data.ten(3,1) = get(S.sl(7),'value');
OUT_data.ten(2,3) = get(S.sl(8),'value');
OUT_data.ten(3,2) = get(S.sl(8),'value');

save OUT_data OUT_data %(structure format)
end

%**************************************************************************
function [] = pb_dump_zdata(varargin)
%update of Euler angles alpha, beta and gamma is not appropriate since they are different for
%for rotations about xtal-z orientation

global Orienitz Orienitzang

S = varargin{3}; % Get structure
delete('OUT_data.mat')

OUT_data.orn = Orienitz; %initial x-tal orientation in lab frame
OUT_data.ang(1,1) = (Orienitzang(1))*(180/pi);
OUT_data.ang(2,1) = (Orienitzang(2))*(180/pi);
OUT_data.ang(3,1) = (Orienitzang(3))*(180/pi);
OUT_data.ang(4,1) = get(S.sl(11),'value'); %updated offset (THETA)

OUT_data.ten(1,1) = get(S.sl(3),'value');
OUT_data.ten(2,2) = get(S.sl(4),'value');
OUT_data.ten(3,3) = get(S.sl(5),'value');
OUT_data.ten(1,2) = get(S.sl(6),'value');
OUT_data.ten(2,1) = get(S.sl(6),'value');
OUT_data.ten(1,3) = get(S.sl(7),'value');
OUT_data.ten(3,1) = get(S.sl(7),'value');
OUT_data.ten(2,3) = get(S.sl(8),'value');
OUT_data.ten(3,2) = get(S.sl(8),'value');

save OUT_data OUT_data %(structure format)
end

%**************************************************************************
function [] = pb_load_alldata(varargin)
%Get Alldata from previous XTALFIT session. Input the tensor, all orientations Euler angles, and offsets.

global Range dimtem theta ymin ymax realdatax realdatay realdataz 
global Orienitx Orienity Orienitz Orienitxang Orienityang Orienitzang

S = varargin{3}; % Get structure

load Alldata

%angles in degrees - convert to radians
Orienitxang = Alldata.ang(:,1)*pi/180;
Orienitx = Alldata.orn(:,1:3); %initial x-tal orientation in lab frame
Orienityang = Alldata.ang(:,2)*pi/180;
Orienity = Alldata.orn(:,4:6); %initial y-tal orientation in lab frame
Orienitzang = Alldata.ang(:,3)*pi/180;
Orienitz = Alldata.orn(:,7:9); %initial z-tal orientation in lab frame

%update sliders and editboxes to the New Euler angles (from XTALFIT)
    set(S.sl(3),'value',Alldata.ten(1,1));  % get the value for Txx.
    set(S.ed(3),'str',num2str(Alldata.ten(1,1)));
    set(S.sl(4),'value',Alldata.ten(2,2));  % get the value for Tyy.
    set(S.ed(4),'str',num2str(Alldata.ten(2,2)));
    set(S.sl(5),'value',Alldata.ten(3,3));  % get the value for Tzz.
    set(S.ed(5),'str',num2str(Alldata.ten(3,3)));
    set(S.sl(6),'value',Alldata.ten(1,2));  % get the value for Txy.
    set(S.ed(6),'str',num2str(Alldata.ten(1,2)));
    set(S.sl(7),'value',Alldata.ten(1,3));  % get the value for Txz.
    set(S.ed(7),'str',num2str(Alldata.ten(1,3)));
    set(S.sl(8),'value',Alldata.ten(2,3));  % get the value for Tyz.
    set(S.ed(8),'str',num2str(Alldata.ten(2,3)));
    
    %x-axis
    set(S.txtb(1),'str',num2str(Alldata.ang(1,1)));  %alpha
    set(S.txtb(2),'str',num2str(Alldata.ang(2,1)));  %beta
    set(S.txtb(3),'str',num2str(Alldata.ang(3,1)));  %gamma  
    set(S.sl(9),'value',Alldata.ang(4,1));  % get the value for lab x-offset about x-axis (THETA in degrees).
    set(S.ed(9),'str',num2str(Alldata.ang(4,1)));      
    %y-axis
    set(S.txtb(4),'str',num2str(Alldata.ang(1,2)));  %alpha
    set(S.txtb(5),'str',num2str(Alldata.ang(2,2)));  %beta
    set(S.txtb(6),'str',num2str(Alldata.ang(3,2)));  %gamma 
    set(S.sl(10),'value',Alldata.ang(4,2));  % get the value for lab x-offset about y-axis (THETA in degrees).
    set(S.ed(10),'str',num2str(Alldata.ang(4,2)));           
    %z-axis
    set(S.txtb(7),'str',num2str(Alldata.ang(1,3)));  %alpha
    set(S.txtb(8),'str',num2str(Alldata.ang(2,3)));  %beta
    set(S.txtb(9),'str',num2str(Alldata.ang(3,3)));  %gamma        
    set(S.sl(11),'value',Alldata.ang(4,3));  % get the value for lab x-offset about z-axis (THETA in degrees).
    set(S.ed(11),'str',num2str(Alldata.ang(4,3)));         
    
%X-tal orientation info
Xorlab = Olab(Orienitx);
Yorlab = Olab(Orienity);
Zorlab = Olab(Orienitz);
    
    if Xorlab == 7
        set(S.txta(11),'str','Z')
        else
        set(S.txta(11),'str','Y')
    end
 
    if Yorlab == 1
        set(S.txta(15),'str','Z')
        else
        set(S.txta(15),'str','X')
    end
    
    if Zorlab == -5
        set(S.txta(19),'str','X')
        else
        set(S.txta(19),'str','Y')
    end
    
    h=get(S.sl(1),'value'); % get the 1st slider value = height
    w=get(S.sl(2),'value'); %   "  "  2nd    "     " = width    
    
%call the main fitting function and plot 
%create the temporary variable arrays: tempx tempy and tempz 
%use inputs = height,width,alpha,beta,gamma,offset (theta),Xorient
scrsz = get(0,'ScreenSize'); %initiate figure
fhheight = 0.85*scrsz(4);
fhwidth = 0.85*scrsz(3);
fhleft = 0.05*scrsz(3);
fhbottom = 0.05*scrsz(4);

%First subplot, rotation about xtal x-axis

tempx=updatefig(Alldata.ten,Orienitx,Orienitxang(1),Orienitxang(2),Orienitxang(3),Alldata.ang(4,1)*pi/180,h,w); 
subplot('position',[(fhleft+25)/fhwidth (fhbottom+50)/fhheight (fhwidth*0.2)/fhwidth fhheight*0.70/fhheight])
plot(tempx(:,1),tempx(:,2)+theta(1),'r',realdatax(:,1),realdatax(:,2),'.k')
set(gca,'YTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360])
axis([min(Range),max(Range),ymin,ymax])
hold on

for i=2:dimtem(2)/2
    j=2*i-1;
    Thet=(theta(j)+Alldata.ang(4,1))*pi/180;
    tempx=updatefig(Alldata.ten,Orienitx,Orienitxang(1),Orienitxang(2),Orienitxang(3),Thet,h,w);
    plot(tempx(:,1),tempx(:,2)+theta(j),'r',realdatax(:,j),realdatax(:,j+1),'.k')
end

hold off
xlabel('ppm') 
ylabel('rotation angle (THETA)')
title('Rotation about Xtal X-Axis')


%Second subplot, rotation about xtal y-axis

tempy=updatefig(Alldata.ten,Orienity,Orienityang(1),Orienityang(2),Orienityang(3),Alldata.ang(4,2)*pi/180,h,w); 
subplot('position',[(fhleft+25+fhwidth*0.2+65)/fhwidth (fhbottom+50)/fhheight fhwidth*0.2/fhwidth fhheight*0.70/fhheight])
plot(tempy(:,1),tempy(:,2)+theta(1),'r',realdatay(:,1),realdatay(:,2),'.k')
set(gca,'YTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360])
axis([min(Range),max(Range),ymin,ymax])
hold on 
for i=2:dimtem(2)/2
    j=2*i-1;
    Thet=(theta(j)+Alldata.ang(4,2))*pi/180;
    tempy=updatefig(Alldata.ten,Orienity,Orienityang(1),Orienityang(2),Orienityang(3),Thet,h,w);
    plot(tempy(:,1),tempy(:,2)+theta(j),'r',realdatay(:,j),realdatay(:,j+1),'.k')
end
hold off
xlabel('ppm') 
ylabel('rotation angle (THETA)')
title('Rotation about Xtal Y-Axis')


%Third subplot, rotation about xtal z-axis

tempz=updatefig(Alldata.ten,Orienitz,Orienitzang(1),Orienitzang(2),Orienitzang(3),Alldata.ang(4,3)*pi/180,h,w); 
subplot('position',[(fhleft+25+2*fhwidth*0.2+130)/fhwidth (fhbottom+50)/fhheight fhwidth*0.2/fhwidth fhheight*0.70/fhheight])
plot(tempz(:,1),tempz(:,2)+theta(1),'r',realdataz(:,1),realdataz(:,2),'.k')
set(gca,'YTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360])
axis([min(Range),max(Range),ymin,ymax])
hold on 
for i=2:dimtem(2)/2
    j=2*i-1;
    Thet=(theta(j)+Alldata.ang(4,3))*pi/180;
    tempz=updatefig(Alldata.ten,Orienitz,Orienitzang(1),Orienitzang(2),Orienitzang(3),Thet,h,w);
    plot(tempz(:,1),tempz(:,2)+theta(j),'r',realdataz(:,j),realdataz(:,j+1),'.k')
end
hold off
xlabel('ppm') 
ylabel('rotation angle (THETA)')
title('Rotation about Xtal Z-Axis')    

end

%**************************************************************************
%test for initial X-tal Orientation 
function z = Olab(MaTrx)
veC = MaTrx*[1;2;3]; %orientation matrix operating on an arbitrary vector
z = trace(MaTrx) + veC(2) - veC(1) + veC(3); %unique condition for each orientation
end

%**************************************************************************
function [] = pb_dump_alldata(varargin)
%Alldataout from XTALFIT session. Send-to-file the tensor, all orientations Euler angles, and offsets.

global Orienitx Orienity Orienitz Orienitxang Orienityang Orienitzang

S = varargin{3}; % Get structure
%delete Alldata.mat

Alldata.ten=[1 0 0;0 1 0;0 0 1]; %preallocate (is this necessary?)
Alldata.ang = zeros(4,3); %xang = Alldata.ang(:,1), yang = Alldata.ang(:,2), zang = Alldata.ang(:,3)
Alldata.orn = zeros(3,9); %xorien = Alldata.orn(:,1:3), yorien = Alldata.orn(:,4:6), zorien = Alldata.orn(:,7:9),

Alldata.ten(1,1) = get(S.sl(3),'value');
Alldata.ten(2,2) = get(S.sl(4),'value');
Alldata.ten(3,3) = get(S.sl(5),'value');
Alldata.ten(1,2) = get(S.sl(6),'value');
Alldata.ten(2,1) = get(S.sl(6),'value');
Alldata.ten(1,3) = get(S.sl(7),'value');
Alldata.ten(3,1) = get(S.sl(7),'value');
Alldata.ten(2,3) = get(S.sl(8),'value');
Alldata.ten(3,2) = get(S.sl(8),'value');

Alldata.orn = [Orienitx Orienity Orienitz]; %initial x-tal orientation in lab frame
Alldata.ang(1,1) = (Orienitxang(1))*(180/pi); %alpha
Alldata.ang(2,1) = (Orienitxang(2))*(180/pi); %beta
Alldata.ang(3,1) = (Orienitxang(3))*(180/pi); %gamma
Alldata.ang(4,1) = get(S.sl(9),'value'); %updated offset (THETA about x-axis)

Alldata.ang(1,2) = (Orienityang(1))*(180/pi); %alpha
Alldata.ang(2,2) = (Orienityang(2))*(180/pi); %beta
Alldata.ang(3,2) = (Orienityang(3))*(180/pi); %gamma
Alldata.ang(4,2) = get(S.sl(10),'value'); %updated offset (THETA about y-axis)

Alldata.ang(1,3) = (Orienitzang(1))*(180/pi); %alpha
Alldata.ang(2,3) = (Orienitzang(2))*(180/pi); %beta
Alldata.ang(3,3) = (Orienitzang(3))*(180/pi); %gamma
Alldata.ang(4,3) = get(S.sl(11),'value'); %updated offset (THETA about z-axis)

Alldata.ang(1,4) = 0; %2nd tensor Euler angles and offset set to zero
Alldata.ang(2,4) = 0;
Alldata.ang(3,4) = 0;
Alldata.ang(4,4) = 0;

save Alldata Alldata %(structure format, you need this syntax with save or else you get an error message)
end

