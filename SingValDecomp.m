function [alpha,singularValues] = SingValDecomp(r,t,n)
%UNTITLED Summary of this function goes here
%   This function takes in a value or reflectivity 0<r<1 and transmission 0<t<1 and produces singular
%   values for the Scattering Matrix S.

dx = 1/n;
alpha = linspace(dx,1,n);
singularValues = zeros(1,n);
S = zeros(4,4);

for j = 1:n
    
S(1,1) = t;
S(1,2) = sqrt(.5*((t-r)/alpha(j) - r*t - 1));
S(1,3) = r;
S(2,1) = sqrt(.5*((t-r)/alpha(j) - r*t - 1));
S(2,2) = t;
S(3,1) = r;
S(3,3) = t;
S(3,4) = sqrt(.5*((t-r)/alpha(j) - r*t - 1));
S(4,3) = sqrt(.5*((t-r)/alpha(j) - r*t - 1));
S(4,4) = t;


q = svd(S);

singularValues(1,j) = q(1);
end

