# CarSimComGenerator

🚗 MATLAB scripts to automate CarSim simulations using the COM interface.

This repository contains a set of modularized MATLAB scripts for automating simulation workflows in CarSim using the COM interface. The scripts support dataset duplication, modification, and batch simulation execution — all programmatically, without GUI interaction.

---

## 📁 Repository Structure

```
CarSim-Automation/
│
├── VSCOM Modular Codes/
│   ├── copyRunControl.m
│   ├── copyProcedures.m
│   ├── copyVehicleAssembly.m
│   ├── copyVehicleSprungMass.m
│   └── VSCOM_CreateDataSet_Example.m
│
├── VSCOM Test Codes/
│   └── runMassSweepCarsim.m
│   └── runMassSweepCarsim_python.py
│   └── VSCOM_test.m
│   └── etc
|
├── README.md
└── .gitignore
```

- `VSCOM Modular Codes/`: Refactored, reusable functions for controlling CarSim via COM.
- `VSCOM Test Codes/`: Original script before function-based refactoring.
- `VSCOM_CreateDataSet_Example.m`: Orchestrates the simulation setup and execution using the modular functions.

---

## Requirements

- **CarSim** installed and registered as a COM server  
  Run the following command as Administrator to register:
  ```bash
  {CarSim prog folder}\CarSim.exe /RegServer
  {CarSim prog folder}\CarSim.exe /Automation
  {CarSim prog folder}\CarSim.exe /SETQUICKLAUNCH
  ```

- **MATLAB** with ActiveX/COM interface support

---

## Quick Start
### 0. Register Automation Server
- 1. Launch Windows Command Prompt as an Admin.
  2. Enter,
     {Your_CarSim_Installed_Folder}\CarSim.exe /RegServer
  3. Enter,
     {Your_CarSim_Installed_Folder}\CarSim.exe /Automation

### 1. Automate CarSim Runs (MATLAB)

1. Open `VSCOM Modular Codes/VSCOM_CreateDataSet_Example.m` in MATLAB.
2. Review and modify dataset names or categories if needed.
3. Run the script:
   - Duplicates Run Control, Procedure, Vehicle Assembly, Sprung Mass datasets
   - Applies key parameter changes (e.g., speed, output format)
   - Executes the simulation via COM

### 2. Code Example: Change vehicle mass & CGH and Run (MATLAB)
```matlab
addpath('{Your folder}\VSCOM Modular Codes');
h.actxserver('CarSim.Application);
h.GoHome();

% Define your CarSim Settings %
% 1. Duplicate Run Control
copyRunControl(h, originalRunLib, originalRunName, originalRunCat, newRunName, targetCat);

% 2. Duplicate procedures
copyProcedures(h, originalProcLib, originalProcName, originalProcCat, newProcName, targetCatProc);

% 3. Duplicate Vehicle assembly
copyVehicleAssembly(h, originalVehLib, originalVehName, originalVehCat, newVehName, targetVehCat);

% 4. Duplicate Sprung mass
copyVehicleSprungMass(h, originalSprungLib, originalSprungName, originalSprungCat, newSprungName, targetSprungCat, originalVehLib, newVehName, targetVehCat, myMass, myCgh);

% 5. Run
h.Run('','')
```

---
## 🧠 Function Overview

Each helper function performs a specific duplication + customization task:

- `copyRunControl.m`: Clone and modify a Run Control dataset
- `copyProcedures.m`: Clone and modify a Procedure dataset (e.g., speed)
- `copyVehicleAssembly.m`: Duplicate Vehicle Assembly with optional changes
- `copyVehicleSprungMass.m`: Modify Sprung Mass and relink to Vehicle Assembly

These are used in sequence in `VSCOM_CreateDataSet_Example.m`.

---
## License

This project is licensed under the MIT License.
⚠️ This project uses CarSim's COM interface (VSCOM) and requires a licensed copy of CarSim.
It does not contain or distribute any proprietary files from Mechanical Simulation.

---

## 👤 Author

kblim,
Hanyang University, Department of Automotive Engineering
Reliability Engineering & Design Lab.
