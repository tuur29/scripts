#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
#MaxHotkeysPerInterval 500
SetTitleMatchMode, 2 ; This let's any window that partially matches the given name get activated
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen

; Remap prtscr to win+shift+s
$PrintScreen::
	SendEvent, #+s	; the + means shift, # means windows key
return

; Add media skip (ctr+f3)
^F3::
	Send {Media_Next}
return

; Add media prev (alt+f3)
!F3::
	Send {Media_Prev}
return

; Disable cortane hotkey (win+c)
#c::return

; Easily open notepad (win+n)
#n::
	Run Notepad
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
