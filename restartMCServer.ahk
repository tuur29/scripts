#NoEnv
#Warn
SendMode Input
SetWorkingDir %A_ScriptDir%

; This AutoHotkey script lets all online players know the server will be restarted before doing so


; search cmd window
WinActivate, Minecraft Server

; get players to kick
WinActivate, Minecraft Server
SendInput, list{Enter}
Sleep, 100
SendInput, ^m{End}+{Home}+{Up}+{Home}
Loop, 33
{
	SendInput, +{Right}
}
SendInput, ^c
ClipWait
StringReplace,clipboard,clipboard,`r`n,,,A

; ask for confirmation
InputBox, Players, All player names,,,,,,,,,%clipboard%
if ErrorLevel
    ExitApp
PlayersArray := StrSplit(Players,", ")

; stop or reboot?
MsgBox, 4,, Stop server (yes) or reboot (no)

; search cmd window
WinActivate, C:\WINDOWS\system32\cmd.exe

; send warning
SendInput, title @a times 20 500 20 {Enter}
SendInput, title @a title [{{}"text":"Server restarts 15", "color":"red"{}}]{Enter}
SendInput, title @a subtitle [{{}"text":"Back in a few minutes"{}}]{Enter}

; countdown
Loop, 14
{
	N := 15 - A_Index
	SendInput, title @a title [{{}"text":"Server restarts %N%", "color":"red"{}}]{Enter}
    Sleep, 1000
}

; kicking players
Loop % PlayersArray.MaxIndex()
{
	Player := PlayersArray[A_Index]
    SendInput, kick %Player% The server is restarting, Back in a few minutes{Enter}
}

; stop or restarting server
IfMsgBox Yes
	SendInput, stop{Enter}
else {
	SendInput, stop{Enter}
	Sleep, 2000
	SendInput, {Enter}
	Sleep, 500
	Run, start.bat
}

ExitApp
Esc::ExitApp
