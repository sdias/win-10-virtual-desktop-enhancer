#SingleInstance, force
#WinActivateForce
#HotkeyInterval 20
#MaxHotkeysPerInterval 20000
#MenuMaskKey vk07
#UseHook
; Credits to Ciantic: https://github.com/Ciantic/VirtualDesktopAccessor

#Include, %A_ScriptDir%\libraries\read-ini.ahk
#Include, %A_ScriptDir%\libraries\tooltip.ahk

; ======================================================================
; Set Up Library Hooks
; ======================================================================

DetectHiddenWindows, On
hwnd := WinExist("ahk_pid " . DllCall("GetCurrentProcessId","Uint"))
hwnd += 0x1000 << 32

hVirtualDesktopAccessor := DllCall("LoadLibrary", "Str", A_ScriptDir . "\libraries\virtual-desktop-accessor.dll", "Ptr")

global GoToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GoToDesktopNumber", "Ptr")
global RegisterPostMessageHookProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "RegisterPostMessageHook", "Ptr")
global UnregisterPostMessageHookProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "UnregisterPostMessageHook", "Ptr")
global GetCurrentDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetCurrentDesktopNumber", "Ptr")
global GetDesktopCountProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "GetDesktopCount", "Ptr")
global IsWindowOnDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsWindowOnDesktopNumber", "Ptr")
global MoveWindowToDesktopNumberProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "MoveWindowToDesktopNumber", "Ptr")
global IsPinnedWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsPinnedWindow", "Ptr")
global PinWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "PinWindow", "Ptr")
global UnPinWindowProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "UnPinWindow", "Ptr")
global IsPinnedAppProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "IsPinnedApp", "Ptr")
global PinAppProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "PinApp", "Ptr")
global UnPinAppProc := DllCall("GetProcAddress", Ptr, hVirtualDesktopAccessor, AStr, "UnPinApp", "Ptr")

DllCall(RegisterPostMessageHookProc, Int, hwnd, Int, 0x1400 + 30)
OnMessage(0x1400 + 30, "VWMess")
VWMess(wParam, lParam, msg, hwnd) {
    OnDesktopSwitch(lParam + 1)
}

; ======================================================================
; Auto Execute
; ======================================================================

; Set up tray tray menu

Menu, Tray, NoStandard
Menu, Tray, Add, &Manage Desktops, OpenDesktopManager
Menu, Tray, Default, &Manage Desktops
Menu, Tray, Add, Reload Settings, Reload
Menu, Tray, Add, Exit, Exit
Menu, Tray, Click, 1

; Read and groom settings

ReadIni("settings.ini")

global GeneralDesktopWrapping := (GeneralDesktopWrapping != "" and GeneralDesktopWrapping ~= "^[01]$") ? GeneralDesktopWrapping : 1
global TooltipsEnabled := (TooltipsEnabled != "" and TooltipsEnabled ~= "^[01]$") ? TooltipsEnabled : 1
global TooltipsLifespan := (TooltipsLifespan != "" and TooltipsLifespan ~= "^\d+$") ? TooltipsLifespan : 750
global TooltipsFadeOutAnimationDuration := (TooltipsFadeOutAnimationDuration != "" and TooltipsFadeOutAnimationDuration ~= "^\d+$") ? TooltipsFadeOutAnimationDuration : 100
global TooltipsPositionX := (TooltipsPositionX == "LEFT" or TooltipsPositionX == "CENTER" or TooltipsPositionX == "RIGHT") ? TooltipsPositionX : "CENTER"
global TooltipsPositionY := (TooltipsPositionY == "TOP" or TooltipsPositionY == "CENTER" or TooltipsPositionY == "BOTTOM") ? TooltipsPositionY : "CENTER"
global TooltipsOnEveryMonitor := (TooltipsOnEveryMonitor != "" and TooltipsOnEveryMonitor ~= "^[01]$") ? TooltipsOnEveryMonitor : 1
global TooltipsFontSize := (TooltipsFontSize != "" and TooltipsFontSize ~= "^\d+$") ? TooltipsFontSize : 11
global TooltipsFontInBold := (TooltipsFontInBold != "" and TooltipsFontInBold ~= "^[01]$") ? (TooltipsFontInBold ? 700 : 400) : 700
global TooltipsFontColor := (TooltipsFontColor != "" and TooltipsFontColor ~= "^0x[0-9A-Fa-f]{1,6}$") ? TooltipsFontColor : "0xFFFFFF"
global TooltipsBackgroundColor := (TooltipsBackgroundColor != "" and TooltipsBackgroundColor ~= "^0x[0-9A-Fa-f]{1,6}$") ? TooltipsBackgroundColor : "0x1F1F1F"
global GeneralUseNativePrevNextDesktopSwitchingIfConflicting := (GeneralUseNativePrevNextDesktopSwitchingIfConflicting ~= "^[01]$" && GeneralUseNativePrevNextDesktopSwitchingIfConflicting == "1" ? true : false)
global GeneralNumberOfCyclableDesktops := GeneralNumberOfCyclableDesktops >= 1 ? GeneralNumberOfCyclableDesktops : 0
global GeneralIconDir := GeneralIconDir != "" ? GeneralIconDir : "icons/"
global GeneralIconDir := GeneralIconDir ~= "/$" ? GeneralIconDir : GeneralIconDir . "/"

; Initialize

global taskbarPrimaryID=0
global taskbarSecondaryID=0
global previousDesktopNo=0
global doFocusAfterNextSwitch=0
global numberedHotkeys={}

global changeDesktopNamesPopupTitle := "Windows 10 Virtual Desktop Enhancer"
global changeDesktopNamesPopupText :=  "Change the desktop name of desktop #{:d}"

initialDesktopNo := _GetCurrentDesktopNumber()

if (GeneralDefaultDesktop != "" && GeneralDefaultDesktop > 0 && GeneralDefaultDesktop != initialDesktopNo) {
    SwitchToDesktop(GeneralDefaultDesktop)
} else {
    ; Call "OnDesktopSwitch" since it wouldn't be called otherwise
    OnDesktopSwitch(initialDesktopNo)
}

; ======================================================================
; Set Up Key Bindings
; ======================================================================

; Translate the modifier keys strings

hkModifiersSwitchNum        := KeyboardShortcutsModifiersSwitchDesktopNum
hkModifiersMoveNum          := KeyboardShortcutsModifiersMoveWindowToDesktopNum
hkModifiersMoveAndSwitchNum := KeyboardShortcutsModifiersMoveWindowAndSwitchToDesktopNum
hkModifiersPlusTen          := KeyboardShortcutsModifiersNextTenDesktops
hkModifiersSwitchDir        := KeyboardShortcutsModifiersSwitchDesktopDir
hkModifiersMoveDir          := KeyboardShortcutsModifiersMoveWindowToDesktopDir
hkModifiersMoveAndSwitchDir := KeyboardShortcutsModifiersMoveWindowAndSwitchToDesktopDir
hkIdentifierPrevious        := KeyboardShortcutsIdentifiersPreviousDesktop
hkIdentifierNext            := KeyboardShortcutsIdentifiersNextDesktop
hkComboPinWin               := KeyboardShortcutsCombinationsPinWindow
hkComboUnpinWin             := KeyboardShortcutsCombinationsUnpinWindow
hkComboTogglePinWin         := KeyboardShortcutsCombinationsTogglePinWindow
hkComboPinApp               := KeyboardShortcutsCombinationsPinApp
hkComboUnpinApp             := KeyboardShortcutsCombinationsUnpinApp
hkComboTogglePinApp         := KeyboardShortcutsCombinationsTogglePinApp
hkComboOpenDesktopManager   := KeyboardShortcutsCombinationsOpenDesktopManager
hkComboChangeDesktopName    := KeyboardShortcutsCombinationsChangeDesktopName

arrayS := Object(),                     arrayR := Object()
arrayS.Insert("\s*|,"),                 arrayR.Insert("")
arrayS.Insert("L(Ctrl|Shift|Alt|Win)"), arrayR.Insert("<$1")
arrayS.Insert("R(Ctrl|Shift|Alt|Win)"), arrayR.Insert(">$1")
arrayS.Insert("Ctrl"),                  arrayR.Insert("^")
arrayS.Insert("Shift"),                 arrayR.Insert("+")
arrayS.Insert("Alt"),                   arrayR.Insert("!")
arrayS.Insert("Win"),                   arrayR.Insert("#")

for index in arrayS {
    hkModifiersSwitchNum        := RegExReplace(hkModifiersSwitchNum, arrayS[index], arrayR[index])
    hkModifiersMoveNum          := RegExReplace(hkModifiersMoveNum, arrayS[index], arrayR[index])
    hkModifiersMoveAndSwitchNum := RegExReplace(hkModifiersMoveAndSwitchNum, arrayS[index], arrayR[index])
    hkModifiersPlusTen          := RegExReplace(hkModifiersPlusTen, arrayS[index], arrayR[index])
    hkModifiersSwitchDir        := RegExReplace(hkModifiersSwitchDir, arrayS[index], arrayR[index])
    hkModifiersMoveDir          := RegExReplace(hkModifiersMoveDir, arrayS[index], arrayR[index])
    hkModifiersMoveAndSwitchDir := RegExReplace(hkModifiersMoveAndSwitchDir, arrayS[index], arrayR[index])
    hkComboPinWin               := RegExReplace(hkComboPinWin, arrayS[index], arrayR[index])
    hkComboUnpinWin             := RegExReplace(hkComboUnpinWin, arrayS[index], arrayR[index])
    hkComboTogglePinWin         := RegExReplace(hkComboTogglePinWin, arrayS[index], arrayR[index])
    hkComboPinApp               := RegExReplace(hkComboPinApp, arrayS[index], arrayR[index])
    hkComboUnpinApp             := RegExReplace(hkComboUnpinApp, arrayS[index], arrayR[index])
    hkComboTogglePinApp         := RegExReplace(hkComboTogglePinApp, arrayS[index], arrayR[index])
    hkComboOpenDesktopManager   := RegExReplace(hkComboOpenDesktopManager, arrayS[index], arrayR[index])
    hkComboChangeDesktopName    := RegExReplace(hkComboChangeDesktopName, arrayS[index], arrayR[index])    
}

; Setup key bindings dynamically
;  If they are set incorrectly in the settings, an error will be thrown.

setUpHotkey(hk, handler, settingPaths, n:=0) {
    Hotkey, %hk%, %handler%, UseErrorLevel
    if (ErrorLevel <> 0) {
        MsgBox, 16, Error, One or more keyboard shortcut settings have been defined incorrectly in the settings file: `n%settingPaths%. `n`nPlease read the README for instructions.
        Exit
    }
    if (n) {
        numberedHotkeys[hk] := n
    }
}

setUpHotkeyWithOneSetOfModifiersAndIdentifier(modifiers, identifier, handler, settingPaths, n:=0) {
    modifiers <> "" && identifier <> "" ? setUpHotkey(modifiers . identifier, handler, settingPaths, n) :
}

setUpHotkeyWithTwoSetOfModifiersAndIdentifier(modifiersA, modifiersB, identifier, handler, settingPaths, n:=0) {
    modifiersA <> "" && modifiersB <> "" && identifier <> "" ? setUpHotkey(modifiersA . modifiersB . identifier, handler, settingPaths, n) :
}

setUpHotkeyWithCombo(combo, handler, settingPaths) {
    combo <> "" ? setUpHotkey(combo, handler, settingPaths) :
}

i := 1
numDesktops := Max(_GetNumberOfDesktops(), 10)
while (i <= numDesktops) {
    hkDesktopI0 := KeyboardShortcutsIdentifiersDesktop%i%
    hkDesktopI1 := KeyboardShortcutsIdentifiersDesktopAlt%i%
    j := 0
    while (j < 2) {
        hkDesktopI := hkDesktopI%j%
        setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersSwitchNum, hkDesktopI, "OnShiftNumberedPress", "[KeyboardShortcutsModifiers] SwitchDesktopNum", i)
        setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersMoveNum, hkDesktopI, "OnMoveNumberedPress", "[KeyboardShortcutsModifiers] MoveWindowToDesktopNum", i)
        setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersMoveAndSwitchNum, hkDesktopI, "OnMoveAndShiftNumberedPress", "[KeyboardShortcutsModifiers] MoveWindowAndSwitchToDesktopNum", i)
        setUpHotkeyWithTwoSetOfModifiersAndIdentifier(hkModifiersSwitchNum, hkModifiersPlusTen, hkDesktopI, "OnShiftNumberedPressNextTen", "[KeyboardShortcutsModifiers] SwitchDesktopNum, [KeyboardShortcutsModifiers] NextTenDesktops", i)
        setUpHotkeyWithTwoSetOfModifiersAndIdentifier(hkModifiersMoveNum, hkModifiersPlusTen, hkDesktopI, "OnMoveNumberedPressNextTen", "[KeyboardShortcutsModifiers] MoveWindowToDesktopNum, [KeyboardShortcutsModifiers] NextTenDesktops", i)
        setUpHotkeyWithTwoSetOfModifiersAndIdentifier(hkModifiersMoveAndSwitchNum, hkModifiersPlusTen, hkDesktopI, "OnMoveAndShiftNumberedPressNextTen", "[KeyboardShortcutsModifiers] MoveWindowAndSwitchToDesktopNum, [KeyboardShortcutsModifiers] NextTenDesktops", i)
        j := j + 1
    }
    i := i + 1
}
if (!(GeneralUseNativePrevNextDesktopSwitchingIfConflicting && _IsPrevNextDesktopSwitchingKeyboardShortcutConflicting(hkModifiersSwitchDir, hkIdentifierPrevious))) {
    setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersSwitchDir, hkIdentifierPrevious, "OnShiftLeftPress", "[KeyboardShortcutsModifiers] SwitchDesktopDir, [KeyboardShortcutsIdentifiers] PreviousDesktop")
}
if (!(GeneralUseNativePrevNextDesktopSwitchingIfConflicting && _IsPrevNextDesktopSwitchingKeyboardShortcutConflicting(hkModifiersSwitchDir, hkIdentifierNext))) {
    setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersSwitchDir, hkIdentifierNext, "OnShiftRightPress", "[KeyboardShortcutsModifiers] SwitchDesktopDir, [KeyboardShortcutsIdentifiers] NextDesktop")
}

setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersMoveDir, hkIdentifierPrevious, "OnMoveLeftPress", "[KeyboardShortcutsModifiers] MoveWindowToDesktopDir, [KeyboardShortcutsIdentifiers] PreviousDesktop")
setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersMoveDir, hkIdentifierNext, "OnMoveRightPress", "[KeyboardShortcutsModifiers] MoveWindowToDesktopDir, [KeyboardShortcutsIdentifiers] NextDesktop")

setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersMoveAndSwitchDir, hkIdentifierPrevious, "OnMoveAndShiftLeftPress", "[KeyboardShortcutsModifiers] MoveWindowAndSwitchToDesktopDir, [KeyboardShortcutsIdentifiers] PreviousDesktop")
setUpHotkeyWithOneSetOfModifiersAndIdentifier(hkModifiersMoveAndSwitchDir, hkIdentifierNext, "OnMoveAndShiftRightPress", "[KeyboardShortcutsModifiers] MoveWindowAndSwitchToDesktopDir, [KeyboardShortcutsIdentifiers] NextDesktop")

setUpHotkeyWithCombo(hkComboPinWin, "OnPinWindowPress", "[KeyboardShortcutsCombinations] PinWindow")
setUpHotkeyWithCombo(hkComboUnpinWin, "OnUnpinWindowPress", "[KeyboardShortcutsCombinations] UnpinWindow")
setUpHotkeyWithCombo(hkComboTogglePinWin, "OnTogglePinWindowPress", "[KeyboardShortcutsCombinations] TogglePinWindow")

setUpHotkeyWithCombo(hkComboPinApp, "OnPinAppPress", "[KeyboardShortcutsCombinations] PinApp")
setUpHotkeyWithCombo(hkComboUnpinApp, "OnUnpinAppPress", "[KeyboardShortcutsCombinations] UnpinApp")
setUpHotkeyWithCombo(hkComboTogglePinApp, "OnTogglePinAppPress", "[KeyboardShortcutsCombinations] TogglePinApp")

setUpHotkeyWithCombo(hkComboOpenDesktopManager, "OpenDesktopManager", "[KeyboardShortcutsCombinations] OpenDesktopManager")

setUpHotkeyWithCombo(hkComboChangeDesktopName, "ChangeDesktopName", "[KeyboardShortcutsCombinations] ChangeDesktopName")

if (GeneralTaskbarScrollSwitching) {
    Hotkey, ~WheelUp, OnTaskbarScrollUp
    Hotkey, ~WheelDown, OnTaskbarScrollDown
}

; ======================================================================
; Event Handlers
; ======================================================================

OnShiftNumberedPress() {
    n := numberedHotkeys[A_ThisHotkey]
    if (n) {
        SwitchToDesktop(n)
    }
}

OnMoveNumberedPress() {
    n := numberedHotkeys[A_ThisHotkey]
    if (n) {
        MoveToDesktop(n)
    }
}

OnMoveAndShiftNumberedPress() {
    n := numberedHotkeys[A_ThisHotkey]
    if (n) {
        MoveAndSwitchToDesktop(n)
    }
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
    if (_IsCursorHoveringTaskbar()) {
        OnShiftLeftPress()
    }
}

OnTaskbarScrollDown() {
    if (_IsCursorHoveringTaskbar()) {
        OnShiftRightPress()
    }
}

OnPinWindowPress() {
    windowID := _GetCurrentWindowID()
    windowTitle := _GetCurrentWindowTitle()
    _PinWindow(windowID)
    _ShowTooltipForPinnedWindow(windowTitle)
}

OnUnpinWindowPress() {
    windowID := _GetCurrentWindowID()
    windowTitle := _GetCurrentWindowTitle()
    _UnpinWindow(windowID)
    _ShowTooltipForUnpinnedWindow(windowTitle)
}

OnTogglePinWindowPress() {
    windowID := _GetCurrentWindowID()
    windowTitle := _GetCurrentWindowTitle()
    if (_GetIsWindowPinned(windowID)) {
        _UnpinWindow(windowID)
        _ShowTooltipForUnpinnedWindow(windowTitle)
    }
    else {
        _PinWindow(windowID)
        _ShowTooltipForPinnedWindow(windowTitle)
    }
}

OnPinAppPress() {
    windowID := _GetCurrentWindowID()
    windowTitle := _GetCurrentWindowTitle()
    _PinApp()
    _ShowTooltipForPinnedApp(windowTitle)
}

OnUnpinAppPress() {
    windowID := _GetCurrentWindowID()
    windowTitle := _GetCurrentWindowTitle()
    _UnpinApp()
    _ShowTooltipForUnpinnedApp(windowTitle)
}

OnTogglePinAppPress() {
    windowID := _GetCurrentWindowID()
    windowTitle := _GetCurrentWindowTitle()
    if (_GetIsAppPinned(windowID)) {
        _UnpinApp(windowID)
        _ShowTooltipForUnpinnedApp(windowTitle)
    }
    else {
        _PinApp(windowID)
        _ShowTooltipForPinnedApp(windowTitle)
    }
}

OnDesktopSwitch(n:=1) {
    ; Give focus first, then display the popup, otherwise the popup could
    ; steal the focus from the legitimate window until it disappears.
    _FocusIfRequested()
    if (TooltipsEnabled) {
        _ShowTooltipForDesktopSwitch(n)
    }
    _ChangeAppearance(n)
    _ChangeBackground(n)

    if (previousDesktopNo) {
        _RunProgramWhenSwitchingFromDesktop(previousDesktopNo)
    }
    _RunProgramWhenSwitchingToDesktop(n)
    previousDesktopNo := n
}

; ======================================================================
; Functions
; ======================================================================

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

; Let the user change desktop names with a prompt, without having to edit the 'settings.ini'
; file and reload the program.
; The changes are temprorary (names will be overwritten by the default values of
; 'settings.ini' when the program will be restarted.
ChangeDesktopName() {
    currentDesktopNumber := _GetCurrentDesktopNumber()
    currentDesktopName := _GetDesktopName(currentDesktopNumber)
    InputBox, newDesktopName, % changeDesktopNamesPopupTitle, % Format(changeDesktopNamesPopupText, _GetCurrentDesktopNumber()), , , , , , , , %currentDesktopName%
    ; If the user choose "Cancel" ErrorLevel is set to 1.
    if (ErrorLevel == 0) {
        _SetDesktopName(currentDesktopNumber, newDesktopName)
    }
    _ChangeAppearance(currentDesktopNumber)
}

Reload() {
    Reload
}

Exit() {
    ExitApp
}

_IsPrevNextDesktopSwitchingKeyboardShortcutConflicting(hkModifiersSwitch, hkIdentifierNextOrPrevious) {
    return ((hkModifiersSwitch == "<#<^" || hkModifiersSwitch == ">#<^" || hkModifiersSwitch == "#<^" || hkModifiersSwitch == "<#>^" || hkModifiersSwitch == ">#>^" || hkModifiersSwitch == "#>^" || hkModifiersSwitch == "<#^" || hkModifiersSwitch == ">#^" || hkModifiersSwitch == "#^") && (hkIdentifierNextOrPrevious == "Left" || hkIdentifierNextOrPrevious == "Right"))
}

_IsCursorHoveringTaskbar() {
    MouseGetPos,,, mouseHoveringID
    if (!taskbarPrimaryID) {
        WinGet, taskbarPrimaryID, ID, ahk_class Shell_TrayWnd
    }
    if (!taskbarSecondaryID) {
        WinGet, taskbarSecondaryID, ID, ahk_class Shell_SecondaryTrayWnd
    }
    return (mouseHoveringID == taskbarPrimaryID || mouseHoveringID == taskbarSecondaryID)
}

_GetCurrentWindowID() {
    WinGet, activeHwnd, ID, A
    return activeHwnd
}

_GetCurrentWindowTitle() {
    WinGetTitle, activeHwnd, A
    return activeHwnd
}

_TruncateString(string:="", n:=10) {
    return (StrLen(string) > n ? SubStr(string, 1, n-3) . "..." : string)
}

_GetDesktopName(n:=1) {
    name := DesktopNames%n%
    if (!name) {
        name := "Desktop " . n
    }
    return name
}

; Set the name of the nth desktop to the value of a given string.
_SetDesktopName(n:=1, name:=0) {
    if (!name) {
        ; Default value: "Desktop N".
        name := "Desktop " %n%
    }
    DesktopNames%n% := name
}

_GetNextDesktopNumber() {
    i := _GetCurrentDesktopNumber()
	if (GeneralDesktopWrapping == 1) {
		i := (i >= _GetNumberOfCyclableDesktops() ? 1 : i + 1)
	} else {
		i := (i >= _GetNumberOfCyclableDesktops() ? i : i + 1)
	}

    return i
}

_GetPreviousDesktopNumber() {
    i := _GetCurrentDesktopNumber()
    if (i > _GetNumberOfCyclableDesktops()) {
        i := _GetNumberOfCyclableDesktops()
    } else if (GeneralDesktopWrapping == 1) {
		i := (i == 1 ? _GetNumberOfCyclableDesktops() : i - 1)
	} else {
		i := (i == 1 ? i : i - 1)
	}

    return i
}

_GetCurrentDesktopNumber() {
    return DllCall(GetCurrentDesktopNumberProc) + 1
}

_GetNumberOfDesktops() {
    return DllCall(GetDesktopCountProc)
}

_GetNumberOfCyclableDesktops() {
    numDesktops := _GetNumberOfDesktops()
    if (GeneralNumberOfCyclableDesktops >= 1) {
        numDesktops := Min(numDesktops, GeneralNumberOfCyclableDesktops)
    }
    return numDesktops
}

_MoveCurrentWindowToDesktop(n:=1) {
    activeHwnd := _GetCurrentWindowID()
    DllCall(MoveWindowToDesktopNumberProc, UInt, activeHwnd, UInt, n-1)
}

_ChangeDesktop(n:=1) {
    DllCall(GoToDesktopNumberProc, Int, n-1)
}

_CallWindowProc(proc, window:="") {
    if (window == "") {
        window := _GetCurrentWindowID()
    }
    return DllCall(proc, UInt, window)
}

_PinWindow(windowID:="") {
    _CallWindowProc(PinWindowProc, windowID)
}

_UnpinWindow(windowID:="") {
    _CallWindowProc(UnpinWindowProc, windowID)
}

_GetIsWindowPinned(windowID:="") {
    return _CallWindowProc(IsPinnedWindowProc, windowID)
}

_PinApp(windowID:="") {
    _CallWindowProc(PinAppProc, windowID)
}

_UnpinApp(windowID:="") {
    _CallWindowProc(UnpinAppProc, windowID)
}

_GetIsAppPinned(windowID:="") {
    return _CallWindowProc(IsPinnedAppProc, windowID)
}

_RunProgram(program:="", settingName:="") {
    if (program <> "") {
        if (FileExist(program)) {
            Run, % program
        }
        else {
            MsgBox, 16, Error, The program "%program%" is not valid. `nPlease reconfigure the "%settingName%" setting. `n`nPlease read the README for instructions.
        }
    }
}

_RunProgramWhenSwitchingToDesktop(n:=1) {
    _RunProgram(RunProgramWhenSwitchingToDesktop%n%, "[RunProgramWhenSwitchingToDesktop] " . n)
}

_RunProgramWhenSwitchingFromDesktop(n:=1) {
    _RunProgram(RunProgramWhenSwitchingFromDesktop%n%, "[RunProgramWhenSwitchingFromDesktop] " . n)
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
    iconFile := Icons%n% ? Icons%n% : n . ".ico"
    if (FileExist(GeneralIconDir . iconFile)) {
        Menu, Tray, Icon, %GeneralIconDir%%iconFile%
    }
    else {
        Menu, Tray, Icon, %GeneralIconDir%+.ico
    }
}

; Only give focus to the foremost window if it has been requested.
_FocusIfRequested() {
    if (doFocusAfterNextSwitch) {
        _Focus()
        doFocusAfterNextSwitch=0
    }
}

; Give focus to the foremost window on the desktop.
_Focus() {
    foremostWindowId := _GetForemostWindowIdOnDesktop(_GetCurrentDesktopNumber())
    WinActivate, ahk_id %foremostWindowId%
}

; Select the ahk_id of the foremost window in a given virtual desktop.
_GetForemostWindowIdOnDesktop(n) {
    ; Desktop count starts at 1 for this script, but at 0 for Windows.
    n -= 1

    ; winIDList contains a list of windows IDs ordered from the top to the bottom for each desktop.
    WinGet winIDList, list
    Loop % winIDList {
        windowID := % winIDList%A_Index%
        windowIsOnDesktop := DllCall(IsWindowOnDesktopNumberProc, UInt, WindowID, UInt, n)
        ; Select the first (and foremost) window which is in the specified desktop.
        if (WindowIsOnDesktop == 1) {
            return WindowID
        }
    }
}

_ShowTooltip(message:="") {
    params := {}
    params.message := message
    params.lifespan := TooltipsLifespan
    params.position := TooltipsCentered
    params.fontSize := TooltipsFontSize
    params.fontWeight := TooltipsFontInBold
    params.fontColor := TooltipsFontColor
    params.backgroundColor := TooltipsBackgroundColor
    Toast(params)
}

_ShowTooltipForDesktopSwitch(n:=1) {
    _ShowTooltip(_GetDesktopName(n))
}

_ShowTooltipForPinnedWindow(windowTitle) {
    _ShowTooltip("Window """ . _TruncateString(windowTitle, 30) . """ pinned.")
}

_ShowTooltipForUnpinnedWindow(windowTitle) {
    _ShowTooltip("Window """ . _TruncateString(windowTitle, 30) . """ unpinned.")
}

_ShowTooltipForPinnedApp(windowTitle) {
    _ShowTooltip("App """ . _TruncateString(windowTitle, 30) . """ pinned.")
}

_ShowTooltipForUnpinnedApp(windowTitle) {
    _ShowTooltip("App """ . _TruncateString(windowTitle, 30) . """ unpinned.")
}
