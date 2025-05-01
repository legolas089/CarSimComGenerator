% =========================================================================
% File:        copyRunControl.m
% Author:      kblim
% Date:        2025-05-01
% Description:
%   Duplicates a Run Control dataset in CarSim using the COM interface.
%   Deletes the existing one if it exists, and creates a new one in the
%   target category. Settings can be modified in the designated section.
%
% Usage:
%   copyRunControl(h, originalRunLib, originalRunName, originalRunCat, ...
%                  newRunName, targetCat)
%
% Parameters:
%   - h               : CarSim COM handle
%   - originalRunLib  : e.g., 'Run Control'
%   - originalRunName : e.g., 'Baseline COM'
%   - originalRunCat  : e.g., 'External Control, Wrappers'
%   - newRunName      : e.g., 'Run_1'
%   - targetCat       : e.g., '* Test Category'
%
% Notes:
%   - Add any additional setup in the "Set your Run Control settings" section.
% =========================================================================


function copyRunControl(h, originalRunLib, originalRunName, originalRunCat, newRunName, targetCat)
    % originalRunLib: Run Control
    % originalRunName: Baseline COM
    % originalRunCat: External Control, Wrappers
    % newRunName: Run_1
    % targetCat: * Test Category

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

    %{ **Set your Run Control settings here** %}
    % Start
    
    % end
end