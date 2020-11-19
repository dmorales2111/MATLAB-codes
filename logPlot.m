function logPlot(file)

A = importdata(file);

x = A(:,1);
y = A(:,2);

semilogy(x,y)
title('XRD')
xlabel('2Theta')
ylabel('Log(Counts)')










