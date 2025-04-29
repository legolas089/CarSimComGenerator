
% COM 서버로 CarSim 실행
h = actxserver('CarSim.Application');
massList = [1270, 1200, 1400, 1600];
for mass = massList
    runMassSweepCarsim(mass)

end

%% Overlay 설정 추가
h.GoHome();  % 안전하게 홈으로 이동

targetRunName = 'Run_1270kg';
targetCategory = '* Mass Sweep';

% Run_1270kg 위치로 이동
h.Gotolibrary('Run Control', targetRunName, targetCategory);
[libName, dataSetName, categoryName] = h.GetCurrentLibInfo();

% 출력
fprintf('📍 현재 위치:\n');
fprintf('Library   : %s\n', libName);
fprintf('Dataset   : %s\n', dataSetName);
fprintf('Category  : %s\n', categoryName);

% Overlay Videos 블루링크에 다른 무게 버전 추가
overlayMassList = [1200, 1400, 1600];  % Overlay에 추가할 무게 리스트
overlayIndex = 23;  % #BlueLink0부터 시작

for mass = overlayMassList
    overlayRunName = ['Run_' num2str(mass) 'kg'];
    keyword = ['#BlueLink' num2str(overlayIndex)];
    h.BlueLink(keyword, 'Run Control', overlayRunName, targetCategory);
    fprintf('🔗 Overlay에 "%s" 추가 완료 (Keyword: %s)\n', overlayRunName, keyword);
    overlayIndex = overlayIndex + 1;
end

fprintf('✅ Overlay Videos 설정 완료!\n');
