#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
SetWorkingDir(A_ScriptDir)

; Create instructions.txt
if !FileExist("instructions.txt") {
    FileAppend("F7 key to force stop the script`nF8 key to force close the AHK", "instructions.txt")
}

; Check if people.txt exists
if !FileExist("people.txt") {
    FileAppend("", "people.txt")
    MsgBox("people.txt created. Please add contacts and rerun.", "Info", "Iconi")
    ExitApp
}

; Read and process contacts
content := FileRead("people.txt")
lines := StrSplit(content, "`n", "`r")
toProcess := []
for line in lines {
    line := Trim(line)
    if (line != "" && !InStr(line, "?")) {
        toProcess.Push(line)
    }
}

if (toProcess.Length = 0) {
    MsgBox("All contacts have been processed.", "Info", "Iconi")
    ExitApp
}

; Create GUI for message selection
myGui := Gui()
myGui.Title := "Message Selector"
myGui.Add("Text",, "Select message to send:")
ddl := myGui.Add("DropDownList", "vMsgChoice w150", ["NewYear", "CNY", "Xmas", "Morning", "Test"])
myGui.Add("Button", "Default w80", "OK").OnEvent("Click", ProcessInput)
myGui.Show()

ProcessInput(*)
{
    global
    myGui.Submit()
    ; Store the selected text BEFORE destroying GUI
    selectedMsg := ddl.Text
    myGui.Destroy()  ; Now destroy GUI after capturing the value
    
    ; Define messages
    messages := Map(
        "NewYear", "Happy New Year! 🎉",
        "CNY", "Happy Lunar New Year! 🧧", 
        "Xmas", "Merry Christmas! 🎄",
        "Morning", "Good Morning! ☀️",
        "Test", "This is a test message."
    )
    msgText := messages[selectedMsg]  ; Use stored value instead of ddl.Text
    
    ; Check Telegram status
    if !ProcessExist("Telegram.exe") {
        MsgBox("Telegram is not running.", "Error", "Iconx")
        ExitApp
    }
    
    try {
        WinActivate("ahk_exe Telegram.exe")
        WinWaitActive("ahk_exe Telegram.exe",, 5)
    } catch {
        MsgBox("Could not activate Telegram window.", "Error", "Iconx")
        ExitApp
    }
    
    ; Initialize stop flag
    global stopScriptFlag := false

    ; Setup modified hotkeys
    Hotkey("F7", (*) => stopScriptFlag := true)  ; Set flag directly
    Hotkey("F8", (*) => ExitApp())  ; Exit script
    
    ; Main sending loop
    for contact in toProcess {
        if stopScriptFlag {
            MsgBox("Script stopped by user.", "Info", "Iconi")
            ExitApp
        }
        
        ; Activate Telegram
        try WinActivate("ahk_exe Telegram.exe")
        Sleep(250)
        
        ; Search contact
        Send("{Esc}")
        Send("^f")
        Sleep(250)
        A_Clipboard := contact
        Send("^v")
        Sleep(500)
        Send("{Enter}")
        Sleep(500)
        
        ; Send message
        A_Clipboard := msgText
        Send("^v")
        Sleep(250)
        Send("{Enter}")
        Sleep(500)
        
        ; Update people.txt
        Loop lines.Length {
            if (Trim(lines[A_Index]) = contact) {
                lines[A_Index] := lines[A_Index] "?"
                break
            }
        }
        
        ; Rewrite file
        FileDelete("people.txt")
        for line in lines {
            FileAppend(line "`n", "people.txt")
        }
    }
    
    MsgBox("All messages sent successfully!", "Complete", "Iconi")
    ExitApp
}

StopScript(&stopScriptFlag) {
    stopScriptFlag := true
}