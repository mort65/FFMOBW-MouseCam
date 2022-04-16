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
minD := 5
delay := 25
edgePerW := 0.05
edgePerH := 0.025
maxp := 3
;;;;;;;;;;;;;;;;;;;;;;

_bMouseCam := False
Hotkey, z, MouseCamOff
Hotkey, Alt, MouseCam
Return

MouseCam:
{
    If (_bMouseCam)
    {
        Return
    }       
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
        shell := ComObjCreate("WScript.Shell")
        exec := shell.Exec(ComSpec " /Q /K echo off")
        exec.StdIn.WriteLine("nomousy.exe /hide`nexit") ;hide cursor 
    }
    _bMouseCam := True 
    _X := (edgePerW * Width)
    _Y := (edgePerH * height)
    _Width := (Width - _X)
    _Height := (height - _Y)
    prevKey:=""
    p:=1 ;momentum 
    While (_bMouseCam) 
    {
        ;sleep 5
        if not WinActive("ahk_exe FATAL_FRAME_MOBW.exe")
        {
            sleep 50
            Continue
        }
        MouseGetPos, _xpos, _ypos
        dX := _xpos - xpos
        dY := _ypos - ypos
        if (key)
        {
            prevKey := key
        }
        key := ""        
        if (Abs(dX) > Abs(dY) and (Abs(dX) >= minD))
        {
            key := bInvertX ? (dX > 0 ? leftKey : rightKey) : (dX > 0 ? rightKey : leftKey)
        }
        else if (Abs(dX) < Abs(dY) and (Abs(dY) >= minD))
        {
            key := bInvertY ? (dY > 0 ? upKey : downkey) : (dY > 0 ? downkey : upKey)
        }        
        else if ((Abs(_xpos) >= _Width) or (Abs(_xpos) <= _X and (Abs(_xpos) < Abs(_ypos))))
        {
            key := bInvertX ? (Abs(_xpos) >= _Width ? leftKey : rightKey) : (Abs(_xpos) >= _Width ? rightKey : leftKey)
            
        }
        else if ((Abs(_ypos) >= _Height) or (Abs(_ypos) <= _Y and (Abs(_ypos) < Abs(_xpos))))
        {
            key := bInvertY ? (Abs(_ypos) >= _Height ? upKey : downKey) : (Abs(_ypos) >= _Height ? downKey : upKey)
        }        
        if (key)
        {
            if (prevKey)
            {
                if (prevKey = key)
                {
                    if (p < maxp)
                    {
                        p++
                    }
                }
                else 
                {
                    p--
                    if (p > 0)
                    {
                        key := prevKey
                    }
                    else
                    {
                        p := 1
                    }
                }
            }
            if winActive("ahk_exe FATAL_FRAME_MOBW.exe")
            {
                SendInput {%key% down}
                Sleep %delay%
                SendInput {%key% up}
            }
            prevKey := key
            xpos:=_xpos
            ypos:=_ypos
        }
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
