Windows 10 Virtual Desktop Enhancer
===

This application enhances the Windows 10 virtual desktops feature. It makes available the following new features:

- Extra customizable keyboard shortcuts to switch or move a window to a different desktop.
- Custom wallpaper per virtual desktop (either a picture or a solid color).
- Current desktop indicator in the tray area.
- Custom desktop names.
- Tooltips showing the desktop name when switching desktops.

Go to the ["Releases" page to download](https://github.com/sdias/win-10-virtual-desktop-enhancer/releases).

## Installation

This app does not need to be installed, simply extract it into a folder in your computer.

To run this app, just run the "virtual-desktop-enhancer.exe" program.

Alternatively you can install AutoHotkey and run the "virtual-desktop-enhancer.ahk" script file.

This application only works on Windows 10 x64.

### Prerequisites

For this app to work, you first might need to install "Visual C++ Redistributable for Visual Studio 2015".
It should be available [here](https://www.microsoft.com/en-us/download/details.aspx?id=48145).

If you want to run version 0.7.0 or above of this app, you need to have the "Windows 10 Anniversary" update installed.

## Troubleshooting

For version 0.6.2 and below, there is an optional patch you can install that will enable you to use the app in case you don't have the update mentioned above.

## Usage

### Custom Wallpapers Per Desktop

To configure the wallpapers, edit the "settings.ini" file.
For each desktop, you can either set the wallpaper to be an image file or a fixed color.
To use images, set the path of the image, either absolute or relative (ex: "1=C:\wallpapers\1.jpg", "2=./wallpapers/2.jpg").
To use fixed colors, set the color in hexadecimal (ex: "3=0xff0000" for red, "4=0xff00" or "4=0x00ff00" for green).
If you set the config of that desktop to empty (ex: "5=") the wallpaper won't change when you switch to that desktop.
Also note that any number of desktops are supported, just add a line for each new one, like for example:

<pre>
[Wallpapers]
1=C:\Wallpapers\Default.jpg
2=
3=
4=
5=
6=
7=
8=
9=
10=
11=C:\Wallpapers\Work.jpg
12=C:\Wallpapers\Email.jpg
20=
50=
999=C:\Wallpapers\End of the world.jpg
</pre>

### Desktop Names

In a similar manner to wallpapers, you can also set a custom name for each desktop.

<pre>
[DesktopNames]
1=Work
2=Games
3=Movies
4=Presentations
5=
6=
7=
8=
9=
10=
15=No idea
</pre>

Note that the desktop's name will be visible in the tooltip of the tray icon and also in the larger tooltip that appears momentarily when you switch desktops.
If a desktop's name is not set, "Desktop <number>" will be displayed.
Again, like wallpapers, any number of desktops are supported by this feature.

### Tooltips

If you enable tooltips, every time you switch desktops a tooltip will appear letting you know the name of the desktop you switched to.

You can customize the appearance of this tooltip:

| Setting         | Description                                                                               | Valid Values                                   |
| --------------- | ----------------------------------------------------------------------------------------- | ---------------------------------------------- |
| Enabled         | If tooltips should be shown.                                                              | 1 (Yes), 0 (No).                               |
| Centered        | If the tooltips should appear at the center of the screen, or in the bottom right corner. | 1 (center), 0 (corner).                        |
| FontSize        | The size of the font.                                                                     | Any reasonable number.                         |
| FontColor       | The color of the font.                                                                    | Any hexadecimal number (from 0x0 to 0xFFFFFF). |
| FontInBold      | If the font should be in bold.                                                            | 1 (Yes), 0 (No).                               |
| BackgroundColor | The color of the background.                                                              | Any hexadecimal number (from 0x0 to 0xFFFFFF). |
| Lifespan        | The time in milliseconds for which each tooltip will be displayed.                        | Any reasonable number.                         |

As an example, you have the default configuration:

<pre>
[Tooltips]
Enabled=1
Centered=1
FontSize=11
FontColor=0xFFFFFF
FontInBold=1
BackgroundColor=0x1F1F1F
Lifespan=750
</pre>

It draws tooltips at the center of the screen, in a white, bold and small font, with a dark background, and they are displayed for 750 milliseconds.

### Keyboard and Mouse Shortcuts

There are three functions: switching to another desktop, moving the current window to another desktop, and moving the current window to another desktop and then switch to that desktop. 

For each function you can set modifiers (a combination of one or more keys) that when pressed at the same time as the number keys (0-9) or the previous and next keys, will execute that function. The keys that are available are: "Ctrl", "Shift", Alt" and "Win". You can also set it to only use the version of the key on one side of the keyboard, by adding "L" or "R" to the beginning, like for example "LCtrl" for left control and "RWin" for right windows key.

You can also set an extra modifier which makes these actions affect desktops 11 to 20 instead, when using the modifiers above and the number keys. You should specify it as you would for the modifiers above.

The previous and next keys can also be customized. They default to "Left" and "Right", for the left and right arrows, respectively, [but can be set to any value in this page (except modifiers)](https://www.autohotkey.com/docs/KeyList.htm).

Also note that if the setting is set to empty, the feature will be disabled.

Hopefully the following examples make this clearer.

#### Behavior with default config

With this config:
<pre>
[KeyboardShortcuts]
Switch=LAlt
Move=LAlt, Shift, Ctrl
MoveAndSwitch=LAlt, Shift
Previous=Left
Next=Right
PlusTen=
</pre>

The following shortcuts are available:

| Description                                                                    | Keyboard Shortcut                            |
| ------------------------------------------------------------------------------ | -------------------------------------------- |
| Switch to desktop by number                                                    | Left Alt + (0-9)                             |
| Switch to next/previous desktop                                                | Left Alt + (Left/Right Arrow)                |
| Move the current window to desktop by number                                   | Left Alt + Shift + Ctrl + (0-9)              |
| Move the current window to next/previous desktop                               | Left Alt + Shift + Ctrl + (Left/Right Arrow) |
| Move the current window to desktop by number and switch to it                  | Left Alt + Shift + (0-9)                     |
| Move the current window to next/previous desktop and switch to it              | Left Alt + Shift + (Left/Right Arrow)        |
| Open Desktop Manager                                                           | Left Alt + (key under Esc)                   |
| Switch to desktop by number (desktops 11-20)                                   | Disabled                                     |
| Move the current window to desktop by number (desktops 11-20)                  | Disabled                                     |
| Move the current window to desktop by number and switch to it (desktops 11-20) | Disabled                                     |

Also, if enabled, you can switch desktops by scrolling over the taskbar.

#### Behavior with custom config

With this config:
<pre>
[KeyboardShortcuts]
Switch=LWin
Move=
MoveAndSwitch=LWin, Alt
Previous=PgUp
Next=PgDn
PlusTen=LShift
</pre>

The following shortcuts are available:

| Description                                                                    | Keyboard Shortcut                    |
| ------------------------------------------------------------------------------ | ------------------------------------ |
| Switch to desktop by number                                                    | Left Win + (0-9)                     |
| Switch to next/previous desktop                                                | Left Win + (Page Up/Page Down)       |
| Move the current window to desktop by number                                   | Disabled                             |
| Move the current window to next/previous desktop                               | Disabled                             |
| Move the current window to desktop by number and switch to it                  | Left Win + Alt + (0-9)               |
| Move the current window to next/previous desktop and switch to it              | Left Win + Alt + (Page Up/Page Down) |
| Open Desktop Manager                                                           | Left Win + (key under Esc)           |
| Switch to desktop by number (desktops 11-20)                                   | Left Win + Left Shift + (0-9)        |
| Move the current window to desktop by number (desktops 11-20)                  | Disabled                             |
| Move the current window to desktop by number and switch to it (desktops 11-20) | Left Win + Alt + Left Shift + (0-9)  |

### Tray Icon

A new tray icon will be available. It indicates the number of the current desktop (1-10).
If you click on it the desktop management screen is displayed.

#### Icon Packs

By default the white text on black background icon pack is set, but more packs are available.

To change between them, go into the "icons" folder and extract the ZIP file for the theme you want to use, and replace any existing files if prompted.

To create custom packs, simply create one icon per desktop and name them appropriately ([desktop number goes here].ico, ex: 1.ico, 5.ico, 99.ico). If the current desktop does not have an icon for it, the "+.ico" icon is shown instead, so make sure you create that as well for your pack.

### Additional Configuration

You can set what is the default desktop using the "[General] DefaultDesktop" setting.
You can set if you want to be able to switch desktops by scrolling over the taskbar using the "[General] TaskbarScrollSwitching" setting (1 for yes, 0 for no).

## Credits

Thanks to Ciantic (Jari Pennanen) for his library and sample AHK script, which can be found [here](https://github.com/Ciantic/VirtualDesktopAccessor).

Thanks to engunneer for his AHK library, which can be found [here](http://www.autohotkey.com/board/topic/21510-toaster-popups/#entry140824).

Thanks to the creator of the ReadINI AHK library, found [here](https://autohotkey.com/board/topic/33506-read-ini-file-in-one-go/).

Thanks to the artists that created the packed wallpapers, whom I lost track of. Sorry.

Thanks to rob3110 on reddit for the extra white icon theme.

Thanks to several people on reddit.com/r/windows10 and in the project's github page for their suggestions.