
function [v,d1,d2] = bs(K,S0,sig,r,T)

% bs computes the price of a European call option
%    using the Black-Scholes option pricing formula
%    
% [v,d1,d2] = bs(K,S0,sig,r,T)

d1 = (log(S0/K)+(r+sig^2/2)*T)/(sig*sqrt(T));
d2 = (log(S0/K)+(r-sig^2/2)*T)/(sig*sqrt(T));

v = S0*my_normcdf(d1) - K*exp(-r*T)*my_normcdf(d2);

end

function y = my_normcdf(x)
% computes the cumulative normal distribution

y = 0.5*erfc(-x/sqrt(2));
end