function [t,y] = midPointLogistic(tinitial,yinitial,dt,nSteps)

t = [tinitial zeros(1,nSteps)];
y = [yinitial zeros(1,nSteps)];

dT = .5*dt;
r=.5
k= 100
for i = 1:nSteps

t(i+1) = t(i) + dt;
y(i+1) = y(i) + dt*tangentSlope(t(i)+dT, y(i) + dT*tangentSlope(t(i),y(i)))

end

plot (t,y)
figure
plot(t,y - (k./(1 + (k/yinitial + 1).*exp(-r*t))))
end 


function yPrime = tangentSlope (t,y)
r=.5
k= 100
yPrime = r*y*(1 - (y/k));

end