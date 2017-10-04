# Installation

## Table of contents

<!-- TOC -->

- [Installation](#installation)
    - [Table of contents](#table-of-contents)
    - [Prerequisites](#prerequisites)
    - [Procedure](#procedure)
        - [Autostart](#autostart)
            - [Procedure 1: Autostart folder](#procedure-1-autostart-folder)
            - [Procedure 2: Task scheduler](#procedure-2-task-scheduler)
    - [Request assistance](#request-assistance)

<!-- /TOC -->

Click here to go back to the [README](../README.md).

## Prerequisites

**This application only works on Windows 10 x64 (64 bit) systems** due to limitations in the library used to control the virtual desktops.  
This is not something that can be changed or _fixed_ in any way.

For this app to work, you first might need to install "Visual C++ Redistributable for Visual Studio 2015". It should be available [here](https://www.microsoft.com/en-us/download/details.aspx?id=52685).

Since [version 0.7.0](https://github.com/sdias/win-10-virtual-desktop-enhancer/releases/tag/0.7) this app will only work if your system has the "Windows 10 Anniversary" update (or later) installed.

## Procedure

Windows 10 Virtual Desktop Enhancer does not need to be installed: simply download [the latest version](https://github.com/sdias/win-10-virtual-desktop-enhancer/releases/latest) and extract it into a folder in your computer.  
Once you have downloaded it you can run it just by executing `virtual-desktop-enhancer.exe` in the folder where you extracted it.

Alternatively you can install [AutoHotkey](https://autohotkey.com/) and run the `virtual-desktop-enhancer.ahk` script file instead.

### Autostart

There are two easy ways to have this program automatically start when you login.  
Please try the first procedure: if it does not work try the second one.

#### Procedure 1: Autostart folder

1. Open the folder where you saved the downloaded files
2. Right click on the executable or on the script file (depending on which one you want to use) -> "Send to" -> "Desktop (create shortcut)"
3. On your desktop there should now be a new shortcut for "virtual-desktop-enhancer.exe": right click on it -> "cut"
4. Open the Start menu; in the search box enter "run" and open the "Run" program which should be the first result
5. In the box which will pop up enter `shell:startup` and click "OK"
6. A folder will open: right click in the folder -> "Paste"
7. Now if you restart the computer the program should start automatically

#### Procedure 2: Task scheduler

1. Open the Start menu and in the search box enter "run": open the "Run" program which should be the first result
2. In the box which will pop up enter `Taskschd.msc` and click "OK"
3. In the menu of window that will open click "Action" -> "Create Basic Task"
4. Choose a name and a description for the task (e.g. "win10-virtual-desktop-enhancer starter") and press "Next"
5. Choose "When I log on" and click "Next"
6. Choose "Start a program" and click "Next"
7. Click on "Browse", find the folder where you placed the `virtual-desktop-enhancer.exe`, open it, select the `virtual-desktop-enhancer.exe` file and click "Open"
8. Copy the content of the "Program/script" field in the "Open in (optional)" field, then remove everything that comes after the last `\` character in that field. For example `C:\Users\USERNAME\Desktop\win10den.exe` would become `C:\Users\USERNAME\Desktop\`
9. Verify that all the settings are correct, select "Open the Properties dialog for this task when I click finish" and click "Finish"
10. In the Properties dialog you can check "Run with highest privileges" in the "General" tab if your account has administrative rights and you want to run the program as administrator
11. In the "Conditions" tab you probably want to uncheck **both** "Stop if the computer switches to battery power" and "Start the task only if the computer is on AC power" if you are tunning this on a laptop
12. In the "Settings" tab you might want to uncheck "Stop the task if it runs longer than..."
13. You can now close the window: if you restart the computer Windows 10 Virtual Desktop Enhancer should start automatically

## Request assistance

If you have problems with the installation of Windows 10 Virtual Desktop Enhancer please submit a new issue in the project page as described [here](issue-page.md).

Click here to go back to the [README](../README.md).