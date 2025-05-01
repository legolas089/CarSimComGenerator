% =========================================================================
% File:        copyProcedures.m
% Author:      kblim
% Date:        2025-05-01
% Description:
%   ** Link this after duplicating Run Control **
%   Duplicates a Procedure dataset in CarSim using the COM interface.
%   Deletes the existing one if needed, updates settings (e.g., speed),
%   and links it via BlueLink to a parent dataset.
%
% Usage:
%   copyProcedures(h, originalProcLib, originalProcName, originalProcCat, ...
%                  newProcName, targetCatProc)
%
% Parameters:
%   - h               : CarSim COM handle
%   - originalProcLib : e.g., 'Procedures'
%   - originalProcName: e.g., 'DLC @ 120 km/h (Quick Start)'
%   - originalProcCat : e.g., 'Handling Testing'
%   - newProcName     : e.g., 'DLC@120km/h - Yaw Rate'
%   - targetCatProc   : e.g., '* My Procedures'
%
% Notes:
%   - Adjust '*SPEED' and '#BlueLink28' as needed based on GUI layout
% =========================================================================



function copyProcedures(h, originalProcLib, originalProcName, originalProcCat, newProcName, targetCatProc)

    % 기존 Procedure 복제본이 있으면 삭제
    if h.DataSetExists(originalProcLib, newProcName, targetCatProc)
        h.DeleteDataSet(originalProcLib, newProcName, targetCatProc);
        fprintf('🗑️ 기존 Procedure "%s" 삭제됨\n', newProcName);
    end
    
    % Procedure 이동 및 복제
    h.Gotolibrary(originalProcLib, originalProcName, originalProcCat);
    h.CreateNew();
    h.DatasetCategory(newProcName, targetCatProc);
    fprintf('✅ Procedure "%s" 복제 완료\n', newProcName);
    
    %{ **Set your Procedure settings here** %}
    % From here
    h.Yellow('*SPEED', num2str(100)); % Set Speed to 100 km/h
    % to here

    h.GoHome();
    h.BlueLink('#BlueLink28',originalProcLib, newProcName, targetCatProc);
    fprintf('🔗 Procedure에 연결 완료\n');
end