function [tTrace,y1,y2,y3,y4] = rk4(t0,y0,dt,nSteps)

y1 = zeros(1,nSteps);
y2 = zeros(1,nSteps);
y3 = zeros(1,nSteps);
y4 = zeros(1,nSteps);
tTrace = zeros(1,nSteps);

t = t0;
y = y0;

for k=1:nSteps
    
    k1 = rkFunc(t,y);
    k2 = rkFunc(t+0.5*dt,y+0.5*dt*k1);
    k3 = rkFunc(t+0.5*dt,y+0.5*dt*k2);
    k4 = rkFunc(t+dt,y+dt*k3);
    
    y = y + dt/6*(k1+2*k2+2*k3+k4);
    
    t = t+dt;

	tTrace(k) = t;
	y1(k) = y(1);
    y2(k) = y(2);
    y3(k) = y(3);
    y4(k) = y(4);
end
   
% add initial condition to vector

y1 = [y0(1) y1];
y2 = [y0(2) y2];
y3 = [y0(3) y3];
y4 = [y0(4) y4];
tTrace = [t0 tTrace];

end

function yPrime = rkFunc(t,y)

a = -20*10^50;
b = -1*10^62;
mu = 6*10^24;
yPrime = zeros(1,length(y));

yPrime(1) = y(2);
yPrime(2) = y(4)^2*y(1)+((a/(mu*y(1)^2))+b/(mu*y(1)^3));
yPrime(3) = y(4);
yPrime(4) = -2*y(4)*y(2)/y(1);
end