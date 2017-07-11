# Personalize the settings

There are lots of parameters you can personalize to make this program behave exactly as you want.  
Mainly you will have to edit some lines in the `settings.ini` file in the main folder of the program.

## Table of contents

<!-- TOC -->

- [Personalize the settings](#personalize-the-settings)
    - [Table of contents](#table-of-contents)
    - [Main settings](#main-settings)
    - [Custom wallpapers](#custom-wallpapers)
        - [Image wallpapers](#image-wallpapers)
        - [Solid color wallpapers](#solid-color-wallpapers)
        - [Example configuration](#example-configuration)
    - [Desktop names](#desktop-names)
        - [Example configuration](#example-configuration-1)
    - [Tooltips](#tooltips)
        - [Example configuration](#example-configuration-2)
    - [Keyboard shortcuts](#keyboard-shortcuts)
        - [Available shortcuts](#available-shortcuts)
            - [Keyboard shortcuts modifier keys](#keyboard-shortcuts-modifier-keys)
            - [Keyboard shortcuts identifier keys](#keyboard-shortcuts-identifier-keys)
            - [Keyboard shortcuts combinations](#keyboard-shortcuts-combinations)
        - [Example configurations](#example-configurations)
            - [Default configuration](#default-configuration)
            - [Custom configuration](#custom-configuration)
    - [Run programs when switching desktops](#run-programs-when-switching-desktops)
        - [Example configuration](#example-configuration-3)
    - [Tray Icon](#tray-icon)
        - [Icon Packs](#icon-packs)
    - [Old settings migration](#old-settings-migration)

<!-- /TOC -->

Click here to go back to the [README](../README.md).

## Main settings

The main settings are found in the `[General]` section of the `settings.ini` file and are used to define some basic settings of the program.  

| Setting                                        | Description                                                                                                        | Valid Values                               |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------ |
| DefaultDesktop                                 | Which desktop will be used as default (The program will switch to this desktop when started).                      | Any valid desktop number                   |
| TaskbarScrollSwitching                         | If scrolling over the taskbar will switch desktops.                                                                | `1`, `0` (Meaning YES and NO respectively) |
| UseNativePrevNextDesktopSwitchingIfConflicting | Whether to switch between desktops instantly or with the default Windows transition if the shortcuts conflict.     | `1`, `0` (Meaning YES and NO respectively) |
| DesktopWrapping                                | If going right from the last desktop should take you to the first one and vice-versa.                              | `1`, `0` (Meaning YES and NO respectively) |

## Custom wallpapers

You can set each virtual desktop to have its own wallpaper (an image or a fixed color) by editing the `[Wallpapers]` section of the `settings.ini` file.  
If you set the configuration of that desktop to empty (ex: `5=`) the wallpaper won't change when you switch to that desktop.  
Also note that any number of desktops are supported, just add a line for each new one, like shown in the examples.

### Image wallpapers

You can set the wallpaper for a certain desktop to be an image by adding the image path on the line corresponding to the desktop number in the `[Wallpapers]` section.  
Image paths can be absolute (e.g. `C:\Wallpapers\Default.jpg`) or relative (e.g. `..\images\Default.jpg`).

To get the absolute path of any file (in this case an image file) saved on your computer open the folder where it's saved, right click on it, copy the "Path" string and the name together with the extension, then merge them like this: `PATH\NAME.EXTENSION`. For example if the path is `C:\Programs\Test` and the filename is `image.png` the absolute path will be `C:\Program\Test\image.png`.

### Solid color wallpapers

You can set the wallpaper for a certain desktop to a solid color by adding the hexadecimal RGB code for that color next to the desktop number in the `[Wallpapers]` section.  

You can use [this special Google page](https://www.google.it/search?q=color+picker) to pick your color: its corresponding hexadecimal RGB code will be displayed on the left (e.g. pure red is `#ff0000`). Copy it, paste it in the correct place and replace the `#` with `0x` (`#ff0000` becomes `0xff0000`).

### Example configuration

Here is an example of a working configuration:
```ini
[Wallpapers]
1=C:\Wallpapers\Default.jpg
2=
3=
4=
5=0xab0923
6=
7=
8=0x0023de
9=
10=
11=C:\Wallpapers\Work.jpg
12=..\images\Email.jpg
20=
50=
999=C:\Wallpapers\End of the world.jpg
```

## Desktop names

In a similar manner to wallpapers you can assign a custom name to each virtual desktop: you can choose your own names by editing the `[DesktopNames]` section of the `settings.ini` file.  
The name will be shown in a popup every time you switch desktop (if you activated the popup feature) and in the tooltip of the tray icon.  
If a desktop's name is not set, "Desktop <number>" will be displayed.  
Again, like wallpapers, any number of desktops are supported by this feature: you can expand by adding new lines with new numbers.

### Example configuration

Here is an example of a working configuration:

```ini
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
```

## Tooltips

If you enable this feature a tooltip will appear every time you switch desktops letting you know the name of the desktop you switched to.

You can customize the appearance of these tooltips by editing the settings in the `[Tooltips]` section of the `settings.ini` file:  

| Setting                   | Description                                                                               | Valid Values                                   |
| ------------------------- | ----------------------------------------------------------------------------------------- | ---------------------------------------------- |
| Enabled                   | If tooltips should be shown.                                                              | `1`, `0` (Meaning YES and NO respectively)     |
| PositionX                 | The horizontal position of the tooltip on the monitor.                                    | LEFT, CENTER, RIGHT                            |
| PositionY                 | The vertical position of the tooltip on the monitor.                                      | TOP, CENTER, BOTTOM                            |
| FontSize                  | The size of the font.                                                                     | Any reasonable number                          |
| FontColor                 | The color of the font.                                                                    | Any hexadecimal number (from 0x0 to 0xFFFFFF)  |
| FontInBold                | If the font should be in bold.                                                            | `1`, `0` (Meaning YES and NO respectively)     |
| BackgroundColor           | The color of the background.                                                              | Any hexadecimal number (from 0x0 to 0xFFFFFF)  |
| Lifespan                  | The time in milliseconds for which each tooltip will be displayed.                        | Any reasonable number                          |
| FadeOutAnimationDuration  | The duration of the FadeOut animation in milliseconds.                                    | Any resonable number (best if less than 500)   |
| OnEveryMonitor            | If the tooltips should be shown on every monitor or just on the primary one.              | `1`, `0` (Meaning YES and NO respectively)     |

### Example configuration

As an example, here you can find the default configuration and a brief explanation of its behavior:

```ini
[Tooltips]
Enabled=1
PositionX=CENTER
PositionY=CENTER
FontSize=11
FontColor=0xFFFFFF
FontInBold=1
BackgroundColor=0x1F1F1F
Lifespan=750
FadeOutAnimationDuration=100
OnEveryMonitor=1
```

This configuration causes tooltips to be drawn on every monitor at the center of the screen, in a white, bold and small font, with a dark background: they are shown for 750 milliseconds, then fade out with an animation during 100 milliseconds.

## Keyboard shortcuts

Windows 10 Virtual Desktop Enhancer allows you to configure your own keyboard shortcuts to perform various actions.  A shortcut is composed of an action part and a context part.

The following are the actions that can be executed in the context of a virtual desktop:

- Switching to another desktop
- Moving the current window to another desktop
- Moving the current window to another desktop and then switch to that desktop
- Do any of the actions above, but relative to the next 10 desktops instead (more details below)

The following are the available context for those actions:

- Previous desktop
- Next desktop
- Desktop number X

To create a shortcut you need to specify a  _modifier key combination_ representing the action and an _identifier key_ representing the context.

A _modifier key combination_ must be composed of one ore more keys chosen from this list: `Ctrl`, `Shift`, `Alt`, `Win`, while an _identifier key_ can be any single key except those used as _modifiers_ (you can find a list with the names of special keys like the arrows, backspace, caps lock and so on [here](https://autohotkey.com/docs/KeyList.htm#Keyboard)).

For example: if you want to set up a keyboard shortcut to be able to switch to the next desktop, you need to set up the modifier keys for "switch to another desktop" (for example, `Ctrl, Win`), and also set up the identifier key for "next desktop" (for example, `Right`). Now pressing `Ctrl + Win + Right arrow` will switch to the next desktop.

The following actions are not executed in the context of a virtual desktop and therefore are defined directly by a _key combination_:

- Open the desktop manager
- Pin the currently visible window, which makes it visible in all of the virtual desktops
- Unpin the currently visible window
- Pin the current visible app, which makes all of the windows of that app visible in all of the virtual desktops
- Unpin the currently visible app
- Toggle pin on the currently visible window
- Toggle pin on the currently visible app
- Change the current desktop name

For each of these actions, you can set a combination of zero or more modifiers (as before), as well as a regular key.
For example: if you want to set up a keyboard shortcut to be able to pin the current window, you just need to set up that combination (for example, `Win, Ctrl, Q`).

### Available shortcuts

This is a list of the available shortcuts.

In addition to the configurable identifier keys, the number keys above the letters on your keyboard also act as identifier keys, and each targets a specific desktop (from Desktop 1 to 10, unless the "NextTenDesktops" modifier is pressed, which will make them target Desktop 11 to 20 instead).

Also note that if a setting is set to empty or not set at all, the feature corresponding to that setting will be disabled.

#### Keyboard shortcuts modifier keys

Each _modifier_ keys' setting can be a combination of the `Ctrl`, `Shift`, `Alt`, `Win` keys, separated by commas. For each key, you can use the left or right variant of the keys specifically, by adding `L` or `R` before the name of the key (e.g. `LCtrl`), otherwise both can be used. See below for examples.

| Name                         | Description                                 |
| ---------------------------- | ------------------------------------------- |
| SwitchDesktop                | Switch to a desktop.                        |
| MoveWindowToDesktop          | Move the current window to another desktop. |
| MoveWindowAndSwitchToDesktop | Move the current window to another desktop, and switch to it. |
| NextTenDesktops              | If doing any of the actions above and targeting a specific desktop (ex: Switch to desktop no. 3) it instead targets the desktop that comes 10 desktops after that one (ex: Switch to desktop no. 13 instead of no. 3). Note that this modifier works together with the modifiers above. |

#### Keyboard shortcuts identifier keys

Each _identifier_ keys' setting can be single key of your keyboard. They can be set to any value listed [in this page](https://autohotkey.com/docs/KeyList.htm#Keyboard) (except for keys already used as _modifiers_).

| Name                         | Description                                 |
| ---------------------------- | ------------------------------------------- |
| PreviousDesktop              | Do the action for the previous desktop. |
| NextDesktop                  | Do the action for the next desktop. |
| Desktop1                     | Do the action for desktop 1 (or desktop 11 if the key for "NextTenDesktops" is being pressed). |
| Desktop2                     | Do the action for desktop 2 (or desktop 12 if the key for "NextTenDesktops" is being pressed). |
| Desktop3                     | Do the action for desktop 3 (or desktop 13 if the key for "NextTenDesktops" is being pressed). |
| Desktop4                     | Do the action for desktop 4 (or desktop 14 if the key for "NextTenDesktops" is being pressed). |
| Desktop5                     | Do the action for desktop 5 (or desktop 15 if the key for "NextTenDesktops" is being pressed). |
| Desktop6                     | Do the action for desktop 6 (or desktop 16 if the key for "NextTenDesktops" is being pressed). |
| Desktop7                     | Do the action for desktop 7 (or desktop 17 if the key for "NextTenDesktops" is being pressed). |
| Desktop8                     | Do the action for desktop 8 (or desktop 18 if the key for "NextTenDesktops" is being pressed). |
| Desktop9                     | Do the action for desktop 9 (or desktop 19 if the key for "NextTenDesktops" is being pressed). |
| Desktop10                    | Do the action for desktop 10 (or desktop 20 if the key for "NextTenDesktops" is being pressed). |
| DesktopAlt1                  | Same as "Desktop1". Can be used as an alternative. |
| DesktopAlt2                  | Same as "Desktop2". Can be used as an alternative. |
| DesktopAlt3                  | Same as "Desktop3". Can be used as an alternative. |
| DesktopAlt4                  | Same as "Desktop4". Can be used as an alternative. |
| DesktopAlt5                  | Same as "Desktop5". Can be used as an alternative. |
| DesktopAlt6                  | Same as "Desktop6". Can be used as an alternative. |
| DesktopAlt7                  | Same as "Desktop7". Can be used as an alternative. |
| DesktopAlt8                  | Same as "Desktop8". Can be used as an alternative. |
| DesktopAlt9                  | Same as "Desktop9". Can be used as an alternative. |
| DesktopAlt10                 | Same as "Desktop10". Can be used as an alternative. |

#### Keyboard shortcuts combinations

_Combination_ keys' settings follow the same rules as [modifier keys' settings](#keyboard-shortcuts-modifier-keys), but in addition to that you need to add a single non-modifier key to the end, in the same format as described for the [identifier keys' settings](#keyboard-shortcuts-identifier-keys).

| Name                         | Description                                                   |
| ---------------------------- | ------------------------------------------------------------- |
| OpenDesktopManager           | Open the desktop manager.                                     |
| TogglePinWindow              | Toggle pin on the current window.                             |
| TogglePinApp                 | Toggle pin on all of the windows of the currently opened app. |
| PinWindow                    | Pin the current window.                                       |
| PinApp                       | Pin all of the windows of the currently opened app.           |
| UnpinWindow                  | Unpin the current window.                                     |
| UnpinApp                     | Unpin all of the windows of the currently opened app.         |
| ChangeDesktopName            | Change the name of the current desktop with a popup prompt.   |

### Example configurations

These are two configuration to better explain the syntax of keyboard shortcuts.

#### Default configuration

With this configuration:

```ini
[KeyboardShortcutsModifiers]
SwitchDesktop=Win, Ctrl
MoveWindowToDesktop=
MoveWindowAndSwitchToDesktop=Win, Ctrl, Shift
NextTenDesktops=

[KeyboardShortcutsIdentifiers]
PreviousDesktop=Left
NextDesktop=Right

[KeyboardShortcutsCombinations]
TogglePinWindow=Win, Ctrl, Shift, Q
TogglePinApp=Win, Ctrl, Shift, A
PinWindow=
PinApp=
UnpinWindow=
UnpinApp=
; "SC029" is the key below your "Esc" key
OpenDesktopManager=LAlt, SC029
ChangeDesktopName=Win, F2
```

The following shortcuts are available:

| Description                                                                    | Keyboard Shortcut                            |
| ------------------------------------------------------------------------------ | -------------------------------------------- |
| Switch to desktop by number                                                    | Win + Ctrl + (0-9)                           |
| Switch to next/previous desktop                                                | Win + Ctrl + (Left/Right Arrow)              |
| Move the current window to desktop by number                                   | Disabled                                     |
| Move the current window to next/previous desktop                               | Disabled                                     |
| Move the current window to desktop by number and switch to it                  | Win + Ctrl + Shift + (0-9)                   |
| Move the current window to next/previous desktop and switch to it              | Win + Ctrl + Shift + (Left/Right Arrow)      |
| Switch to desktop by number (desktops 11-20)                                   | Disabled                                     |
| Move the current window to desktop by number (desktops 11-20)                  | Disabled                                     |
| Move the current window to desktop by number and switch to it (desktops 11-20) | Disabled                                     |
| Pin/unpin (toggle) current <u>window</u>                                       | Win + Ctrl + Shift + Q                       |
| Pin/unpin (toggle) current <u>app</u>                                          | Win + Ctrl + Shift + A                       |
| Pin current window to all desktops                                             | Disabled                                     |
| Pin current app to all desktops                                                | Disabled                                     |
| Unpin current window from all desktops                                         | Disabled                                     |
| Unpin current app from all desktops                                            | Disabled                                     |
| Open Desktop Manager                                                           | Win + Ctrl + (key under Esc)                 |

#### Custom configuration

With this configuration:
```ini
[KeyboardShortcutsModifiers]
SwitchDesktop=LAlt
MoveWindowToDesktop=LAlt, Shift
MoveWindowAndSwitchToDesktop=LAlt, Ctrl, Shift
NextTenDesktops=Win

[KeyboardShortcutsIdentifiers]
PreviousDesktop=PgUp
NextDesktop=PgDn

[KeyboardShortcutsCombinations]
TogglePinWindow=
TogglePinApp=
PinWindow=
PinApp=
UnpinWindow=
UnpinApp=
OpenDesktopManager=
```

The following shortcuts are available:

| Description                                                                    | Keyboard Shortcut                             |
| ------------------------------------------------------------------------------ | --------------------------------------------- |
| Switch to desktop by number                                                    | Left Alt + (0-9)                              |
| Switch to next/previous desktop                                                | Left Alt + (Page Up/Page Down)                |
| Move the current window to desktop by number                                   | Left Alt + Shift + (0-9)                      |
| Move the current window to next/previous desktop                               | Left Alt + Shift + (Page Up/Page Down)        |
| Move the current window to desktop by number and switch to it                  | Left Alt + Ctrl + Shift + (0-9)               |
| Move the current window to next/previous desktop and switch to it              | Left Alt + Ctrl + Shift + (Page Up/Page Down) |
| Switch to desktop by number (desktops 11-20)                                   | Left Alt + Win + (0-9)                        |
| Move the current window to desktop by number (desktops 11-20)                  | Left Alt + Shift + Win (0-9)                  |
| Move the current window to desktop by number and switch to it (desktops 11-20) | Left Alt + Ctrl + Shift + Win (0-9)           |
| Pin/unpin (toggle) current <u>window</u>                                       | Disabled                                      |
| Pin/unpin (toggle) current <u>app</u>                                          | Disabled                                      |
| Pin current window to all desktops                                             | Disabled                                      |
| Pin current app to all desktops                                                | Disabled                                      |
| Unpin current window from all desktops                                         | Disabled                                      |
| Unpin current app from all desktops                                            | Disabled                                      |
| Open Desktop Manager                                                           | Disabled                                      |

## Run programs when switching desktops

You can run a program when switching _to_ or _from_ a certain desktop by entering the executable path of the programs in the `[RunProgramWhenSwitchingFromDesktop]` and `[RunProgramWhenSwitchingToDesktop]` sections of `settings.ini` in a similar way to [desktop names](#desktop-names) or [desktop wallpapers](#custom-wallpapers).

The file can be of any type, not just executable ones (for example you can select an image or text file and it will be opened with the default program associated with it).

To get the absolute path of any file (in this case the file you want to execute) saved on your computer open the folder where it's saved, right click on it, copy the "Path" string and the name together with the extension, then merge them like this: `PATH\NAME.EXTENSION`. For example if the path is `C:\Programs\Test` and the filename is `image.png` the absolute path will be `C:\Program\Test\image.png`.


### Example configuration

```ini
[General]
DefaultDesktop=2

[RunProgramWhenSwitchingToDesktop]
1=C:/Batch Files/Open Chrome.bat
2=C:/Batch Files/Open Outlook.bat
3=

[RunProgramWhenSwitchingFromDesktop]
1=C:/Batch Files/Close Chrome.bat
2=C:/Batch Files/Close Outlook.bat
3=
```

With the configuration above, once this app starts, it will switch to desktop 2, and it will run the "Open Outlook.bat" program.  
If you then switch to the first desktop, it will run the "Close Outlook.bat" and "Open Chrome.bat" programs.  
If you then switch to the second desktop, it will run the "Close Chrome.bat" and "Open Outlook.bat" programs.  
If you then switch to the third desktop, it will run the "Close Outlook.bat" program.

## Tray Icon

A new tray icon will be available while the program is running. It will state the number of the current desktop (1-10).  
If you click on it the desktop management screen will be displayed.

### Icon Packs

By default the white text on black background icon pack is set, but more packs are available: to change between them, go into the "icons" folder and extract the ZIP file for the theme you want to use, and replace any existing files if prompted.

To create personalized custom packs, simply create one icon per desktop and name them appropriately (`[desktop number goes here].ico`, ex: `1.ico`, `5.ico`, `99.ico`). If the current desktop does not have an icon for it, the `+.ico` icon is shown instead, so make sure you create that as well for your pack.

## Old settings migration

Between version 0.9.1 and the following ones, the name and location of some settings changed. The table and examples below should explain what was changed.

| Old location                        | New Location                                                |
| ----------------------------------- | ----------------------------------------------------------- |
| \[KeyboardShortcuts\] Switch        | \[KeyboardShortcutsModifiers\] SwitchDesktop                |
| \[KeyboardShortcuts\] Move          | \[KeyboardShortcutsModifiers\] MoveWindowToDesktop          |
| \[KeyboardShortcuts\] MoveAndSwitch | \[KeyboardShortcutsModifiers\] MoveWindowAndSwitchToDesktop |
| \[KeyboardShortcuts\] PlusTen       | \[KeyboardShortcutsModifiers\] NextTenDesktops              |
| \[KeyboardShortcuts\] Previous      | \[KeyboardShortcutsIdentifiers\] PreviousDesktop            |
| \[KeyboardShortcuts\] Next          | \[KeyboardShortcutsIdentifiers\] NextDesktop                |

Old configuration:

```ini
[KeyboardShortcuts]
Switch=LAlt
Move=LAlt, Shift, Ctrl
MoveAndSwitch=LAlt, Shift
PlusTen=
Previous=Left
Next=Right
```

New configuration (converted):

```ini
[KeyboardShortcutsModifiers]
SwitchDesktop=LAlt
MoveWindowToDesktop=LAlt, Shift, Ctrl
MoveWindowAndSwitchToDesktop=LAlt, Shift
NextTenDesktops=

[KeyboardShortcutsIdentifiers]
PreviousDesktop=Left
NextDesktop=Right
```

Click here to go back to the [README](../README.md).