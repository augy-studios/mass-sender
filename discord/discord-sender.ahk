#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent
SetWorkingDir(A_ScriptDir)

; Define messages and corresponding files
messages := Map(
    "NewYear", "Happy New Year! 🎉",
    "CNY",     "Happy Chinese New Year! 🧧", 
    "Xmas",    "Merry Christmas! 🎄",
    "Morning", "Good Morning! ☀️",
    "Test",    "Test Message 🧪"
)

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

; Create option-specific people files
for key in messages {
    filename := key "-people.txt"
    if !FileExist(filename) {
        FileAppend("", filename)
    }
}

; Create GUI with dynamic options
myGui := Gui()
myGui.Title := "Message Selector"
myGui.Add("Text",, "Select message to send:")

; Collect keys from the Map
keys := []
for key in messages
    keys.Push(key)

ddl := myGui.Add("DropDownList", "vMsgChoice w150", keys)
myGui.Add("Button", "Default w80", "OK").OnEvent("Click", ProcessInput)
myGui.Show()

ProcessInput(*)
{
    global
    myGui.Submit()
    selectedMsg := ddl.Text
    myGui.Destroy()
    
    ; Use selected message file
    selectedFile := selectedMsg "-people.txt"
    msgText := messages[selectedMsg]

    ; Read from selected file
    content := FileRead(selectedFile)
    lines := StrSplit(content, "`n", "`r")
    toProcess := []
    for line in lines {
        line := Trim(line)
        if (line != "" && !InStr(line, "?")) {
            toProcess.Push(line)
        }
    }

    if (toProcess.Length = 0) {
        MsgBox("All contacts in " selectedFile " have been processed.", "Info", "Iconi")
        ExitApp
    }

    ; Check if Discord program exists
    discordProcesses := ["Discord.exe", "DiscordCanary.exe", "DiscordPTB.exe"]
    openDiscords := []

    for process in discordProcesses {
        if ProcessExist(process) {
            openDiscords.Push(process)
        }
    }

    if openDiscords.Length = 0 {
        MsgBox("No Discord instance is running.", "Error", "Iconx")
        ExitApp
    } else if openDiscords.Length > 1 {
        MsgBox("Multiple Discord instances are running. Please close all but one.", "Error", "Iconx")
        ExitApp
    }

    try {
        WinActivate("ahk_exe " openDiscords[1])
        WinWaitActive("ahk_exe " openDiscords[1],, 5)
    } catch {
        MsgBox("Could not activate Discord window.", "Error", "Iconx")
        ExitApp
    }

    global stopScriptFlag := false
    Hotkey("F7", (*) => stopScriptFlag := true)
    Hotkey("F8", (*) => ExitApp())

    for contact in toProcess {
        if stopScriptFlag {
            MsgBox("Script stopped by user.", "Info", "Iconi")
            ExitApp
        }

        ; Search contact
        Send("^k")
        Sleep(250)
        A_Clipboard := contact
        Send("^v")
        Sleep(750)
        Send("{Enter}")
        Sleep(500)
        
        ; Send message
        A_Clipboard := msgText
        Send("^v")
        Sleep(250)
        Send("{Enter}")
        Sleep(500)

        ; Update selected message file
        Loop lines.Length {
            if (Trim(lines[A_Index]) = contact) {
                lines[A_Index] := lines[A_Index] "?"
                break
            }
        }
        
        FileDelete(selectedFile)
        for line in lines {
            FileAppend(line "`n", selectedFile)
        }
    }

    MsgBox("All messages sent successfully!", "Complete", "Iconi")
    ExitApp
}