# CarSimComGenerator

🚗 MATLAB scripts to automate CarSim simulations using the COM interface.

This project automates the duplication of Run Control datasets, modifies vehicle parameters (e.g., sprung mass), batch-executes simulations, and processes the results using Python.

---

## Features

- Duplicate and configure CarSim Run Control datasets automatically
- Modify vehicle parameters (e.g., Sprung Mass `M_SU`)
- Batch run multiple simulations without manual intervention
---

## Repository Structure

carsim-automation/  
├── runMassSweepCarsim.m # MATLAB function to set up and run mass sweep simulations  
├── VSCOM_test.m # Main script to automate batch execution and overlay setup  
└── README.md # Project overview (this file)

---

## Requirements

### MATLAB
- MATLAB R2023b or newer
- CarSim installed and registered as a COM server (`CarSim.Application`)
- CarSim database containing a `Baseline COM` Run Control dataset

---

## Quick Start

### 1. Automate CarSim Runs (MATLAB)

```matlab
h = actxserver('CarSim.Application');
massList = [1200, 1400, 1600];
for mass = massList
    runMassSweepCarsim(mass);
end
```

---

## License

This project is licensed under the MIT License.

---

## Author

kblim
