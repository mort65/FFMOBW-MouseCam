#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetKeyDelay, 0, 20

;Variables
;;;;;;;;;;;;;;;;;;;;;;
upKey := "u"
downKey := "n"
leftKey := "h"
rightKey := ";"
bHideMouse := True
bInvertX := False
bInvertY := False
minD := 3
delay := 25
edgePerW := 0.05edgePerH := 0.025
;;;;;;;;;;;;;;;;;;;;;;

_bMouseCam := False


Hotkey, z, MouseCamOff
Hotkey, Alt, MouseCam

MouseCam:
{
    If (_bMouseCam)
    {
        Return
    }
    _bMouseCam := True
    MouseGetPos, xpos, ypos
    if Winexist("ahk_exe FATAL_FRAME_MOBW.exe")
    {
        WinGetPos, X, Y, Width, Height
    }
    if (!width or !Height)
    {
        Return
    }
    if (bHideMouse and FileExist("nomousy.exe"))
    {
        Run, nomousy.exe /hide ;hide cursor
    }
    _X := (edgePerW * Width)
    _Y := (edgePerH * height)
	_Width := (Width - _X)
    _Height := (height - _Y)
    While (_bMouseCam) 
    {
        ;sleep 5
        MouseGetPos, _xpos, _ypos
        dX := _xpos - xpos
        dY := _ypos - ypos
        key := ""
        if ((Abs(dX) > Abs(dY) and (Abs(dX) >= minD)) or (Abs(_xpos) >= _Width) or (Abs(_xpos) <= _X and (Abs(_xpos) < Abs(_ypos))))
        {
            if (dX > 0 or (Abs(_xpos) >= _Width))
            {
                if (bInvertX)
                {
                    key := leftKey
                }
                else
                {
                    key := rightKey
                }
                
                if WinActive("ahk_exe FATAL_FRAME_MOBW.exe")
                {
                    SendInput {%key% down}
                    Sleep %delay%
                    SendInput {%key% up}                    
                }
            }
            else if (dX < 0 or (Abs(_xpos) <= _X))
            {
                if (bInvertX)
                {
                    key := rightKey
                }
                else
                {
                    key := leftKey
                }
                if WinActive("ahk_exe FATAL_FRAME_MOBW.exe") 
                {
                    SendInput {%key% down}
                    Sleep %delay%
                    SendInput {%key% up}
                }
            }
            
        }
        else if ((Abs(dX) < Abs(dY) and (Abs(dY) >= minD)) or (Abs(_ypos) >= _Height) or (Abs(_ypos) <= _Y and (Abs(_ypos) < Abs(_xpos))))
        {
            if (dY < 0 or (Abs(_ypos) <= _Y))
            {
                if (bInvertY)
                {
                    key := downKey
                }
                else
                {
                    key := upKey
                }
                
                if WinActive("ahk_exe FATAL_FRAME_MOBW.exe") 
                {
                    SendInput {%key% down}
                    Sleep %delay%
                    SendInput {%key% up}
                }
            }
            else if (dY > 0 or (Abs(_ypos) >= _Height ))
            {
                if (bInvertY)
                {
                    key := upKey
                }
                else
                {
                    key := downKey
                }
                
                if WinActive("ahk_exe FATAL_FRAME_MOBW.exe")
                {
                    SendInput {%key% down}
                    Sleep %delay%
                    SendInput {%key% up}
                }
            }               
        }
        xpos:=_xpos
        ypos:=_ypos
    }
    Return
}

MouseCamOff:
{
    _bMouseCam := False
    if (bHideMouse and FileExist("nomousy.exe"))
    {
        Run, nomousy.exe ;show cursor
    }
    Return
}