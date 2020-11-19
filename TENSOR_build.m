function [] = TENSOR_build
%Specalized tensor rotating GUI - by P. Stallworth 10/13/16.  This GUI has 
%no command line inputs.  Instead, the operator inputs the tensor initially (in the lab frame) 
%and then adjusts the Euler angles in order to transform from lab frame to PAS frame. 
%There is also a rotation about lab-x-axis. The rotations are observed as a blue, green, and red labeled axes in the
%"test" coordinate system. These coordinates (X", Y", Z") as well as the tensor components (T"ij) vary as the Euler angles are varied.
%The "test" coordinate system becomes the PAS upon diagonalization.

%close all %closes all figures
global Mdat Orien I0
Mdat = [1 0 0;0 1 0;0 0 1]; %predefined input tensor
Orien = [1 0 0;0 1 0;0 0 1]; %predefined x-tal orientation (for output to XTALFIT)
I0 = [1 0 0;0 1 0;0 0 1]; %initiate unit matrix

%After diagonalization, this GUI gives the option that a, b and c be the eigenvalues for the 3x3 tensor (here set to unity.)
%The option is with the "Eigen View" checkbox.  The eigenvectors are orthogonal, only when the tensor is symmetric.
a=1; b=1; c=1; 
prinax=1;

%initiate the axes rotation gui
scrsz = get(0,'ScreenSize'); %initiate figure 
hui.fh = figure('Units','pixels','Position',[0.05*scrsz(3) 0.05*scrsz(4) 0.85*scrsz(3) 0.80*scrsz(4)],...
    'Name','Tensor-Rot',...  %'menubar','none',...
    'Numbertitle','off'); %'ToolBar','none','Tag','fig');
    %'ResizeFcn',@resizeuis);

fhsize = get(hui.fh,'Position');
fhheight = fhsize(4);
fhwidth = fhsize(3);
fhleft = fhsize(1);
fhbottom = fhsize(2);    

axes('Units','normalized','Xlim',[-1 1],'Ylim',[-1 1],'Zlim',[-1 1],...
'YTickLabel',['-1' '-0.8' '-0.6' '-0.4' '-0.2' '0' '0.2' '0.4' '0.6' '0.8' '1'],...
'XTickLabel',['-1','-0.5','0','0.5','1'],'ZTickLabel',['-1' '-0.8' '-0.6' '-0.4' '-0.2' '0' '0.2' '0.4' '0.6' '0.8' '1'],...
'Position',[(fhleft-35+3*fhwidth*0.06+115)/fhwidth (fhbottom+fhheight*0.80-19*fhheight*0.03-145)/fhheight 0.4 0.75],'XGrid','on','YGrid','on','ZGrid','on')


updatefig_rot1(I0,prinax,a,b,c)   %initiates the 3-D plot

hui.txt(1) = uicontrol('style','text','string','gamma','units','normalized','position',...
    [(fhleft-35)/fhwidth (fhbottom+fhheight*0.80-20*fhheight*0.03-130)/fhheight 0.03 0.03],'fontsize',8);
hui.ed(1) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-35+fhwidth*0.03)/fhwidth (fhbottom+fhheight*0.80-20*fhheight*0.03-130)/fhheight 0.03 0.03],'fontsize',8);
hui.sl(1) = uicontrol('style','slider','units','normalized',...
    'position',[(fhleft-35+2*fhwidth*0.03)/fhwidth (fhbottom+fhheight*0.80-20*fhheight*0.03-130)/fhheight (2*fhwidth*0.06+20)/fhwidth 0.03],'sliderstep',[0.005 0.1],...
    'value',0,...%value has to be within min/max range
    'min',-180,'max',180);

%slider2 = Euler angle = beta
hui.txt(2) = uicontrol('style','text','string','beta','units','normalized',...
    'position',[(fhleft-35)/fhwidth (fhbottom+fhheight*0.80-19*fhheight*0.03-125)/fhheight 0.03 0.03],'fontsize',8);
hui.ed(2) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-35+fhwidth*0.03)/fhwidth (fhbottom+fhheight*0.80-19*fhheight*0.03-125)/fhheight 0.03 0.03],'fontsize',8);
hui.sl(2) = uicontrol('style','slider','units','normalized','position',...
    [(fhleft-35+2*fhwidth*0.03)/fhwidth (fhbottom+fhheight*0.80-19*fhheight*0.03-125)/fhheight (2*fhwidth*0.06+20)/fhwidth 0.03],'sliderstep',[0.005 0.1],...
    'value',0,...%value has to be within min/max range
    'min',-180,'max',180);

%slider3 = Euler angle = alpha
hui.txt(3) = uicontrol('style','text','string','alpha','units','normalized','position',...
    [(fhleft-35)/fhwidth (fhbottom+fhheight*0.80-18*fhheight*0.03-120)/fhheight 0.03 0.03],'fontsize',8);
hui.ed(3) = uicontrol('style','edit','string',num2str(0),'units','normalized','position',...
    [(fhleft-35+fhwidth*0.03)/fhwidth (fhbottom+fhheight*0.80-18*fhheight*0.03-120)/fhheight 0.03 0.03],'fontsize',8);
hui.sl(3) = uicontrol('style','slider','units','normalized',...
    'position',[(fhleft-35+2*fhwidth*0.03)/fhwidth (fhbottom+fhheight*0.80-18*fhheight*0.03-120)/fhheight (2*fhwidth*0.06+20)/fhwidth 0.03],'sliderstep',[0.005 0.1],...
    'value',0,...%value has to be within min/max range
    'min',-180,'max',180);

%slider4 = Lab rotation angle (Theta)
hui.txt(4) = uicontrol('style','text','string','Tensor Rotation about Lab-x axis (theta)','units','normalized',...
    'position',[(fhleft-35)/fhwidth (fhbottom+fhheight*0.80-13*fhheight*0.03-95)/fhheight (3*fhwidth*0.06+20)/fhwidth 0.06],'fontsize',11,'background',[0.25 0.75 0.25]);
hui.ed(4) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-35)/fhwidth (fhbottom+fhheight*0.80-14*fhheight*0.03-100)/fhheight 0.06 0.03],'fontsize',8);
hui.sl(4) = uicontrol('style','slider','units','normalized',...
    'position',[(fhleft-35+fhwidth*0.06)/fhwidth (fhbottom+fhheight*0.80-14*fhheight*0.03-100)/fhheight (2*fhwidth*0.06+20)/fhwidth 0.03],'sliderstep',[0.005 0.1],...
    'value',0,...%value has to be within min/max range
    'min',-180,'max',180);

%Initial Tensor components
hui.txt(5) = uicontrol('style','text','string','Input Lab-Frame Tensor Components','units','normalized',...
    'position',[(fhleft-35)/fhwidth (fhbottom+fhheight*0.80+fhheight*0.03+5)/fhheight (3*fhwidth*0.06+20)/fhwidth 0.06],'fontsize',11,'background',[0.25 0.75 0.25]);

hui.txt(43) = uicontrol('style','text','string','Txx','units','normalized',...
    'position',[(fhleft-35)/fhwidth (fhbottom+fhheight*0.80)/fhheight 0.06 0.03],'fontsize',11);
hui.ed(5) = uicontrol('style','edit','string',num2str(1),'units','normalized',...
    'position',[(fhleft-35)/fhwidth (fhbottom+fhheight*0.80-fhheight*0.03-3)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','y');

hui.txt(44) = uicontrol('style','text','string','Txy','units','normalized',...
    'position',[(fhleft-35+fhwidth*0.06+10)/fhwidth (fhbottom+fhheight*0.80)/fhheight 0.06 0.03],'fontsize',11);
hui.ed(6) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-35+fhwidth*0.06+10)/fhwidth (fhbottom+fhheight*0.80-fhheight*0.03-3)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','y');

hui.txt(45) = uicontrol('style','text','string','Txz','units','normalized',...
    'position',[(fhleft-35+2*fhwidth*0.06+20)/fhwidth (fhbottom+fhheight*0.80)/fhheight 0.06 0.03],'fontsize',11);
hui.ed(7) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-35+2*fhwidth*0.06+20)/fhwidth (fhbottom+fhheight*0.80-fhheight*0.03-3)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','y');

hui.txt(46) = uicontrol('style','text','string','Tyx','units','normalized',...
    'position',[(fhleft-35)/fhwidth (fhbottom+fhheight*0.80-2*fhheight*0.03-15)/fhheight 0.06 0.03],'fontsize',11);
hui.ed(8) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-35)/fhwidth (fhbottom+fhheight*0.80-3*fhheight*0.03-18)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','y');

hui.txt(47) = uicontrol('style','text','string','Tyy','units','normalized',...
    'position',[(fhleft-35+fhwidth*0.06+10)/fhwidth (fhbottom+fhheight*0.80-2*fhheight*0.03-15)/fhheight 0.06 0.03],'fontsize',11);
hui.ed(9) = uicontrol('style','edit','string',num2str(1),'units','normalized',...
    'position',[(fhleft-35+fhwidth*0.06+10)/fhwidth (fhbottom+fhheight*0.80-3*fhheight*0.03-18)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','y');

hui.txt(48) = uicontrol('style','text','string','Tyz','units','normalized',...
    'position',[(fhleft-35+2*fhwidth*0.06+20)/fhwidth (fhbottom+fhheight*0.80-2*fhheight*0.03-15)/fhheight 0.06 0.03],'fontsize',11);
hui.ed(10) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-35+2*fhwidth*0.06+20)/fhwidth (fhbottom+fhheight*0.80-3*fhheight*0.03-18)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','y');

hui.txt(49) = uicontrol('style','text','string','Tzx','units','normalized',...
    'position',[(fhleft-35)/fhwidth (fhbottom+fhheight*0.80-4*fhheight*0.03-30)/fhheight 0.06 0.03],'fontsize',11);
hui.ed(11) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-35)/fhwidth (fhbottom+fhheight*0.80-5*fhheight*0.03-33)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','y');

hui.txt(50) = uicontrol('style','text','string','Tzy','units','normalized',...
    'position',[(fhleft-35+fhwidth*0.06+10)/fhwidth (fhbottom+fhheight*0.80-4*fhheight*0.03-30)/fhheight 0.06 0.03],'fontsize',11);
hui.ed(12) = uicontrol('style','edit','string',num2str(0),'units','normalized',...
    'position',[(fhleft-35+fhwidth*0.06+10)/fhwidth (fhbottom+fhheight*0.80-5*fhheight*0.03-33)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','y');

hui.txt(51) = uicontrol('style','text','string','Tzz','units','normalized',...
    'position',[(fhleft-35+2*fhwidth*0.06+20)/fhwidth (fhbottom+fhheight*0.80-4*fhheight*0.03-30)/fhheight 0.06 0.03],'fontsize',11);
hui.ed(13) = uicontrol('style','edit','string',num2str(1),'units','normalized',...
    'position',[(fhleft-35+2*fhwidth*0.06+20)/fhwidth (fhbottom+fhheight*0.80-5*fhheight*0.03-33)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','y');    

%Oriented Axes relative to Lab
hui.txt(6) = uicontrol('style','text','string','Transformed Axes (PAS) w.r.t. Lab','units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+3*fhwidth*0.06+160)/fhwidth (fhbottom+fhheight*0.80-7*fhheight*0.03-75)/fhheight (3*fhwidth*0.06+20)/fhwidth 2*fhheight*0.03/fhheight],...
    'fontsize',11,'background',[0.25 0.75 0.25]);
hui.txt(7) = uicontrol('style','text','string','blue','units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+3*fhwidth*0.06+160)/fhwidth (fhbottom+fhheight*0.80-8*fhheight*0.03-81)/fhheight 0.06 0.03],...
    'fontsize',11,'background','c');
hui.txt(8) = uicontrol('style','text','string','X"-axis (a)','units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+3*fhwidth*0.06+160)/fhwidth (fhbottom+fhheight*0.80-9*fhheight*0.03-81)/fhheight 0.06 0.03],'fontsize',10,'background','c');
hui.txt(9) = uicontrol('style','text','string','green','units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+4*fhwidth*0.06+170)/fhwidth (fhbottom+fhheight*0.80-8*fhheight*0.03-81)/fhheight 0.06 0.03],'fontsize',11,'background','g');
hui.txt(10) = uicontrol('style','text','string','Y"-axis (b)','units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+4*fhwidth*0.06+170)/fhwidth (fhbottom+fhheight*0.80-9*fhheight*0.03-81)/fhheight 0.06 0.03],'fontsize',10,'background','g');
hui.txt(11) = uicontrol('style','text','string','red','units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+5*fhwidth*0.06+180)/fhwidth (fhbottom+fhheight*0.80-8*fhheight*0.03-81)/fhheight 0.06 0.03],'fontsize',11,'background','r');
hui.txt(12) = uicontrol('style','text','string','Z"-axis (c)','units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+5*fhwidth*0.06+180)/fhwidth (fhbottom+fhheight*0.80-9*fhheight*0.03-81)/fhheight 0.06 0.03],'fontsize',10,'background','r');

hui.txt(13) = uicontrol('style','text','string',num2str(I0(1,1)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+3*fhwidth*0.06+160)/fhwidth (fhbottom+fhheight*0.80-10*fhheight*0.03-87)/fhheight 0.06 0.03],'fontsize',11);
hui.txt(14) = uicontrol('style','text','string',num2str(I0(2,1)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+3*fhwidth*0.06+160)/fhwidth (fhbottom+fhheight*0.80-11*fhheight*0.03-93)/fhheight 0.06 0.03],'fontsize',11);
hui.txt(15) = uicontrol('style','text','string',num2str(I0(3,1)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+3*fhwidth*0.06+160)/fhwidth (fhbottom+fhheight*0.80-12*fhheight*0.03-99)/fhheight 0.06 0.03],'fontsize',11);

hui.txt(16) = uicontrol('style','text','string',num2str(I0(1,2)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+4*fhwidth*0.06+170)/fhwidth (fhbottom+fhheight*0.80-10*fhheight*0.03-87)/fhheight 0.06 0.03],'fontsize',11);
hui.txt(17) = uicontrol('style','text','string',num2str(I0(2,2)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+4*fhwidth*0.06+170)/fhwidth (fhbottom+fhheight*0.80-11*fhheight*0.03-93)/fhheight 0.06 0.03],'fontsize',11);
hui.txt(18) = uicontrol('style','text','string',num2str(I0(3,2)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+4*fhwidth*0.06+170)/fhwidth (fhbottom+fhheight*0.80-12*fhheight*0.03-99)/fhheight 0.06 0.03],'fontsize',11);

hui.txt(19) = uicontrol('style','text','string',num2str(I0(1,3)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+5*fhwidth*0.06+180)/fhwidth (fhbottom+fhheight*0.80-10*fhheight*0.03-87)/fhheight 0.06 0.03],'fontsize',11);
hui.txt(20) = uicontrol('style','text','string',num2str(I0(2,3)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+5*fhwidth*0.06+180)/fhwidth (fhbottom+fhheight*0.80-11*fhheight*0.03-93)/fhheight 0.06 0.03],'fontsize',11);
hui.txt(21) = uicontrol('style','text','string',num2str(I0(3,3)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+5*fhwidth*0.06+180)/fhwidth (fhbottom+fhheight*0.80-12*fhheight*0.03-99)/fhheight 0.06 0.03],'fontsize',11);

%initiate the tensor figure with text and output of rotated tensor
hui.txt(40) = uicontrol('style','text','string','Transformed Tensor w.r.t. Lab-frame','units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+3*fhwidth*0.06+160)/fhwidth (fhbottom+fhheight*0.80+fhheight*0.03+5)/fhheight (3*fhwidth*0.06+20)/fhwidth 0.06],...
    'fontsize',11,'background',[0.25 0.75 0.25]);

hui.txt(22) = uicontrol('style','text','string','T"xx','units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+3*fhwidth*0.06+160)/fhwidth (fhbottom+fhheight*0.80)/fhheight 0.06 0.03],...
    'fontsize',11);
hui.txt(23) = uicontrol('style','text','string',num2str(Mdat(1,1)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+3*fhwidth*0.06+160)/fhwidth (fhbottom+fhheight*0.80-fhheight*0.03-3)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','c');

hui.txt(24) = uicontrol('style','text','string','T"xy','units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+4*fhwidth*0.06+170)/fhwidth (fhbottom+fhheight*0.80)/fhheight 0.06 0.03],'fontsize',11);
hui.txt(25) = uicontrol('style','text','string',num2str(Mdat(1,2)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+4*fhwidth*0.06+170)/fhwidth (fhbottom+fhheight*0.80-fhheight*0.03-3)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','y');

hui.txt(26) = uicontrol('style','text','string','T"xz','units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+5*fhwidth*0.06+180)/fhwidth (fhbottom+fhheight*0.80)/fhheight 0.06 0.03],'fontsize',11);
hui.txt(27) = uicontrol('style','text','string',num2str(Mdat(1,3)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+5*fhwidth*0.06+180)/fhwidth (fhbottom+fhheight*0.80-fhheight*0.03-3)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','y');

hui.txt(28) = uicontrol('style','text','string','T"yx','units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+3*fhwidth*0.06+160)/fhwidth (fhbottom+fhheight*0.80-2*fhheight*0.03-15)/fhheight 0.06 0.03],'fontsize',11);
hui.txt(29) = uicontrol('style','text','string',num2str(Mdat(2,1)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+3*fhwidth*0.06+160)/fhwidth (fhbottom+fhheight*0.80-3*fhheight*0.03-18)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','y');

hui.txt(30) = uicontrol('style','text','string','T"yy','units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+4*fhwidth*0.06+170)/fhwidth (fhbottom+fhheight*0.80-2*fhheight*0.03-15)/fhheight 0.06 0.03],'fontsize',11);
hui.txt(31) = uicontrol('style','text','string',num2str(Mdat(2,2)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+4*fhwidth*0.06+170)/fhwidth (fhbottom+fhheight*0.80-3*fhheight*0.03-18)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','g');

hui.txt(32) = uicontrol('style','text','string','T"yz','units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+5*fhwidth*0.06+180)/fhwidth (fhbottom+fhheight*0.80-2*fhheight*0.03-15)/fhheight 0.06 0.03],'fontsize',11);
hui.txt(33) = uicontrol('style','text','string',num2str(Mdat(2,3)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+5*fhwidth*0.06+180)/fhwidth (fhbottom+fhheight*0.80-3*fhheight*0.03-18)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','y');

hui.txt(34) = uicontrol('style','text','string','T"zx','units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+3*fhwidth*0.06+160)/fhwidth (fhbottom+fhheight*0.80-4*fhheight*0.03-30)/fhheight 0.06 0.03],'fontsize',11);
hui.txt(35) = uicontrol('style','text','string',num2str(Mdat(3,1)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+3*fhwidth*0.06+160)/fhwidth (fhbottom+fhheight*0.80-5*fhheight*0.03-33)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','y');

hui.txt(36) = uicontrol('style','text','string','T"zy','units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+4*fhwidth*0.06+170)/fhwidth (fhbottom+fhheight*0.80-4*fhheight*0.03-30)/fhheight 0.06 0.03],'fontsize',11);
hui.txt(37) = uicontrol('style','text','string',num2str(Mdat(3,2)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+4*fhwidth*0.06+170)/fhwidth (fhbottom+fhheight*0.80-5*fhheight*0.03-33)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','y');

hui.txt(38) = uicontrol('style','text','string','T"zz','units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+5*fhwidth*0.06+180)/fhwidth (fhbottom+fhheight*0.80-4*fhheight*0.03-30)/fhheight 0.06 0.03],'fontsize',11);
hui.txt(39) = uicontrol('style','text','string',num2str(Mdat(3,3)),'units','normalized',...
    'position',[(fhleft-35+0.4*fhwidth+5*fhwidth*0.06+180)/fhwidth (fhbottom+fhheight*0.80-5*fhheight*0.03-33)/fhheight 0.06 0.03],...
    'fontsize',11,'backg','r');

%Initial Orientation
%X-tal Offset (Euler angle adjust)
hui.txt(41) = uicontrol('style','text','units','normalized',...
    'string','X-tal Orientation with B-field along lab-z axis',...
    'position',[(fhleft-35)/fhwidth (fhbottom+fhheight*0.80-7*fhheight*0.03-75)/fhheight (3*fhwidth*0.06+20)/fhwidth (2*fhheight*0.03)/fhheight],'fontsize',11,'background',[0.25 0.75 0.25]);

hui.txt(42) = uicontrol('style','text','string','"Test-frame" Offset (Euler angles)','units','normalized',...
    'position',[(fhleft-35)/fhwidth (fhbottom+fhheight*0.80-17*fhheight*0.03-115)/fhheight (3*fhwidth*0.06+20)/fhwidth 0.06],'fontsize',11,'background',[0.25 0.75 0.25]);
%{
hui.txt(52) = uicontrol('style','text','string','Lab Z-axis projection','position',[600 740 150 25],'fontsize',12);
hui.txt(53) = uicontrol('style','text','string',num2str(Mdat(3,3)),'position',[620 710 110 25],...
    'fontsize',12,'backg','r');
%}

hui.bg = uibuttongroup('units','normalized',...
                     'pos',[(fhleft-35)/fhwidth (fhbottom+fhheight*0.80-10*fhheight*0.03-80)/fhheight (3*fhwidth*0.06+20)/fhwidth (3*fhheight*0.03)/fhheight]);


huiscrsz = get(hui.bg,'Position');
huileft = huiscrsz(1);
huibottom = huiscrsz(2);
huiwidth = huiscrsz(3);
huiheight = huiscrsz(4);


hui.rd(1) = uicontrol(hui.bg,...
                    'style','rad',...
                    'unit','normalized',...
                    'position',[0 (huiheight*0.5)/huiheight (1/3) 0.5],...
                    'string','rot@X", Z"||B0');

hui.rd(2) = uicontrol(hui.bg,...
                    'style','rad',...
                    'unit','normalized',...
                    'position',[0 0 (1/3) 0.5],...
                    'string','rot@X", Y"||B0');

hui.rd(3) = uicontrol(hui.bg,...
                    'style','rad',...
                    'unit','normalized',...
                    'position',[(1/3) 0.5 (1/3) 0.5],...
                    'string','rot@Y", Z"||B0');

hui.rd(4) = uicontrol(hui.bg,...
                    'style','rad',...
                    'unit','normalized',...
                    'position',[(1/3) 0 (1/3) 0.5],...
                    'string','rot@Y", X"||B0');

hui.rd(5) = uicontrol(hui.bg,...
                    'style','rad',...
                    'unit','normalized',...
                    'position',[2*(1/3) 0.5 (1/3) 0.5],...
                    'string','rot@Z", X"||B0');

hui.rd(6) = uicontrol(hui.bg,...
                    'style','rad',...
                    'unit','normalized',...
                    'position',[2*(1/3) 0 (1/3) 0.5],...
                    'string','rot@Z", Y"||B0');

hui.ch(1) = uicontrol('style','check',...
                 'unit','normalized',...
                 'position',[0.45 (fhbottom+fhheight*0.80+fhheight*0.03+5)/fhheight 0.07 0.03],...
                 'string','Eigen View',...
                 'fontsize',11,'BackgroundColor',[1 0.5 1]);
             
hui.ch(2) = uicontrol('style','check',...
                 'unit','normalized',...
                 'position',[0.45 (fhbottom+fhheight*0.80+0.07*fhheight)/fhheight 0.07 0.03],...
                 'string','X-tal View',...
                 'fontsize',11,'BackgroundColor',[1 0.5 1]);                     

hui.pb(1) = uicontrol('style','pushbutton',...
                'units','normalized','BackgroundColor',[1 0.5 1],...
                'position',[(fhleft-35+0.4*fhwidth+4*fhwidth*0.06+170)/fhwidth (fhbottom+fhheight*0.80-15*fhheight*0.03-111)/fhheight 0.06 2*0.03],...
                'string','Refine','fontsize',11,...
                'callback',{@pb_refine,hui});   

hui.pb(2) = uicontrol('style','pushbutton',...
                'units','normalized','BackgroundColor',[1 0.5 0],...
                'position',[(fhleft-35+0.4*fhwidth+3*fhwidth*0.06+160)/fhwidth (fhbottom+fhheight*0.80-18*fhheight*0.03-120)/fhheight 0.09 2*0.03],...
                'string','OUT_data','fontsize',11,...
                'callback',{@pb_datadump,hui});               

hui.pb(3) = uicontrol('style','pushbutton',...
                'units','normalized','BackgroundColor',[0 0.5 0],...
                'position',[(fhleft-35+0.4*fhwidth+3*fhwidth*0.09+180)/fhwidth (fhbottom+fhheight*0.80-18*fhheight*0.03-120)/fhheight 0.09 2*0.03],...
                'string','IN_data','fontsize',11,...
                'callback',{@pb_dataload,hui});             
                        
set([hui.sl,hui.ed,hui.rd,hui.txt,hui.ch],'callback',{@vec_rot,hui}); %this line does it all!       
end

%##################################################
function [] = vec_rot(varargin)
% Orient the axes.
global Mdat Orien I0
[h,S] = deal(varargin{[1,3]});  % Get the [address,structure].

switch h  % Who called, edit box or slider?
    case S.ed(1) %if 1st edit box called
        L = get(S.sl(1),{'min','max','value'});  % Get the slider's info.
        E = str2double(get(h,'string'));  % Numerical edit string.
        if E >= L{1} && E <= L{2} % Set slider value to current edit box value.
            set(S.sl(1),'value',E)  % E falls within range of slider.
        else
            set(h,'string',L{3}) % User tried to set edit box to value out of slider range, 
        end                      % so edit box value remains unchanged. 
    case S.sl(1) %if slider called
        set(S.ed(1),'string',get(h,'value')) % Set edit box value to current slider value.

    case S.ed(2) %if 2nd edit box called
        L = get(S.sl(2),{'min','max','value'});  % Get the slider's info.
        E = str2double(get(h,'string'));  % Numerical edit string.
        if E >= L{1} && E <= L{2} % Set slider value to current edit box value.
            set(S.sl(2),'value',E)  % E falls within range of slider.
        else
            set(h,'string',L{3}) % User tried to set edit box to value out of slider range, 
        end                      % so edit box value remains unchanged. 
    case S.sl(2) %if slider called
        set(S.ed(2),'string',get(h,'value')) % Set edit box value to current slider value.
  
    case S.ed(3) %if 3rd edit box called
        L = get(S.sl(3),{'min','max','value'});  % Get the slider's info.
        E = str2double(get(h,'string'));  % Numerical edit string.
        if E >= L{1} && E <= L{2} % Set slider value to current edit box value.
            set(S.sl(3),'value',E)  % E falls within range of slider.
        else
            set(h,'string',L{3}) % User tried to set edit box to value out of slider range, 
        end                      % so edit box value remains unchanged. 
    case S.sl(3) %if slider called
        set(S.ed(3),'string',get(h,'value')) % Set edit box value to current slider value.

    case S.ed(4) %if 4th edit box called
        L = get(S.sl(4),{'min','max','value'});  % Get the slider's info.
        E = str2double(get(h,'string'));  % Numerical edit string.
        if E >= L{1} && E <= L{2} % Set slider value to current edit box value.
            set(S.sl(4),'value',E)  % E falls within range of slider.
        else
            set(h,'string',L{3}) % User tried to set edit box to value out of slider range, 
        end                      % so edit box value remains unchanged. 
    case S.sl(4) %if slider called
        set(S.ed(4),'string',get(h,'value')) % Set edit box value to current slider value.
        
    otherwise
        % Do nothing, or whatever.
end 

switch findobj(get(S.bg,'selectedobject'))
    case S.rd(1)
       Xor = 1; %rot X" || lab x, z||B0
    case S.rd(2)
       Xor = 2; %rot X" || lab x, y||B0
    case S.rd(3)
       Xor = 3; %rot Y" || lab x, z||B0
    case S.rd(4) 
       Xor = 4; %rot Y" || lab x, x||B0
    case S.rd(5)
       Xor = 5; %rot Z" || lab x, x||B0
    case S.rd(6)
       Xor = 6; %rot Z" || lab x, y||B0
    otherwise
       Xor = 1;
end

%Xtal orientations 
if Xor == 1
    Orient = [1 0 0;0 1 0;0 0 1]; %rot about crystal x-axis||lab x, with z-xtal along B0 initially (y-xtal along -y-lab)
elseif Xor == 2
    Orient = [1 0 0;0 0 -1;0 1 0]; %rot about crystal x-axis||lab x, with y-xtal along B0 initially (z-xtal along -y-lab)
elseif Xor == 3
    Orient = [0 1 0;-1 0 0;0 0 1]; %rot about crystal y-axis||lab x, with z-xtal along B0 initially (x-xtal along -y-lab)
elseif Xor == 4
    Orient = [0 1 0;0 0 1;1 0 0]; %rot about crystal y-axis||lab x, with x-xtal along B0 initially (z-xtal along y-lab)
elseif Xor == 5
    Orient = [0 0 1;0 -1 0;1 0 0]; %rot about crystal z-axis||lab x, with x-xtal along B0 initially (y-xtal along -y-lab)
else
    Orient = [0 0 1;1 0 0;0 1 0]; %rot about crystal z-axis||lab x, with y-xtal along B0 initially (x-xtal along y-lab)
end
 Orien = Orient; %Reset the global (not sure how to handle this?)
 
    Mdat(1,1) = str2double(get(S.ed(5),'string')); %input Lab-frame Tensor
    Mdat(1,2) = str2double(get(S.ed(6),'string'));
    Mdat(1,3) = str2double(get(S.ed(7),'string'));
    Mdat(2,1) = str2double(get(S.ed(8),'string'));
    Mdat(2,2) = str2double(get(S.ed(9),'string'));
    Mdat(2,3) = str2double(get(S.ed(10),'string'));
    Mdat(3,1) = str2double(get(S.ed(11),'string'));
    Mdat(3,2) = str2double(get(S.ed(12),'string'));
    Mdat(3,3) = str2double(get(S.ed(13),'string'));
    
    singtest = log(cond(Mdat));
    if singtest > 5
        disp('check for matrix singularity')
        Mdat=[1 0 0;0 1 0;0 0 1];
    end
F1 = get(S.sl(1),'value')*pi/180;  % get the value for gamma.
F2 = get(S.sl(2),'value')*pi/180;  % get the value for beta.
F3 = get(S.sl(3),'value')*pi/180;  % get the value for alpha.
F4 = get(S.sl(4),'value')*pi/180;  % get the value for THETA.

Ralfa=[cos(F3) sin(F3) 0;-sin(F3) cos(F3) 0;0 0 1]; 
Rbeta=[cos(F2) 0 -sin(F2);0 1 0;sin(F2) 0 cos(F2)];
Rgamm=[cos(F1) sin(F1) 0;-sin(F1) cos(F1) 0;0 0 1];
Rot = [1 0 0;0 cos(F4) sin(F4);0 -sin(F4) cos(F4)]; %rotations of THETA about lab x-axis

%rotates tensor w.r.t. lab - use inverse of a matrix = (M\I0)
%NOTE inverse of a non-singular matrix using inv(M) or M^(-1) is not accurate in MATLAB
R = Rot*Orien*Rgamm*Rbeta*Ralfa; %transformation from Lab-frame to X-tal frame to PAS-frame
Mdatout=(R\I0)*Mdat*R;

%rotates the lab w.r.t. test-frame (except for the axes field, just replace "Test-frame" with "Lab-frame" and vice versa in GUI)
%RLab = Orien*Ralfa*Rbeta*Rgamm*Rot; 

%show the tensor (the components T"ij = transformation wrt lab) 
        set(S.txt(23),'str',num2str(Mdatout(1,1),4)); 
        set(S.txt(25),'str',num2str(Mdatout(1,2),4)); 
        set(S.txt(27),'str',num2str(Mdatout(1,3),4));
        set(S.txt(29),'str',num2str(Mdatout(2,1),4));
        set(S.txt(31),'str',num2str(Mdatout(2,2),4));
        set(S.txt(33),'str',num2str(Mdatout(2,3),4)); 
        set(S.txt(35),'str',num2str(Mdatout(3,1),4));
        set(S.txt(37),'str',num2str(Mdatout(3,2),4));
        set(S.txt(39),'str',num2str(Mdatout(3,3),4));    

%show the unit vectors (the vectors are the columns of R)

        set(S.txt(13),'str',num2str(R(1,1),4)); 
        set(S.txt(14),'str',num2str(R(2,1),4)); %blue xtal X"
        set(S.txt(15),'str',num2str(R(3,1),4));
 
        set(S.txt(16),'str',num2str(R(1,2),4));
        set(S.txt(17),'str',num2str(R(2,2),4)); %green xtal Y"
        set(S.txt(18),'str',num2str(R(3,2),4)); 
 
        set(S.txt(19),'str',num2str(R(1,3),4));
        set(S.txt(20),'str',num2str(R(2,3),4)); %red xtal Z"
        set(S.txt(21),'str',num2str(R(3,3),4));     
        
%For Eigen view (rotated axes take on abs magnitudes from tensor diagonal components)
if get(S.ch(1),'Value') == get(S.ch(1),'Max') %note that for a checkbox the 'Max' state is 'when checked'
          %Redefine a, b, c and prinax to see relative sizes of eigenvalues a, b and c.
            ai=abs(Mdatout(1,1));
            bi=abs(Mdatout(2,2));
            ci=abs(Mdatout(3,3));
          %make prinax equal to whichever has largest magnitude a, b and c
            if ai > bi && ai > ci
                px = ai;
            elseif bi > ci
                px = bi;
            else
                px = ci;
            end
            if get(S.ch(2),'Value') == get(S.ch(2),'Max')
                %update the figure (3-D plot with x-tal axes and surface dimensions defined by px,ai,bi,ci)
                updatefig_rot2(R,px,ai,bi,ci)
            else
                %update the figure (3-D plot with x-tal axes dimensions defined by px,ai,bi,ci)
                updatefig_rot1(R,px,ai,bi,ci)
            end
else
       ai = 1; bi = 1; ci = 1; px = 1;
            if get(S.ch(2),'Value') == get(S.ch(2),'Max')
                %update the figure (3-D plot with x-tal axes and surface dimensions of unit dimensions)
                updatefig_rot2(R,px,ai,bi,ci)
            else
                %update the figure (3-D plot with x-tal axes of unit dimensions)
                updatefig_rot1(R,px,ai,bi,ci)
            end
end

end %vec_rot

%**************************************************************************
function [] = pb_refine(varargin)
%Callback for pushbutton #1. Gets rough slider values for alpha, beta and
%gamma, then optimizes these angles for diagonalization (Tij = 0, for i~=j)
%Then updates GUI (figure, Tensor components, Rot. Axes, etc.)

global Mdat Orien I0
S = varargin{3}; % Get structure

Parstr = [1 1 1];%preallocate initial angles in Parstart
Parstr(1) = get(S.sl(1),'value')*pi/180;  % get the value for gamma.
Parstr(2) = get(S.sl(2),'value')*pi/180;  % get the value for beta.
Parstr(3) = get(S.sl(3),'value')*pi/180;  % get the value for alpha.

Ra=[cos(Parstr(3)) sin(Parstr(3)) 0;-sin(Parstr(3)) cos(Parstr(3)) 0;0 0 1]; 
Rb=[cos(Parstr(2)) 0 -sin(Parstr(2));0 1 0;sin(Parstr(2)) 0 cos(Parstr(2))];
Rg=[cos(Parstr(1)) sin(Parstr(1)) 0;-sin(Parstr(1)) cos(Parstr(1)) 0;0 0 1];

R = Orien*Rg*Rb*Ra; %transformation from Lab-frame to X-tal frame to PAS-frame
Md=(R\I0)*Mdat*R;

temp=trace(abs(Md));
if temp ~= 0
    chisqjunk = (sum(sum(abs(Md)))-temp)/temp; %not a chi-square
else
    chisqjunk = sum(sum(abs(Md)));
end 

f1=Parstr(1)*180/pi; f2=Parstr(2)*180/pi; f3=Parstr(3)*180/pi; %convert Euler angles to degrees

disp(['start alpha = ' num2str(f3) 'deg']);
disp(['start beta = ' num2str(f2) 'deg']);
disp(['start gamma = ' num2str(f1) 'deg']);
disp(['start error = ' num2str(chisqjunk)]);
disp('..... ');
%disp('      ');

%FVAL and EXITFLAG can be useful if troubleshooting is needed, disp(FVAL) = chi-square value
%[Parend, FVAL, EXITFLAG] = fminsearch(@calcobj,Parstr); %optimization subroutine (earlier Matlab versions)
[Parend, FVAL] = fminsearch(@calcobj,Parstr); 
%[Parend, FVAL, EXITFLAG] = patternsearch(@calcobj,Parstr); %a better optimization subroutine
%[Parend, FVAL] = patternsearch(@calcobj,Parstr); 
%disp(EXITFLAG); %outcome of optimization: 1 = convergence, 0 = maximum iterations occurred, -1 = termination
%disp('..... ');

Ra = [cos(Parend(3)) sin(Parend(3)) 0;-sin(Parend(3)) cos(Parend(3)) 0;0 0 1]; 
Rb = [cos(Parend(2)) 0 -sin(Parend(2));0 1 0;sin(Parend(2)) 0 cos(Parend(2))];
Rg = [cos(Parend(1)) sin(Parend(1)) 0;-sin(Parend(1)) cos(Parend(1)) 0;0 0 1];

R = Orien*Rg*Rb*Ra; %transformation from Lab-frame to X-tal frame to PAS-frame
Md = (R\I0)*Mdat*R; 

%rotates the lab w.r.t. tensor (except for the axes field, just replace "Test-frame" with "Lab-frame" and vice versa in GUI)
%RLab = Ra*Rb*Rg*Orien; 

f1=Parend(1)*180/pi; f2=Parend(2)*180/pi; f3=Parend(3)*180/pi;
F1=f1-floor(f1/180)*180; F2=f2-floor(f2/180)*180; F3=f3-floor(f3/180)*180; %used below to find the angle (within the range)
        FF3 = abs(F3 - f3); %error in Euler angle refinement, see below for to-screen info
        FF2 = abs(F2 - f2);
        FF1 = abs(F1 - f1);
testpm=sum(Parend(abs(Parend)>180)); %Zero if all elements in Parend (optimized angles) are in the range -180 to 180.

if testpm ~= 0 %Zero sliders and editboxes for the Euler angles
    disp('optimization yields erroneous result: alpha, beta and/gamma > 90deg!');
    disp('Re-construct x-tal frame tensor');
    set(S.sl(1),'value',0);  % zero the value for gamma.
    set(S.ed(1),'str',num2str(0));
    set(S.sl(2),'value',0);  % zero the value for beta.
    set(S.ed(2),'str',num2str(0));
    set(S.sl(3),'value',0);  % zero the value for alpha.
    set(S.ed(3),'str',num2str(0));
    set(S.sl(4),'value',0);  % set the value for x-tal rotation (offset) to zero.
    set(S.ed(4),'str',num2str(0));        
else
%update sliders and editboxes to the Refined Euler angles
    set(S.sl(1),'value',F1);  % set the value for gamma.
    set(S.ed(1),'str',num2str(F1));
    set(S.sl(2),'value',F2);  % set the value for beta.
    set(S.ed(2),'str',num2str(F2));
    set(S.sl(3),'value',F3);  % set the value for alpha.
    set(S.ed(3),'str',num2str(F3));
    set(S.sl(4),'value',0);  % set the value for x-tal rotation (offset) to zero.
    set(S.ed(4),'str',num2str(0));        

%update the tensor (the components T"ij) to refined values
    set(S.txt(23),'str',num2str(Md(1,1),4)); 
    set(S.txt(25),'str',num2str(Md(1,2),4)); 
    set(S.txt(27),'str',num2str(Md(1,3),4));
    set(S.txt(29),'str',num2str(Md(2,1),4));
    set(S.txt(31),'str',num2str(Md(2,2),4));
    set(S.txt(33),'str',num2str(Md(2,3),4)); 
    set(S.txt(35),'str',num2str(Md(3,1),4));
    set(S.txt(37),'str',num2str(Md(3,2),4));
    set(S.txt(39),'str',num2str(Md(3,3),4));     

%update the unit x-tal frame vectors (the vectors are the columns of R)
    set(S.txt(13),'str',num2str(R(1,1),4)); 
    set(S.txt(14),'str',num2str(R(2,1),4)); %blue xtal X"
    set(S.txt(15),'str',num2str(R(3,1),4));
 
    set(S.txt(16),'str',num2str(R(1,2),4));
    set(S.txt(17),'str',num2str(R(2,2),4)); %green xtal Y"
    set(S.txt(18),'str',num2str(R(3,2),4)); 
 
    set(S.txt(19),'str',num2str(R(1,3),4));
    set(S.txt(20),'str',num2str(R(2,3),4)); %red xtal Z"
    set(S.txt(21),'str',num2str(R(3,3),4));     
    
disp(['end alpha = ' num2str(f3) 'deg']);
disp(['end beta = ' num2str(f2) 'deg']);
disp(['end gamma = ' num2str(f1) 'deg']);
disp('   ')

disp('Optimization errors should be 0deg, if not, hit Refine again (or tweek Euler angles)');
disp(['alpha optimization error = ' num2str(FF3) 'deg']);
disp(['beta optimization error = ' num2str(FF2) 'deg']);
disp(['gamma optimization error = ' num2str(FF1) 'deg']);
disp('     ');
%{
disp(['    ' 'Optimized Diagonal Tensor' '       ']);
disp([Md(1,1) Md(1,2) Md(1,3)]); 
disp('     ');
disp([Md(2,1) Md(2,2) Md(2,3)]); 
disp('     ');
disp([Md(3,1) Md(3,2) Md(3,3)]); 
disp('     ');
disp(['    ' 'Optimized Eigen Vectors' '       ']);
disp(['blue xtal X"  :[' num2str(R(1,1)) ', ' num2str(R(2,1)) ', ' num2str(R(3,1)),'] ']); 
disp('     ');
disp(['green xtal Y"   :[' num2str(R(1,2)) ', ' num2str(R(2,2)) ', ' num2str(R(3,2)),'] ']); 
disp('     ');
disp(['red xtal Z"    :[' num2str(R(1,3)) ', ' num2str(R(2,3)) ', ' num2str(R(3,3)),'] ']);
disp('     ');
%}
    disp(['end error = ' num2str(FVAL)]); %end error
    disp('     ');

%plot cartesian axes in unscaled or "Eigen" and "X-tal" views
%For Eigen view (rotated axes take on abs magnitudes from tensor diagonal components)
if get(S.ch(1),'Value') == get(S.ch(1),'Max') %note that for a checkbox the 'Max' state is 'when checked'
          %Redefine a, b, c and prinax to see relative sizes of eigenvalues a, b and c.
            ai=abs(Md(1,1));
            bi=abs(Md(2,2));
            ci=abs(Md(3,3));
          %make prinax equal to whichever has largest magnitude a, b and c
            if ai > bi && ai > ci
                px = ai;
            elseif bi > ci
                px = bi;
            else
                px = ci;
            end
            if get(S.ch(2),'Value') == get(S.ch(2),'Max')
                %update the figure (3-D plot with x-tal axes and surface dimensions defined by px,ai,bi,ci)
                updatefig_rot2(R,px,ai,bi,ci)
            else
                %update the figure (3-D plot with x-tal axes dimensions defined by px,ai,bi,ci)
                updatefig_rot1(R,px,ai,bi,ci)
            end
else
       ai = 1; bi = 1; ci = 1; px = 1;
            if get(S.ch(2),'Value') == get(S.ch(2),'Max')
                %update the figure (3-D plot with x-tal axes and surface of unit dimensions)
                updatefig_rot2(R,px,ai,bi,ci)
            else
                %update the figure (3-D plot with x-tal axes of unit dimensions)
                updatefig_rot1(R,px,ai,bi,ci)
            end
end

end %pb_refine
%***************************************************
function err = calcobj(par)
Ra=[cos(par(3)) sin(par(3)) 0;-sin(par(3)) cos(par(3)) 0;0 0 1]; 
Rb=[cos(par(2)) 0 -sin(par(2));0 1 0;sin(par(2)) 0 cos(par(2))];
Rg=[cos(par(1)) sin(par(1)) 0;-sin(par(1)) cos(par(1)) 0;0 0 1];

R = Orien*Rg*Rb*Ra;
Md = (R\I0)*Mdat*R;

temp=trace(abs(Md));

% need scalar error for fminsearch/patternsearch
    if temp ~= 0
        err = (sum(sum(abs(Md)))-temp)/temp;
    else
        err = sum(sum(abs(Md)));
    end  
end %calcobj

%close(S.fh)  %closes the figure after optimization
end %calcobj
%**************************************************************************
function [] = pb_datadump(varargin)
%Callback for pushbutton #2. Gets slider values for alpha, beta, gamma and
%THETA, then saves these angles (in deg) along with the lab-frame tensor in
%a data structure OUT_data.

global Mdat Orien
S = varargin{3}; % Get structure

OUT_data.ten = Mdat;
OUT_data.orn = Orien;
OUT_data.ang(1,1) = get(S.sl(3),'value');  % get the value for alpha in deg.
OUT_data.ang(2,1) = get(S.sl(2),'value');  % get the value for beta in deg.
OUT_data.ang(3,1) = get(S.sl(1),'value');  % get the value for gamma in deg.
OUT_data.ang(4,1) = get(S.sl(4),'value');  % get the value for lab rotation THETA (considered as an offset).

save OUT_data OUT_data %save Euler angles and lab-frame tensor to m-file called OUT_data
end %pb_datadump
%**************************************************************************
function [] = pb_dataload(varargin)
%Callback for pushbutton #3. Gets values for alpha, beta, gamma and
%THETA, then updates the slider/editboxes with these angles (in deg) from a data structure IN_data.
global Mdat Orien I0

S = varargin{3}; % Get structure

load OUT_data %get Euler angles and lab-frame offset angle from IN_data

f1 = OUT_data.ang(1,1);  % get the value for alpha.
f2 = OUT_data.ang(2,1);  % get the value for beta.
f3 = OUT_data.ang(3,1);  % get the value for gamma.
f4 = OUT_data.ang(4,1); %new lab-frame rotation (x_tal offset)

Orien = OUT_data.orn; %update initial x-tal orientation in lab frame
orlab = Olab(Orien);
    
    if orlab == 7
        set(S.rd(1),'value',1)
    elseif orlab == -1
        set(S.rd(2),'value',1)
    elseif orlab == 1
        set(S.rd(3),'value',1)
    elseif orlab == 2 
        set(S.rd(4),'value',1)    
    elseif orlab == -5
        set(S.rd(5),'value',1)
    elseif orlab == 0
        set(S.rd(6),'value',1)
    end

Mdat = OUT_data.ten; 

%update the lab-frame tensor (the components Tij)
        set(S.ed(5),'str',num2str(Mdat(1,1),4)); 
        set(S.ed(6),'str',num2str(Mdat(1,2),4)); 
        set(S.ed(7),'str',num2str(Mdat(1,3),4));
        set(S.ed(8),'str',num2str(Mdat(2,1),4));
        set(S.ed(9),'str',num2str(Mdat(2,2),4));
        set(S.ed(10),'str',num2str(Mdat(2,3),4)); 
        set(S.ed(11),'str',num2str(Mdat(3,1),4));
        set(S.ed(12),'str',num2str(Mdat(3,2),4));
        set(S.ed(13),'str',num2str(Mdat(3,3),4));     

%update sliders and editboxes to the New Euler angles (from XTALFIT)
    set(S.sl(3),'value',f1);  % get the value for alpha.
    set(S.ed(3),'str',num2str(f1));        
    set(S.sl(2),'value',f2);  % get the value for beta.
    set(S.ed(2),'str',num2str(f2));        
    set(S.sl(1),'value',f3);  % get the value for gamma.
    set(S.ed(1),'str',num2str(f3));        
    set(S.sl(4),'value',f4);  % get the value for x-tal rotation (offset).
    set(S.ed(4),'str',num2str(f4));        
    
Parstr = [0 0 0 0];%preallocate initial angles in radians 
Parstr(1) = f3*pi/180;  % gamma.
Parstr(2) = f2*pi/180;  % beta.
Parstr(3) = f1*pi/180;  % alpha.
Parstr(4) = f4*pi/180;  % offset.

Ra=[cos(Parstr(3)) sin(Parstr(3)) 0;-sin(Parstr(3)) cos(Parstr(3)) 0;0 0 1]; 
Rb=[cos(Parstr(2)) 0 -sin(Parstr(2));0 1 0;sin(Parstr(2)) 0 cos(Parstr(2))];
Rg=[cos(Parstr(1)) sin(Parstr(1)) 0;-sin(Parstr(1)) cos(Parstr(1)) 0;0 0 1];
Rot = [1 0 0;0 cos(Parstr(4)) sin(Parstr(4));0 -sin(Parstr(4)) cos(Parstr(4))]; %rotations of THETA about lab x-axis

R = Rot*Orien*Rg*Rb*Ra;
Md=(R\I0)*Mdat*R;

%rotates the lab w.r.t. tensor (except for the axes field, just replace "Test-frame" with "Lab-frame" and vice versa in GUI)
%RLab = Orien*Ra*Rb*Rg*Rot; 

%update the tensor (the components T"ij) to imported adjustments
    set(S.txt(23),'str',num2str(Md(1,1),4)); 
    set(S.txt(25),'str',num2str(Md(1,2),4)); 
    set(S.txt(27),'str',num2str(Md(1,3),4));
    set(S.txt(29),'str',num2str(Md(2,1),4));
    set(S.txt(31),'str',num2str(Md(2,2),4));
    set(S.txt(33),'str',num2str(Md(2,3),4)); 
    set(S.txt(35),'str',num2str(Md(3,1),4));
    set(S.txt(37),'str',num2str(Md(3,2),4));
    set(S.txt(39),'str',num2str(Md(3,3),4));     
   
%update the unit x-tal vectors wrt lab (the vectors are the cols of R)
    set(S.txt(13),'str',num2str(R(1,1),4)); 
    set(S.txt(14),'str',num2str(R(2,1),4)); %blue xtal X"
    set(S.txt(15),'str',num2str(R(3,1),4));
 
    set(S.txt(16),'str',num2str(R(1,2),4));
    set(S.txt(17),'str',num2str(R(2,2),4)); %green xtal Y"
    set(S.txt(18),'str',num2str(R(3,2),4)); 
 
    set(S.txt(19),'str',num2str(R(1,3),4));
    set(S.txt(20),'str',num2str(R(2,3),4)); %red xtal Z"
    set(S.txt(21),'str',num2str(R(3,3),4));     

    
%plot cartesian axes in unscaled or "Eigen view"
%For Eigen view (rotated axes take on abs magnitudes from tensor diagonal components)
if get(S.ch(1),'Value') == get(S.ch(1),'Max') %note that for a checkbox the 'Max' state is 'when checked'
          %Redefine a, b, c and prinax to see relative sizes of eigenvalues a, b and c.
            ai=abs(Md(1,1));
            bi=abs(Md(2,2));
            ci=abs(Md(3,3));
          %make prinax equal to whichever has largest magnitude a, b and c
            if ai > bi && ai > ci
                px = ai;
            elseif bi > ci
                px = bi;
            else
                px = ci;
            end
            if get(S.ch(2),'Value') == get(S.ch(2),'Max')
                %update the figure (3-D plot with x-tal axes and surface dimensions defined by px,ai,bi,ci)
                updatefig_rot2(R,px,ai,bi,ci)
            else
                %update the figure (3-D plot with x-tal axes dimensions defined by px,ai,bi,ci)
                updatefig_rot1(R,px,ai,bi,ci)
            end
else
       ai = 1; bi = 1; ci = 1; px = 1;
            if get(S.ch(2),'Value') == get(S.ch(2),'Max')
                %update the figure (3-D plot with x-tal axes and surface of unit dimensions)
                updatefig_rot2(R,px,ai,bi,ci)
            else
                %update the figure (3-D plot with x-tal axes of unit dimensions)
                updatefig_rot1(R,px,ai,bi,ci)
            end
end

end %pb_dataload
%**************************************************************************
%test for initial X-tal Orientation 
function z = Olab(MaTrx)
veC = MaTrx*[1;2;3]; %orientation matrix operating on an arbitrary vector
z = trace(MaTrx) + veC(2) - veC(1) + veC(3); %unique condition for each orientation
end
%**************************************************************************
function [] = updatefig_rot1(Rp,prnx,aa,bb,cc) %Rp=Eigenvector matrix, aa=x-eigenvalue, bb=y-eigenvalue, cc=z-eigenvalue
%plots X-tal Axes 
%plot cartesian axes with length defined by prinax
AxEs=[-prnx 0 0;prnx 0 0];
plot3(AxEs(:,1),AxEs(:,2),AxEs(:,3),'k')
view([142.5,30]);
hold on
grid
AyEs=[0 -prnx 0;0 prnx 0];
plot3(AyEs(:,1),AyEs(:,2),AyEs(:,3),'k')
AzEs=[0 0 -prnx;0 0 prnx];
plot3(AzEs(:,1),AzEs(:,2),AzEs(:,3),'k')
daspect([1 1 1]) %fix aspect ratio for fig
        
tmp1 = Rp*[aa 0 0]'; %column eigenvector of magnitude aa
tmp2 = Rp*[0 bb 0]'; %column eigenvector of magnitude bb
tmp3 = Rp*[0 0 cc]'; %column eigenvector of magnitude cc

%the 3 orthogonal x-tal vector axes:
Ax1=[-tmp1';tmp1']; %2 row x 3 column 
Ax2=[-tmp2';tmp2'];
Ax3=[-tmp3';tmp3'];        

%Unit Vectors (2 point plot = unit vector...morphing towards Principal axes)
Pnts = [tmp1';tmp2';tmp3']; %3 row x 3 column
plot3(Ax1(:,1),Ax1(:,2),Ax1(:,3),'Color',[0 0.75 1],'LineWidth',5) %x-tal X"
plot3(Ax2(:,1),Ax2(:,2),Ax2(:,3),'Color',[0.5 1 0],'LineWidth',5) %x-tal Y"
plot3(Ax3(:,1),Ax3(:,2),Ax3(:,3),'Color',[1 0.25 0],'LineWidth',5) %x-tal Z"
plot3(Pnts(:,1),Pnts(:,2),Pnts(:,3),'.k','MarkerSize',50) %black unit vector frontcaps  
%plot3(0,0,0,'.k','MarkerSize',50) %origin
%plot3(0,0,0,'oy','MarkerSize',19) %origin

% Plot labels
xlabel('lab-x')
ylabel('lab-y')
zlabel('lab-z')  
hold off    
end %updatefig_rot1
%**************************************************************************
function [] = updatefig_rot2(Rp,prnx,aa,bb,cc) %Rp=Eigenvector matrix, aa=x-eigenvalue, bb=y-eigenvalue, cc=z-eigenvalue
%plots X-tal Axes and Surfaces
%plot cartesian axes with length defined by prinax
AxEs=[-prnx 0 0;prnx 0 0];
plot3(AxEs(:,1),AxEs(:,2),AxEs(:,3),'k')
view([142.5,30]);
hold on
grid
AyEs=[0 -prnx 0;0 prnx 0];
plot3(AyEs(:,1),AyEs(:,2),AyEs(:,3),'k')
AzEs=[0 0 -prnx;0 0 prnx];
plot3(AzEs(:,1),AzEs(:,2),AzEs(:,3),'k')
daspect([1 1 1]) %fix aspect ratio for fig
        
tmp1 = Rp*[aa 0 0]'; %column eigenvector of magnitude aa
tmp2 = Rp*[0 bb 0]'; %column eigenvector of magnitude bb
tmp3 = Rp*[0 0 cc]'; %column eigenvector of magnitude cc

%the 3 orthogonal x-tal vector axes:
Ax1=[-tmp1';tmp1']; %2 row x 3 column 
Ax2=[-tmp2';tmp2'];
Ax3=[-tmp3';tmp3'];        

%Unit Vectors (2 point plot = unit vector...morphing towards Principal axes)
Pnts = [tmp1';tmp2';tmp3']; %3 row x 3 column
plot3(Ax1(:,1),Ax1(:,2),Ax1(:,3),'Color',[0 0.75 1],'LineWidth',5) %x-tal X"
plot3(Ax2(:,1),Ax2(:,2),Ax2(:,3),'Color',[0.5 1 0],'LineWidth',5) %x-tal Y"
plot3(Ax3(:,1),Ax3(:,2),Ax3(:,3),'Color',[1 0.25 0],'LineWidth',5) %x-tal Z"
plot3(Pnts(:,1),Pnts(:,2),Pnts(:,3),'.k','MarkerSize',50) %black unit vector frontcaps  
%plot3(0,0,0,'.k','MarkerSize',50) %origin
%plot3(0,0,0,'oy','MarkerSize',19) %origin

%Plot of X-tal Surfaces
%the surface is constructed by specifying the 4-corners (x,y,z,c) with the last entry  being a value from the color scale.
%Do this for 6 surfaces (2 for each x-tal vector)
%3 col X 4 row = sufrace defined by 4 points (each point given by a row)
SF1p = [(Ax1(2,:)+Ax2(2,:)+Ax3(2,:))/2; (Ax1(2,:)+Ax2(2,:)+Ax3(1,:))/2; (Ax1(2,:)+Ax2(1,:)+Ax3(1,:))/2; (Ax1(2,:)+Ax2(1,:)+Ax3(2,:))/2];
SF1m = [(Ax1(1,:)+Ax2(2,:)+Ax3(2,:))/2; (Ax1(1,:)+Ax2(2,:)+Ax3(1,:))/2; (Ax1(1,:)+Ax2(1,:)+Ax3(1,:))/2; (Ax1(1,:)+Ax2(1,:)+Ax3(2,:))/2];
patch(SF1p(:,1), SF1p(:,2), SF1p(:,3),'c') 
patch(SF1m(:,1), SF1m(:,2), SF1m(:,3),'c') 

SF2p = [(Ax1(2,:)+Ax2(2,:)+Ax3(2,:))/2; (Ax1(2,:)+Ax2(2,:)+Ax3(1,:))/2; (Ax1(1,:)+Ax2(2,:)+Ax3(1,:))/2; (Ax1(1,:)+Ax2(2,:)+Ax3(2,:))/2];
SF2m = [(Ax1(2,:)+Ax2(1,:)+Ax3(2,:))/2; (Ax1(2,:)+Ax2(1,:)+Ax3(1,:))/2; (Ax1(1,:)+Ax2(1,:)+Ax3(1,:))/2; (Ax1(1,:)+Ax2(1,:)+Ax3(2,:))/2];
patch(SF2p(:,1), SF2p(:,2), SF2p(:,3),'g') 
patch(SF2m(:,1), SF2m(:,2), SF2m(:,3),'g') 

SF3p = [(Ax1(2,:)+Ax2(2,:)+Ax3(2,:))/2; (Ax1(1,:)+Ax2(2,:)+Ax3(2,:))/2; (Ax1(1,:)+Ax2(1,:)+Ax3(2,:))/2; (Ax1(2,:)+Ax2(1,:)+Ax3(2,:))/2];
SF3m = [(Ax1(2,:)+Ax2(2,:)+Ax3(1,:))/2; (Ax1(1,:)+Ax2(2,:)+Ax3(1,:))/2; (Ax1(1,:)+Ax2(1,:)+Ax3(1,:))/2; (Ax1(2,:)+Ax2(1,:)+Ax3(1,:))/2];
patch(SF3p(:,1), SF3p(:,2), SF3p(:,3),'r') 
patch(SF3m(:,1), SF3m(:,2), SF3m(:,3),'r') 

% Plot labels
xlabel('lab-x')
ylabel('lab-y')
zlabel('lab-z')  
hold off    
end %updatefig_rot2