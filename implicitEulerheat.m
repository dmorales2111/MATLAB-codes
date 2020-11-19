% Example:

% [x,z,y0,ya] = forwardEulerheat(128);
% plot(x,y0,x,y,x,ya,'o')

function [x,y,y0,ya] = implicitEulerheat(n)

% initial condition

x = linspace(-10,10,n);

dxs = (x(2)-x(1))^2;

y0 = 1/sqrt(2*pi)*exp(-x.^2/2);

tMax = 1;
nSteps = 1;
dt = tMax/nSteps;

kappa = .5;

lambda = (kappa*dt/dxs);

A = zeros(n,n);

for i = 1:n-1;
    A(i,i) = (1-2*lambda);
    A(i+1,i) = lambda;
    A(i,i+1) = lambda;
end
A(n,n) = (1-2*lambda);
A(n,n-1) = lambda;
A(n-1,n) = lambda;

y = y0;
z = A*transpose(y); 
y = y + transpose(z);


ya = 1/sqrt(2*pi)*exp(-x.^2/2);

end



