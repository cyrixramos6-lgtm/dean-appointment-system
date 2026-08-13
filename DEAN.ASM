.386
.model flat, stdcall
option casemap:none

includelib kernel32.lib
includelib user32.lib
includelib gdi32.lib


ExitProcess         PROTO :DWORD
GetModuleHandleA    PROTO :DWORD
RegisterClassExA    PROTO :DWORD
CreateWindowExA     PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ShowWindow          PROTO :DWORD,:DWORD
UpdateWindow        PROTO :DWORD
GetMessageA         PROTO :DWORD,:DWORD,:DWORD,:DWORD
TranslateMessage    PROTO :DWORD
DispatchMessageA    PROTO :DWORD
DefWindowProcA      PROTO :DWORD,:DWORD,:DWORD,:DWORD
PostQuitMessage     PROTO :DWORD
SendMessageA        PROTO :DWORD,:DWORD,:DWORD,:DWORD
GetWindowTextA      PROTO :DWORD,:DWORD,:DWORD
SetWindowTextA      PROTO :DWORD,:DWORD
MessageBoxA         PROTO :DWORD,:DWORD,:DWORD,:DWORD

CS_HREDRAW          EQU 0002h
CS_VREDRAW          EQU 0001h

WS_OVERLAPPED       EQU 00000000h
WS_CAPTION          EQU 00C00000h
WS_SYSMENU          EQU 00080000h
WS_MINIMIZEBOX      EQU 00020000h
WS_VISIBLE          EQU 10000000h
WS_CHILD            EQU 40000000h
WS_BORDER           EQU 00800000h
WS_TABSTOP          EQU 00010000h
WS_EX_CLIENTEDGE    EQU 00000200h

LBS_STANDARD        EQU 00a00003h
WS_VSCROLL          EQU 00200000h

LB_ADDSTRING        EQU 0180h
LB_INSERTSTRING     EQU 0181h
LB_DELETESTRING     EQU 0182h
LB_SETCURSEL        EQU 0186h
LB_GETCURSEL        EQU 0188h
LB_GETTEXT          EQU 0189h
LB_GETCOUNT         EQU 018Bh

MB_YESNO            EQU 4
MB_YESNOCANCEL      EQU 3
IDYES               EQU 6
IDNO                EQU 7
IDCANCEL            EQU 2

WS_OVERLAPPEDWINDOW EQU 00CF0000h
CW_USEDEFAULT       EQU 80000000h

SW_SHOW             EQU 5
WM_DESTROY          EQU 0002h
WM_COMMAND          EQU 0111h

ID_BTN_SCHEDULE     EQU 101
ID_BTN_VIEW         EQU 102
ID_BTN_SEARCH       EQU 103
ID_BTN_CANCEL       EQU 104
ID_LIST_APPOINMENTS EQU 105

COLOR_WINDOW        EQU 5


WNDCLASSEX STRUCT
    cbSize          DWORD ?
    style           DWORD ?
    lpfnWndProc     DWORD ?
    cbClsExtra      DWORD ?
    cbWndExtra      DWORD ?
    hInstance       DWORD ?
    hIcon           DWORD ?
    hCursor         DWORD ?
    hbrBackground   DWORD ?
    lpszMenuName    DWORD ?
    lpszClassName   DWORD ?
    hIconSm         DWORD ?
WNDCLASSEX ENDS

MSG STRUCT
    hwnd            DWORD ?
    message         DWORD ?
    wParam          DWORD ?
    lParam          DWORD ?
    time            DWORD ?
    pt_x            DWORD ?
    pt_y            DWORD ?
MSG ENDS

.data

; Window class and control strings
className           BYTE "DeanAppointmentWindow",0
windowTitle         BYTE "Dean Appointment Management System",0
staticClass         BYTE "STATIC",0
editClass           BYTE "EDIT",0
buttonClass         BYTE "BUTTON",0
listBoxClass        BYTE "LISTBOX",0

; Labels and UI text
lblTitleText        BYTE "DEAN APPOINTMENT MANAGEMENT SYSTEM",0
lblStudentText      BYTE "Student Name / ID:",0
lblDateText         BYTE "Appointment Date:",0
lblTimeText         BYTE "Appointment Time:",0
lblPurposeText      BYTE "Purpose to Talk:",0

btnScheduleText     BYTE "Schedule",0
btnViewText         BYTE "Manage / Cancel",0
btnSearchText       BYTE "Search Record",0
btnCancelText       BYTE "Clear Fields",0

; Dialog and message box prompts
msgBoxTitle         BYTE "Dean Appointment System",0
msgScheduled        BYTE "Appointment successfully scheduled and filed!",0
msgClearedFields    BYTE "Input form fields cleared.",0
msgSelectError      BYTE "Please enter a student name or ID to schedule.",0
msgNotFound         BYTE "No matching appointment record found.",0
msgSelectOne        BYTE "Please select an appointment from the list box first.",0
msgFound            BYTE "Record found! Displaying details...",0
msgCancelledDone    BYTE "Appointment has been cancelled and removed.",0
promptSuffix        BYTE 13,10,13,10,"[Options: Yes=Cancel Record | No=Reschedule/Edit | Cancel=Back]",0
msgReschedInfo      BYTE "Record loaded back into input form. Modify details and click 'Schedule' to update.",0

; Application Handles & Control IDs
hInstance           DWORD ?
hHwnd               DWORD ?
hEditStudent        DWORD ?
hEditDate           DWORD ?
hEditTime           DWORD ?
hEditPurpose        DWORD ?
hListBox            DWORD ?

; Working buffers
studentBuf          BYTE 128 DUP(0)
dateBuf             BYTE 64 DUP(0)
timeBuf             BYTE 64 DUP(0)
purposeBuf          BYTE 128 DUP(0)
displayBuf          BYTE 512 DUP(0)
existingBuf         BYTE 512 DUP(0)
dialogBuf           BYTE 700 DUP(0)

wc                  WNDCLASSEX <>
msg                 MSG <>

.code


WndProc PROC hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    LOCAL id:DWORD
    LOCAL code:DWORD

    mov eax, uMsg
    cmp eax, WM_DESTROY
    je WindowDestroy
    cmp eax, WM_COMMAND
    je WindowCommand

    INVOKE DefWindowProcA, hWnd, uMsg, wParam, lParam
    ret

WindowCommand:
    mov eax, wParam
    movzx edx, ax
    mov id, edx
    shr eax, 16
    movzx edx, ax
    mov code, edx

    mov eax, id
    cmp eax, ID_BTN_SCHEDULE
    je DoSchedule
    cmp eax, ID_BTN_VIEW
    je DoView
    cmp eax, ID_BTN_SEARCH
    je DoSearch
    cmp eax, ID_BTN_CANCEL
    je DoCancel
    jmp RetDefault

DoSchedule:
    cmp hEditStudent, 0
    je RetDefault
    INVOKE GetWindowTextA, hEditStudent, ADDR studentBuf, 128
    cmp byte ptr [studentBuf], 0
    je EmptyName

    INVOKE GetWindowTextA, hEditDate, ADDR dateBuf, 64
    INVOKE GetWindowTextA, hEditTime, ADDR timeBuf, 64
    INVOKE GetWindowTextA, hEditPurpose, ADDR purposeBuf, 128

    ; Format neat table row: Name | Date | Time | Purpose
    lea edi, displayBuf
    lea esi, studentBuf
    call CopyString
    
    mov byte ptr [edi], ' '
    inc edi
    mov byte ptr [edi], '|'
    inc edi
    mov byte ptr [edi], ' '
    inc edi

    lea esi, dateBuf
    call CopyString

    mov byte ptr [edi], ' '
    inc edi
    mov byte ptr [edi], '|'
    inc edi
    mov byte ptr [edi], ' '
    inc edi

    lea esi, timeBuf
    call CopyString

    mov byte ptr [edi], ' '
    inc edi
    mov byte ptr [edi], '|'
    inc edi
    mov byte ptr [edi], ' '
    inc edi

    lea esi, purposeBuf
    call CopyString

    mov byte ptr [edi], 0

    cmp hListBox, 0
    je RetDefault
    INVOKE SendMessageA, hListBox, LB_ADDSTRING, 0, ADDR displayBuf
    INVOKE MessageBoxA, hWnd, ADDR msgScheduled, ADDR msgBoxTitle, 0
    jmp RetDefault

EmptyName:
    INVOKE MessageBoxA, hWnd, ADDR msgSelectError, ADDR msgBoxTitle, 0
    jmp RetDefault

DoView:
    cmp hListBox, 0
    je RetDefault
    INVOKE SendMessageA, hListBox, LB_GETCURSEL, 0, 0
    cmp eax, -1
    je NoSelection
    mov ebx, eax
    INVOKE SendMessageA, hListBox, LB_GETTEXT, ebx, ADDR existingBuf

    ; Build detailed popup showing student info, schedule, purpose, and action choices
    lea edi, dialogBuf
    lea esi, existingBuf
    call CopyString
    lea esi, promptSuffix
    call CopyString

    INVOKE MessageBoxA, hWnd, ADDR dialogBuf, ADDR msgBoxTitle, MB_YESNOCANCEL
    cmp eax, IDYES
    je ActionCancelAppointment
    cmp eax, IDNO
    je ActionRescheduleAppointment
    jmp RetDefault

ActionCancelAppointment:
    INVOKE SendMessageA, hListBox, LB_DELETESTRING, ebx, 0
    INVOKE MessageBoxA, hWnd, ADDR msgCancelledDone, ADDR msgBoxTitle, 0
    jmp RetDefault

ActionRescheduleAppointment:
    INVOKE SendMessageA, hListBox, LB_DELETESTRING, ebx, 0
    INVOKE SetWindowTextA, hEditStudent, ADDR existingBuf
    INVOKE MessageBoxA, hWnd, ADDR msgReschedInfo, ADDR msgBoxTitle, 0
    jmp RetDefault

NoSelection:
    INVOKE MessageBoxA, hWnd, ADDR msgSelectOne, ADDR msgBoxTitle, 0
    jmp RetDefault

DoSearch:
    cmp hListBox, 0
    je RetDefault
    INVOKE GetWindowTextA, hEditStudent, ADDR studentBuf, 128
    cmp byte ptr [studentBuf], 0
    je EmptyName
    
    INVOKE SendMessageA, hListBox, LB_GETCOUNT, 0, 0
    mov ecx, eax
    xor ebx, ebx

SearchLoop:
    cmp ebx, ecx
    jge NotFound
    INVOKE SendMessageA, hListBox, LB_GETTEXT, ebx, ADDR existingBuf
    
    lea esi, studentBuf
    lea edi, existingBuf
    call StrSearchAtStart
    cmp al, 1
    jne SearchNext

    ; Highlight/Select matched item in list box
    INVOKE SendMessageA, hListBox, LB_SETCURSEL, ebx, 0
    
    ; Pop up exact details for the dean to see immediately
    lea edi, dialogBuf
    lea esi, existingBuf
    call CopyString
    
    INVOKE MessageBoxA, hWnd, ADDR dialogBuf, ADDR msgFound, 0
    jmp RetDefault

SearchNext:
    inc ebx
    jmp SearchLoop

NotFound:
    INVOKE MessageBoxA, hWnd, ADDR msgNotFound, ADDR msgBoxTitle, 0
    jmp RetDefault

DoCancel:
    cmp hEditStudent, 0
    je RetDefault
    INVOKE SetWindowTextA, hEditStudent, 0
    INVOKE SetWindowTextA, hEditDate, 0
    INVOKE SetWindowTextA, hEditTime, 0
    INVOKE SetWindowTextA, hEditPurpose, 0
    INVOKE MessageBoxA, hWnd, ADDR msgClearedFields, ADDR msgBoxTitle, 0
    jmp RetDefault

RetDefault:
    xor eax, eax
    ret

WindowDestroy:
    INVOKE PostQuitMessage, 0
    xor eax, eax
    ret

WndProc ENDP


CopyString PROC
    push eax
CopyLoop:
    mov al, [esi]
    cmp al, 0
    je CopyDone
    mov [edi], al
    inc esi
    inc edi
    jmp CopyLoop
CopyDone:
    pop eax
    ret
CopyString ENDP

StrSearchAtStart PROC
    push ebx
SearchStringLoop:
    mov al, [esi]
    cmp al, 0
    je SearchEqual
    mov bl, [edi]
    cmp bl, 0
    je SearchNotEqual
    cmp bl, '|'
    je SearchNotEqual
    
    ; Case-insensitive text comparison
    mov dl, al
    cmp dl, 'A'
    jb S1
    cmp dl, 'Z'
    ja S1
    add dl, 20h
S1:
    mov dh, bl
    cmp dh, 'A'
    jb S2
    cmp dh, 'Z'
    ja S2
    add dh, 20h
S2:
    cmp dl, dh
    jne SearchNotEqual
    inc esi
    inc edi
    jmp SearchStringLoop

SearchEqual:
    mov al, 1
    pop ebx
    ret

SearchNotEqual:
    xor al, al
    pop ebx
    ret
StrSearchAtStart ENDP

; ==================================================
; MAIN ENTRY POINT
; ==================================================
main PROC
    INVOKE GetModuleHandleA, 0
    mov hInstance, eax

    mov wc.cbSize, SIZEOF WNDCLASSEX
    mov wc.style, CS_HREDRAW OR CS_VREDRAW
    mov eax, OFFSET WndProc
    mov wc.lpfnWndProc, eax
    mov wc.cbClsExtra, 0
    mov wc.cbWndExtra, 0
    mov eax, hInstance
    mov wc.hInstance, eax
    mov wc.hIcon, 0
    mov wc.hCursor, 0
    mov wc.hbrBackground, COLOR_WINDOW + 1
    mov wc.lpszMenuName, 0
    mov eax, OFFSET className
    mov wc.lpszClassName, eax
    mov wc.hIconSm, 0

    INVOKE RegisterClassExA, ADDR wc

    INVOKE CreateWindowExA, \
        0, \
        ADDR className, \
        ADDR windowTitle, \
        WS_OVERLAPPEDWINDOW OR WS_VISIBLE, \
        CW_USEDEFAULT, \
        CW_USEDEFAULT, \
        800, \
        650, \
        0, \
        0, \
        hInstance, \
        0
    mov hHwnd, eax

    ; Create Title Header Banner
    INVOKE CreateWindowExA, 0, ADDR staticClass, ADDR lblTitleText, \
        WS_CHILD OR WS_VISIBLE, 180, 20, 440, 25, hHwnd, 0, hInstance, 0

    ; Student Name / ID Field
    INVOKE CreateWindowExA, 0, ADDR staticClass, ADDR lblStudentText, \
        WS_CHILD OR WS_VISIBLE, 50, 65, 150, 25, hHwnd, 0, hInstance, 0
    INVOKE CreateWindowExA, WS_EX_CLIENTEDGE, ADDR editClass, 0, \
        WS_CHILD OR WS_VISIBLE OR WS_TABSTOP, 200, 63, 520, 25, hHwnd, 0, hInstance, 0
    mov hEditStudent, eax

    ; Appointment Date Field
    INVOKE CreateWindowExA, 0, ADDR staticClass, ADDR lblDateText, \
        WS_CHILD OR WS_VISIBLE, 50, 105, 150, 25, hHwnd, 0, hInstance, 0
    INVOKE CreateWindowExA, WS_EX_CLIENTEDGE, ADDR editClass, 0, \
        WS_CHILD OR WS_VISIBLE OR WS_TABSTOP, 200, 103, 520, 25, hHwnd, 0, hInstance, 0
    mov hEditDate, eax

    ; Appointment Time Field
    INVOKE CreateWindowExA, 0, ADDR staticClass, ADDR lblTimeText, \
        WS_CHILD OR WS_VISIBLE, 50, 145, 150, 25, hHwnd, 0, hInstance, 0
    INVOKE CreateWindowExA, WS_EX_CLIENTEDGE, ADDR editClass, 0, \
        WS_CHILD OR WS_VISIBLE OR WS_TABSTOP, 200, 143, 520, 25, hHwnd, 0, hInstance, 0
    mov hEditTime, eax

    ; Purpose to Talk Field
    INVOKE CreateWindowExA, 0, ADDR staticClass, ADDR lblPurposeText, \
        WS_CHILD OR WS_VISIBLE, 50, 185, 150, 25, hHwnd, 0, hInstance, 0
    INVOKE CreateWindowExA, WS_EX_CLIENTEDGE, ADDR editClass, 0, \
        WS_CHILD OR WS_VISIBLE OR WS_TABSTOP, 200, 183, 520, 25, hHwnd, 0, hInstance, 0
    mov hEditPurpose, eax

    ; Action Control Buttons
    INVOKE CreateWindowExA, 0, ADDR buttonClass, ADDR btnScheduleText, \
        WS_CHILD OR WS_VISIBLE OR WS_TABSTOP, 180, 235, 100, 35, hHwnd, ID_BTN_SCHEDULE, hInstance, 0
    INVOKE CreateWindowExA, 0, ADDR buttonClass, ADDR btnViewText, \
        WS_CHILD OR WS_VISIBLE OR WS_TABSTOP, 295, 235, 100, 35, hHwnd, ID_BTN_VIEW, hInstance, 0
    INVOKE CreateWindowExA, 0, ADDR buttonClass, ADDR btnSearchText, \
        WS_CHILD OR WS_VISIBLE OR WS_TABSTOP, 410, 235, 100, 35, hHwnd, ID_BTN_SEARCH, hInstance, 0
    INVOKE CreateWindowExA, 0, ADDR buttonClass, ADDR btnCancelText, \
        WS_CHILD OR WS_VISIBLE OR WS_TABSTOP, 525, 235, 100, 35, hHwnd, ID_BTN_CANCEL, hInstance, 0

    ; Main Scrollable List Box View Box
    INVOKE CreateWindowExA, WS_EX_CLIENTEDGE, ADDR listBoxClass, 0, \
        WS_CHILD OR WS_VISIBLE OR LBS_STANDARD OR WS_VSCROLL, 50, 290, 670, 270, hHwnd, ID_LIST_APPOINMENTS, hInstance, 0
    mov hListBox, eax

    INVOKE ShowWindow, hHwnd, SW_SHOW
    INVOKE UpdateWindow, hHwnd

MessageLoop:
    INVOKE GetMessageA, ADDR msg, 0, 0, 0
    cmp eax, 0
    je ProgramExit
    INVOKE TranslateMessage, ADDR msg
    INVOKE DispatchMessageA, ADDR msg
    jmp MessageLoop

ProgramExit:
    INVOKE ExitProcess, 0

main ENDP

END main