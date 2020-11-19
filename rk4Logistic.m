function [tTrace,y1] = rk4Logistic(t0,y0,dt,nSteps)

y1 = zeros(1,nSteps);
tTrace = zeros(1,nSteps);

t = t0;
y = y0;

r = .5
K = 100
for k=1:nSteps
    
    k1 = rkFunc(t,y);
    k2 = rkFunc(t+0.5*dt,y+0.5*dt*k1);
    k3 = rkFunc(t+0.5*dt,y+0.5*dt*k2);
    k4 = rkFunc(t+dt,y+dt*k3);
    
    y = y + dt/6*(k1+2*k2+2*k3+k4);
    
    t = t+dt;

	tTrace(k) = t;
	y1(k) = y(1);
end
   
% add initial condition to vector

y1 = [y0(1) y1];
tTrace = [t0 tTrace];

end

function yPrime = rkFunc(t,y)

r = .5
k = 100

yPrime = zeros(1,length(y));

yPrime(1) =  r*y(1)*(1 - y(1)/k);

end