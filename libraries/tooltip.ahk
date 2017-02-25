; Credits to engunneer (http://www.autohotkey.com/board/topic/21510-toaster-popups/#entry140824)

Toast(params:=0) {

	message := params.message ? params.message : ""
	lifespan := params.lifespan ? params.lifespan : 1500
	position := params.position ? params.position : 0
	doWait := params.doWait ? params.doWait : 0
	fontSize := params.fontSize ? params.fontSize : 11
	fontWeight := params.fontWeight ? params.fontWeight : 700
	fontColor := params.fontColor ? params.fontColor : "0xFFFFFF"
	backgroundColor := params.backgroundColor ? params.backgroundColor : "0x1F1F1F"

	Global TP_GUI_ID 
	DetectHiddenWindows, On
	SysGet, Workspace, MonitorWorkArea
	Gui, 89:Destroy
	Gui, 89:-Caption +ToolWindow +LastFound +AlwaysOnTop
	Gui, 89:Color, %backgroundColor%
	Gui, 89:Font, s%fontSize% c%fontColor% w%fontWeight%, Segoe UI
	Gui, 89:Add, Text, xp+25 yp+20 gTP_Fade, %message%
	Gui, 89:Show, Hide
	TP_GUI_ID := WinExist()
	WinGetPos, GUIX, GUIY, GUIWidth, GUIHeight, ahk_id %TP_GUI_ID%
	
	GUIWidth += 20
	GUIHeight += 15

	if (position==0) {
		NewX := WorkSpaceRight-GUIWidth
		NewY := WorkspaceBottom-GUIHeight-12
	}
	else {
		NewX := (WorkSpaceRight-GUIWidth)/2
		NewY := (WorkspaceBottom-GUIHeight)/2
	}

	Gui, 89:Show, Hide x%NewX% y%NewY% w%GUIWidth% h%GUIHeight%

	DllCall("AnimateWindow","UInt",TP_GUI_ID,"Int",1,"UInt","0x00080000") ; TOAST!
	if (lifespan) {
		SetTimer, TP_Fade, % lifespan
		if(doWait == 1) {
			Sleep % lifespan
		}
	}
	Return
}

TP_Wait() {
	Global TP_GUI_ID
	WinWaitClose, ahk_id %TP_GUI_ID%
}

TP_Fade() {
	DllCall("AnimateWindow","UInt",TP_GUI_ID,"Int",100,"UInt","0x00090000") ; Fade out when clicked
	Gui, 89:Destroy
	Return
}