function fourierSum(N)

%Computes the Nth partial fourier sum of step function%

M = 2048;

x = linspace(0,pi,M);
x1 = linspace(0,pi/2,M);
x2 = linspace(pi/2,pi,M);


%compute the partial sums%

sum = zeros(1,M);

for k = 1:N;
    if rem(k,2) == 0;
    sum = sum + (2/pi/k)*(-1 + (-1)^(k/2))*sin(k*x);
    else sum = sum + (6/pi/k)*sin(k*x);
    end
end
plot(x1,ones(1,M),x2,2.*ones(1,M),x,sum)

title('Exact Function and Partial Sum')


end
