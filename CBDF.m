function [prob] = CBDF(x1,x2,p,n)


z = 0;
for i = x1:x2;
    z = z + nchoosek(n,i)*(p^i)*(1-p)^(n-i);
end
prob = z;


end

