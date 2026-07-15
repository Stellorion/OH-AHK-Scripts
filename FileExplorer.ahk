#Requires AutoHotkey v2.0

; --- Quick Folder Jumps ---
#HotIf WinActive("ahk_class CabinetWClass")
; -- Games --
CapsLock & 1:: ExplorerJump(A_Desktop . "\Games")
; -- Softwares --
CapsLock & 2:: ExplorerJump(A_Desktop . "\Softwares")
; -- Desktop --
CapsLock & 3:: ExplorerJump(A_Desktop)
; -- Downloads --
CapsLock & 4:: ExplorerJump(EnvGet("USERPROFILE") . "\Downloads")
; -- Pictures --
CapsLock & 5:: ExplorerJump(EnvGet("USERPROFILE") . "\Pictures")

; -- Jump to Parent --
CapsLock & Tab:: Send("!{Up}")

#HotIf

; The Navigation Function
ExplorerJump(Path) {
    if WinActive("ahk_class CabinetWClass") {
        for window in ComObject("Shell.Application").Windows {
            try {
                if (window.hwnd == WinActive("A")) {
                    window.Navigate(Path)
                    return
                }
            }
        }
    }
    if DirExist(Path)
        Run(Path)
    else
        MsgBox("Folder does not exist: " . Path)
}