%models the Magnetic field in a region due to a series of helmholtz coils, using the BCOIL2 function%


A = input('Enter for A (in units of 1.257*10^-6 T*m) '); A = A*(1.257*10^(-6));
R = input('Enter for Bore Radius (in cm) '); R = R/100;
L = input('Enter for length between coils (in cm) '); L = L/100;
n = input('Enter for number of coil pairs '); 
h = input('Enter for initial coil separation (in cm) '); h = h/100;


x = linspace(-4.09,100,1024); z = x/100;
y = zeros(1,1024); 

for i = 1:1024
    for k=1:n
        y(i) = y(i) + BCOIL2(A,R,h+(k*L),z(i));
    end 
end 
Data=xlsread('C:\users\Danil\Documents\Magnet_FG.xlsx', 'A2:C115');

figure
subplot(2,1,1)
plot(Data(:,1),Data(:,2), x,y)
grid on
title('Magnetic Field Map')
xlabel('Distance from Bottom of Magnet (cm)')
ylabel('Magnetic Field (T)')

subplot(2,1,2)
scatter(Data(:,1),Data(:,3), '.')
grid on
title('Gradient Map')
xlabel('Distance from Bottom of Magnet (cm)')
ylabel('Gradient Strength (G/cm)')

