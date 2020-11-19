
% Example:

% [x,y,y0,ya] = rkheat(128);
% plot(x,y0,x,y,x,ya,'o')

function [x,y,y0,ya] = rkfokkerplanck(n)

% initial condition

x = linspace(-10,10,n);

dxs = (x(2)-x(1))^2;

y0 = 1/sqrt(2*pi)*exp(-x.^2/2);

y = y0;

tMax = 1;
nSteps = 1000;
dt = tMax/nSteps;

fdt = 1.0/6.0*dt;

for k=1:nSteps
	
    k1 = rkFunc(y,dxs);
	k2 = rkFunc(y+0.5*dt*k1,dxs);
    k3 = rkFunc(y+0.5*dt*k2,dxs);
    k4 = rkFunc(y+dt*k3,dxs);
	
    y = y + fdt*(k1+2*k2+2*k3+k4);
end

% done with numerics, compute
% analytical solution

ya = 1/sqrt(2*pi*2)*exp(-x.^2/4);

end

% System of ODEs 

function yPrime = rkFunc(y,dxs)

m = length(y);

D = 0.5;

dx = sqrt(dxs);
yPrime = zeros(1,m);
sigma = .5;

yPrime(1) = sigma^2/2*(y(2)-2*y(1))/dxs + D*(y(2)-y(1))*y(1)/dx + D*y(1);

for k=2:m-1
    yPrime(k) =  sigma^2/2*(y(k+1)-2*y(k)+y(k-1))/dxs + D*(y(k+1)-y(k))*y(k)/dx + D*y(k);
end

yPrime(m) = sigma^2/2*(-2*y(m)+y(m-1))/dxs + D*(-y(m))*y(m)/dx + D*y(m);

end

