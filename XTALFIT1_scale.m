function [] = XTALFIT1_scale(datax)
%Specalized Single spectral fitting GUI - by P. Stallworth 10/16.  
%Input for n data sets, the m X 2n single data set matrix 
%(data(1,n)= angle, data(i:n)= freq array, data(i:n+1)= intensity) to be fit (SPECTset).  
%Edit 'fitfunc' (at the end) with the appropriate fitting function.
%datax, datay, dataz = x-axis, y-axis and z-axis data sets

global Minit1 Range1 dimtem theta ymin1 ymax1 redat 

%Edit initial slider, max and min values = [height width Txx Tyy Tzz Txy Txz Tyz Offset];
Minit1=[1 0 0;0 1 0;0 0 1]; %predefine lab-frame tensor
initvalues = [25 100 0 0 0 0 0 0 0];
maxvalues = [100 500 5000 5000 5000 2000 2000 2000 180];
minvalues = [5 10 -3000 -3000 -3000 -2000 -2000 -2000 -180];
res = 100; %resolution of reduced data set
fitres = 100; %resolution of fittings
minRange1=-3000;
maxRange1=3000;
del=(maxRange1-minRange1)/(fitres-1);
Range1 = (minRange1:del:maxRange1)'; %defines the range and ppm resolution of the fit
theta=datax(1,:);
dimtem=[res 50]; %dimtemp(1) = res rows, dimtemp(2) = 50 cols
ymin1 = -1;
ymax1 = theta(length(theta))+16;
datheight = 15; %data spectral intensity adjust
n=9; %to pick-out baseline points for renormalization

%Normalize the data and add DC
tempdatax = zeros(res,50); %preallocate truncated data sets
for i = 1:25 %renormalizes intensity of 25 spectra to fit between 0 and 360 
    tempdatax(:,2*i-1:2*i) = SECTRES(datax(2:end,2*i-1:2*i),minRange1,maxRange1,res); 
    basdat = sum(tempdatax(res-n:res,2*i))/10; %define baseline value
    tempdatax(:,2*i) = tempdatax(:,2*i) - basdat; %baseline adjust
    maxdat = max(tempdatax(:,2*i)); %identify the maximum intensity value
    if maxdat > 0 %conditional for cases where maxdat = 0
        tempdatax(:,2*i) = datheight*tempdatax(:,2*i)/maxdat + theta(2*i); %normalize and add DC
    else
        tempdatax(:,2*i) = datheight*tempdatax(:,2*i) + theta(2*i); %just add DC
    end
end
redat=tempdatax;

%initiate the figure
scrsz = get(0,'ScreenSize'); %initiate figure 
xui.fh = figure('units','pixels','position',[0.1*scrsz(3) 0.1*scrsz(4) 1.5*scrsz(3)/3 0.8*scrsz(4)],...
       'name','XTALFIT1_scale',...  %'menubar','none',...
       'numbertitle','off','ToolBar','none',...
       'resize','on');

fhsize = get(xui.fh,'position');
fhheight = fhsize(4);
fhwidth = fhsize(3);
fhleft = fhsize(1);
fhbottom = fhsize(2);

subplot('position',[(fhleft-50)/fhwidth,(fhbottom-20)/fhheight,0.45,0.75])
%plot(redat(:,1),redat(:,2),'.k')
set(gca,'YTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360])
axis([min(Range1),max(Range1),ymin1,ymax1])
hold on %note that "hold on" and "hold off" do not produce messages in the command window
for i=1:25
    j=2*i-1;
    plot(redat(:,j),redat(:,j+1),'.k')
end
hold off
xlabel('ppm') 
ylabel('rotation angle (THETA)')
title('Rotation about X-tal Axis')

%For example, hui looks like this:
%hui = 
%
%     sl: [209.0018 2.0020 5.0020 8.0020 11.0020 14.0020 17.0020]
%    txt: [0.0020 3.0020 6.0020 9.0020 12.0020 15.0020 210.0018]
%     ed: [1.0020 4.0020 7.0020 10.0020 13.0020 16.0020 211.0018]

%slider1 = height
hui.txt(1) = uicontrol('style','text','units','normalized','string','fit height',...
    'position',[(fhleft-50+fhwidth*0.45+55)/fhwidth (fhbottom+0.75*fhheight+50)/fhheight 0.05 0.04]);
hui.ed(1) = uicontrol('style','edit',...
    'string',num2str(initvalues(1)),'units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+55)/fhwidth (fhbottom+0.75*fhheight+50-0.04*fhheight)/fhheight 0.05 0.04]);
hui.sl(1)=uicontrol('style','slider','units','normalized',...
'position',[(fhleft-50+fhwidth*0.45+55)/fhwidth (fhbottom+0.75*fhheight+50-6*0.04*fhheight)/fhheight 0.05 0.2],...
'sliderstep',[0.015 1],...
'value',initvalues(1),...%value has to be within min/max range
'min',minvalues(1),'max',maxvalues(1)); 

%slider2 = width
hui.txt(2) = uicontrol('style','text','string','fit width','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+55)/fhwidth (fhbottom+0.75*fhheight+50-8*0.04*fhheight)/fhheight 0.05 0.04]);
hui.ed(2) = uicontrol('style','edit','units','normalized',...
    'string',num2str(initvalues(2)),...
    'position',[(fhleft-50+fhwidth*0.45+55)/fhwidth (fhbottom+0.75*fhheight+50-9*0.04*fhheight)/fhheight 0.05 0.04]);
hui.sl(2)=uicontrol('style','slider','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+55)/fhwidth (fhbottom+0.75*fhheight+50-14*0.04*fhheight)/fhheight 0.05 0.2],...
    'sliderstep',[0.01 1],...
    'value',initvalues(2),...%value has to be within min/max range
    'min',minvalues(2),'max',maxvalues(2)); 

%slider12 = offset (x-axis rotation angle)
hui.txt(12) = uicontrol('style','text','string','offset','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+55)/fhwidth (fhbottom+0.75*fhheight+50-16*0.04*fhheight)/fhheight 0.05 0.04]);
hui.ed(12) = uicontrol('style','edit','units','normalized',...
    'string',num2str(initvalues(9)),...
    'position',[(fhleft-50+fhwidth*0.45+55)/fhwidth (fhbottom+0.75*fhheight+50-17*0.04*fhheight)/fhheight 0.05 0.04]);
hui.sl(12)=uicontrol('style','slider','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+55)/fhwidth (fhbottom+0.75*fhheight+50-22*0.04*fhheight)/fhheight 0.05 0.2],...
    'sliderstep',[0.01 1],...
    'value',initvalues(9),...%value has to be within min/max range
    'min',minvalues(9),'max',maxvalues(9)); 

%slider3 = Txx
hui.txt(3) = uicontrol('style','text','string','Txx','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+85+2*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50)/fhheight 0.05 0.04]); %,'fontsize',10);
hui.ed(3) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+85+2*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-0.04*fhheight)/fhheight 0.05 0.04]); %,'fontsize',10);
hui.sl(3) = uicontrol('style','slider','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+85+2*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-6*0.04*fhheight)/fhheight 0.05 0.2],...
    'sliderstep',[0.005 0.1],'value',initvalues(3),...%value has to be within min/max range
    'min',minvalues(3),'max',maxvalues(3));

%slider4 = Tyy
hui.txt(4) = uicontrol('style','text','string','Tyy','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+95+3*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50)/fhheight 0.05 0.04]); %,'fontsize',10);
hui.ed(4) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+95+3*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-0.04*fhheight)/fhheight 0.05 0.04]); %,'fontsize',10);
hui.sl(4) = uicontrol('style','slider','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+95+3*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-6*0.04*fhheight)/fhheight 0.05 0.2],...
    'sliderstep',[0.005 0.1],...
    'value',initvalues(4),...%value has to be within min/max range
    'min',minvalues(4),'max',maxvalues(4));

%slider5 = Tzz
hui.txt(5) = uicontrol('style','text','string','Tzz','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+105+4*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50)/fhheight 0.05 0.04]); %,'fontsize',10);
hui.ed(5) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+105+4*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-0.04*fhheight)/fhheight 0.05 0.04]); %,'fontsize',10);
hui.sl(5) = uicontrol('style','slider','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+105+4*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-6*0.04*fhheight)/fhheight 0.05 0.2],...
    'sliderstep',[0.005 0.1],...
    'value',initvalues(5),...%value has to be within min/max range
    'min',minvalues(5),'max',maxvalues(5));

%slider6 = Txy
hui.txt(6) = uicontrol('style','text','string','Txy','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+105+4*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-8*0.04*fhheight)/fhheight 0.05 0.04]); %,'fontsize',10);
hui.ed(6) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+105+4*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-9*0.04*fhheight)/fhheight 0.05 0.04]); %,'fontsize',10);
hui.sl(6) = uicontrol('style','slider','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+105+4*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-14*0.04*fhheight)/fhheight 0.05 0.2],...
    'sliderstep',[0.005 0.1],...
    'value',initvalues(6),...%value has to be within min/max range
    'min',minvalues(6),'max',maxvalues(6));

%slider7 = Txz
hui.txt(7) = uicontrol('style','text','string','Txz','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+95+3*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-8*0.04*fhheight)/fhheight 0.05 0.04]); %,'fontsize',10);
hui.ed(7) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+95+3*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-9*0.04*fhheight)/fhheight 0.05 0.04]); %,'fontsize',10);
hui.sl(7) = uicontrol('style','slider','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+95+3*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-14*0.04*fhheight)/fhheight 0.05 0.2],...
    'sliderstep',[0.005 0.1],...
    'value',initvalues(7),...%value has to be within min/max range
    'min',minvalues(7),'max',maxvalues(7));

%slider8 = Tyz
hui.txt(8) = uicontrol('style','text','string','Tyz','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+85+2*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-8*0.04*fhheight)/fhheight 0.05 0.04]); %,'fontsize',10);
hui.ed(8) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+85+2*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-9*0.04*fhheight)/fhheight 0.05 0.04]); %,'fontsize',10);
hui.sl(8) = uicontrol('style','slider','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+85+2*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-14*0.04*fhheight)/fhheight 0.05 0.2],...
    'sliderstep',[0.005 0.1],...
    'value',initvalues(8),...%value has to be within min/max range
    'min',minvalues(8),'max',maxvalues(8));


%slider9 = alpha
hui.txt(9) = uicontrol('style','text','string','alpha','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+85+2*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-16*0.04*fhheight)/fhheight 0.05 0.04]); %,'fontsize',10);
hui.ed(9) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+85+2*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-17*0.04*fhheight)/fhheight 0.05 0.04]); %,'fontsize',10);
hui.sl(9) = uicontrol('style','slider','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+85+2*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-22*0.04*fhheight)/fhheight 0.05 0.2],...
    'sliderstep',[0.005 0.1],...
    'value',initvalues(9),...%value has to be within min/max range
    'min',minvalues(9),'max',maxvalues(9));

%slider10 = beta
hui.txt(10) = uicontrol('style','text','string','beta','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+95+3*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-16*0.04*fhheight)/fhheight 0.05 0.04]); %,'fontsize',10);
hui.ed(10) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+95+3*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-17*0.04*fhheight)/fhheight 0.05 0.04]); %,'fontsize',10);
hui.sl(10) = uicontrol('style','slider','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+95+3*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-22*0.04*fhheight)/fhheight 0.05 0.2],...
    'sliderstep',[0.005 0.1],...
    'value',initvalues(9),...%value has to be within min/max range
    'min',minvalues(9),'max',maxvalues(9));

%slider11 = gamma
hui.txt(11) = uicontrol('style','text','string','gamma','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+105+4*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-16*0.04*fhheight)/fhheight 0.05 0.04]); %'fontsize',10);
hui.ed(11) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+105+4*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-17*0.04*fhheight)/fhheight 0.05 0.04]); %,'fontsize',10);
hui.sl(11) = uicontrol('style','slider','units','normalized',...
    'position',[(fhleft-50+fhwidth*0.45+105+4*0.05*fhwidth)/fhwidth (fhbottom+0.75*fhheight+50-22*0.04*fhheight)/fhheight 0.05 0.2],'sliderstep',[0.005 0.1],...
    'value',initvalues(9),...%value has to be within min/max range
    'min',minvalues(9),'max',maxvalues(9));

hui.pb(1) = uicontrol('style','push',... 
                 'units','normalized',...
                 'posit',[(fhleft-50)/fhwidth (fhbottom+fhheight*0.75+20)/fhheight 0.12 0.07],...
                 'string', 'Fit Data In',...
                 'fontsize',12,'BackgroundColor',[1 0.5 0],...
                 'callback',{@pb_load_data,hui}); 

hui.pb(2) = uicontrol('style','push',... 
                 'units','normalized',...
                 'posit',[(fhleft-50+fhwidth*0.12+10)/fhwidth (fhbottom+fhheight*0.75+20)/fhheight 0.12 0.07],...
                 'string', 'Fit Data Out',...
                 'fontsize',12,'BackgroundColor',[0 0.5 0],...
                 'callback',{@pb_dump_data,hui}); 
             
set([hui.sl;hui.txt;hui.ed],'callback',{@update_fitb,hui}); %this line does it all!

end %XTALFIT1
%**************************************************************************
function update_fitb(varargin)
global Minit1 Range1 dimtem
global theta ymin1 ymax1 redat Orienit
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
        
    case STR.ed(12) %if 12th edit box called
        L = get(STR.sl(12),{'min','max','value'});  % Get the slider's info.
        E = str2double(get(h,'string'));  % Numerical edit string.
        if E >= L{1} && E <= L{2} % Set slider value to current edit box value.
            set(STR.sl(12),'value',E)  % E falls within range of slider.
        else
            set(h,'string',L{3}) % User tried to set edit box to value out of slider range, 
        end                      % so edit box value remains unchanged. 
    case STR.sl(12) %if slider called
        set(STR.ed(12),'string',get(h,'value')) % Set edit box value to current slider value.
                            
    otherwise
        % Do nothing, or whatever.
end

Tenval=Minit1;
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

alf = get(STR.sl(9),'value'); %  = alpha (new tensor alpha)
bet = get(STR.sl(10),'value'); % = beta (new tensor beta)
gam = get(STR.sl(11),'value'); % = gamma (new tensor gamma)
offset = get(STR.sl(12),'value'); % = offset

%call the main fitting function and plot 
%create the temporary variable arrays: tempx tempy and tempz 
%use inputs = height,width,alpha,beta,gamma,offset (theta),Xorient

scrsz = get(0,'ScreenSize'); %initiate figure  
fhheight = 0.8*scrsz(4);
fhwidth = 0.5*scrsz(3);
fhleft = 0.1*scrsz(3);
fhbottom = 0.1*scrsz(4);

tempx=updatefig_1(Tenval,Orienit,alf,bet,gam,offset,div1,div2); 
subplot('position',[(fhleft-50)/fhwidth,(fhbottom-20)/fhheight,0.45,0.75])
plot(tempx(:,1),tempx(:,2)+theta(1),'r',redat(:,1),redat(:,2),'.k')
set(gca,'YTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360])
axis([min(Range1),max(Range1),ymin1,ymax1])
hold on
for i=2:dimtem(2)/2
    j=2*i-1;
    Thet=theta(j)+offset;
    tempx=updatefig_1(Tenval,Orienit,alf,bet,gam,Thet,div1,div2);
    plot(tempx(:,1),tempx(:,2)+theta(j),'r',redat(:,j),redat(:,j+1),'.k')
end
hold off
xlabel('ppm') 
ylabel('rotation angle (THETA)')
title('Rotation about X-tal Axis')

end %function update_fitb

%***************************************************
function z = updatefig_1(Min,Orient,alf,bet,gam,thet,h,w)

alf = alf*pi/180;
bet = bet*pi/180;
gam = gam*pi/180;
thet = thet*pi/180;

I0=[1 0 0;0 1 0;0 0 1];
Ra=[cos(alf) sin(alf) 0;-sin(alf) cos(alf) 0;0 0 1]; 
Rb=[cos(bet) 0 -sin(bet);0 1 0;sin(bet) 0 cos(bet)];
Rg=[cos(gam) sin(gam) 0;-sin(gam) cos(gam) 0;0 0 1];
Rot = [1 0 0;0 cos(thet) sin(thet);0 -sin(thet) cos(thet)]; %rotations of THETA about lab x-axis

R = Rot*Rg*Rb*Ra*Orient; %transformation tensor -> fist orient - second tweek - third rotate
Minp=R*Min*(R\I0); %transformed tensor to fit data

%{
Note, the following transformation doesn't work!  It's probably obvious, but I don't see it....maybe the matrices don't commute?
R = Orient*Ra*Rb*Rg*Rot; %rotation matrix
Minp=(R\I0)*Min*R; %1st tensor

The test: input a simple diagonal tensor, then change sliders. Do not use Euler angles (from Tensor or XTALFIT1).
Tii will change fits for axes j and k, but not i.
Tij will change fits only for axis k.
If anything else happens - there is a problem.
%}

z = SPECTfit(Minp,h,w); %set-up for two tensors.  Can do more, just edit SPECTfit to accept more tensors....
end %updatefig_1

%**************************************************************************
function z = SPECTfit(Ten1,h,w) 
%Default set-up for two tensors.  Can do more, just edit to accept more tensors....
%f1=frequency shift (zz component) of 1st tensor

global Range1
F=zeros(size(Range1));


for i=1:length(Range1)
   F(i) = 0.3*h*exp(-(Range1(i)-Ten1(3,3)).^2/(2*w^2)); % Gaussian broadened line   
end

z = [Range1,F];
end %function SPECTfit

%**************************************************************************
function [] = pb_load_data(varargin)
%Callback for pushbutton data in. Gets values for alpha, beta, gamma and offset (THETA), 
%then updates the slider/editboxes with these angles (in deg) from a data structure IN_data.
global Range1 dimtem theta ymin1 ymax1 redat Orienit
S = varargin{3}; % Get structure

load OUT_data %get lab-frame x-tal tensor, Euler angles and lab-frame offset angle from OUT_data

Orienit = OUT_data.orn; %initial x-tal orientation in lab frame

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

    alf = OUT_data.ang(1,1); %  = alpha 
    bet = OUT_data.ang(2,1); % = beta 
    gam = OUT_data.ang(3,1); % = gamma 
    ofst = OUT_data.ang(4,1); % = offset    
    
    set(S.sl(9),'value',alf); %  = alpha 
    set(S.ed(9),'str',num2str(alf));
    set(S.sl(10),'value',bet); % = beta
    set(S.ed(10),'str',num2str(bet));
    set(S.sl(11),'value',gam); % = gamma 
    set(S.ed(11),'str',num2str(gam));
    set(S.sl(12),'value',ofst); % = offset
    set(S.ed(12),'str',num2str(ofst));
    
h=get(S.sl(1),'value'); % get the 1st slider value = height
w=get(S.sl(2),'value'); %   "  "  2nd    "     " = width

%update the figure (calculate new tensor, x,y,z plots and fits)

scrsz = get(0,'ScreenSize'); %initiate figure  
fhheight = 0.8*scrsz(4);
fhwidth = 0.5*scrsz(3);
fhleft = 0.1*scrsz(3);
fhbottom = 0.1*scrsz(4);

Fitx = updatefig_1(OUT_data.ten,Orienit,alf,bet,gam,ofst,h,w);
subplot('position',[(fhleft-50)/fhwidth,(fhbottom-20)/fhheight,0.45,0.75])
plot(Fitx(:,1),Fitx(:,2)+theta(1),'r',redat(:,1),redat(:,2),'.k')
set(gca,'YTick',[0 15 30 45 60 75 90 105 120 135 150 165 180 195 210 225 240 255 270 285 300 315 330 345 360])
axis([min(Range1),max(Range1),ymin1,ymax1])
hold on
for i=2:dimtem(2)/2
    j=2*i-1;
    THET=theta(j)+ofst;
    tempx=updatefig_1(OUT_data.ten,Orienit,alf,bet,gam,THET,h,w); %call the main fitting function for each theta
    plot(tempx(:,1),tempx(:,2)+theta(j),'r',redat(:,j),redat(:,j+1),'.k')
end
hold off
xlabel('ppm') 
ylabel('rotation angle (THETA)')
title('Rotation about X-tal Axis')
end %pb_load_xdata
%**************************************************************************

function [] = pb_dump_data(varargin)
%update of Euler angles alpha, beta and gamma is not appropriate since they are different for
%for rotations about xtal orientation

global Orienit

S = varargin{3}; % Get structure
delete('OUT_data.mat')

OUT_data.orn = Orienit; %initial x-tal orientation in lab frame
OUT_data.ang(1,1) = get(S.sl(9),'value'); %alpha
OUT_data.ang(2,1) = get(S.sl(10),'value'); %beta
OUT_data.ang(3,1) = get(S.sl(11),'value'); %gamma
OUT_data.ang(4,1) = get(S.sl(12),'value'); % = x-offset (THETA about x-axis)

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
end %pb_dump_xdata
