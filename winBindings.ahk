#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
#MaxHotkeysPerInterval 500
SetTitleMatchMode, 2 ; This let's any window that partially matches the given name get activated
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen

; Source: https://www.autohotkey.com/boards/viewtopic.php?t=54557&start=20
MWAGetMonitor(Mx := "", My := "")
{
	if  (!Mx or !My) 
	{
		; if Mx or My is empty, revert to the mouse cursor placement
		Coordmode, Mouse, Screen	; use Screen, so we can compare the coords with the sysget information`
		MouseGetPos, Mx, My
	}

	SysGet, MonitorCount, 80	; monitorcount, so we know how many monitors there are, and the number of loops we need to do
	Loop, %MonitorCount%
	{
		SysGet, mon%A_Index%, Monitor, %A_Index%	; "Monitor" will get the total desktop space of the monitor, including taskbars

		if ( Mx >= mon%A_Index%left ) && ( Mx < mon%A_Index%right ) && ( My >= mon%A_Index%top ) && ( My < mon%A_Index%bottom )
		{
			ActiveMon := A_Index
			break
		}
	}
	return ActiveMon
}

; Easily open notepad on window where mouse is (win+n)
; To make this work consistently, also disable native function: https://www.ghacks.net/2015/03/22/how-to-disable-specific-global-hotkeys-in-windows/
#n::
	; Get cursor position and monitor handle
	ActiveMon := MWAGetMonitor()

	; Get monitor information
	SysGet, mon, Monitor, %ActiveMon%
	monWidth := Abs(monRight - monLeft)
	monHeight := Abs(monTop - monBottom)

	; Open Notepad and move it to the center of the active monitor
	Run notepad.exe
	WinWaitActive, ahk_exe notepad.exe

	winWidth := 900
	winHeight := monHeight / 2
	WinMove, A, , monLeft + (monWidth / 2) - winWidth / 2, monTop + (monHeight / 2) - winHeight / 2
	WinMove, A, , , , winWidth, winHeight ; separate call to fix dpi issues

	; Bring the window to the top
	WinActivate, A
return

; Disable F1 Help hotkey
F1::return

; Dim second monitor (ctrl+shift+F1)
^+F1::
	SysGet, Mon2, Monitor, 2 ; select monitor here
	Mon2Width:=Abs(Mon2Right-Mon2Left)
	Mon2Height:=Abs(Mon2Top-Mon2Bottom)
	; MsgBox, Left: %Mon2Left%, Top: %Mon2Top%, Width: %Mon2Width%, Height %Mon2Height%

	KeyWait F1 ; workaround, best to also disable F1 
	Gui +LastFound +AlwaysOnTop -Caption +ToolWindow +E0x20 ; last command makes it clickthrough
	WinSet, Transparent, 180
	Gui, Color, 000000
	Gui, Show, X%Mon2Left% Y%Mon2Top% W%Mon2Width% H%Mon2Height% NoActivate, window

	KeyWait F1, D
	Gui Destroy
Return

; Toggle Night mode (configure nightlight quick action in top right)
^!End::
	Send {LWin down}a{LWin up}
	Sleep 150
	Send {LShift down}{Tab}{LShift up}
	Sleep 150
	Send {Right}
	Sleep 150
	Send {Right}
	Sleep 150
	Send {Right}
	Sleep 150
	Send {Enter}
	Sleep 150
	Send {LWin down}a{LWin up}
return

; ; Slack
#IfWinActive, Slack
{
	; thumbs up (alt+t)
	!t::
		Send :thumbsup:{Space}
	return

	; thumbs up as reaction (ctrl+alt+t)
	^!t::
		Send {+}:thumbsup:{Enter}
	return

	; checkmark as reaction (ctrl+alt+y)
	^!y::
		Send {+}:heavy_check_mark:{Enter}
	return

	; /giphy (ctrl+alt+g)
	^!g::
		Send /giphy{Space}
	return

	; reminder (ctrl+alt+r)
	^!r::
		Send /remind me to{Space}
	return
}

; Disable ctrl+scroll to zoom in chrome (useful when using trackpad)
#IfWinActive, Chrome
{
	^WheelDown::return
	^WheelUp::return
}
