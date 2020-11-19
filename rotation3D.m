function r = rotation3D(sig11, sig22, sig33, theta, psi)

%For a given Theta and Psi, maps a 3-D rotation and its inverse on a state 
%sigma as a function of Phi and returns resultant v_33 
%sig11, sig22, sig33 = diagonal values of state sigma

syms phi
rTheta = [1 0 0; 0 cos(theta) sin(theta); 0 -sin(theta) cos(theta)];
rPhi = [cos(phi) sin(phi) 0; -sin(phi) cos(phi) 0,; 0 0 1];


rPsi = [1 0 0; 0 cos(psi) sin(psi); 0 -sin(psi) cos(psi)];
rTrans = [0 -1 0; 1 0 0; 0 0 1];

sigma = [sig11 0 0; 0 sig22 0; 0 0 sig33];


Ph = linspace(0,2*pi, 128);

v33 = zeros(128,2); 

for k = 1:128
    a = subs(rPhi, phi, Ph(k)); b = rTheta*a; c = inv(rPsi)*inv(rTrans)*inv(b)*sigma*rPsi*rTrans*b;
    v33(k,1) = Ph(k); 
    v33(k,2) = c(3,3);
end

r = v33;




