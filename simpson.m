function v = simpson(a,b,n)

% SIMPSON computes a definite integral using Simpson's rule
% n needs to be odd

x = linspace(a,b,n);

dx = x(2)-x(1);

v = intf(x(1))+intf(x(end)); % end points
v = v + 4*sum(intf(x(2:2:end-1)));
v = v + 2*sum(intf(x(3:2:end-2)));

v = v/3*dx;

end


function v = intf(x)

v=  1./(x.^2 + 4.*x + 13).^2;

end


%simpson(-10000,10000, 100000001)