# Automatic release deployment script

This script automates the procedure of deploying a new release of the program, creating the zip file which will be manually uploaded to GitHub.

## Table of contents

<!-- TOC -->

- [Automatic release deployment script](#automatic-release-deployment-script)
    - [Table of contents](#table-of-contents)
    - [How to deploy a new release](#how-to-deploy-a-new-release)
        - [Using the Python script](#using-the-python-script)
        - [Using the compiled executable](#using-the-compiled-executable)
    - [The deployment process](#the-deployment-process)
    - [How to compile `deploy.py` into `deploy.bat`](#how-to-compile-deploypy-into-deploybat)

<!-- /TOC -->

## How to deploy a new release

The deployment script is available both as a Python script (which requires Python to be installed and configured on your computer) and as a compiled executable (which does not require Python).

### Using the Python script

Running the Python script requires Python to be installed on your computer along with the following modules: GItPython, markdown, semantic_version.  
You can install them via `pip` running the command `pip install GitPython markdown semantic_version`.

To run the script simply enter the `deploy-release` folder and run `python deploy.py`.

### Using the compiled executable

To run the compiled executable simply double click the `deploy.bat` file.

## The deployment process

1. The script will first check if you are currently on `master` branch and warn you otherwise, so as to avoid an accidental release of a development branch.
2. Then it will get the latest release version number and ask for the new release version number: it must be valid (of the form x.x.x) and greater than the latest one.
3. Once a valid version number has been entered the script will automatically perform a series of operations to build the final zip file that you will have to manually upload to GitHub in the release page. The zip file will be placed in the `deploy-release` folder.
4. Lastly you will be asked if you want to see the `git diff` between this release and the previous one (which can be useful to write the release description).
5. Once the script has finished the release folder can be deleted safely, but it's not necessary as it will be ignored by git and will be overwritten at the start of the next deployment.

## How to compile `deploy.py` into `deploy.bat`

Note: this procedure should be performed only when `deploy.py` has been modified to generate a matching `deploy.bat`. It's not necessary to perform it every time you want to use `deploy.bat`.

First of all you must have Python installed and configured on your computer along with the following modules: GItPython, markdown, semantic\_version, cx\_Freeze.  
You can install them via `pip` running the command `pip install GitPython markdown semantic_version cx_Freeze`.

1. Open the `deploy-release` folder.
2. Double click the `PyToExe.bat` executable: it will start the compilation process through `setupPyToExe.py`.
3. The `build` folder will be generated and `deploy.exe` will be inside it and `deploy.bat` will link to it.
