% Example:

% [x,y,y0,ya] = forwardEulerheat(128);
% plot(x,y0,x,y,x,ya,'o')

function [x,y,y0,ya] = forwardEulerheat(n)

% initial condition

x = linspace(-10,10,n);

dxs = (x(2)-x(1))^2;

y0 = 1/sqrt(2*pi)*exp(-x.^2/2);

y = y0;

tMax = 1;
nSteps = 1000;
dt = tMax/nSteps;


for k=1:nSteps
	
    k1 = rkFunc(y,dxs);
	
    y = y + dt*(k1);
end

% done with numerics, compute
% analytical solution

ya = 1/sqrt(2*pi)*exp(-x.^2/2);

end

% System of ODEs 

function yPrime = rkFunc(y,dxs)

m = length(y);

D = 0.5;

yPrime = zeros(1,m);

yPrime(1) = D*(y(2)-2*y(1))/dxs;

for k=2:m-1
    yPrime(k) =  D*(y(k+1)-2*y(k)+y(k-1))/dxs; 
end

yPrime(m) = D*(-2*y(m)+y(m-1))/dxs;

end

