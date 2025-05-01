"""
File        : runMassSweepCarsim_python.py
Description : Clone and configure CarSim datasets for different vehicle masses using COM interface (Python)
Author      : kbLim
Created     : 2025-04-29
Last Updated: 2025-04-29
input: mass(kg)
output: CarSim dataset({Your_Location_to_CarSim}\Results)
"""

import win32com.client


def runMassSweepCarSimPy(mass):
    # Start COM
    h = win32com.client.Dispatch('CarSim.Application')
    h.GoHome()

    ## Define settings

    # Original Run Control
    originalRunLib = 'Run Control'
    originalRunName = 'Baseline COM'
    originalRunCat = 'External Control, Wrappers'

    # New Run Control
    newRunName = f'Run_{mass}kg'
    targetCat = '* Mass Sweep'

    # Original Vehicle Assembly
    originalVehLib = 'Vehicle: Assembly'

    # New Vehicle
    newVehName = f'Vehicle_{mass}kg'

    ## Copy Run Control (Delete if exists)

    if h.DataSetExists(originalRunLib, newRunName, targetCat):
        h.DeleteDataSet(originalRunLib, newRunName, targetCat)
        print(f'🗑️ Existing Run Control "{newRunName}" deleted')

    h.Gotolibrary(originalRunLib, originalRunName, originalRunCat)
    h.CreateNew()
    h.DatasetCategory(newRunName, targetCat)
    print(f'✅ Run Control "{newRunName}" created')

    ## Copy Vehicle Assembly (Delete if exists)

    if h.DataSetExists(originalVehLib, newVehName, targetCat):
        h.DeleteDataSet(originalVehLib, newVehName, targetCat)
        print(f'🗑️ Existing Vehicle "{newVehName}" deleted')

    h.Gotolibrary(originalVehLib, '', '')
    h.CreateNew()
    h.DatasetCategory(newVehName, targetCat)
    print(f'✅ Vehicle "{newVehName}" created')

    libName, dataSetName, categoryName = h.GetCurrentLibInfo()

    print('📍 Current Location:')
    print(f'Library   : {libName}')
    print(f'Dataset   : {dataSetName}')
    print(f'Category  : {categoryName}')

    h.GoHome()
    h.BlueLink('#BlueLink2', originalVehLib, newVehName, targetCat)
    print(f'🔗 Linked Vehicle "{newVehName}" to Run Control "{newRunName}"')

    ## Copy Vehicle: Sprung Mass
    originalSprungMassLib = 'Vehicle: Sprung Mass'
    originalSprungMassName = 'C-Class, Hatchback SM'
    originalSprungMassCat = 'C-Class'

    newSprungMassName = f'SprungMass_{mass}kg'

    h.Gotolibrary(originalSprungMassLib, '', '')
    libName, dataSetName, categoryName = h.GetCurrentLibInfo()

    print('📍 Current Location:')
    print(f'Library   : {libName}')
    print(f'Dataset   : {dataSetName}')
    print(f'Category  : {categoryName}')

    if h.DataSetExists(originalSprungMassLib, newSprungMassName, targetCat):
        h.DeleteDataSet(originalSprungMassLib, newSprungMassName, targetCat)
        print(f'🗑️ Existing Sprung Mass "{newSprungMassName}" deleted')

    h.Gotolibrary(originalSprungMassLib, originalSprungMassName, originalSprungMassCat)
    h.CreateNew()
    h.DatasetCategory(newSprungMassName, targetCat)
    print(f'✅ Sprung Mass "{newSprungMassName}" created')

    ## Link Sprung Mass to New Vehicle
    h.Gotolibrary(originalVehLib, newVehName, targetCat)
    h.BlueLink('#BlueLink0', originalSprungMassLib, newSprungMassName, targetCat)
    print(f'🔗 Linked Sprung Mass "{newSprungMassName}" to Vehicle "{newVehName}"')

    ## Set Sprung Mass value
    h.Gotolibrary(originalSprungMassLib, newSprungMassName, targetCat)
    h.Yellow('M_SU', str(mass))
    print(f'⚙️ Set M_SU for SprungMass "{newSprungMassName}" to {mass}')

    h.GoHome()

    h.Ring("#RingCtrl7", '4')  # Output: Excel CSV
    ringVal = h.GetRing('#RingCtrl7')
    if ringVal == '4':
        print('⚙️ CSV file output completed')

    outputFolder = f'Result_{mass}kg'
    h.Yellow('Results', outputFolder)

    h.Run('', '')
