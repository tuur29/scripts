#SingleInstance, force
#MaxHotkeysPerInterval 500
SetTitleMatchMode, 2 ; This let's any window that partially matches the given name get activated

; Remap prtscr to win+shift+s
$PrintScreen::
	SendEvent, #+s
return

; Add media skip
^F3::	;the ^ means ctrl
	Send {Media_Next}
return

; Add media prev
!F3::	;the ! means alt
	Send {Media_Prev}
return

; Slack thumbs up
!t::
	Send :thumbsup:{Enter}

; Slack thumbs up as reaction
^!t::
	Send {+}:thumbsup:{Enter}
return

; Disable ctrl+scroll to zoom
#IfWinActive, Chrome
^WheelDown::return
#IfWinActive, Chrome
^WheelUp::return
