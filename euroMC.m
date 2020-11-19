function [v, vAna] = euroMC(N)
% euroMC.m Monte-Carlo simulation for Black-Scholes
%          no interest rates

S0 = 100; K = 100; sig = 0.3; T = 1;

nSteps = 252; dt = T/nSteps;

S = S0*ones(N,1); % set initial condition

for k=1:nSteps
   S = S + S*sig*sqrt(dt).*randn(N,1); % solve SDE
end

v = sum(max(S-K,0))/N; % numerical option price

d1 = (log(S0/K)+sig^2/2*T)/(sig*sqrt(T));
d2 = (log(S0/K)-sig^2/2*T)/(sig*sqrt(T));

Nd1 = 0.5*erfc(-d1/sqrt(2)); Nd2 = 0.5*erfc(-d2/sqrt(2));

vAna = S0*Nd1 - K*Nd2; % analytical option price

end
