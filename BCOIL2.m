function z = BCOIL2(A,R,h,d)

%A = constant, R = magnet bore radius 
%h = distance between coils
%d = field point
 z = (A/R)*((1/(((d-(h/2))^2)/(R^2)))^(3/2) + (1/(((d+(h/2))^2)/(R^2)))^(3/2));
