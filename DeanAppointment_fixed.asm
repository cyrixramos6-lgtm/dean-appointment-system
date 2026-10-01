; DeanAppointment.asm
; Simple x86 MASM console program for Visual Studio.
; Target platform: Win32 / x86.
; Dean password: dean123

.386
.model flat, c
option casemap:none

includelib kernel32.lib
includelib ucrt.lib
includelib legacy_stdio_definitions.lib

printf PROTO C :VARARG
gets_s PROTO C :PTR BYTE, :DWORD
atoi PROTO C :PTR BYTE
strcpy_s PROTO C :PTR BYTE, :DWORD, :PTR BYTE
strcmp PROTO C :PTR BYTE, :PTR BYTE
ExitProcess PROTO STDCALL :DWORD

MAX_APPOINTMENTS EQU 20
NAME_SIZE EQU 32
DATE_SIZE EQU 16
TIME_SIZE EQU 32
PURPOSE_SIZE EQU 64

; Appointment:
; ID       DWORD
; Status   DWORD
; Name     32 bytes
; Date     16 bytes
; Time     32 bytes
; Purpose  64 bytes
APPT_SIZE EQU 152

STATUS_PENDING   EQU 0
STATUS_ACCEPTED  EQU 1
STATUS_CANCELLED EQU 2
STATUS_MOVED     EQU 3
STATUS_DONE      EQU 4

.data
appTitle db 13,10,"==============================================",13,10
      db "          DEAN APPOINTMENT SYSTEM",13,10
      db "==============================================",13,10,0

menu db 13,10
     db "[1] Submit appointment",13,10
     db "[2] Clear input",13,10
     db "[3] Dean login",13,10
     db "[4] Dean logout",13,10
     db "[5] Accept appointment",13,10
     db "[6] Cancel appointment",13,10
     db "[7] Move appointment",13,10
     db "[8] Mark appointment done",13,10
     db "[9] Check my status",13,10
     db "[10] Show appointment queue",13,10
     db "[11] Show selected appointment",13,10
     db "[0] Exit",13,10
     db "Choose: ",0

namePrompt db "Student name: ",0
datePrompt db "Appointment date (MM/DD/YYYY): ",0
timePrompt db "Appointment time (HH:MM - HH:MM): ",0
purposePrompt db "Purpose: ",0
passwordPrompt db "Dean password: ",0
idPrompt db "Appointment ID: ",0
newDatePrompt db "New date: ",0
newTimePrompt db "New time: ",0

submittedMsg db 13,10,"Appointment submitted. ID = %d",13,10,0
loginOK db 13,10,"Dean login successful.",13,10,0
loginBad db 13,10,"Wrong password.",13,10,0
logoutMsg db 13,10,"Dean logged out.",13,10,0
needLogin db 13,10,"Dean login required.",13,10,0
invalidMsg db 13,10,"Invalid choice or appointment ID.",13,10,0
notFound db 13,10,"Appointment not found.",13,10,0
fullMsg db 13,10,"Appointment queue is full.",13,10,0
clearMsg db 13,10,"Input cleared.",13,10,0
acceptedMsg db 13,10,"Appointment accepted.",13,10,0
cancelledMsg db 13,10,"Appointment cancelled.",13,10,0
movedMsg db 13,10,"Appointment moved.",13,10,0
doneMsg db 13,10,"Appointment marked as done.",13,10,0

queueTitle db 13,10,"---------------- APPOINTMENT QUEUE ----------------",13,10,0
queueFormat db "ID: %d | Name: %s | Date: %s | Time: %s | Status: %s",13,10,0
emptyMsg db "No appointments available.",13,10,0
fcfsMsg db "Order: first come, first served (FCFS).",13,10,0

selectedTitle db 13,10,"------------- SELECTED APPOINTMENT -------------",13,10,0
idLabel db "ID      : %d",13,10,0
nameLabel db "Name    : %s",13,10,0
dateLabel db "Date    : %s",13,10,0
timeLabel db "Time    : %s",13,10,0
purposeLabel db "Purpose : %s",13,10,0
statusLabel db "Status  : %s",13,10,0

statusPending db "Pending",0
statusAccepted db "Accepted",0
statusCancelled db "Cancelled",0
statusMoved db "Moved",0
statusDone db "Done",0

deanPassword db "dean123",0
crlf db 13,10,0
pressEnter db 13,10,"Press ENTER to continue...",0

inputBuffer db 128 dup(0)
nameBuffer db NAME_SIZE dup(0)
dateBuffer db DATE_SIZE dup(0)
timeBuffer db TIME_SIZE dup(0)
purposeBuffer db PURPOSE_SIZE dup(0)
passwordBuffer db 32 dup(0)

appointments db MAX_APPOINTMENTS * APPT_SIZE dup(0)
appointmentCount dd 0
nextID dd 1001
selectedIndex dd -1
deanLoggedIn dd 0

.code

; ------------------------------------------------------------
; Clear a buffer.
; EDI = address, ECX = size
; ------------------------------------------------------------
ClearBuffer PROC
    push eax
    xor eax,eax
    rep stosb
    pop eax
    ret
ClearBuffer ENDP

; ------------------------------------------------------------
; Copy a string.
; EDI = destination, ECX = destination size, ESI = source
; ------------------------------------------------------------
CopyString PROC
    invoke strcpy_s, edi, ecx, esi
    ret
CopyString ENDP

; ------------------------------------------------------------
; Return ESI = address of appointment at index EAX.
; ------------------------------------------------------------
GetAppointment PROC
    mov esi,OFFSET appointments
    imul eax,APPT_SIZE
    add esi,eax
    ret
GetAppointment ENDP

; ------------------------------------------------------------
; Return EAX = index for an ID.
; EAX = ID on entry.
; EAX = -1 if not found.
; ------------------------------------------------------------
FindAppointment PROC
    push ebx
    push ecx
    push edx

    mov ebx,eax
    xor ecx,ecx

faLoop:
    cmp ecx,appointmentCount
    jae faNotFound

    mov eax,ecx
    call GetAppointment
    mov edx,[esi]
    cmp edx,ebx
    je faFound

    inc ecx
    jmp faLoop

faFound:
    mov eax,ecx
    jmp faExit

faNotFound:
    mov eax,-1

faExit:
    pop edx
    pop ecx
    pop ebx
    ret
FindAppointment ENDP

; ------------------------------------------------------------
; EAX = status. Returns EDX = status text.
; ------------------------------------------------------------
GetStatusText PROC
    cmp eax,STATUS_PENDING
    je gsPending
    cmp eax,STATUS_ACCEPTED
    je gsAccepted
    cmp eax,STATUS_CANCELLED
    je gsCancelled
    cmp eax,STATUS_MOVED
    je gsMoved
    mov edx,OFFSET statusDone
    ret
gsPending:
    mov edx,OFFSET statusPending
    ret
gsAccepted:
    mov edx,OFFSET statusAccepted
    ret
gsCancelled:
    mov edx,OFFSET statusCancelled
    ret
gsMoved:
    mov edx,OFFSET statusMoved
    ret
GetStatusText ENDP

; ------------------------------------------------------------
; Show one appointment.
; EAX = index.
; ------------------------------------------------------------
ShowAppointment PROC
    push ebx
    mov ebx,eax

    mov edx,OFFSET selectedTitle
    invoke printf,edx

    mov eax,ebx
    call GetAppointment

    push esi

    mov eax,[esi]
    invoke printf,OFFSET idLabel,eax

    pop esi
    lea edx,[esi+8]
    invoke printf,OFFSET nameLabel,edx
    lea edx,[esi+40]
    invoke printf,OFFSET dateLabel,edx
    lea edx,[esi+56]
    invoke printf,OFFSET timeLabel,edx
    lea edx,[esi+88]
    invoke printf,OFFSET purposeLabel,edx

    mov eax,[esi+4]
    call GetStatusText
    invoke printf,OFFSET statusLabel,edx

    pop ebx
    ret
ShowAppointment ENDP

; ------------------------------------------------------------
; Clear input fields.
; ------------------------------------------------------------
ClearInput PROC
    pushad

    mov edi,OFFSET nameBuffer
    mov ecx,NAME_SIZE
    call ClearBuffer

    mov edi,OFFSET dateBuffer
    mov ecx,DATE_SIZE
    call ClearBuffer

    mov edi,OFFSET timeBuffer
    mov ecx,TIME_SIZE
    call ClearBuffer

    mov edi,OFFSET purposeBuffer
    mov ecx,PURPOSE_SIZE
    call ClearBuffer

    invoke printf,OFFSET clearMsg

    popad
    ret
ClearInput ENDP

; ------------------------------------------------------------
; Submit a student appointment.
; ------------------------------------------------------------
SubmitAppointment PROC
    pushad

    cmp appointmentCount,MAX_APPOINTMENTS
    jb submitSpace

    invoke printf,OFFSET fullMsg
    jmp submitExit

submitSpace:
    ; Read student information.
    invoke printf,OFFSET namePrompt
    invoke gets_s,ADDR nameBuffer,NAME_SIZE

    invoke printf,OFFSET datePrompt
    invoke gets_s,ADDR dateBuffer,DATE_SIZE

    invoke printf,OFFSET timePrompt
    invoke gets_s,ADDR timeBuffer,TIME_SIZE

    invoke printf,OFFSET purposePrompt
    invoke gets_s,ADDR purposeBuffer,PURPOSE_SIZE

    ; Get new appointment address.
    mov eax,appointmentCount
    call GetAppointment

    ; Clear record.
    push esi
    mov edi,esi
    mov ecx,APPT_SIZE
    call ClearBuffer
    pop esi

    ; ID and Pending status.
    mov eax,nextID
    mov [esi],eax
    mov dword ptr [esi+4],STATUS_PENDING

    ; Copy fields.
    lea edi,[esi+8]
    invoke strcpy_s,edi,NAME_SIZE,ADDR nameBuffer
    lea edi,[esi+40]
    invoke strcpy_s,edi,DATE_SIZE,ADDR dateBuffer
    lea edi,[esi+56]
    invoke strcpy_s,edi,TIME_SIZE,ADDR timeBuffer
    lea edi,[esi+88]
    invoke strcpy_s,edi,PURPOSE_SIZE,ADDR purposeBuffer

    invoke printf,OFFSET submittedMsg,nextID

    inc nextID
    inc appointmentCount
    call ClearInput

submitExit:
    popad
    ret
SubmitAppointment ENDP

; ------------------------------------------------------------
; Dean login. Password = dean123
; ------------------------------------------------------------
DeanLogin PROC
    invoke printf,OFFSET passwordPrompt
    invoke gets_s,ADDR passwordBuffer,32

    invoke strcmp,ADDR passwordBuffer,ADDR deanPassword
    test eax,eax
    jne loginFailed

    mov deanLoggedIn,1
    invoke printf,OFFSET loginOK
    ret

loginFailed:
    invoke printf,OFFSET loginBad
    ret
DeanLogin ENDP

; ------------------------------------------------------------
; Dean logout.
; ------------------------------------------------------------
DeanLogout PROC
    mov deanLoggedIn,0
    invoke printf,OFFSET logoutMsg
    ret
DeanLogout ENDP

; ------------------------------------------------------------
; Change status.
; EAX = new status.
; ------------------------------------------------------------
ChangeStatus PROC
    push ebx
    mov ebx,eax

    cmp deanLoggedIn,1
    je csLoggedIn
    invoke printf,OFFSET needLogin
    jmp csExit

csLoggedIn:
    invoke printf,OFFSET idPrompt
    invoke gets_s,ADDR inputBuffer,128
    invoke atoi,ADDR inputBuffer

    call FindAppointment
    cmp eax,-1
    je csNotFound

    call GetAppointment
    mov [esi+4],ebx

    cmp ebx,STATUS_ACCEPTED
    je csAccepted
    cmp ebx,STATUS_CANCELLED
    je csCancelled
    invoke printf,OFFSET doneMsg
    jmp csExit

csAccepted:
    invoke printf,OFFSET acceptedMsg
    jmp csExit

csCancelled:
    invoke printf,OFFSET cancelledMsg
    jmp csExit

csNotFound:
    invoke printf,OFFSET notFound

csExit:
    pop ebx
    ret
ChangeStatus ENDP

; ------------------------------------------------------------
; Move an appointment to a new date/time.
; ------------------------------------------------------------
MoveAppointment PROC
    pushad

    cmp deanLoggedIn,1
    je moveLoggedIn
    invoke printf,OFFSET needLogin
    jmp moveExit

moveLoggedIn:
    invoke printf,OFFSET idPrompt
    invoke gets_s,ADDR inputBuffer,128
    invoke atoi,ADDR inputBuffer
    call FindAppointment
    cmp eax,-1
    je moveNotFound

    mov ebx,eax

    mov eax,ebx
    call GetAppointment
    invoke printf,OFFSET newDatePrompt
    invoke gets_s,ADDR dateBuffer,DATE_SIZE
    lea edi,[esi+40]
    invoke strcpy_s,edi,DATE_SIZE,ADDR dateBuffer

    mov eax,ebx
    call GetAppointment
    invoke printf,OFFSET newTimePrompt
    invoke gets_s,ADDR timeBuffer,TIME_SIZE
    lea edi,[esi+56]
    invoke strcpy_s,edi,TIME_SIZE,ADDR timeBuffer

    mov eax,ebx
    call GetAppointment
    mov dword ptr [esi+4],STATUS_MOVED

    invoke printf,OFFSET movedMsg
    jmp moveExit

moveNotFound:
    invoke printf,OFFSET notFound

moveExit:
    popad
    ret
MoveAppointment ENDP

; ------------------------------------------------------------
; Show the whole queue in FCFS order.
; ------------------------------------------------------------
ShowQueue PROC
    pushad

    invoke printf,OFFSET queueTitle

    cmp appointmentCount,0
    jne queueHasData
    invoke printf,OFFSET emptyMsg
    jmp queueExit

queueHasData:
    xor ebx,ebx

queueLoop:
    cmp ebx,appointmentCount
    jae queueDone

    mov eax,ebx
    call GetAppointment

    mov eax,[esi+4]
    call GetStatusText
    push edx                    ; status
    lea edx,[esi+56]
    push edx                    ; time
    lea edx,[esi+40]
    push edx                    ; date
    lea edx,[esi+8]
    push edx                    ; name
    mov eax,[esi]
    push eax                    ; id
    push OFFSET queueFormat
    call printf
    add esp,24

    inc ebx
    jmp queueLoop

queueDone:
    invoke printf,OFFSET fcfsMsg

queueExit:
    popad
    ret
ShowQueue ENDP

; ------------------------------------------------------------
; Ask the student for a name and show matching appointments.
; ------------------------------------------------------------
CheckMyStatus PROC
    pushad

    invoke printf,OFFSET namePrompt
    invoke gets_s,ADDR inputBuffer,128

    xor ebx,ebx
    xor ecx,ecx

checkLoop:
    cmp ecx,appointmentCount
    jae checkDone

    mov eax,ecx
    call GetAppointment

    lea edx,[esi+8]
    invoke strcmp,ADDR inputBuffer,edx
    cmp eax,0
    jne checkNext

    mov eax,ecx
    call ShowAppointment
    inc ebx

checkNext:
    inc ecx
    jmp checkLoop

checkDone:
    cmp ebx,0
    jne checkExit
    invoke printf,OFFSET notFound

checkExit:
    popad
    ret
CheckMyStatus ENDP

; ------------------------------------------------------------
; Show selected appointment.
; If none is selected, ask for an ID and select it.
; ------------------------------------------------------------
ShowSelected PROC
    mov eax,selectedIndex
    cmp eax,-1
    jne showExisting

    invoke printf,OFFSET idPrompt
    invoke gets_s,ADDR inputBuffer,128
    invoke atoi,ADDR inputBuffer
    call FindAppointment
    cmp eax,-1
    je showNotFound

    mov selectedIndex,eax

showExisting:
    mov eax,selectedIndex
    call ShowAppointment
    ret

showNotFound:
    invoke printf,OFFSET notFound
    ret
ShowSelected ENDP

; ------------------------------------------------------------
; Main program.
; ------------------------------------------------------------
main PROC
    invoke printf,OFFSET appTitle

mainLoop:
    invoke printf,OFFSET menu
    invoke gets_s,ADDR inputBuffer,128
    invoke atoi,ADDR inputBuffer

    cmp eax,0
    je exitProgram
    cmp eax,1
    je option1
    cmp eax,2
    je option2
    cmp eax,3
    je option3
    cmp eax,4
    je option4
    cmp eax,5
    je option5
    cmp eax,6
    je option6
    cmp eax,7
    je option7
    cmp eax,8
    je option8
    cmp eax,9
    je option9
    cmp eax,10
    je option10
    cmp eax,11
    je option11

    invoke printf,OFFSET invalidMsg
    jmp mainLoop

option1:
    call SubmitAppointment
    jmp mainLoop

option2:
    call ClearInput
    jmp mainLoop

option3:
    call DeanLogin
    jmp mainLoop

option4:
    call DeanLogout
    jmp mainLoop

option5:
    mov eax,STATUS_ACCEPTED
    call ChangeStatus
    jmp mainLoop

option6:
    mov eax,STATUS_CANCELLED
    call ChangeStatus
    jmp mainLoop

option7:
    call MoveAppointment
    jmp mainLoop

option8:
    mov eax,STATUS_DONE
    call ChangeStatus
    jmp mainLoop

option9:
    call CheckMyStatus
    jmp mainLoop

option10:
    call ShowQueue
    jmp mainLoop

option11:
    call ShowSelected
    jmp mainLoop

exitProgram:
    invoke ExitProcess,0
main ENDP

END main
