% COM 서버로 CarSim 실행
h = actxserver('CarSim.Application');
h.GoHome();  % 초기 위치로 이동

% 예: Vehicles > Vehicle: Assembly > C-Class, Hatchback: No ABS 로 이동
h.Gotolibrary('Vehicle: Assembly', '', '');
% 현재 위치 확인
[libName, dataSetName, categoryName] = h.GetCurrentLibInfo();

% 출력
fprintf('📍 현재 위치:\n');
fprintf('Library   : %s\n', libName);
fprintf('Dataset   : %s\n', dataSetName);
fprintf('Category  : %s\n', categoryName);

h.GoHome();
[libName, dataSetName, categoryName] = h.GetCurrentLibInfo();

% 출력
fprintf('📍 현재 위치:\n');
fprintf('Library   : %s\n', libName);
fprintf('Dataset   : %s\n', dataSetName);
fprintf('Category  : %s\n', categoryName);

h.Gotolibrary('Vehicle: Sprung Mass', '', '');
[libName, dataSetName, categoryName] = h.GetCurrentLibInfo();

% 출력
fprintf('📍 현재 위치:\n');
fprintf('Library   : %s\n', libName);
fprintf('Dataset   : %s\n', dataSetName);
fprintf('Category  : %s\n', categoryName);
