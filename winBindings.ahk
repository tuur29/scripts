#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
#MaxHotkeysPerInterval 500
SetTitleMatchMode, 2 ; This let's any window that partially matches the given name get activated
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Mouse, Screen

; Remap prtscr to win+shift+s
; $PrintScreen::
; 	SendEvent, #+s	; the + means shift, # means windows key
; return

; Add media skip
; ^F3::	;the ^ means ctrl
; 	Send {Media_Next}
; return

; Add media prev
; !F3::	;the ! means alt
; 	Send {Media_Prev}
; return

; ; Slack
#IfWinActive, Slack
{
	; thumbs up
	!t::
		Send :thumbsup:{Space}{Enter}
	return

	; thumbs up as reaction
	^!t::
		Send {+}:thumbsup:{Enter}
	return

	; checkmark as reaction
	^!y::
		Send {+}:heavy_check_mark:{Enter}
	return

	; /giphy
	^!g::
		Send /giphy{Space}
	return

	; reminder
	^!r::
		Send /remind me to{Space}
	return
}

; Toggle Night mode
!End::
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

; Disable ctrl+scroll to zoom
#IfWinActive, Chrome
{
	^WheelDown::return
	^WheelUp::return
}
