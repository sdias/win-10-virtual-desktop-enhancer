# Known issues

This is a useful list of some of the most important issues reported for this project.  
A brief description of the problem and of the available solutions or workarounds are collected here: please follow the links to the original issues to read all the details.

For a complete list of all the issues reported for this project visit [this page](https://github.com/sdias/win-10-virtual-desktop-enhancer/issues).

## Table of contents

<!-- TOC -->

- [Known issues](#known-issues)
    - [Table of contents](#table-of-contents)
        - [Programs run as another user](#programs-run-as-another-user)
        - [Remote Desktop Protocol](#remote-desktop-protocol)
        - [Synergy and AutoHotkey](#synergy-and-autohotkey)
        - [Windows 10 Game Bar](#windows-10-game-bar)

<!-- /TOC -->

Click here to go back to the [README](../README.md).

### Programs run as another user

**Problem**:  
Windows 10 Virtual Desktop Enhancer can have some difficulties when interacting with windows which are run with higher rights than the program itself.  
[This comment on issue #21](https://github.com/sdias/win-10-virtual-desktop-enhancer/issues/21#issuecomment-308504500) collects what is known about the interaction between this program and other programs run as other users; most importantly:

- When running as a normal user Windows 10 Virtual Desktop Enhancer will not work when a program run as another user is focused
- If your account is an administrator you should experience no problem at all, still if you do you can run WIndows 10 VIrtual Desktop Enhancer as administrator to solve those issues

**Workaround**:  
While no definitive solution to these problems can be provided as they are related to an external library used by this project, a simple workaround is to run Windows 10 Virtual Desktop Enhancer with administrative rights.  
If you want to test this workaround follow these steps:

- Right click on the executable or on the link
- Click "Run as administrator"

If you want it to always run with administrative rights floow these steps:

- Right click on the executable or on the link
- Click "Properties"
- Select the "Compatibility"
- Check "Run this program as an administrator"

This will solve the issues at the cost of breaking the tray icon and tooltip functionalities, except if your account is an administrator.

### Remote Desktop Protocol

**Problem**:  
In [issue #15](https://github.com/sdias/win-10-virtual-desktop-enhancer/issues/15) an user reported that while connecting via RDP (Remote Desktop Protocol) to a remote machine running this application he experienced some trouble with hotkeys not being correctly transmitted to the remote machine and with the program not cahnging dekstops and wallpapers correctly.

**Solution**:  
There is no solution or workaround for this issue: if you experience similar problems you can report them in a new issue or in [issue #15](https://github.com/sdias/win-10-virtual-desktop-enhancer/issues/15) if you believe it to be related.

### Synergy and AutoHotkey

**Problem**:  
[Issue #41](https://github.com/sdias/win-10-virtual-desktop-enhancer/issues/41) seems to suggest that AutoHotkey and [Synergy](https://symless.com/synergy) can conflict and prevent some hotkey combination from working correctly: in this particular issue it has been reported that it was not possible to issue more than one command holding down the modifier keys (e.g. `Ctrl + Win + Left + Left` to switch tow desktops to the left).

**Solution**:  
There is no solution or workaround for this issue even though many more similar issues regarding conflicts between these two programs can be found on the internet.

### Windows 10 Game Bar

**Problem**:  
In [issue 57](https://github.com/sdias/win-10-virtual-desktop-enhancer/issues/57) an user reported how certain hotkeys in certain situations triggered a popup from Windows asking whether or not to start the Game Bar.  
In particular any hotkey combination containing the `Alt` key alone or with other keys or any hotkey containing the `Win` key alone seem to cause this issue.

**Workaround**:  
Although it has not been possible to pinpoint exactly what the root cause of this bug is, there are two available workarounds:

 - Disabling the Windows Game Bar (recommended if it's not used on your computer). [Here is a guide](https://www.howtogeek.com/273180/how-to-disable-windows-10s-game-dvr-and-game-bar/) explaining how to do it
 - Not using the `Alt` key (neither alone nor with other keys) nor the `Win` key alone (it looks to be fine if used together with other keys) in your custom hotkeys setup (recommended if you want to use the Game Bar on your computer). See the [customization page](settings.md#keyboard-shortcuts) of this documentation for further details

Click here to go back to the [README](../README.md).