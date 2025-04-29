% COM 서버로 CarSim 실행
h = actxserver('CarSim.Application');

% 홈으로 이동
h.GoHome();

% 원본 데이터 위치
originalTitle = 'External Control, Wrappers';
originalDataSet = 'Baseline COM';

% 복사 대상 카테고리
targetCategory = '* Mass Sweep';
targetDataSet = 'Modified Mass Run';

% 데이터셋 존재 확인
ok = h.DataSetExists('', originalDataSet, originalTitle);
if ~ok
    error('%s 카테고리에서 %s 데이터셋을 찾을 수 없습니다.', originalTitle, originalDataSet);
end

% 기존 복사본 제거
h.DeleteDataSet('', targetDataSet, targetCategory);  % 이미 있을 경우 삭제

% 원본 데이터셋 열기
h.Gotolibrary('', originalDataSet, originalTitle);
h.CreateNew();  % 복제

% 복제본의 위치(카테고리) 및 이름 설정
h.DatasetCategory(targetDataSet, targetCategory);
% 
% % 차량 설정으로 이동 후 무게 변경
% h.Gotolibrary('Vehicles', 'C-Class Hatchback', 'Vehicle Assemblies');
% h.Yellow('#M_SU', '1400');  % 실제 키워드 확인 필요

% 다시 이동한 카테고리로 돌아가서 실행
h.Gotolibrary('Run Control', targetDataSet, targetCategory);
h.Run('', '');

