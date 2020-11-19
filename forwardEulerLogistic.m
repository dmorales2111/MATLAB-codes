function [t,y] = forwardEulerLogistic(tinitial,yinitial,dt,nSteps)

t = [tinitial zeros(1,nSteps)];
y = [yinitial zeros(1,nSteps)];

r = .5;
k = 100;
for l=1:nSteps
    t(l+1) = t(l) + dt;
    y(l+1) = y(l) + dt*(r*y(l)*(1-((1/k)*y(l))));    
end
plot(t,y)

figure

plot(t,y - (k./(1 + (k/yinitial + 1).*exp(-r*t))))
end

