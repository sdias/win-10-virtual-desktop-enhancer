#SingleInstance, force
#WinActivateForce
; Credits to: https://github.com/Ciantic/VirtualDesktopAccessor

#Include, read-ini.ahk

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

DllCall(RegisterPostMessageHookProc, Int, hwnd, Int, 0x1400 + 30)
OnMessage(0x1400 + 30, "VWMess")
VWMess(wParam, lParam, msg, hwnd) {
    ChangeAppearance(lParam + 1)
    ChangeBackground(lParam + 1)
    Focus()
}

; ======================================================================
; Auto Execute
; ======================================================================

Menu, Tray, Add, &Manage Desktops, OpenDesktopManager
Menu, Tray, Default, &Manage Desktops
Menu, Tray, Click, 1

ReadIni("settings.ini")
ChangeAppearance(1)
ChangeDesktop(1)

; ======================================================================
; Keybindings
; ======================================================================

*<!1::
*<!2::
*<!3::
*<!4::
*<!5::
*<!6::
*<!7::
*<!8::
*<!9::
*<!0::
    ChangeDesktop(substr(A_ThisHotkey, 0, 1))
Return

!SC029::
   OpenDesktopManager()
Return

; ======================================================================
; Functions
; ======================================================================

GoToNextDesktop() {
    i := (GetCurrentDesktopNumber() + 1)
    if (i < GetNumberOfDesktops()) {
        i := i + 1
    }
    else {
        i := 1
    }
    ChangeDesktop(i)
}

OpenDesktopManager() {
    Send #{Tab}
}

GetCurrentDesktopNumber() {
    Return DllCall(GetCurrentDesktopNumberProc)
}

GetNumberOfDesktops() {
    Return DllCall(GetDesktopCountProc)
}

ChangeDesktop(n) {
    if (n == 0) {
        n := 10
    }
    DllCall(GoToDesktopNumberProc, Int, n-1)
}

ChangeBackground(n) {
    line := Wallpapers%n%

    isHex := RegExMatch(line, "^([0-9A-Fa-f]{1,6})", hexMatchTotal)

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

ChangeAppearance(n) {
    Menu, Tray, Tip, Desktop %n%
    Menu, Tray, Icon, icons/%n%.ico
}

Focus() {
    WinActivate, ahk_class Shell_TrayWnd
    SendEvent !{Esc}
}
