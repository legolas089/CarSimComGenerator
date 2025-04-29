
%% Function

function runMassSweepCarsim(mass)
    % COM 시작
    h = actxserver('CarSim.Application');
    h.GoHome();
    
    %% 설정 값 정의
    
    % Run Control 원본 정보
    originalRunLib  = 'Run Control';
    originalRunName = 'Baseline COM';
    originalRunCat  = 'External Control, Wrappers';
    
    % 복제 Run Control
    newRunName = ['Run_' num2str(mass) 'kg'];
    targetCat  = '* Mass Sweep';
    
    % Vehicle Assembly 원본 정보
    originalVehLib  = 'Vehicle: Assembly';  % 이게 Library 이름임
    originalVehName = 'C-Class, Hatchback: No ABS';
    
    % 복제 Vehicle
    newVehName = ['Vehicle_' num2str(mass) 'kg'];
    
    
    
    %% Run Control 복제 (기존 삭제 포함)
    
    % 기존 Run Control 복제본이 있으면 삭제
    if h.DataSetExists(originalRunLib, newRunName, targetCat)
        h.DeleteDataSet(originalRunLib, newRunName, targetCat);
        fprintf('🗑️ 기존 Run Control "%s" 삭제됨\n', newRunName);
    end
    
    % Run Control 이동 및 복제
    h.Gotolibrary(originalRunLib, originalRunName, originalRunCat);
    h.CreateNew();
    h.DatasetCategory(newRunName, targetCat);
    fprintf('✅ Run Control "%s" 복제 완료\n', newRunName);
    
    %% Vehicle Assembly 복제 (기존 삭제 포함)
    
    % 기존 Vehicle 복제본이 있으면 삭제
    if h.DataSetExists(originalVehLib, newVehName, targetCat)
        h.DeleteDataSet(originalVehLib, newVehName, targetCat);
        fprintf('🗑️ 기존 Vehicle "%s" 삭제됨\n', newVehName);
    end
    
    % Vehicle 이동 및 복제
    h.Gotolibrary(originalVehLib, '', '');
    h.CreateNew();
    h.DatasetCategory(newVehName, targetCat);
    fprintf('✅ Vehicle "%s" 복제 완료\n', newVehName);
    [libName, dataSetName, categoryName] = h.GetCurrentLibInfo();
    
    % 출력
    fprintf('📍 현재 위치:\n');
    fprintf('Library   : %s\n', libName);
    fprintf('Dataset   : %s\n', dataSetName);
    fprintf('Category  : %s\n', categoryName);
    
    h.GoHome()
    h.BlueLink('#BlueLink2', originalVehLib, newVehName, targetCat);
    fprintf('🔗 Run Control "%s"에 Vehicle "%s" 연결 완료\n', newRunName, newVehName);
    
    
    %% Vehicle: Sprung Mass 복제
    originalSprungMassLib  = 'Vehicle: Sprung Mass';
    originalSprungMassName = 'C-Class, Hatchback SM';
    originalSprungMassCat  = 'C-Class';
    
    newSprungMassName = ['SprungMass_' num2str(mass) 'kg'];
    
    h.Gotolibrary(originalSprungMassLib, '', '');
    [libName, dataSetName, categoryName] = h.GetCurrentLibInfo();
    
    % 출력
    fprintf('📍 현재 위치:\n');
    fprintf('Library   : %s\n', libName);
    fprintf('Dataset   : %s\n', dataSetName);
    fprintf('Category  : %s\n', categoryName);
    
    
    
    % 기존 복제본 있으면 삭제
    if h.DataSetExists(originalSprungMassLib, newSprungMassName, targetCat)
        h.DeleteDataSet(originalSprungMassLib, newSprungMassName, targetCat);
        fprintf('🗑️ 기존 Sprung Mass "%s" 삭제됨\n', newSprungMassName);
    end
    
    % 복제 수행
    h.Gotolibrary(originalSprungMassLib, originalSprungMassName, originalSprungMassCat);
    h.CreateNew();
    h.DatasetCategory(newSprungMassName, targetCat);
    fprintf('✅ Sprung Mass "%s" 복제 완료\n', newSprungMassName);
    
    %% 복제된 Vehicle로 이동해서 Sprung Mass 연결
    h.Gotolibrary(originalVehLib, newVehName, targetCat);
    
    % 정확한 BlueLink 키워드 확인 필요 (예: #BlueLink4)
    h.BlueLink('#BlueLink0', originalSprungMassLib, newSprungMassName, targetCat);
    fprintf('🔗 Vehicle "%s"에 Sprung Mass "%s" 연결 완료\n', newVehName, newSprungMassName);
    
    %% SprungMass_%kg으로 이동해서 M_SU 설정
    h.Gotolibrary(originalSprungMassLib, newSprungMassName, targetCat);
    
    % 정확한 Yellow 키워드 M_SU에 값 설정
    h.Yellow('M_SU', num2str(mass))
    
    fprintf('⚙️ SprungMass "%s"의 M_SU를 %d으로 설정 완료!\n', newSprungMassName, mass);
    
    h.GoHome()
    
    h.Ring("#RingCtrl7",'4') % Output: Excel CSV
    ringVal = h.GetRing('#RingCtrl7');
    if(ringVal == '4')
        fprintf('⚙️ CSV 파일 출력 완료!\n');
    end
    outputFolder = ['Result_' num2str(mass) 'kg'];
    h.Yellow('Results', outputFolder)

    h.Run('', '');


end
