#Requires AutoHotkey v2.0
#SingleInstance Force

#HotIf WinActive("ahk_exe DungeonRampage.exe")
; Attacks/Scrolls
Delete::j
End::k
PgDn::l

; UI/Console Controls
Insert:: Send "{Numpad2}"
#HotIf