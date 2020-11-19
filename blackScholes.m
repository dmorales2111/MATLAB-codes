function V = blackScholes(S0, K, r, sig, T)

%Black-Scholes Formula, which calculates the value of a European Call
%Option with initial value S0 (in dollars), strike price K (dollars), interest rate r and volatility
%sig (in percent), and time T in years.

rp = r/100;
sigp = sig/100;

d1= log(S0/K) + (rp + (sigp^2/2))*T/(sigp*sqrt(T));
d2= log(S0/K) + (rp - (sigp^2/2))*T/(sigp*sqrt(T));


b = S0*N(d1)-K*exp(-rp*T)*N(d2);
V = vpa(b,4)
end

function a = N(d)
%cumulative Normal Distribution
syms x
a = 1/sqrt(2*pi)*int(exp((-x^2)/2), -inf, d);
end