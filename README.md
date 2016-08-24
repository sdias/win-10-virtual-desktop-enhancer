Windows 10 Virtual Desktop Enhancer
===

This application enhances the Windows 10 multiple desktops feature.
By default you can only switch to the next/previous desktops by pressing [Windows + Ctrl + (Left or Right Arrow)].
This allows you to switch directly to each specific desktop on demand with new keyboard shortcuts.
It also allows you to have a custom wallpaper per desktop.

## Installation

For this app to work, you first need to install "Visual C++ Redistributable for Visual Studio 2015".
It should be available [here](https://www.microsoft.com/en-us/download/details.aspx?id=48145).

To run this app, just run the "virtual-desktop-enhancer.exe" program.

Alternatively you can install AutoHotkey and run the "virtual-desktop-enhancer.ahk" script file.

The executable only can only run on x64 versions of Windows 10, but if you can run this app on Windows 10 x86 if you install AutoHotkey and run the script instead. 

## Usage

### Keyboard Shortcuts

While running, the following keyboard shortcuts are available:
- [Left Alt + (key under Esc)]

    Goes to the desktop management screen.
    This is additionally available (by default) by pressing [Windows + Tab].
    You can move windows between desktops by dragging them while inside this screen.

- [Left Alt + (1-9)]

    Switch to the desktop for the respective key (ex: [LAlt + 3] goes to Desktop 3).

Note that to add a new desktop you can press the "New Desktop (+)" button on the desktop management screen.
A maximum of 9 desktops are supported.

### Tray Icon

A new tray icon will be available. It indicates the number of the current desktop (1-9).
If you click on it the desktop management screen is displayed.

The icons have white text over black background. An inverted color scheme (black text over whithe background) is also available.

To change between both, go into the "icons" folder and extract either the "white.zip" or "black.zip" files, replacing any existing files. You can also use custom icons, by copying them into this folder and renaming them "1.ico" through "9.ico".

### Custom Wallpapers Per Desktop

To configure the wallpapers, edit the "settings.ini" file and set the paths of the wallpaper image files for the desktops you want.

A few are included by default. The paths can be relative (ex: "./wallpapers/1.jpg") or absolute (ex: "C:\wallpapers\1.jpg").

If you set the path to empty (ex: "1=" instead of "1=./wallpapers/1.jpg") the wallpaper won't change when you switch to that desktop.

## Credits

Thanks to Ciantic (Jari Pennanen) for his library, which can be found [here](https://github.com/Ciantic/VirtualDesktopAccessor).
Thanks to the creator of the ReadINI AHK library, found [here](https://autohotkey.com/board/topic/33506-read-ini-file-in-one-go/).
Thanks to the artists that created the packed wallpapers, whom I lost track of. Sorry.