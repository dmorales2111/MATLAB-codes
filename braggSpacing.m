function [d] = braggSpacing(lambda,ang)
%returns d-spacing dpeending on wavelength of xray and bragg angle

d = lambda/(2*sin(ang/2*pi/180))*1e10;


