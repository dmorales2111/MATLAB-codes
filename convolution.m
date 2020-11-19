%computes the convolution of two functions (represented as column vectors)
%by transforming the functions into vectors, computing the FFT of each,and
%computing the IFFT of the product.%

N = 2048;

x = linspace(-10,10, N);
%initialize the vectors, then populate the vectors according to functions
f = exp(-3.*x.^2);
g = exp(-4.*x.^2);

%next, compute the FFT of each%  

F = fft(f);
G = fft(g);


%multiply and take the IFFT%

conv = (1/sqrt(2*N*pi))*(fftshift(ifft(F.*G)));
conv = conv(1:N);
figure
subplot(3,1,1)
plot(x,conv)
title('Convolution by FFT')

subplot(3,1,2)
plot(x,sqrt(pi/7)*exp(-12.*(x.^2)/7))
title('Convolution by analytics')

subplot(3,1,3)
plot(x, sqrt(pi/7)*exp(-12.*(x.^2)/7) - conv)
title('error of FFT convolution')
