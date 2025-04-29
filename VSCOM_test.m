% COM 서버로 CarSim 실행
h = actxserver('CarSim.Application');
% massList = [1270, 1200, 1400, 1600];
% seed 고정

massMean = 1270; % kg
massCV = 0.1; % Coefficient of Variation (CV)
massList = massMean * (1 + massCV * randn(1, 10)); % Generate random masses

for i = 1:length(massList)
    mass = massList(i);
    runMassSweepCarsim(mass);
    disp(formatted('%d: Mass %d kg completed.\n', i,mass));
end

disp('CarSim COM server finished.');
% runMassSweepCarsim(1600)
