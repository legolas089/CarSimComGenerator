% =========================================================================
% File:        copyVehicleAssembly.m
% Author:      kblim
% Date:        2025-05-01
% Description:
%   ** Link this after duplicating Run Control **
%   This function automates the duplication of a Vehicle Assembly dataset
%   in CarSim using the COM interface. If a dataset with the target name
%   already exists, it will be deleted. A new copy will be made and stored
%   in the specified target category.
%
%   Optionally, post-copy modifications can be made by filling in the
%   "Set your Vehicle Assembly settings here" section.
%
% Usage:
%   copyVehicleAssembly(h, originalVehLib, originalVehName, originalVehCat, ...
%                       newVehName, targetVehCat)
%
% Parameters:
%   - h               : CarSim COM handle (actxserver('CarSim.Application'))
%   - originalVehLib  : Library name of the original Vehicle Assembly (e.g., 'Vehicle: Assembly')
%   - originalVehName : Dataset name of the original Vehicle Assembly (e.g., 'C-Class, Hatchback: No ABS')
%   - originalVehCat  : Category of the original dataset (e.g., 'C-Class')
%   - newVehName      : Dataset name for the duplicated assembly (e.g., 'Vehicle_1270kg')
%   - targetVehCat    : Target category to store the duplicated dataset (e.g., '* Test Vehicle Category')
%
% Dependencies:
%   - Requires CarSim COM Automation Server to be registered
%   - Ensure '#BlueLink2' correctly refers to the Vehicle Assembly link
%
% Notes:
%   - The BlueLink at the end re-links the vehicle to itself. If your goal
%     is to link the assembly to a parent dataset (like Run Control), firstly create
%     your Run Control and then link it to the Vehicle Assembly.
% =========================================================================



function copyVehicleAssembly(h, originalVehLib, originalVehName, originalVehCat, newVehName, targetVehCat)

    % 기존 Vehicle Assembly 복제본이 있으면 삭제
    if h.DataSetExists(originalVehLib, newVehName, targetVehCat)
        h.DeleteDataSet(originalVehLib, newVehName, targetVehCat);
        fprintf('🗑️ 기존 Vehicle Assembly "%s" 삭제됨\n', newVehName);
    end
    
    % Vehicle Assembly 이동 및 복제
    h.Gotolibrary(originalVehLib, originalVehName, originalVehCat);
    h.CreateNew();
    h.DatasetCategory(newVehName, targetVehCat);
    fprintf('✅ Vehicle Assembly "%s" 복제 완료\n', newVehName);

    %{ **Set your Vehicle Assembly settings here** %}
    % From here

    % to here
    
    h.GoHome();
    h.BlueLink('#BlueLink2',originalVehLib, newVehName, targetVehCat);
    fprintf('🔗 Vehicle Assembly에 연결 완료\n');
end
