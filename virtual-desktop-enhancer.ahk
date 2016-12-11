#SingleInstance, force
#WinActivateForce
#HotkeyInterval 20
#MaxHotkeysPerInterval 20000
; Credits to Ciantic: https://github.com/Ciantic/VirtualDesktopAccessor

#Include, read-ini.ahk
#Include, tooltip.ahk

; ======================================================================
; Setup
; ======================================================================

DetectHiddenWindows, On
hwnd := WinExist("ahk_pid " . DllCall("GetCurrentProcessId","Uint"))
hwnd += 0x1000 << 32

hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", ".\virtual-desktop-accessor.dll", "Ptr") 

global GoToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GoToDesktopNumber", "Ptr")
global RegisterPostMessageHookProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "RegisterPostMessageHook", "Ptr")
global UnregisterPostMessageHookProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "UnregisterPostMessageHook", "Ptr")
global GetCurrentDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetCurrentDesktopNumber", "Ptr")
global GetDesktopCountProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetDesktopCount", "Ptr")
global IsWindowOnCurrentVirtualDesktopProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsWindowOnCurrentVirtualDesktop", "Ptr")
global MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "MoveWindowToDesktopNumber", "Ptr")

DllCall(RegisterPostMessageHookProc, Int, hwnd, Int, 0x1400 + 30)
OnMessage(0x1400 + 30, "VWMess")
VWMess(wParam, lParam, msg, hwnd) {
    OnDesktopSwitch(lParam + 1)
}

; ======================================================================
; Auto Execute
; ======================================================================

Menu, Tray, NoStandard
Menu, Tray, Add, &Manage Desktops, OpenDesktopManager
Menu, Tray, Default, &Manage Desktops
Menu, Tray, Add, Reload Settings, Reload
Menu, Tray, Add, Exit, Exit
Menu, Tray, Click, 1

ReadIni("settings.ini")

global TooltipsAreEnabled := (TooltipsAreEnabled != "" and TooltipsAreEnabled ~= "^[01]$") ? TooltipsAreEnabled : 1
global TooltipsLifespan := (TooltipsLifespan != "" and TooltipsLifespan ~= "^\d+$") ? TooltipsLifespan : 750
global TooltipsCentered := (TooltipsCentered != "" and TooltipsCentered ~= "^[01]$") ? TooltipsCentered : 1
global TooltipsFontSize := (TooltipsFontSize != "" and TooltipsFontSize ~= "^\d+$") ? TooltipsFontSize : 11
global TooltipsFontInBold := (TooltipsFontInBold != "" and TooltipsFontInBold ~= "^[01]$") ? (TooltipsFontInBold ? 700 : 400) : 700
global TooltipsFontColor := (TooltipsFontColor != "" and TooltipsFontColor ~= "^0x[0-9A-Fa-f]{1,6}$") ? TooltipsFontColor : "0xFFFFFF"
global TooltipsBackgroundColor := (TooltipsBackgroundColor != "" and TooltipsBackgroundColor ~= "^0x[0-9A-Fa-f]{1,6}$") ? TooltipsBackgroundColor : "0x1F1F1F"

SwitchToDesktop(GeneralDefaultDesktop)
; Update everything again, if the default desktop matches the current one
OnDesktopSwitch(GeneralDefaultDesktop)

; ======================================================================
; Key Bindings
; ======================================================================

; Format and translate up the modifier keys strings

switchModifiers := KeyboardShortcutsSwitch
moveModifiers := KeyboardShortcutsMove
moveAndSwitchModifiers := KeyboardShortcutsMoveAndSwitch
previousKey := KeyboardShortcutsPrevious
nextKey := KeyboardShortcutsNext
plusTenModifiers := KeyboardShortcutsPlusTen

arrayS := Object()
arrayR := Object()
arrayS.Insert(", ?"),                   arrayR.Insert("")
arrayS.Insert("L(Ctrl|Shift|Alt|Win)"), arrayR.Insert("<$1")
arrayS.Insert("R(Ctrl|Shift|Alt|Win)"), arrayR.Insert(">$1")
arrayS.Insert("Ctrl"),                  arrayR.Insert("^")
arrayS.Insert("Shift"),                 arrayR.Insert("+")
arrayS.Insert("Alt"),                   arrayR.Insert("!")
arrayS.Insert("Win"),                   arrayR.Insert("#")

for index in arrayS {
    switchModifiers := RegExReplace(switchModifiers, arrayS[index], arrayR[index])
    moveModifiers := RegExReplace(moveModifiers, arrayS[index], arrayR[index])
    moveAndSwitchModifiers := RegExReplace(moveAndSwitchModifiers, arrayS[index], arrayR[index])
    plusTenModifiers := RegExReplace(plusTenModifiers, arrayS[index], arrayR[index])
}

; Setup key bindings dynamically
;  If they are set incorrectly in the settings, an error will be thrown. 

areSwitchModsValid := (switchModifiers <> "")
areMoveModsValid := (moveModifiers <> "")
areMoveAndSwitchModsValid := (moveAndSwitchModifiers <> "")
arePrevAndNextKeysValid := (previousKey <> "" && nextKey <> "")
arePlusTenModsValid := (plusTenModifiers <> "")

i := 0
while (i < 10) {
    if (areSwitchModsValid) {
        Hotkey, % (switchModifiers . i), OnShiftNumberedPress, UseErrorLevel
        areSwitchModsValid := (ErrorLevel = 0)
        ErrorLevel := 0
        if (arePlusTenModsValid) {
            Hotkey, % (switchModifiers . plusTenModifiers . i), OnShiftNumberedPressNextTen, UseErrorLevel
            arePlusTenModsValid := (ErrorLevel = 0)
            ErrorLevel := 0
        }
    }
    if (areMoveModsValid) {
        Hotkey, % (moveModifiers . i), OnMoveNumberedPress, UseErrorLevel
        areMoveModsValid := (ErrorLevel = 0)
        ErrorLevel := 0
        if (arePlusTenModsValid) {
            Hotkey, % (moveModifiers . plusTenModifiers . i), OnMoveNumberedPressNextTen, UseErrorLevel
            arePlusTenModsValid := (ErrorLevel = 0)
            ErrorLevel := 0
        }
    }
    if (areMoveAndSwitchModsValid) {
        Hotkey, % (moveAndSwitchModifiers . i), OnMoveAndShiftNumberedPress, UseErrorLevel
        areMoveAndSwitchModsValid := (ErrorLevel = 0)
        ErrorLevel := 0
        if (arePlusTenModsValid) {
            Hotkey, % (moveAndSwitchModifiers . plusTenModifiers . i), OnMoveAndShiftNumberedPressNextTen, UseErrorLevel
            arePlusTenModsValid := (ErrorLevel = 0)
            ErrorLevel := 0
        }
    }
    i := i + 1
}
if (areSwitchModsValid && arePrevAndNextKeysValid) {
    Hotkey, % (switchModifiers . previousKey), OnShiftLeftPress, UseErrorLevel
    Hotkey, % (switchModifiers . nextKey), OnShiftRightPress, UseErrorLevel
    arePrevAndNextKeysValid := (ErrorLevel = 0)
    ErrorLevel := 0
    Hotkey, % (switchModifiers . "SC029"), OpenDesktopManager, UseErrorLevel
}
if (areMoveModsValid && arePrevAndNextKeysValid) {
    Hotkey, % (moveModifiers . previousKey), OnMoveLeftPress, UseErrorLevel
    Hotkey, % (moveModifiers . nextKey), OnMoveRightPress, UseErrorLevel
    arePrevAndNextKeysValid := (ErrorLevel = 0)
    ErrorLevel := 0
}
if (areMoveAndSwitchModsValid && arePrevAndNextKeysValid) {
    Hotkey, % (moveAndSwitchModifiers . previousKey), OnMoveAndShiftLeftPress, UseErrorLevel
    Hotkey, % (moveAndSwitchModifiers . nextKey), OnMoveAndShiftRightPress, UseErrorLevel
    arePrevAndNextKeysValid := (ErrorLevel = 0)
    ErrorLevel := 0
}

; Check if it failed to setup the key bindings
;  Ignore if it failed because the modifiers just weren't defined, which disables the keyboard shortcut

areSwitchModsValid := areSwitchModsValid || (switchModifiers = "")
areMoveModsValid := areMoveModsValid || (moveModifiers = "")
areMoveAndSwitchModsValid := areMoveAndSwitchModsValid || (moveAndSwitchModifiers = "")
arePrevAndNextKeysValid := arePrevAndNextKeysValid || (previousKey = "" || nextKey = "")

if (!areSwitchModsValid || !areMoveModsValid || !areMoveAndSwitchModsValid || !arePrevAndNextKeysValid) {
    MsgBox, 16, Error, The keyboard shortcuts have been defined incorrectly in the settings file. Please read the instructions again and reconfigure them.
    Exit
}

if (GeneralTaskbarScrollSwitching) {
    Hotkey, % "~WheelUp", OnTaskbarScrollUp
    Hotkey, % "~WheelDown", OnTaskbarScrollDown
}


; ======================================================================
; Event Handlers
; ======================================================================

OnShiftNumberedPress() {
    SwitchToDesktop(substr(A_ThisHotkey, 0, 1))
}

OnShiftNumberedPressNextTen() {
    SwitchToDesktop(1 . substr(A_ThisHotkey, 0, 1))
}

OnMoveNumberedPress() {
    MoveToDesktop(substr(A_ThisHotkey, 0, 1))
}

OnMoveNumberedPressNextTen() {
    MoveToDesktop(1 . substr(A_ThisHotkey, 0, 1))
}

OnMoveAndShiftNumberedPress() {
    MoveAndSwitchToDesktop(substr(A_ThisHotkey, 0, 1))
}

OnMoveAndShiftNumberedPressNextTen() {
    MoveAndSwitchToDesktop(1 . substr(A_ThisHotkey, 0, 1))
}

OnShiftLeftPress() {
    SwitchToDesktop(_GetPreviousDesktopNumber())
}

OnShiftRightPress() {
    SwitchToDesktop(_GetNextDesktopNumber())
}

OnMoveLeftPress() {
    MoveToDesktop(_GetPreviousDesktopNumber())
}

OnMoveRightPress() {
    MoveToDesktop(_GetNextDesktopNumber())
}

OnMoveAndShiftLeftPress() {
    MoveAndSwitchToDesktop(_GetPreviousDesktopNumber())
}

OnMoveAndShiftRightPress() {
    MoveAndSwitchToDesktop(_GetNextDesktopNumber())
}

OnTaskbarScrollUp() {
    if (IsCursorHoveringTaskbar()) {
        OnShiftLeftPress()
    }
}

OnTaskbarScrollDown() {
    if (IsCursorHoveringTaskbar()) {
        OnShiftRightPress()
    }
}

OnDesktopSwitch(n:=1) {
    if (TooltipsAreEnabled) {
        _ShowTooltip(n)
    }
    _ChangeAppearance(n)
    _ChangeBackground(n)
    _FocusIfRequested()
}

; ======================================================================
; Functions
; ======================================================================

global taskbarID=0

IsCursorHoveringTaskbar() {
    MouseGetPos,,, mouseHoveringID
    if (!taskbarID) {
        WinGet, taskbarID, ID, ahk_class Shell_TrayWnd
    }
    return (mouseHoveringID == taskbarID)
}

global doFocusAfterNextSwitch=0

SwitchToDesktop(n:=1) {
    doFocusAfterNextSwitch=1
    _ChangeDesktop(n)
}

MoveToDesktop(n:=1) {
    _MoveCurrentWindowToDesktop(n)
    _Focus()
}

MoveAndSwitchToDesktop(n:=1) {
    doFocusAfterNextSwitch=1
    _MoveCurrentWindowToDesktop(n)
    _ChangeDesktop(n)
}

OpenDesktopManager() {
    Send #{Tab}
}

Reload() {
    Reload
}

Exit() {
    ExitApp
}

_GetDesktopName(n:=1) {
    if (n == 0) {
        n := 10
    }
    name := DesktopNames%n%
    if (!name) {
        name := "Desktop " . n
    }
    return name
}

_GetNextDesktopNumber() {
    i := _GetCurrentDesktopNumber()
    i := (i = _GetNumberOfDesktops() ? 1 : i + 1)
    return i
}

_GetPreviousDesktopNumber() {
    i := _GetCurrentDesktopNumber()
    i := (i = 1 ? _GetNumberOfDesktops() : i - 1)
    return i
}

_GetCurrentDesktopNumber() {
    return DllCall(GetCurrentDesktopNumberProc) + 1
}

_GetNumberOfDesktops() {
    return DllCall(GetDesktopCountProc)
}

_MoveCurrentWindowToDesktop(n:=1) {
    WinGet, activeHwnd, ID, A
    DllCall(MoveWindowToDesktopNumberProc, UInt, activeHwnd, UInt, n-1)
}

_ChangeDesktop(n:=1) {
    if (n == 0) {
        n := 10
    }
    DllCall(GoToDesktopNumberProc, Int, n-1)
}

_ChangeBackground(n:=1) {
    line := Wallpapers%n%

    isHex := RegExMatch(line, "^0x([0-9A-Fa-f]{1,6})", hexMatchTotal)

    if (isHex) {
        hexColorReversed := SubStr("00000" . hexMatchTotal1, -5)

        RegExMatch(hexColorReversed, "^([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})", match)
        hexColor := "0x" . match3 . match2 . match1, hexColor += 0

        DllCall("SystemParametersInfo", UInt, 0x14, UInt, 0, Str, "", UInt, 1)
        DllCall("SetSysColors", "Int", 1, "Int*", 1, "UInt*", hexColor)
    }
    else {
        filePath := line

        isRelative := (substr(filePath, 1, 1) == ".")
        if (isRelative) {
            filePath := (A_WorkingDir . substr(filePath, 2))
        }
        if (filePath and FileExist(filePath)) {
            DllCall("SystemParametersInfo", UInt, 0x14, UInt, 0, Str, filePath, UInt, 1)
        }
    }
}

_ChangeAppearance(n:=1) {
    Menu, Tray, Tip, % _GetDesktopName(n)
    if (FileExist("./icons/" . n ".ico")) {
        Menu, Tray, Icon, icons/%n%.ico
    }
    else {
        Menu, Tray, Icon, icons/+.ico
    }
}

_FocusIfRequested() {
    if (doFocusAfterNextSwitch) {
        _Focus()
        doFocusAfterNextSwitch=0
    }
}

_Focus() {
    WinActivate, ahk_class Shell_TrayWnd
    SendEvent !{Esc}
}

_ShowTooltip(n:=1) {
    if (n == 0) {
        n := 10
    }
    params := {}
    params.message := _GetDesktopName(n)
    params.lifespan := TooltipsLifespan
    params.position := TooltipsCentered
    params.fontSize := TooltipsFontSize
    params.fontWeight := TooltipsFontInBold
    params.fontColor := TooltipsFontColor
    params.backgroundColor := TooltipsBackgroundColor
    Toast(params)
}