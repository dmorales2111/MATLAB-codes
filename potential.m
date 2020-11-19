function potential(q,a,b)

%calculates and plots the electrostatic potential of a point charge q in
%space with coordinates a, b, and c%

[X,Y] = meshgrid(-5:.1:5);
phi = q./((X-a).^2 + (Y-b).^2);

surf(X,Y,phi);
colormap hsv
colorbar



