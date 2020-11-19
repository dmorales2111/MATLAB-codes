function [prob,mu,sig] = Binomial(p,n,k)

mu = n*p;
sig = n*p*(1-p);

prob = nchoosek(100,k)*p^(k)*(1-p)^(n-k);
end

