#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%


; #region To-Do's
/*

- options to toggle repeats?
    = if so, then set to not repeat on key held
    = Find optimal loop timing to lockdown an interabtable object & to best utilize the UniversalCodes list &/or BoosterList
- Full numpad binds (& maybe ctrl+# for extra Comm binds) {maybe even default to ctrl+# so numpad can still be used manually}



- Edit Command (Numpad+) to be held instead of toggled?



- find optimal key delay to prevent skipped inputs
    = add option to settings?
- allow freely rebound Keys??
- Settings? (especially needed if user can freely bind Keys)
    = Save setings via .ini ?
- Decide on default keys

*/
; #endregion To-Do's



; #region Variables
    KeyEdit := 0
    CommandArray := []
    TempComm :=
    TempIndex := 
    UniversalCodes := ["b3`n","c1`n","c2`n","c7`n","d6`n","f2`n","h5`n","i1`n","j6`n","k9`n","l0`n","m6`n","m9`n","o5`n","p1`n","r2`n","r4`n","t2`n","u2`n","u9`n","v0`n","x8`n","y9`n","z3`n"]
    ; UniversalCodes list from Wurps [https://pastebin.com/raw/0PEKMVkR] & {https://www.youtube.com/watch?v=tkabFueSUOQ}
    BoosterList = ["Betty","George","Billy","Kablam","Susie","Igor","Gilbert","Daryl","Seth","Sam","Brody","Blue","Freddy","Bobbie","Louie","Albert"]
    ; Current list of all Radar Booster names. courtesy of [zlixqi] in Wurps' discord server



; #endregion Variables

Exit ; Ends the Auto-Execute before it runs any labels early

; #region Labels&Functions

    MakeTheGui: ; Build the command input gui
        Gui, 1:New, +LabelComm_Input , Set Command
        Gui, Font, s10
        Gui, Show, w200 h80, 
        
        TempComm := CommandArray[TempIndex]
        Gui, add, edit, -WantReturn w175 vTempComm, 
        GuiControl, , TempComm, %TempComm%
        GuiControl, focus, TempComm
        Send {End}
        Gui, Add, Button, Default gSaveCommand,Save
    Return

    SaveCommand: ; Save the input command into the CommandArray
        Gui, Submit
        KeyEdit := 0 ; so you dont need to hit Numpad+ again to leave editing mode after saving a command
        CommandArray[%TempIndex%] := TempComm
    Return

    Comm_InputClose:
        Gui, Cancel
    Return

; #endregion Labels

; #region KeyRegs

        ; Keys not listed in the below IfWinActive section will not run while an input GUI is open&focused
        ; - perhaps will specify which gui's to apply this to later if proper settings become viable #tag To-Do
    #IfWinActive ahk_class AutoHotkeyGUI
        ; Enables Escape to close any Gui without overwriting current saved info
        Esc::
            Gui, cancel
        Return
    #IfWinActive ; encloses the gui specification   



    ; might be changed later to #IfWinActive [LethalCompany application name]
    #IfWinNotActive ahk_class AutoHotkeyGUI
        ; #tag Clear Saved Codes
        NumpadSub::
            CommandArray := []
        Return

        ; #tag UniversalCodes Codes List
        Numpad1::
            i := 0
            For i, value in UniversalCodes
            {
                TempComm := UniversalCodes[i]
                Send, %TempComm%
            }
        Return

        ; #tag Example Key
        Numpad0::
            if(!KeyEdit && (CommandArray[0] != ""))
            {   ; run command
                ; msgbox, run the command
            
                TempComm := CommandArray[0]
                Send, %TempComm%`n
                if InStr(SubStr(TempComm, 1 , 6), "flash")
                { ; if flashing a radar booster, this will cancel any flashlight store prompt that may arise in the event of a typo or a teammate turning off the booster
                    Send, deny`n
                }
            } else if(KeyEdit)
            {   ; run Gui function
                ; msgbox, make the gui
                TempIndex := 0 ; WHY DOES EVERYTHING GUI HATE ARRAYS!? :wurpsNotlikethis:
                Gosub, MakeTheGui
            }
        Return

        ; Toggle Rebinding
        NumpadAdd::
            if(KeyEdit)
            {
                KeyEdit := 0  
            } else
            {
                KeyEdit := 1
            }
        Return



    Numpad9::
    Send, %A_ThisHotkey%`n%A_ThisHotkey%
    Return


    #IfWinNotActive

    F9:: ; F9 is outside of all #IfWinActive/#ifWinNotActive enclosures, so it will run regardless of focused window. V important for the shutdown key imo
        ExitApp
    Return

; #endregion KeyRegs