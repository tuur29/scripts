#SingleInstance, force
#MaxHotkeysPerInterval 500

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

; RN Refresh
!F5::	;the ! means alt
	Run, adb shell input text "RR", , Hide 
return

; RN Menu
^!F5::	;the ! means alt
	Run, adb shell input keyevent 82, , Hide 
return

; Disable ctrl+scroll to zoom
^WheelDown::return
^WheelUp::return