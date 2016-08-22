Windows 10 Virtual Desktop Assistant
===

This application will enhance the Windows 10 multiple desktops feature.
By default you can switch to the next/previous desktops by pressing [Windows + Ctrl + (Left or Right Arrow)].
This will allow you to switch to each specific desktop on demand with new keyboard shortcuts.
It will also allow you have a custom wallpaper per desktop.

## Installation

For "Virtual Desktop Assistant" to work, you first need to install "Visual C++ Redistributable for Visual Studio 2015".
It should be available [here](https://www.microsoft.com/en-us/download/details.aspx?id=48145).

To run this app, just run the "virtual-desktop-assistant.exe" program or install AutoHotkey and run the "virtual-desktop-assistant.ahk" script file.

## Usage

### Keyboard Shortcuts

While running, the following keyboard shortcuts are available:
- [Left Alt + (key under Esc)]

    Goes to the desktop management screen.
    This is additionally available (by default) by pressing [Windows + Tab].
    You can move windows between desktops by dragging them while inside this screen.

- [Left Alt + (1-9)]

    Switch to the desktop for the respective key (ex: [LAlt + 3] goes to Desktop 3).

Note that to add a new desktop you can press the "+ New Desktop" button on the desktop management screen.
A maximum of 9 desktops are supported.

### Tray Icon

A new tray icon will be available. It indicates the number of the current desktop (1-9).
If you click on it the desktop management screen will be displayed.

The icons will have white text over black background. An inverted color scheme is provided but will require minor tweaks to the script.

### Custom Wallpapers Per Desktop

To configure the wallpapers, edit the "settings.ini" file and set the paths of the wallpaper image files for the desktops you want.

A few are included by default. The paths can be relative (ex: "./wallpapers/1.jpg") or absolute (ex: "C:\wallpapers\1.jpg").

If you set the path to empty (ex: "1=" instead of "1=./wallpapers/1.jpg") the wallpaper won't change when you switch to that desktop.

## Credits

Credits to Ciantic (Jari Pennanen) for his library, which can be found [here](https://github.com/Ciantic/VirtualDesktopAccessor).
Credits to the creator of the ReadINI AHK library, found [here](https://autohotkey.com/board/topic/33506-read-ini-file-in-one-go/).