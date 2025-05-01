% =========================================================================
% File:        copyVehicleSprungMass.m
% Author:      kblim
% Date:        2025-05-01
% Description: 
%   ** Link this after duplicating Vehicle Assembly **
%   This function automates the duplication and customization of a 
%   Vehicle: Sprung Mass dataset in CarSim via COM interface. 
%   It sets a new sprung mass value and links the customized 
%   dataset to a specific Vehicle Assembly.
%
% Usage:
%   copyVehicleSprungMass(h, originalSprungLib, originalSprungName, originalSprungCat, ...
%                         newSprungName, targetSprungCat, ...
%                         originalVehLib, newVehName, targetVehCat)
%
% Parameters:
%   - h                 : CarSim COM handle (actxserver('CarSim.Application'))
%   - originalSprungLib: Library name of the original Sprung Mass (e.g., 'Vehicle: Sprung mass')
%   - originalSprungName: Name of the original Sprung Mass dataset
%   - originalSprungCat : Category of the original Sprung Mass dataset
%   - newSprungName     : Name of the new dataset to create (e.g., 'Vehicle_SprungMass_1300kg')
%   - targetSprungCat   : Category under which the new dataset will be saved
%   - originalVehLib    : Library name of the Vehicle Assembly to link (e.g., 'Vehicle: Assembly')
%   - newVehName        : Name of the Vehicle Assembly to update
%   - targetVehCat      : Category of the Vehicle Assembly
%
% Dependencies:
%   - Requires CarSim COM Automation Server to be registered.
%   - Dataset keywords (e.g., 'M_SU', '#BlueLink0') must match the CarSim GUI layout.
% =========================================================================


function copyVehicleSprungMass(h, originalSprungLib, originalSprungName, originalSprungCat, newSprungName, targetSprungCat, originalVehLib, newVehName, targetVehCat)

    % 기존 Vehicle Sprung mass 복제본이 있으면 삭제
    if h.DataSetExists(originalSprungLib, newSprungName, targetSprungCat)
        h.DeleteDataSet(originalSprungLib, newSprungName, targetSprungCat);
        fprintf('🗑️ 기존 Vehicle Sprung mass "%s" 삭제됨\n', newSprungName);
    end

    % 복제
    h.Gotolibrary(originalSprungLib, originalSprungName, originalSprungCat);
    h.CreateNew();
    h.DatasetCategory(newSprungName, targetSprungCat);
    fprintf('✅ Vehicle Sprung mass "%s" 복제 완료\n', newSprungName);

    %{ Set your Vehicle Sprung mass settings here %}
    % From here
    h.Yellow('M_SU', num2str(1300)); % Set Sprung mass to 1300 kg
    % to here


    % 연결
    h.Gotolibrary(originalVehLib, newVehName, targetVehCat);
    h.BlueLink('#BlueLink0', originalSprungLib, newSprungName, targetSprungCat);
    fprintf('🔗 Vehicle Sprung mass에 연결 완료\n');
    h.GoHome();
end