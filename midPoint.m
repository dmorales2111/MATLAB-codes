function [tTrace,y1,y2] = midPoint(t0,y0,dt,nSteps)

y1 = zeros(1,nSteps);
y2 = zeros(1,nSteps);
tTrace = zeros(1,nSteps);

t = t0;
y = y0;

for k=1:nSteps
    
    k1 = rkFunc(t,y);
    y = y + dt*rkFunc(t+0.5*dt,y+0.5*dt*k1);
    
    t = t+dt;

	tTrace(k) = t;
	y1(k) = y(1);
    y2(k) = y(2);
end
   
% add initial condition to vector

y1 = [y0(1) y1];
y2 = [y0(2) y2];
tTrace = [t0 tTrace];
    
end

function yPrime = rkFunc(t,y)

yPrime = zeros(1,length(y));

yPrime(1) =  y(2);
yPrime(2) = -y(1);
end