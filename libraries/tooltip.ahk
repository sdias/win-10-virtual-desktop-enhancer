; Credits to engunneer (http://www.autohotkey.com/board/topic/21510-toaster-popups/#entry140824)

; Disaply a toast popup on each monitor.
Toast(params:=0) {
	; We need this so that all the GUI_ID_X variables are global.
	global

	local message, lifespan, position, fontSize, fontWeight, fontColor, backgroundColor, GUIHandleName, GUIX, GUIY, GUIWidth, GUIHeight, NewX, NewY

	message := params.message ? params.message : ""
	lifespan := params.lifespan ? params.lifespan : 1500
	position := params.position ? params.position : 0
	fontSize := params.fontSize ? params.fontSize : 11
	fontWeight := params.fontWeight ? params.fontWeight : 700
	fontColor := params.fontColor ? params.fontColor : "0xFFFFFF"
	backgroundColor := params.backgroundColor ? params.backgroundColor : "0x1F1F1F"

	DetectHiddenWindows, On

  if (TooltipsOnEveryMonitor == "1") {
    ; Get total number of monitors.
    SysGet, monitorN, 80
  } else {
    ; Consider just the primary monitor.
    monitorN = 1
  }

	; For each monitor we need to create and draw the GUI of the toast.
	Loop, %monitorN% {
		; We need a different handle for each GUI in each monitor.
		GUIHandleName = GUIForMonitor%A_Index%

		; Get the workspace of the monitor.
		SysGet, Workspace, MonitorWorkArea, %A_Index%

		; Greate the GUI.
		Gui, %GUIHandleName%:Destroy
		Gui, %GUIHandleName%:-Caption +ToolWindow +LastFound +AlwaysOnTop
		Gui, %GUIHandleName%:Color, %backgroundColor%
		Gui, %GUIHandleName%:Font, s%fontSize% c%fontColor% w%fontWeight%, Segoe UI
		Gui, %GUIHandleName%:Add, Text, xp+25 yp+20, %message%
		Gui, %GUIHandleName%:Show, Hide

		OnMessage(0x201, "closePopups")

		; Save the GUI ID of each GUI in a different variable.
		GUI_ID_%A_Index% := WinExist()

		; Position the GUI on the monitor.
		WinGetPos, GUIX, GUIY, GUIWidth, GUIHeight
		GUIWidth += 20
		GUIHeight += 15
    if (ToolTipsPositionX == "LEFT") {
      NewX := WorkSpaceLeft
    } else if (ToolTipsPositionX == "RIGHT") {
      NewX := WorkSpaceRight - GUIWidth
    } else {
      ; CENTER or something wrong.
      NewX := (WorkSpaceRight + WorkspaceLeft - GUIWidth) / 2
    }
    if (ToolTipsPositionY == "TOP") {
      NewY := WorkSpaceTop
    } else if (ToolTipsPositionY == "BOTTOM") {
      NewY := WorkSpaceBottom - GUIHeight
    } else {
      ; CENTER or something wrong.
      NewY := (WorkSpaceTop + WorkspaceBottom - GUIHeight) / 2
    }

		; Show the GUI
		Gui, %GUIHandleName%:Show, Hide x%NewX% y%NewY% w%GUIWidth% h%GUIHeight%
		DllCall("AnimateWindow", "UInt", GUI_ID_%A_Index%, "Int", 1, "UInt", "0x00080000")
	}

	; Make all the toasts from all the monitors automatically disappear after a certain time.
	if (lifespan) {
		; Execute closePopups() only one time after lifespan milliseconds.
		SetTimer, closePopups, % -lifespan
	}

	Return
}

; Close all the toast messages.
; This function is called after a given time (lifespan) or when the text in the toasts is clicked.
closePopups() {
	global
	Loop, %monitorN% {
		GUIHandleName = GUIForMonitor%A_Index%
		; Fade out each toast window.
		DllCall("AnimateWindow", "UInt", GUI_ID_%A_Index%, "Int", TooltipsFadeOutAnimationDuration, "UInt", "0x00090000")
		; Free the memory used by each toast.
		Gui, %GUIHandleName%:Destroy
	}
}
