;========================================================================================
; Copyright (c) 2013 Voltoid Technologies
; All rights reserved.
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;     * Redistributions of source code must retain the above copyright
;       notice, this list of conditions and the following disclaimer.
;     * Redistributions in binary form must reproduce the above copyright
;       notice, this list of conditions and the following disclaimer in the
;       documentation and/or other materials provided with the distribution.
;     * Neither the names of Shock nor the names of its contributors may be
;       used to endorse or promote products derived from this software without
;       prior written permission.
;
; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
; IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
; INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
; TO, PROCUREMENT OF SUBSTITUTE GOODS OR  SERVICES; LOSS OF USE, DATA OR PROFITS; OR
; BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
; ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
; DAMAGE
;========================================================================================
; Date Created:         03/03/2013 Adrian Collado
; Date Edited:          03/05/2013 Adrian Collado
; Date Committed:       03/05/2013 Adrian Collado
;========================================================================================
; Authors:
;     Adrian Collado
;       Website: <Under Construction>
;       Github:  https://github.com/ChosenOreo/
;       Email:   acollado@citlink.net
;========================================================================================
BITS 16
ORG 0x7C00

CPU 8086

Entry:
        JMP Main
        
;========================================================================================
; Includes
;========================================================================================
%include "disk/fat12block.asm"
%include "disk/floppy.asm"
%include "video/videoinit.asm"
%include "video/display.asm"
%include "abort/abort.asm"

BITS 16
CPU 8086
;========================================================================================
; Data
;========================================================================================
Messages:
        .AbortString:           DB      "[Abort]", 0x0A, 0x0D, 0x00
        .VideoTestString:       DB      "[Init] Video Initialized!", 0x0A, 0x0D, 0x00
        
;========================================================================================
; Main
;========================================================================================
Main:
        CLI
        XOR AX, AX
        MOV DS, AX
        MOV ES, AX
        MOV SS, AX
        MOV SP, 0xFFFF
        STI
        
        JMP 0x0000:Main.Flush
        .Flush:
        
        MOV [ExtFATBlock.DriveNumber], DL
        
        CALL InitVideoDefault
        
        MOV SI, Messages.VideoTestString
        CALL VideoDisplayString
        
        MOV CX, 0x0005
        MOV AX, 0x0001
        MOV BX, 0x0000
        MOV ES, BX
        MOV BX, 0x0500
        CALL ReadSectors
        
        JC Abort
        
        JMP 0x0000:0x0500
        
TIMES 510 - ($-$$) DB 0

DW 0xAA55
