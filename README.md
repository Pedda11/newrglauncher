# RG-Launcher

## First installation:

### Zip-Content:

- Folder: bundle
    - Folder: launcher
        - Folder: data
        - flutter_windows.dll
        - twodotnulllauncher.exe
    - launcher_version.txt → contains the version of the launcher, e.g. 1.0.0
- Folder: data
- flutter_windows.dll
- setup_rg_launcher.exe

## Preparation for Updates:

### To get the hash of the release.zip:

- Get-FileHash setup_Release.zip -Algorithm SHA256
- Get-FileHash Release.zip -Algorithm SHA256

### Content of the release.zip:

- data(folder)
- flutter_windows.dll
- launcher_version.txt
- twodotnulllauncher.exe

### Content of the setup_release.zip:

- data(folder)
- flutter_windows.dll
- setup_twodotnulllauncher.exe
- setup_rg_launcher.exe

