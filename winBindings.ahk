#SingleInstance, force

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