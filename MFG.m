Data=xlsread('C:\users\danil\Documents\Magnet_FG.xlsx', 'A2:C115');

figure
subplot(2,1,1)
plot(Data(:,1),Data(:,2))
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

