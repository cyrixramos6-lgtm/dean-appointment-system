; DeanAppointmentSystem_FINAL.asm
; MASM 32-bit Console Application
; No GUI. Uses Kernel32 only. No INVOKE statements.

.386
.model flat, stdcall
option casemap:none

includelib kernel32.lib

GetStdHandle      PROTO STDCALL :DWORD
ReadConsoleA      PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteConsoleA     PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateFileA       PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ReadFile          PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WriteFile         PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CloseHandle       PROTO STDCALL :DWORD
SetFilePointer    PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
ExitProcess       PROTO STDCALL :DWORD

STD_INPUT_HANDLE  EQU -10
STD_OUTPUT_HANDLE EQU -11
GENERIC_READ      EQU 80000000h
GENERIC_WRITE     EQU 40000000h
FILE_SHARE_READ   EQU 1
CREATE_ALWAYS     EQU 2
OPEN_EXISTING     EQU 3
OPEN_ALWAYS       EQU 4
FILE_ATTRIBUTE_NORMAL EQU 80h
FILE_END          EQU 2
INVALID_HANDLE_VALUE EQU -1

MAX_APPTS EQU 10

; Appointment record layout - 268 bytes each
APPT_NAME_OFF    EQU 0       ; 64 bytes
APPT_STUDENTID_OFF EQU 64    ; 32 bytes
APPT_DATE_OFF    EQU 96      ; 16 bytes
APPT_TIME_OFF    EQU 112     ; 64 bytes
APPT_PURPOSE_OFF EQU 176     ; 128 bytes
APPT_STATUS_OFF  EQU 304     ; 16 bytes
APPT_START_OFF   EQU 320     ; DWORD
APPT_END_OFF     EQU 324     ; DWORD
APPT_ID_OFF      EQU 328     ; DWORD
APPT_SIZE        EQU 332

.data

szTitle db 13,10,"==================================================",13,10
        db "             DEAN APPOINTMENT SYSTEM",13,10
        db "==================================================",13,10,0

szMain db 13,10,"================ MAIN DASHBOARD ================",13,10
        db "[1] STUDENT / REQUESTER",13,10
        db "[2] DEAN SECURE LOGIN",13,10
        db "[3] EXIT",13,10
        db "Choose: ",0

szStudentMenu db 13,10,"=============== STUDENT FUNCTIONS ===============",13,10
              db "[1] Submit Appointment",13,10
              db "[2] Check Status",13,10
              db "[3] View FCFS List",13,10
              db "[4] Exit to Main Dashboard",13,10
              db "Choose: ",0

szDeanMenu db 13,10,"============= DEAN MANAGEMENT (SECURE) =============",13,10
           db "[1] View Appointment List",13,10
           db "[2] Accept Appointment",13,10
           db "[3] Reschedule Appointment",13,10
           db "[4] Cancel Appointment",13,10
           db "[5] Mark Appointment as DONE",13,10
           db "[6] Logout to Main Dashboard",13,10
           db "Choose: ",0

szDeanLoginHeader db 13,10,"================ DEAN SECURE LOGIN ================",13,10,0
szUsername db "Dean Username: ",0
szPassword db "Dean Password: ",0
szBadLogin db "Invalid Dean username or password. Access denied.",13,10,0
szGoodPass db "Dean login successful. Dean management is unlocked.",13,10,0
szUsernameValue db "DEAN",0
szPasswordValue db "DEAN123",0

szNamePrompt db 13,10,"Student / Person Name: ",0
szStudentIDPrompt db "Student / Person ID (example: 24-11671): ",0
szDatePrompt db "Appointment Date (MM/DD/YYYY): ",0
szTimePrompt db "Time Interval (example: 12:00 PM - 12:40 PM): ",0
szPurposePrompt db "Reason / Consultation: ",0

szIntervalHelp db 13,10,"Enter your own 12-hour appointment time.",13,10
               db "Example: 12:00 PM - 12:40 PM",13,10
               db "Any valid minutes are allowed (example: 07:00 PM - 07:40 PM).",13,10,0

szCreated db 13,10,"Appointment request created.",13,10
          db "Status: WAITING - waiting for Dean approval.",13,10
          db "Keep your Student / Person ID to check your appointment.",13,10,0

szNoAppointments db 13,10,"No active appointments.",13,10,0
szMaxReached db 13,10,"Maximum of 10 appointments reached.",13,10
             db "Saving the current list to recordlist_TXT.txt...",13,10
             db "Resetting the active appointment list.",13,10,0

szSaved db "Appointment records saved.",13,10,0
szFileError db "File error. The system could not access the record file.",13,10,0
szInvalid db "Invalid choice/input.",13,10,0
szInvalidDate db "Invalid date. Please use MM/DD/YYYY.",13,10,0
szInvalidInterval db "Invalid time interval.",13,10
                   db "Examples: 09:00 AM - 10:00 AM or 12:00pm-1:00.",13,10
                   db 0
szOverlap db "The requested interval overlaps an existing appointment.",13,10,0
szFull db "The appointment list is full.",13,10,0

szEnterID db 13,10,"Appointment ID: ",0
szEnterStudentID db 13,10,"Student / Person ID: ",0
szStudentID db "Student ID: ",0
szNotFound db "Appointment ID not found.",13,10,0
szWaitingOnly db "This appointment cannot be changed in its current status.",13,10,0
szAccepted db "Appointment ACCEPTED.",13,10,0
szRescheduled db "Appointment RESCHEDULED.",13,10,0
szCancelled db "Appointment CANCELLED.",13,10,0
szDone db "Appointment marked as DONE.",13,10,0

szNewDate db "New Date (MM/DD/YYYY): ",0
szNewTime db "New Time Interval: ",0

szStatusHeader db 13,10,"================ APPOINTMENT STATUS ================",13,10,0
szListHeader db 13,10,"================ FCFS APPOINTMENT LIST ================",13,10,0
szLine db "--------------------------------------------------",13,10,0

szID db "ID: ",0
szName db "Name: ",0
szDate db "Date: ",0
szTime db "Time: ",0
szPurpose db "Purpose: ",0
szStatus db "Status: ",0
szStart db "Start minutes: ",0
szEnd db "End minutes: ",0
szBlank db 13,10,0

szStudentCheck db 13,10,"Enter your Student / Person ID to view your appointment(s).",13,10,0
szLogout db "Logged out.",13,10,0
szArchiveHeader db 13,10,"========== APPOINTMENT ARCHIVE ==========",13,10,0
szArchiveCycle db "Cycle archived because the maximum of 10 appointments was reached.",13,10,0

szFileActive db "appointment_active.dat",0
szFileArchive db "recordlist_TXT.txt",0

inputBuf db 256 dup(0)
nameBuf db 64 dup(0)
studentIDBuf db 32 dup(0)
dateBuf db 32 dup(0)
timeBuf db 64 dup(0)
purposeBuf db 128 dup(0)
passBuf db 32 dup(0)
deanUserBuf db 32 dup(0)

outBuf db 512 dup(0)

hIn dd 0
hOut dd 0
bytesRead dd 0
bytesWritten dd 0

apptCount dd 0
nextID dd 1
selectedIndex dd 0
selectedID dd 0
startTemp dd 0
endTemp dd 0

; Raw appointment storage: 10 x 268 bytes
appointments db (MAX_APPTS * APPT_SIZE) dup(0)

szWaiting db "WAITING",0
szAcceptedText db "ACCEPTED",0
szRescheduledText db "RESCHEDULED",0
szCancelledText db "CANCELLED",0
szDoneText db "DONE",0

.code

main PROC
    call InitConsole
    call LoadActive

MainLoop:
    call PrintTitle
    mov edx, OFFSET szMain
    call PrintStr
    mov edx, OFFSET inputBuf
    mov ecx, 32
    call ReadLine
    mov esi, OFFSET inputBuf
    call ParseUInt
    cmp eax, 1
    je StudentMode
    cmp eax, 2
    je DeanLogin
    cmp eax, 3
    je ProgramExit
    mov edx, OFFSET szInvalid
    call PrintStr
    jmp MainLoop

StudentMode:
    call StudentMenu
    jmp MainLoop

DeanLogin:
    call DeanLoginProc
    jmp MainLoop

ProgramExit:
    call SaveActive
    push 0
    call ExitProcess
main ENDP

; ------------------------------------------------------------
; Console initialization
; ------------------------------------------------------------
InitConsole PROC
    push STD_INPUT_HANDLE
    call GetStdHandle
    mov hIn, eax
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov hOut, eax
    ret
InitConsole ENDP

PrintTitle PROC
    mov edx, OFFSET szTitle
    call PrintStr
    ret
PrintTitle ENDP

; EDX = zero-terminated string
PrintStr PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov esi, edx
    xor ecx, ecx
PS_Len:
    cmp byte ptr [esi+ecx], 0
    je PS_GotLen
    inc ecx
    jmp PS_Len
PS_GotLen:
    push 0
    push offset bytesWritten
    push ecx
    push esi
    push hOut
    call WriteConsoleA
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
PrintStr ENDP

; EDX = buffer, ECX = max chars
ReadLine PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    mov edi, edx
    mov ebx, ecx
    dec ebx
    push 0
    push offset bytesRead
    push ebx
    push edi
    push hIn
    call ReadConsoleA
    mov eax, bytesRead
    cmp eax, 0
    je RL_Done
    mov byte ptr [edi+eax], 0
    dec eax
    cmp byte ptr [edi+eax], 10
    jne RL_CheckCR
    mov byte ptr [edi+eax], 0
    dec eax
RL_CheckCR:
    cmp eax, 0
    jl RL_Done
    cmp byte ptr [edi+eax], 13
    jne RL_Done
    mov byte ptr [edi+eax], 0
RL_Done:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
ReadLine ENDP

; ESI = string, returns unsigned integer in EAX
ParseUInt PROC
    push ebx
    push ecx
    push edx
    xor eax, eax
    xor ebx, ebx
PU_Loop:
    mov bl, [esi]
    cmp bl, 0
    je PU_Done
    cmp bl, '0'
    jb PU_Bad
    cmp bl, '9'
    ja PU_Bad
    imul eax, eax, 10
    sub bl, '0'
    add eax, ebx
    inc esi
    jmp PU_Loop
PU_Bad:
    xor eax, eax
PU_Done:
    pop edx
    pop ecx
    pop ebx
    ret
ParseUInt ENDP

; ESI=source EDI=destination ECX=max bytes incl terminator
CopyString PROC
    push eax
    push ecx
    push esi
    push edi
    cmp ecx, 0
    je CS_Done
    dec ecx
CS_Loop:
    cmp ecx, 0
    je CS_Term
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    dec ecx
    cmp al, 0
    jne CS_Loop
    jmp CS_Done
CS_Term:
    mov byte ptr [edi], 0
CS_Done:
    pop edi
    pop esi
    pop ecx
    pop eax
    ret
CopyString ENDP

; ------------------------------------------------------------
; Student menu
; ------------------------------------------------------------
StudentMenu PROC
SM_Loop:
    mov edx, OFFSET szStudentMenu
    call PrintStr
    mov edx, OFFSET inputBuf
    mov ecx, 32
    call ReadLine
    mov esi, OFFSET inputBuf
    call ParseUInt
    cmp eax, 1
    je SM_Submit
    cmp eax, 2
    je SM_Check
    cmp eax, 3
    je SM_List
    cmp eax, 4
    je SM_Exit
    mov edx, OFFSET szInvalid
    call PrintStr
    jmp SM_Loop
SM_Submit:
    call SubmitAppointment
    jmp SM_Loop
SM_Check:
    call CheckStatus
    jmp SM_Loop
SM_List:
    call ViewAppointments
    jmp SM_Loop
SM_Exit:
    ret
StudentMenu ENDP

; ------------------------------------------------------------
; Submit appointment
; ------------------------------------------------------------
SubmitAppointment PROC
    cmp apptCount, MAX_APPTS
    jb SA_NotFull
    mov edx, OFFSET szFull
    call PrintStr
    ret
SA_NotFull:
    mov edx, OFFSET szNamePrompt
    call PrintStr
    mov edx, OFFSET nameBuf
    mov ecx, 64
    call ReadLine
    cmp byte ptr [nameBuf], 0
    je SA_Invalid

    mov edx, OFFSET szStudentIDPrompt
    call PrintStr
    mov edx, OFFSET studentIDBuf
    mov ecx, 32
    call ReadLine
    cmp byte ptr [studentIDBuf], 0
    je SA_Invalid

    mov edx, OFFSET szDatePrompt
    call PrintStr
    mov edx, OFFSET dateBuf
    mov ecx, 32
    call ReadLine
    mov esi, OFFSET dateBuf
    call ValidateDate
    jc SA_BadDate

    mov edx, OFFSET szIntervalHelp
    call PrintStr
    mov edx, OFFSET szTimePrompt
    call PrintStr
    mov edx, OFFSET timeBuf
    mov ecx, 64
    call ReadLine
    mov edx, OFFSET timeBuf
    call ParseInterval
    jc SA_BadTime
    mov startTemp, eax
    mov endTemp, edx
    mov ebx, eax
    mov edi, edx

    mov esi, ebx
    mov ecx, edi
    call CheckOverlap
    jc SA_Overlap

    mov edx, OFFSET szPurposePrompt
    call PrintStr
    mov edx, OFFSET purposeBuf
    mov ecx, 128
    call ReadLine

    mov eax, apptCount
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax

    mov esi, OFFSET nameBuf
    mov ecx, 64
    call CopyString

    mov eax, apptCount
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax
    mov esi, OFFSET studentIDBuf
    add edi, APPT_STUDENTID_OFF
    mov ecx, 32
    call CopyString

    mov eax, apptCount
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax
    mov esi, OFFSET dateBuf
    mov edi, OFFSET appointments
    add edi, eax
    add edi, APPT_DATE_OFF
    mov ecx, 16
    call CopyString

    ; Recompute record pointer because EAX was changed by CopyString.
    mov eax, apptCount
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax
    mov esi, OFFSET timeBuf
    add edi, APPT_TIME_OFF
    mov ecx, 64
    call CopyString

    mov eax, apptCount
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax
    mov esi, OFFSET purposeBuf
    add edi, APPT_PURPOSE_OFF
    mov ecx, 128
    call CopyString

    mov eax, apptCount
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax
    mov esi, OFFSET szWaiting
    add edi, APPT_STATUS_OFF
    mov ecx, 16
    call CopyString

    mov eax, apptCount
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax
    mov eax, startTemp
    mov [edi+APPT_START_OFF], eax
    mov eax, endTemp
    mov [edi+APPT_END_OFF], eax
    mov eax, nextID
    mov [edi+APPT_ID_OFF], eax
    inc nextID
    inc apptCount
    call SaveActive

    mov edx, OFFSET szCreated
    call PrintStr

    cmp apptCount, MAX_APPTS
    jne SA_Done
    call ArchiveAndReset
SA_Done:
    ret
SA_Invalid:
    mov edx, OFFSET szInvalid
    call PrintStr
    ret
SA_BadDate:
    mov edx, OFFSET szInvalidDate
    call PrintStr
    ret
SA_BadTime:
    mov edx, OFFSET szInvalidInterval
    call PrintStr
    ret
SA_Overlap:
    mov edx, OFFSET szOverlap
    call PrintStr
    ret
SubmitAppointment ENDP

; ------------------------------------------------------------
; Validate date: MM/DD/YYYY basic numeric/range validation
; ------------------------------------------------------------
ValidateDate PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    mov esi, edx
    cmp byte ptr [esi+2], '/'
    jne VD_Bad
    cmp byte ptr [esi+5], '/'
    jne VD_Bad
    mov al, [esi]
    sub al, '0'
    cmp al, 9
    ja VD_Bad
    mov bl, [esi+1]
    sub bl, '0'
    cmp bl, 9
    ja VD_Bad
    movzx eax, al
    movzx ebx, bl
    imul eax, 10
    add eax, ebx
    cmp eax, 1
    jb VD_Bad
    cmp eax, 12
    ja VD_Bad
    mov al, [esi+3]
    sub al, '0'
    cmp al, 9
    ja VD_Bad
    mov bl, [esi+4]
    sub bl, '0'
    cmp bl, 9
    ja VD_Bad
    movzx eax, al
    movzx ebx, bl
    imul eax, 10
    add eax, ebx
    cmp eax, 1
    jb VD_Bad
    cmp eax, 31
    ja VD_Bad
    clc
    jmp VD_End
VD_Bad:
    stc
VD_End:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
ValidateDate ENDP

; ------------------------------------------------------------
; Parse interval in EDX.
; Exact accepted format: HH:MM AM - HH:MM PM
; Returns EAX=start minutes, EDX=end minutes, CF=1 on error.
; ------------------------------------------------------------
ParseInterval PROC
    ; Input: EDX -> "12:00 PM - 12:40 PM" (spaces optional around separators)
    ; Accepts 12-hour times, AM/PM (case-insensitive), minutes 00-59.
    ; No fixed duration: 30, 40, 45, 60 minutes, etc. are allowed.
    ; Returns EAX=start minutes, EDX=end minutes, CF=1 on error.
    push ebx
    push ecx
    push esi
    push edi
    push ebp

    mov edi, edx

    ; skip leading spaces
PI_LS1:
    cmp byte ptr [edi], ' '
    jne PI_SH
    inc edi
    jmp PI_LS1

    ; start hour: 1 or 2 digits
PI_SH:
    xor eax, eax
    xor ecx, ecx
PI_SHL:
    mov bl, [edi]
    cmp bl, '0'
    jb PI_SHD
    cmp bl, '9'
    ja PI_SHD
    imul eax, eax, 10
    sub bl, '0'
    movzx ebx, bl
    add eax, ebx
    inc edi
    inc ecx
    cmp ecx, 2
    jb PI_SHL
PI_SHD:
    cmp ecx, 0
    je PI_BAD
    cmp eax, 1
    jb PI_BAD
    cmp eax, 12
    ja PI_BAD
    mov ebp, eax
    cmp byte ptr [edi], ':'
    jne PI_BAD
    inc edi

    ; start minutes exactly two digits, any 00-59
    mov bl, [edi]
    cmp bl, '0'
    jb PI_BAD
    cmp bl, '9'
    ja PI_BAD
    sub bl, '0'
    movzx eax, bl
    imul eax, eax, 10
    inc edi
    mov bl, [edi]
    cmp bl, '0'
    jb PI_BAD
    cmp bl, '9'
    ja PI_BAD
    sub bl, '0'
    movzx ebx, bl
    add eax, ebx
    inc edi
    cmp eax, 59
    ja PI_BAD
    mov ecx, eax

PI_SSP:
    cmp byte ptr [edi], ' '
    jne PI_SAP
    inc edi
    jmp PI_SSP
PI_SAP:
    mov al, [edi]
    and al, 0DFh
    cmp al, 'A'
    je PI_SAM
    cmp al, 'P'
    je PI_SPM
    jmp PI_BAD
PI_SAM:
    xor ebx, ebx
    jmp PI_SPER
PI_SPM:
    mov ebx, 1
PI_SPER:
    inc edi
    mov al, [edi]
    and al, 0DFh
    cmp al, 'M'
    jne PI_BAD
    inc edi

    ; convert start to minutes in EBP
    mov eax, ebp
    cmp eax, 12
    jne PI_SNOT12
    cmp ebx, 0
    je PI_S12AM
    jmp PI_SCONV
PI_S12AM:
    xor eax, eax
    jmp PI_SCONV
PI_SNOT12:
    cmp ebx, 0
    je PI_SCONV
    add eax, 12
PI_SCONV:
    imul eax, eax, 60
    add eax, ecx
    mov ebp, eax

    ; spaces before dash
PI_BD:
    cmp byte ptr [edi], ' '
    jne PI_DASH
    inc edi
    jmp PI_BD
PI_DASH:
    cmp byte ptr [edi], '-'
    jne PI_BAD
    inc edi
PI_AD:
    cmp byte ptr [edi], ' '
    jne PI_EH
    inc edi
    jmp PI_AD

    ; end hour
PI_EH:
    xor eax, eax
    xor ecx, ecx
PI_EHL:
    mov bl, [edi]
    cmp bl, '0'
    jb PI_EHD
    cmp bl, '9'
    ja PI_EHD
    imul eax, eax, 10
    sub bl, '0'
    movzx ebx, bl
    add eax, ebx
    inc edi
    inc ecx
    cmp ecx, 2
    jb PI_EHL
PI_EHD:
    cmp ecx, 0
    je PI_BAD
    cmp eax, 1
    jb PI_BAD
    cmp eax, 12
    ja PI_BAD
    mov esi, eax
    cmp byte ptr [edi], ':'
    jne PI_BAD
    inc edi

    ; end minutes 00-59
    mov bl, [edi]
    cmp bl, '0'
    jb PI_BAD
    cmp bl, '9'
    ja PI_BAD
    sub bl, '0'
    movzx eax, bl
    imul eax, eax, 10
    inc edi
    mov bl, [edi]
    cmp bl, '0'
    jb PI_BAD
    cmp bl, '9'
    ja PI_BAD
    sub bl, '0'
    movzx ebx, bl
    add eax, ebx
    inc edi
    cmp eax, 59
    ja PI_BAD
    mov ecx, eax

PI_ESP:
    cmp byte ptr [edi], ' '
    jne PI_EAP
    inc edi
    jmp PI_ESP
PI_EAP:
    mov al, [edi]
    and al, 0DFh
    cmp al, 'A'
    je PI_EAM
    cmp al, 'P'
    je PI_EPM
    jmp PI_BAD
PI_EAM:
    xor ebx, ebx
    jmp PI_EPER
PI_EPM:
    mov ebx, 1
PI_EPER:
    inc edi
    mov al, [edi]
    and al, 0DFh
    cmp al, 'M'
    jne PI_BAD
    inc edi
PI_TRAIL:
    cmp byte ptr [edi], ' '
    jne PI_ENDSTR
    inc edi
    jmp PI_TRAIL
PI_ENDSTR:
    cmp byte ptr [edi], 0
    jne PI_BAD

    ; convert end time
    mov eax, esi
    cmp eax, 12
    jne PI_ENOT12
    cmp ebx, 0
    je PI_E12AM
    jmp PI_ECONV
PI_E12AM:
    xor eax, eax
    jmp PI_ECONV
PI_ENOT12:
    cmp ebx, 0
    je PI_ECONV
    add eax, 12
PI_ECONV:
    imul eax, eax, 60
    add eax, ecx
    mov edx, eax
    mov eax, ebp
    cmp edx, eax
    jbe PI_BAD
    clc
    jmp PI_DONE
PI_BAD:
    stc
PI_DONE:
    pop ebp
    pop edi
    pop esi
    pop ecx
    pop ebx
    ret
ParseInterval ENDP

; ESI=start, ECX=end. CF=1 if overlap
CheckOverlap PROC
    push eax
    push ebx
    push edx
    push edi
    push esi
    mov eax, esi
    mov edx, ecx
    xor ebx, ebx
CO_Loop:
    cmp ebx, apptCount
    jae CO_No
    mov edi, ebx
    imul edi, APPT_SIZE
    mov esi, OFFSET appointments
    add edi, esi
    ; Ignore CANCELLED and DONE records for overlap
    cmp byte ptr [edi+APPT_STATUS_OFF], 'C'
    je CO_Next
    cmp byte ptr [edi+APPT_STATUS_OFF], 'D'
    je CO_Next
    mov esi, [edi+APPT_START_OFF]
    mov edi, [edi+APPT_END_OFF]
    ; overlap when newStart < oldEnd AND newEnd > oldStart
    cmp eax, edi
    jae CO_Next
    cmp edx, esi
    jbe CO_Next
    stc
    jmp CO_End
CO_Next:
    inc ebx
    jmp CO_Loop
CO_No:
    clc
CO_End:
    pop esi
    pop edi
    pop edx
    pop ebx
    pop eax
    ret
CheckOverlap ENDP

; ------------------------------------------------------------
; View appointments in FCFS order
; ------------------------------------------------------------
ViewAppointments PROC
    cmp apptCount, 0
    jne VA_Start
    mov edx, OFFSET szNoAppointments
    call PrintStr
    ret
VA_Start:
    mov edx, OFFSET szListHeader
    call PrintStr
    xor ebx, ebx
VA_Loop:
    cmp ebx, apptCount
    jae VA_Done
    push ebx
    call PrintAppointmentByIndex
    pop ebx
    inc ebx
    jmp VA_Loop
VA_Done:
    ret
ViewAppointments ENDP

; EBX=index
PrintAppointmentByIndex PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    mov eax, ebx
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax

    mov edx, OFFSET szLine
    call PrintStr
    mov edx, OFFSET szID
    call PrintStr
    mov eax, [edi+APPT_ID_OFF]
    call PrintNumber
    mov edx, OFFSET szStudentID
    call PrintStr
    mov edx, edi
    add edx, APPT_STUDENTID_OFF
    call PrintStr
    mov edx, OFFSET szBlank
    call PrintStr
    mov edx, OFFSET szName
    call PrintStr
    mov edx, edi
    add edx, APPT_NAME_OFF
    call PrintStr
    mov edx, OFFSET szBlank
    call PrintStr
    mov edx, OFFSET szDate
    call PrintStr
    mov edx, edi
    add edx, APPT_DATE_OFF
    call PrintStr
    mov edx, OFFSET szBlank
    call PrintStr
    mov edx, OFFSET szTime
    call PrintStr
    mov edx, edi
    add edx, APPT_TIME_OFF
    call PrintStr
    mov edx, OFFSET szBlank
    call PrintStr
    mov edx, OFFSET szPurpose
    call PrintStr
    mov edx, edi
    add edx, APPT_PURPOSE_OFF
    call PrintStr
    mov edx, OFFSET szBlank
    call PrintStr
    mov edx, OFFSET szStatus
    call PrintStr
    mov edx, edi
    add edx, APPT_STATUS_OFF
    call PrintStr
    mov edx, OFFSET szBlank
    call PrintStr

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
PrintAppointmentByIndex ENDP

; EAX=number
PrintNumber PROC
    push eax
    push ebx
    push ecx
    push edx
    push edi
    mov edi, OFFSET outBuf+500
    mov byte ptr [edi], 0
    cmp eax, 0
    jne PN_Convert
    dec edi
    mov byte ptr [edi], '0'
    jmp PN_Print
PN_Convert:
    xor edx, edx
    mov ebx, 10
PN_Div:
    xor edx, edx
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl
    test eax, eax
    jnz PN_Div
PN_Print:
    mov edx, edi
    call PrintStr
    pop edi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
PrintNumber ENDP

; ------------------------------------------------------------
; Student status check
; ------------------------------------------------------------
CheckStatus PROC
    mov edx, OFFSET szStudentCheck
    call PrintStr
    mov edx, OFFSET szEnterStudentID
    call PrintStr
    mov edx, OFFSET inputBuf
    mov ecx, 32
    call ReadLine
    cmp byte ptr [inputBuf], 0
    je CS_Invalid

    xor ecx, ecx              ; ECX = number of matches
    xor esi, esi              ; ESI = appointment index
CS_Loop:
    cmp esi, apptCount
    jae CS_DoneLoop
    mov eax, esi
    push ecx
    mov ecx, APPT_SIZE
    imul eax, ecx
    pop ecx
    mov edi, OFFSET appointments
    add edi, eax

    push esi
    push ecx
    mov esi, OFFSET inputBuf
    add edi, APPT_STUDENTID_OFF
    call CompareStrings
    pop ecx
    pop esi
    jne CS_Next

    cmp ecx, 0
    jne CS_Show
    mov edx, OFFSET szStatusHeader
    call PrintStr
CS_Show:
    push esi
    mov ebx, esi
    call PrintAppointmentByIndex
    pop esi
    inc ecx
CS_Next:
    inc esi
    jmp CS_Loop
CS_DoneLoop:
    cmp ecx, 0
    jne CS_End
    mov edx, OFFSET szNotFound
    call PrintStr
CS_End:
    ret
CS_Invalid:
    mov edx, OFFSET szInvalid
    call PrintStr
    ret
CheckStatus ENDP

; EAX=ID, returns EAX=index, CF=0
FindByID PROC
    push ebx
    push ecx
    push edx
    push edi
    mov edx, eax
    xor ebx, ebx
FB_Loop:
    cmp ebx, apptCount
    jae FB_Not
    mov eax, ebx
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax
    mov eax, [edi+APPT_ID_OFF]
    cmp eax, edx
    je FB_Found
    inc ebx
    jmp FB_Loop
FB_Found:
    mov eax, ebx
    clc
    pop edi
    pop edx
    pop ecx
    pop ebx
    ret
FB_Not:
    stc
    pop edi
    pop edx
    pop ecx
    pop ebx
    ret
FindByID ENDP

; ------------------------------------------------------------
; Dean login and management
; ------------------------------------------------------------
DeanLoginProc PROC
    ; The Dean must authenticate before any management command is available.
    mov edx, OFFSET szDeanLoginHeader
    call PrintStr

    mov edx, OFFSET szUsername
    call PrintStr
    mov edx, OFFSET deanUserBuf
    mov ecx, 32
    call ReadLine
    mov esi, OFFSET deanUserBuf
    mov edi, OFFSET szUsernameValue
    call CompareStrings
    jne DL_Bad

    mov edx, OFFSET szPassword
    call PrintStr
    mov edx, OFFSET passBuf
    mov ecx, 32
    call ReadLine
    mov esi, OFFSET passBuf
    mov edi, OFFSET szPasswordValue
    call CompareStrings
    jne DL_Bad

    mov edx, OFFSET szGoodPass
    call PrintStr
DeanLoop:
    mov edx, OFFSET szDeanMenu
    call PrintStr
    mov edx, OFFSET inputBuf
    mov ecx, 32
    call ReadLine
    mov esi, OFFSET inputBuf
    call ParseUInt
    cmp eax, 1
    je DL_View
    cmp eax, 2
    je DL_Accept
    cmp eax, 3
    je DL_Reschedule
    cmp eax, 4
    je DL_Cancel
    cmp eax, 5
    je DL_Done
    cmp eax, 6
    je DL_Logout
    mov edx, OFFSET szInvalid
    call PrintStr
    jmp DeanLoop
DL_View:
    call ViewAppointments
    jmp DeanLoop
DL_Accept:
    call AcceptAppointment
    jmp DeanLoop
DL_Reschedule:
    call RescheduleAppointment
    jmp DeanLoop
DL_Cancel:
    call CancelAppointment
    jmp DeanLoop
DL_Done:
    call MarkDone
    jmp DeanLoop
DL_Logout:
    mov edx, OFFSET szLogout
    call PrintStr
    ret
DL_Bad:
    mov edx, OFFSET szBadLogin
    call PrintStr
    ret
DeanLoginProc ENDP

; Compare ESI string and EDI string, flags set like strcmp
CompareStrings PROC
    push eax
CS_Compare:
    mov al, [esi]
    cmp al, [edi]
    jne CS_Diff
    cmp al, 0
    je CS_Same
    inc esi
    inc edi
    jmp CS_Compare
CS_Diff:
    pop eax
    ret
CS_Same:
    pop eax
    ret
CompareStrings ENDP

ReadAppointmentID PROC
    mov edx, OFFSET szEnterID
    call PrintStr
    mov edx, OFFSET inputBuf
    mov ecx, 32
    call ReadLine
    mov esi, OFFSET inputBuf
    call ParseUInt
    ret
ReadAppointmentID ENDP

; Dean accepts waiting appointment
AcceptAppointment PROC
    call ReadAppointmentID
    cmp eax, 0
    je AA_Bad
    call FindByID
    jc AA_NotFound
    mov ebx, eax
    mov eax, ebx
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax
    cmp byte ptr [edi+APPT_STATUS_OFF], 'W'
    jne AA_NotWaiting
    mov esi, OFFSET szAcceptedText
    add edi, APPT_STATUS_OFF
    mov ecx, 16
    call CopyString
    call SaveActive
    mov edx, OFFSET szAccepted
    call PrintStr
    ret
AA_Bad:
    mov edx, OFFSET szInvalid
    call PrintStr
    ret
AA_NotFound:
    mov edx, OFFSET szNotFound
    call PrintStr
    ret
AA_NotWaiting:
    mov edx, OFFSET szWaitingOnly
    call PrintStr
    ret
AcceptAppointment ENDP

; Dean reschedules waiting appointment
RescheduleAppointment PROC
    call ReadAppointmentID
    cmp eax, 0
    je RA_Bad
    mov selectedID, eax
    call FindByID
    jc RA_NotFound
    mov selectedIndex, eax

    mov eax, selectedIndex
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax
    mov al, [edi+APPT_STATUS_OFF]
    cmp al, 'C'
    je RA_NotWaiting
    cmp al, 'D'
    je RA_NotWaiting

    mov edx, OFFSET szNewDate
    call PrintStr
    mov edx, OFFSET dateBuf
    mov ecx, 32
    call ReadLine
    mov edx, OFFSET dateBuf
    call ValidateDate
    jc RA_BadDate

    mov edx, OFFSET szNewTime
    call PrintStr
    mov edx, OFFSET timeBuf
    mov ecx, 64
    call ReadLine
    mov edx, OFFSET timeBuf
    call ParseInterval
    jc RA_BadTime
    mov startTemp, eax
    mov endTemp, edx

    mov esi, startTemp
    mov ecx, endTemp
    mov edx, selectedIndex
    call CheckOverlapExcept
    jc RA_Overlap

    mov eax, selectedIndex
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax

    mov eax, startTemp
    mov [edi+APPT_START_OFF], eax
    mov eax, endTemp
    mov [edi+APPT_END_OFF], eax

    mov esi, OFFSET dateBuf
    mov edx, edi
    add edx, APPT_DATE_OFF
    mov edi, edx
    mov ecx, 16
    call CopyString

    mov eax, selectedIndex
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax
    mov esi, OFFSET timeBuf
    mov edx, edi
    add edx, APPT_TIME_OFF
    mov edi, edx
    mov ecx, 32
    call CopyString

    mov eax, selectedIndex
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax
    mov esi, OFFSET szRescheduledText
    mov edx, edi
    add edx, APPT_STATUS_OFF
    mov edi, edx
    mov ecx, 16
    call CopyString

    call SaveActive
    mov edx, OFFSET szRescheduled
    call PrintStr
    ret
RA_Bad:
    mov edx, OFFSET szInvalid
    call PrintStr
    ret
RA_NotFound:
    mov edx, OFFSET szNotFound
    call PrintStr
    ret
RA_NotWaiting:
    mov edx, OFFSET szWaitingOnly
    call PrintStr
    ret
RA_BadDate:
    mov edx, OFFSET szInvalidDate
    call PrintStr
    ret
RA_BadTime:
    mov edx, OFFSET szInvalidInterval
    call PrintStr
    ret
RA_Overlap:
    mov edx, OFFSET szOverlap
    call PrintStr
    ret
RescheduleAppointment ENDP

; ESI = new start minutes, ECX = new end minutes, EDX = index to ignore
; CF=1 if overlap with another active appointment
CheckOverlapExcept PROC
    push eax
    push ebx
    push edx
    push esi
    push edi
    mov startTemp, esi
    mov endTemp, ecx
    mov selectedIndex, edx
    xor ebx, ebx
COE_Loop:
    cmp ebx, apptCount
    jae COE_No
    cmp ebx, selectedIndex
    je COE_Next
    mov eax, ebx
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax
    cmp byte ptr [edi+APPT_STATUS_OFF], 'C'
    je COE_Next
    cmp byte ptr [edi+APPT_STATUS_OFF], 'D'
    je COE_Next
    mov eax, startTemp
    cmp eax, [edi+APPT_END_OFF]
    jae COE_Next
    mov eax, endTemp
    cmp eax, [edi+APPT_START_OFF]
    jbe COE_Next
    stc
    jmp COE_End
COE_Next:
    inc ebx
    jmp COE_Loop
COE_No:
    clc
COE_End:
    pop edi
    pop esi
    pop edx
    pop ebx
    pop eax
    ret
CheckOverlapExcept ENDP

CancelAppointment PROC
    call ReadAppointmentID
    cmp eax, 0
    je CA_Bad
    call FindByID
    jc CA_NotFound
    mov ebx, eax
    mov eax, ebx
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax
    mov al, [edi+APPT_STATUS_OFF]
    cmp al, 'C'
    je CA_NotWaiting
    cmp al, 'D'
    je CA_NotWaiting
    mov esi, OFFSET szCancelledText
    add edi, APPT_STATUS_OFF
    mov ecx, 16
    call CopyString
    call SaveActive
    mov edx, OFFSET szCancelled
    call PrintStr
    ret
CA_Bad:
    mov edx, OFFSET szInvalid
    call PrintStr
    ret
CA_NotFound:
    mov edx, OFFSET szNotFound
    call PrintStr
    ret
CA_NotWaiting:
    mov edx, OFFSET szWaitingOnly
    call PrintStr
    ret
CancelAppointment ENDP

MarkDone PROC
    call ReadAppointmentID
    cmp eax, 0
    je MD_Bad
    call FindByID
    jc MD_NotFound
    mov ebx, eax
    mov eax, ebx
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax
    mov al, [edi+APPT_STATUS_OFF]
    cmp al, 'A'
    je MD_Allowed
    cmp al, 'R'
    jne MD_NotAccepted
MD_Allowed:
    mov esi, OFFSET szDoneText
    add edi, APPT_STATUS_OFF
    mov ecx, 16
    call CopyString
    call SaveActive
    mov edx, OFFSET szDone
    call PrintStr
    ret
MD_Bad:
    mov edx, OFFSET szInvalid
    call PrintStr
    ret
MD_NotFound:
    mov edx, OFFSET szNotFound
    call PrintStr
    ret
MD_NotAccepted:
    mov edx, OFFSET szWaitingOnly
    call PrintStr
    ret
MarkDone ENDP

; ------------------------------------------------------------
; Active binary file: count + nextID + 3320 bytes
; ------------------------------------------------------------
SaveActive PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push 0
    push FILE_ATTRIBUTE_NORMAL
    push CREATE_ALWAYS
    push 0
    push 0
    push GENERIC_WRITE
    push offset szFileActive
    call CreateFileA
    cmp eax, INVALID_HANDLE_VALUE
    je SAV_Bad
    mov ebx, eax
    push 0
    push offset bytesWritten
    push 4
    push offset apptCount
    push ebx
    call WriteFile
    push 0
    push offset bytesWritten
    push 4
    push offset nextID
    push ebx
    call WriteFile
    push 0
    push offset bytesWritten
    push (MAX_APPTS * APPT_SIZE)
    push offset appointments
    push ebx
    call WriteFile
    push ebx
    call CloseHandle
SAV_Bad:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
SaveActive ENDP

LoadActive PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push 0
    push FILE_ATTRIBUTE_NORMAL
    push OPEN_EXISTING
    push 0
    push FILE_SHARE_READ
    push GENERIC_READ
    push offset szFileActive
    call CreateFileA
    cmp eax, INVALID_HANDLE_VALUE
    je LA_Default
    mov ebx, eax
    push 0
    push offset bytesRead
    push 4
    push offset apptCount
    push ebx
    call ReadFile
    push 0
    push offset bytesRead
    push 4
    push offset nextID
    push ebx
    call ReadFile
    push 0
    push offset bytesRead
    push (MAX_APPTS * APPT_SIZE)
    push offset appointments
    push ebx
    call ReadFile
    push ebx
    call CloseHandle
    cmp apptCount, MAX_APPTS
    jbe LA_Done
    mov apptCount, 0
    mov nextID, 1
LA_Done:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
LA_Default:
    mov apptCount, 0
    mov nextID, 1
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
LoadActive ENDP

; ------------------------------------------------------------
; Archive all 10 appointments to recordlist_TXT.txt, then reset.
; ------------------------------------------------------------
ArchiveAndReset PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov edx, OFFSET szMaxReached
    call PrintStr

    push 0
    push FILE_ATTRIBUTE_NORMAL
    push OPEN_ALWAYS
    push 0
    push FILE_SHARE_READ
    push GENERIC_WRITE
    push offset szFileArchive
    call CreateFileA
    cmp eax, INVALID_HANDLE_VALUE
    je AR_ResetOnly
    mov ebx, eax

    push FILE_END
    push 0
    push 0
    push ebx
    call SetFilePointer

    mov edx, OFFSET szArchiveHeader
    call FileWriteString
    mov edx, OFFSET szArchiveCycle
    call FileWriteString

    xor esi, esi
AR_Loop:
    cmp esi, apptCount
    jae AR_Close
    ; Header for each record
    mov edx, OFFSET szLine
    call FileWriteString
    mov edx, OFFSET szID
    call FileWriteString
    mov eax, esi
    mov ecx, APPT_SIZE
    imul eax, ecx
    mov edi, OFFSET appointments
    add edi, eax
    mov eax, [edi+APPT_ID_OFF]
    call FileWriteNumber
    mov edx, OFFSET szStudentID
    call FileWriteString
    mov edx, edi
    add edx, APPT_STUDENTID_OFF
    call FileWriteString
    mov edx, OFFSET szBlank
    call FileWriteString
    mov edx, OFFSET szName
    call FileWriteString
    mov edx, edi
    add edx, APPT_NAME_OFF
    call FileWriteString
    mov edx, OFFSET szDate
    call FileWriteString
    mov edx, edi
    add edx, APPT_DATE_OFF
    call FileWriteString
    mov edx, OFFSET szTime
    call FileWriteString
    mov edx, edi
    add edx, APPT_TIME_OFF
    call FileWriteString
    mov edx, OFFSET szPurpose
    call FileWriteString
    mov edx, edi
    add edx, APPT_PURPOSE_OFF
    call FileWriteString
    mov edx, OFFSET szStatus
    call FileWriteString
    mov edx, edi
    add edx, APPT_STATUS_OFF
    call FileWriteString
    mov edx, OFFSET szBlank
    call FileWriteString
    inc esi
    jmp AR_Loop
AR_Close:
    push ebx
    call CloseHandle
AR_ResetOnly:
    mov apptCount, 0
    mov nextID, 1
    mov edi, OFFSET appointments
    mov ecx, (MAX_APPTS * APPT_SIZE)
    xor eax, eax
    rep stosb
    call SaveActive

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
ArchiveAndReset ENDP

; EBX = archive file handle, EDX=string
FileWriteString PROC
    push eax
    push ecx
    push edx
    push esi
    mov esi, edx
    xor ecx, ecx
FWS_Len:
    cmp byte ptr [esi+ecx], 0
    je FWS_Got
    inc ecx
    jmp FWS_Len
FWS_Got:
    push 0
    push offset bytesWritten
    push ecx
    push esi
    push ebx
    call WriteFile
    pop esi
    pop edx
    pop ecx
    pop eax
    ret
FileWriteString ENDP

; EAX=number, EBX=archive file handle
FileWriteNumber PROC
    push eax
    push ebx
    push ecx
    push edx
    push edi
    mov edi, OFFSET outBuf+500
    mov byte ptr [edi], 0
    cmp eax, 0
    jne FWN_Convert
    dec edi
    mov byte ptr [edi], '0'
    jmp FWN_Write
FWN_Convert:
    xor edx, edx
    mov ecx, 10
FWN_Div:
    xor edx, edx
    div ecx
    add dl, '0'
    dec edi
    mov [edi], dl
    test eax, eax
    jnz FWN_Div
FWN_Write:
    mov edx, edi
    call FileWriteString
    pop edi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
FileWriteNumber ENDP

END main
