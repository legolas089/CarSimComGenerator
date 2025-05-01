% =========================================================================
% File:        VSCOM_CreateDataSet_Example.m
% Author:      kblim
% Date:        2025-05-01
% Description:
%   This script demonstrates a full CarSim COM automation workflow using
%   helper functions (copyRunControl, copyProcedures, copyVehicleAssembly,
%   copyVehicleSprungMass).
%
%   The process includes:
%     *** Process Must be done in order!!! ***
%     1. Launching the CarSim COM server
%     2. Move to ['Run Control', 'Baseline COM', 'External Control, Wrappers']
%     3. Duplicate and set datasets
%        (1) run "copyRunControl"
%        (2) set "copyProcedures"
%        (3) set "copyVehicleAssembly"
%        (4) set "copyVehicleSprungMass"
%     4. Modify Run Control settings (output format, overlay options, etc.)
%     5. Run the simulation
%
% Requirements:
%   - CarSim must be registered as a COM server (via /RegServer)
%   - The helper functions must be in the same directory or on the MATLAB path
% =========================================================================

% ==========================================================================
% In This Example:
%   0. Start CarSim COM server
%   1. Go to Target Dataset
%   2. Copy Run Control:
%       'Run Control' to 'Run_1' in '* Test Category'
%   3. Copy Procedures: 
%       'DLC @ 120 km/h (Quick Start)' to 'DLC@100km/h - Yaw Rate' in '* Test Procedures Category'
%   4. Copy Vehicle Assembly:
%       'C-Class, Hatchback: No ABS' to 'Vehicle_1300kg' in '* Test Vehicle Category'
%   5. Copy Vehicle Sprung mass:
%       'B-Class, Hatchback' to 'Vehicle_SprungMass_1300kg' in '* Test Sprung mass Category'
%   6. Run Control - Output file format setting, Overlays
%   7. Run CarSim
% =========================================================================

%% 0. Start CarSim COM server
h = actxserver('CarSim.Application');
h.GoHome();

%% 1. Go to Target Dataset
h.Gotolibrary('Run Control', 'Baseline COM', 'External Control, Wrappers');
[libName, dataSetName, categoryName] = h.GetCurrentLibInfo();

% 출력
fprintf('📍 현재 위치:\n');
fprintf('Library   : %s\n', libName);
fprintf('Dataset   : %s\n', dataSetName);
fprintf('Category  : %s\n', categoryName);


%% 2. Copy Run Control, if exists, delete it, create new one
newRunName = 'Run_1';
targetCat = '* Test Category';
originalRunLib = 'Run Control';
originalRunName = 'Baseline COM';
originalRunCat = 'External Control, Wrappers';
copyRunControl(h, originalRunLib, originalRunName, originalRunCat, newRunName, targetCat);

%% 3. Copy Procedures, if exists, delete it, create new one
% Set your settings in copyProcedure function
originalProcLib = 'Procedures';
originalProcName = 'DLC @ 120 km/h (Quick Start)'; %'DLC @ -10 km/h';
originalProcCat = 'Handling Testing';
newProcName = 'DLC@100km/h - Yaw Rate';
targetCatProc = '* Test Procedures Category';
copyProcedures(h, originalProcLib, originalProcName, originalProcCat, newProcName, targetCatProc);

%% 4. Copy Vehicle Assembly, if exists, delete it, create new one
originalVehLib = 'Vehicle: Assembly';  % 이게 Library 이름임
originalVehName = 'C-Class, Hatchback: No ABS';
originalVehCat = 'C-Class';
newVehName = 'Vehicle_1300kg'; % Set your new vehicle name here
targetVehCat = '* Test Vehicle Category';
copyVehicleAssembly(h, originalVehLib, originalVehName, originalVehCat, newVehName, targetVehCat);

%% 5. Copy Vehicle Sprung mass, if exists, delete it, create new one
originalSprungLib = 'Vehicle: Sprung mass';  % 이게 Library 이름임
originalSprungName = 'C-Class, Hatchback';
originalSprungCat = 'C-Class';
newSprungName = 'SprungMass_CHatch_1300kg'; % Set your new vehicle name here
targetSprungCat = '* Test Sprung mass Category';
copyVehicleSprungMass(h, originalSprungLib, originalSprungName, originalSprungCat, newSprungName, targetSprungCat, originalVehLib, newVehName, targetVehCat);

%% 6. Run Control - Output file format setting, Overlays
h.Ring("#RingCtrl7", '4'); % 4 -> Output: Excel CSV
h.Checkbox("#Checkbox1", '0'); % 0 -> No Overlays
fprintf('✅ Run Control 설정 완료\n');

%% 7. Run CarSim
h.Run('','')
fprintf('🚗 CarSim 실행 완료\n');