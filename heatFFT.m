% heatFFT Solve heat equation using fft

N = 128; % number of grid points

% Set up computational grid

xMin = -10; xMax = 10; xDomain = xMax-xMin;

dx = xDomain/N;

x = linspace(xMin, xMax-dx, N);
    
% Fourier space discretization

dom = 2*pi/xDomain; om = [0:N/2,-N/2+1:-1]*dom;

f = zeros(1,N); f(N/2+1) = 1/dx; % delta in real space (discretized) 
fnumF = fft(f).*exp(-om.^2*t/2); % propagate Fourier modes
fnum = real(ifft(fnumF));        % inverse transform

fana = 1/sqrt(2*pi*t)*exp(-x.^2/(2*t)); % analytical solution

% plot results

plot(x,fnum,x,fana,'o')

