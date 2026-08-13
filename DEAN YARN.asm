; ============================================================
; DEAN APPOINTMENT SYSTEM
; Professional Win32 GUI - MASM x86 / Visual Studio
;
; FLOW:
;   BOOK -> FCFS LIST -> VIEW DETAILS -> SEARCH
;        -> CANCEL/REMOVE -> AUTO REFRESH -> EXIT
;
; FEATURES:
;   * Dean appointment only
;   * Maximum 10 appointments
;   * First-Come, First-Served (FCFS)
;   * Unique Appointment ID
;   * View all appointments
;   * View selected student details
;   * Search by Appointment ID
;   * Cancel physically removes the record
;   * Remaining records shift automatically
;   * FCFS list refreshes immediately after cancellation
;   * In-memory storage (data resets when program closes)
; ============================================================

.386
.model flat, stdcall
option casemap:none

includelib kernel32.lib
includelib user32.lib


GetModuleHandleA   PROTO STDCALL :DWORD
ExitProcess        PROTO STDCALL :DWORD
RegisterClassA     PROTO STDCALL :DWORD
LoadCursorA        PROTO STDCALL :DWORD,:DWORD
CreateWindowExA    PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateFontA         PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ShowWindow         PROTO STDCALL :DWORD,:DWORD
UpdateWindow       PROTO STDCALL :DWORD
GetMessageA        PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
TranslateMessage   PROTO STDCALL :DWORD
DispatchMessageA   PROTO STDCALL :DWORD
DefWindowProcA     PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
PostQuitMessage    PROTO STDCALL :DWORD
DestroyWindow      PROTO STDCALL :DWORD
GetWindowTextA     PROTO STDCALL :DWORD,:DWORD,:DWORD
SetWindowTextA     PROTO STDCALL :DWORD,:DWORD
MessageBoxA        PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
SendMessageA       PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
CreateSolidBrush   PROTO STDCALL :DWORD
SetTextColor       PROTO STDCALL :DWORD,:DWORD
SetBkColor         PROTO STDCALL :DWORD,:DWORD
lstrlenA           PROTO STDCALL :DWORD
lstrcpyA           PROTO STDCALL :DWORD,:DWORD
lstrcatA           PROTO STDCALL :DWORD,:DWORD
lstrcpynA          PROTO STDCALL :DWORD,:DWORD,:DWORD

NULL                    equ 0
TRUE                    equ 1

WS_OVERLAPPEDWINDOW      equ 00CF0000h
WS_CHILD                 equ 40000000h
WS_VISIBLE               equ 10000000h
WS_VSCROLL               equ 00200000h
WS_TABSTOP               equ 00010000h
WS_BORDER                equ 00800000h
WS_EX_CLIENTEDGE         equ 00000200h

ES_AUTOHSCROLL            equ 00000080h
ES_NUMBER                 equ 00002000h
BS_PUSHBUTTON             equ 00000000h
BS_DEFPUSHBUTTON         equ 00000001h
BS_GROUPBOX              equ 00000007h
LBS_NOTIFY                equ 00000001h

SW_SHOW                   equ 5

WM_CREATE                 equ 0001h
WM_DESTROY                equ 0002h
WM_CLOSE                  equ 0010h
WM_COMMAND               equ 0111h
WM_SETFONT                equ 0030h
WM_CTLCOLORSTATIC         equ 0138h

LB_ADDSTRING              equ 0180h
LB_RESETCONTENT           equ 0184h
LB_GETCURSEL              equ 0188h

MB_OK                     equ 00000000h
MB_ICONINFORMATION        equ 00000040h
MB_ICONWARNING            equ 00000030h

CS_HREDRAW                equ 0002h
CS_VREDRAW                equ 0001h
COLOR_WINDOW              equ 5
IDC_ARROW                 equ 32512

MAX_RECORDS               equ 10
NAME_LEN                  equ 30
PURPOSE_LEN               equ 60
DATE_LEN                  equ 10
TIME_LEN                  equ 5

; Edit controls
ID_NAME                   equ 1001
ID_DATE                   equ 1002
ID_TIME                   equ 1003
ID_PURPOSE                equ 1004
ID_APPTID                 equ 1005

; Buttons
ID_BOOK                   equ 2001
ID_VIEW                   equ 2002
ID_DETAILS                equ 2003
ID_SEARCH                 equ 2004
ID_CANCEL                 equ 2005
ID_EXIT                   equ 2006
ID_CLEAR                  equ 2007

; Display controls
ID_LIST                   equ 3001
ID_STATUS                 equ 3002
ID_DETAILSBOX             equ 3003

WNDCLASS STRUCT
    style           dd ?
    lpfnWndProc     dd ?
    cbClsExtra      dd ?
    cbWndExtra      dd ?
    hInstance       dd ?
    hIcon           dd ?
    hCursor         dd ?
    hbrBackground   dd ?
    lpszMenuName    dd ?
    lpszClassName   dd ?
WNDCLASS ENDS

MSG STRUCT
    hwnd            dd ?
    message         dd ?
    wParam          dd ?
    lParam          dd ?
    time            dd ?
    ptX             dd ?
    ptY             dd ?
MSG ENDS

WndProc             PROTO :DWORD,:DWORD,:DWORD,:DWORD
RefreshList         PROTO
BookAppointment     PROTO
ViewSelected        PROTO
SearchAppointment   PROTO
CancelAppointment   PROTO
ShowRecord          PROTO :DWORD
BuildListItem       PROTO :DWORD
CopyRecord          PROTO :DWORD,:DWORD
ClearRecord         PROTO :DWORD
ParseID             PROTO
NumberToText        PROTO :DWORD,:DWORD

.data

className       db "DeanAppointmentSystem",0
windowTitle     db "Dean Appointment System - College of Engineering & Architecture",0

clsStatic       db "STATIC",0
clsEdit         db "EDIT",0
clsButton       db "BUTTON",0
clsListBox      db "LISTBOX",0

txtHeader       db "DEAN APPOINTMENT SYSTEM",0
fontFace        db "Segoe UI",0
txtSubHeader    db "College of Engineering & Architecture",0
txtBookSection  db "STUDENT / APPOINTMENT INFORMATION",0
txtListSection  db "APPOINTMENT LIST (FCFS ORDER)",0
txtSearchSec    db "SEARCH APPOINTMENT",0
txtCancelSec    db "CANCEL APPOINTMENT",0
txtDetailsSec   db "APPOINTMENT DETAILS",0
txtInputGroup   db "BOOK AN APPOINTMENT",0
txtQueueGroup   db "FCFS APPOINTMENT QUEUE",0
txtActionGroup  db "SYSTEM ACTIONS",0
txtStatusGroup  db "SYSTEM STATUS",0

txtName         db "Student Name:",0
txtDate         db "Appointment Date:",0
txtTime         db "Appointment Time:",0
txtPurpose      db "Purpose / Concern:",0
txtID           db "ID (Search / Cancel):",0

txtBook         db "BOOK APPOINTMENT",0
txtView         db "VIEW ALL",0
txtDetails      db "VIEW SELECTED",0
txtSearch       db "SEARCH",0
txtCancel       db "CANCEL / REMOVE",0
txtExit         db "EXIT",0
txtClear        db "CLEAR",0
txtSearchBtn    db "SEARCH",0

msgBooked       db "Appointment booked successfully.",0
msgFull         db "The appointment queue is full. Maximum is 10.",0
msgInvalid      db "Please complete all fields. Date: MM/DD/YY or MM/DD/YYYY. Time: H:MM or HH:MM.",0
msgNotFound     db "Appointment ID not found.",0
msgCancelled    db "Appointment removed successfully.",0
msgNoRecords    db "No appointments available.",0
msgSelect       db "Please select an appointment from the FCFS list first.",0
msgExit         db "Thank you. Dean Appointment System closed.",0

statusReady     db "System ready. Appointments are served in FCFS order.",0
statusBooked   db "New appointment added to the end of the FCFS queue.",0
statusRemoved  db "Appointment removed. FCFS list updated automatically.",0

prefixID        db "ID: ",0
prefixName      db " | Student: ",0
prefixDate      db " | Date: ",0
prefixTime      db " | Time: ",0
prefixPurpose   db " | Purpose: ",0

detailID        db "Appointment ID: ",0
detailName      db "Student Name: ",0
detailDate      db "Appointment Date: ",0
detailTime      db "Appointment Time: ",0
detailPurpose   db "Purpose / Concern: ",0
detailQueue     db "FCFS Queue Position: ",0

newline         db 13,10,0
sep             db "----------------------------------------",0

inputName       db 64 dup(0)
inputDate       db 16 dup(0)
inputTime       db 16 dup(0)
inputPurpose    db 128 dup(0)
inputID         db 16 dup(0)

numBuf          db 16 dup(0)
listBuf         db 256 dup(0)
detailsBuf      db 512 dup(0)

; Appointment storage
names           db MAX_RECORDS*(NAME_LEN+1) dup(0)
dates           db MAX_RECORDS*(DATE_LEN+1) dup(0)
times           db MAX_RECORDS*(TIME_LEN+1) dup(0)
purposes        db MAX_RECORDS*(PURPOSE_LEN+1) dup(0)
ids             db MAX_RECORDS dup(0)

recCount        dd 0
nextID          dd 1

hInstance       dd 0
hMainWnd        dd 0
hEditName       dd 0
hEditDate       dd 0
hEditTime       dd 0
hEditPurpose    dd 0
hEditID         dd 0
hList           dd 0
hStatus         dd 0
hDetailsBox     dd 0
hFont           dd 0
hFontBold       dd 0
hHeader         dd 0
hHeaderBrush    dd 0
hStatusBrush    dd 0

wc              WNDCLASS <>
msg             MSG <>

.code

start:
    invoke GetModuleHandleA, NULL
    mov hInstance, eax

    ; Register window class
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, OFFSET WndProc
    mov wc.cbClsExtra, 0
    mov wc.cbWndExtra, 0
    mov eax, hInstance
    mov wc.hInstance, eax
    mov wc.hIcon, 0

    invoke LoadCursorA, NULL, IDC_ARROW
    mov wc.hCursor, eax

    mov wc.hbrBackground, COLOR_WINDOW+1
    mov wc.lpszMenuName, 0
    mov wc.lpszClassName, OFFSET className

    invoke RegisterClassA, ADDR wc

    invoke CreateWindowExA, 0, ADDR className, ADDR windowTitle, \
           WS_OVERLAPPEDWINDOW, 70, 30, 1180, 760, \
           NULL, NULL, hInstance, NULL

    mov hMainWnd, eax

    ; Clean Segoe UI fonts for a more professional interface.
    invoke CreateFontA, 18, 0, 0, 0, 700, 0, 0, 0, 1, 0, 0, 0, 0, ADDR fontFace
    mov hFontBold, eax

    invoke CreateFontA, 15, 0, 0, 0, 400, 0, 0, 0, 1, 0, 0, 0, 0, ADDR fontFace
    mov hFont, eax

    ; Header and status background brushes.
    invoke CreateSolidBrush, 002B3A55h
    mov hHeaderBrush, eax
    invoke CreateSolidBrush, 00EAF0F6h
    mov hStatusBrush, eax

    invoke ShowWindow, hMainWnd, SW_SHOW
    invoke UpdateWindow, hMainWnd

message_loop:
    invoke GetMessageA, ADDR msg, NULL, 0, 0
    cmp eax, 0
    je program_end

    invoke TranslateMessage, ADDR msg
    invoke DispatchMessageA, ADDR msg
    jmp message_loop

program_end:
    invoke ExitProcess, 0

WndProc PROC hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD

    cmp uMsg, WM_CREATE
    je window_create

    cmp uMsg, WM_CTLCOLORSTATIC
    je color_static

    cmp uMsg, WM_COMMAND
    je window_command

    cmp uMsg, WM_CLOSE
    je window_close

    cmp uMsg, WM_DESTROY
    je window_destroy

    invoke DefWindowProcA, hWnd, uMsg, wParam, lParam
    ret

window_create:

 
    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtHeader, \
           WS_CHILD or WS_VISIBLE or WS_BORDER or 00000001h, 30, 20, 1070, 48, \
           hWnd, 0, hInstance, NULL
    mov hHeader, eax
    invoke SendMessageA, eax, WM_SETFONT, hFontBold, TRUE

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtSubHeader, \
           WS_CHILD or WS_VISIBLE, 30, 68, 1070, 24, \
           hWnd, 0, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

  
    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtInputGroup, \
           WS_CHILD or WS_VISIBLE or BS_GROUPBOX, \
           30, 100, 430, 345, hWnd, 0, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFontBold, TRUE

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtName, \
           WS_CHILD or WS_VISIBLE, 50, 135, 120, 25, \
           hWnd, 0, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsEdit, NULL, \
           WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_AUTOHSCROLL, \
           175, 132, 255, 28, hWnd, ID_NAME, hInstance, NULL
    mov hEditName, eax
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtDate, \
           WS_CHILD or WS_VISIBLE, 50, 180, 120, 25, \
           hWnd, 0, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsEdit, NULL, \
           WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_AUTOHSCROLL, \
           175, 177, 150, 28, hWnd, ID_DATE, hInstance, NULL
    mov hEditDate, eax
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtTime, \
           WS_CHILD or WS_VISIBLE, 50, 225, 120, 25, \
           hWnd, 0, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsEdit, NULL, \
           WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_AUTOHSCROLL, \
           175, 222, 150, 28, hWnd, ID_TIME, hInstance, NULL
    mov hEditTime, eax
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtPurpose, \
           WS_CHILD or WS_VISIBLE, 50, 270, 120, 25, \
           hWnd, 0, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsEdit, NULL, \
           WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_AUTOHSCROLL, \
           175, 267, 255, 28, hWnd, ID_PURPOSE, hInstance, NULL
    mov hEditPurpose, eax
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    ; Appointment ID used by Search and Cancel.
    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtID, \
           WS_CHILD or WS_VISIBLE, 50, 320, 120, 25, \
           hWnd, 0, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsEdit, NULL, \
           WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_AUTOHSCROLL or ES_NUMBER, \
           175, 317, 100, 28, hWnd, ID_APPTID, hInstance, NULL
    mov hEditID, eax
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE


    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtQueueGroup, \
           WS_CHILD or WS_VISIBLE or BS_GROUPBOX, \
           480, 100, 620, 345, hWnd, 0, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFontBold, TRUE

    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsListBox, NULL, \
           WS_CHILD or WS_VISIBLE or WS_VSCROLL or WS_TABSTOP or LBS_NOTIFY, \
           500, 135, 580, 255, hWnd, ID_LIST, hInstance, NULL
    mov hList, eax
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR statusReady, \
           WS_CHILD or WS_VISIBLE, 500, 400, 580, 25, \
           hWnd, 0, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtActionGroup, \
           WS_CHILD or WS_VISIBLE or BS_GROUPBOX, \
           30, 460, 1070, 75, hWnd, 0, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFontBold, TRUE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtBook, \
           WS_CHILD or WS_VISIBLE or WS_TABSTOP or BS_DEFPUSHBUTTON, \
           45, 485, 170, 34, hWnd, ID_BOOK, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtClear, \
           WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
           225, 485, 100, 34, hWnd, ID_CLEAR, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtView, \
           WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
           335, 485, 145, 34, hWnd, ID_VIEW, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtDetails, \
           WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
           490, 485, 145, 34, hWnd, ID_DETAILS, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtSearchBtn, \
           WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
           645, 485, 120, 34, hWnd, ID_SEARCH, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtCancel, \
           WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
           775, 485, 175, 34, hWnd, ID_CANCEL, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtExit, \
           WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
           960, 485, 120, 34, hWnd, ID_EXIT, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    ; ========================================================
    ; BOTTOM: DETAILS + STATUS
    ; ========================================================
    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtDetailsSec, \
           WS_CHILD or WS_VISIBLE or BS_GROUPBOX, \
           30, 550, 700, 145, hWnd, 0, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFontBold, TRUE

    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsStatic, NULL, \
           WS_CHILD or WS_VISIBLE or WS_BORDER, \
           50, 585, 660, 90, hWnd, ID_DETAILSBOX, hInstance, NULL
    mov hDetailsBox, eax
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtStatusGroup, \
           WS_CHILD or WS_VISIBLE or BS_GROUPBOX, \
           750, 550, 350, 145, hWnd, 0, hInstance, NULL
    invoke SendMessageA, eax, WM_SETFONT, hFontBold, TRUE

    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsStatic, ADDR statusReady, \
           WS_CHILD or WS_VISIBLE or WS_BORDER, \
           770, 585, 310, 90, hWnd, ID_STATUS, hInstance, NULL
    mov hStatus, eax
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    call RefreshList
    ret

color_static:
    ; wParam = HDC, lParam = control HWND.
    mov eax, lParam
    cmp eax, hHeader
    je color_header

    mov eax, hStatus
    cmp lParam, eax
    je color_status

    invoke DefWindowProcA, hWnd, uMsg, wParam, lParam
    ret

color_header:
    invoke SetTextColor, wParam, 00FFFFFFh
    invoke SetBkColor, wParam, 002B3A55h
    mov eax, hHeaderBrush
    ret

color_status:
    invoke SetTextColor, wParam, 002B3A55h
    invoke SetBkColor, wParam, 00EAF0F6h
    mov eax, hStatusBrush
    ret

window_command:
    mov eax, wParam
    and eax, 0FFFFh

    ; Book
    cmp eax, ID_BOOK
    je cmd_book

    ; View all
    cmp eax, ID_VIEW
    je cmd_view

    ; View selected
    cmp eax, ID_DETAILS
    je cmd_details

    ; Search
    cmp eax, ID_SEARCH
    je cmd_search

    ; Cancel / remove
    cmp eax, ID_CANCEL
    je cmd_cancel

    ; Exit
    cmp eax, ID_EXIT
    je cmd_exit

    cmp eax, ID_CLEAR
    je cmd_clear

    ret

cmd_book:
    call BookAppointment
    ret

cmd_view:
    call RefreshList
    invoke SetWindowTextA, hStatus, ADDR statusReady
    ret

cmd_details:
    call ViewSelected
    ret

cmd_search:
    call SearchAppointment
    ret

cmd_cancel:
    call CancelAppointment
    ret

cmd_clear:
    invoke SetWindowTextA, hEditName, NULL
    invoke SetWindowTextA, hEditDate, NULL
    invoke SetWindowTextA, hEditTime, NULL
    invoke SetWindowTextA, hEditPurpose, NULL
    invoke SetWindowTextA, hEditID, NULL
    invoke SetWindowTextA, hDetailsBox, NULL
    invoke SetWindowTextA, hStatus, ADDR statusReady
    ret

cmd_exit:
    invoke DestroyWindow, hMainWnd
    ret

window_close:
    invoke DestroyWindow, hWnd
    ret

window_destroy:
    invoke PostQuitMessage, 0
    ret

WndProc ENDP

BookAppointment PROC
    mov eax, recCount
    cmp eax, MAX_RECORDS
    jb book_space_ok

    invoke MessageBoxA, hMainWnd, ADDR msgFull, ADDR txtHeader, \
           MB_OK or MB_ICONWARNING
    ret

book_space_ok:
    invoke GetWindowTextA, hEditName, ADDR inputName, 64
    invoke GetWindowTextA, hEditDate, ADDR inputDate, 16
    invoke GetWindowTextA, hEditTime, ADDR inputTime, 16
    invoke GetWindowTextA, hEditPurpose, ADDR inputPurpose, 128

    invoke lstrlenA, ADDR inputName
    cmp eax, 0
    je book_invalid

    ; Accept MM/DD/YY (8) or MM/DD/YYYY (10).
    invoke lstrlenA, ADDR inputDate
    cmp eax, 8
    jb book_invalid
    cmp eax, 10
    ja book_invalid

    ; Accept H:MM (4) or HH:MM (5).
    invoke lstrlenA, ADDR inputTime
    cmp eax, 4
    jb book_invalid
    cmp eax, 5
    ja book_invalid

    invoke lstrlenA, ADDR inputPurpose
    cmp eax, 0
    je book_invalid

    ; Store name
    mov eax, recCount
    mov ebx, NAME_LEN+1
    mul ebx
    mov edi, OFFSET names
    add edi, eax
    invoke lstrcpynA, edi, ADDR inputName, NAME_LEN+1

    ; Store date
    mov eax, recCount
    mov ebx, DATE_LEN+1
    mul ebx
    mov edi, OFFSET dates
    add edi, eax
    invoke lstrcpynA, edi, ADDR inputDate, DATE_LEN+1

    ; Store time
    mov eax, recCount
    mov ebx, TIME_LEN+1
    mul ebx
    mov edi, OFFSET times
    add edi, eax
    invoke lstrcpynA, edi, ADDR inputTime, TIME_LEN+1

    ; Store purpose
    mov eax, recCount
    mov ebx, PURPOSE_LEN+1
    mul ebx
    mov edi, OFFSET purposes
    add edi, eax
    invoke lstrcpynA, edi, ADDR inputPurpose, PURPOSE_LEN+1

    ; Store unique ID
    mov eax, recCount
    mov ebx, nextID
    mov [ids+eax], bl

    inc nextID
    inc recCount

    call RefreshList
    invoke SetWindowTextA, hStatus, ADDR statusBooked

    ; Clear booking fields
    invoke SetWindowTextA, hEditName, NULL
    invoke SetWindowTextA, hEditDate, NULL
    invoke SetWindowTextA, hEditTime, NULL
    invoke SetWindowTextA, hEditPurpose, NULL

    invoke MessageBoxA, hMainWnd, ADDR msgBooked, ADDR txtHeader, \
           MB_OK or MB_ICONINFORMATION
    ret

book_invalid:
    invoke MessageBoxA, hMainWnd, ADDR msgInvalid, ADDR txtHeader, \
           MB_OK or MB_ICONWARNING
    ret
BookAppointment ENDP

RefreshList PROC
    invoke SendMessageA, hList, LB_RESETCONTENT, 0, 0

    mov ecx, recCount
    cmp ecx, 0
    jne refresh_has_records

    invoke SendMessageA, hList, LB_ADDSTRING, 0, ADDR msgNoRecords
    ret

refresh_has_records:
    xor esi, esi

refresh_loop:
    push ecx
    push esi

    invoke BuildListItem, esi
    invoke SendMessageA, hList, LB_ADDSTRING, 0, ADDR listBuf

    pop esi
    pop ecx

    inc esi
    loop refresh_loop

    ret
RefreshList ENDP

BuildListItem PROC index:DWORD

    invoke lstrcpyA, ADDR listBuf, ADDR prefixID

    mov eax, index
    movzx eax, byte ptr [ids+eax]
    invoke NumberToText, eax, ADDR numBuf
    invoke lstrcatA, ADDR listBuf, ADDR numBuf

    invoke lstrcatA, ADDR listBuf, ADDR prefixName
    mov eax, index
    mov ebx, NAME_LEN+1
    mul ebx
    mov edx, OFFSET names
    add edx, eax
    invoke lstrcatA, ADDR listBuf, edx

    invoke lstrcatA, ADDR listBuf, ADDR prefixDate
    mov eax, index
    mov ebx, DATE_LEN+1
    mul ebx
    mov edx, OFFSET dates
    add edx, eax
    invoke lstrcatA, ADDR listBuf, edx

    invoke lstrcatA, ADDR listBuf, ADDR prefixTime
    mov eax, index
    mov ebx, TIME_LEN+1
    mul ebx
    mov edx, OFFSET times
    add edx, eax
    invoke lstrcatA, ADDR listBuf, edx

    invoke lstrcatA, ADDR listBuf, ADDR prefixPurpose
    mov eax, index
    mov ebx, PURPOSE_LEN+1
    mul ebx
    mov edx, OFFSET purposes
    add edx, eax
    invoke lstrcatA, ADDR listBuf, edx

    ret
BuildListItem ENDP

ViewSelected PROC
    invoke SendMessageA, hList, LB_GETCURSEL, 0, 0

    cmp eax, 0FFFFFFFFh
    je view_no_selection

    invoke ShowRecord, eax
    ret

view_no_selection:
    invoke SetWindowTextA, hStatus, ADDR msgSelect
    invoke MessageBoxA, hMainWnd, ADDR msgSelect, ADDR txtDetailsSec, \
           MB_OK or MB_ICONWARNING
    ret
ViewSelected ENDP

ShowRecord PROC index:DWORD

    invoke lstrcpyA, ADDR detailsBuf, ADDR detailID

    mov eax, index
    movzx eax, byte ptr [ids+eax]
    invoke NumberToText, eax, ADDR numBuf
    invoke lstrcatA, ADDR detailsBuf, ADDR numBuf
    invoke lstrcatA, ADDR detailsBuf, ADDR newline

    invoke lstrcatA, ADDR detailsBuf, ADDR detailName
    mov eax, index
    mov ebx, NAME_LEN+1
    mul ebx
    mov edx, OFFSET names
    add edx, eax
    invoke lstrcatA, ADDR detailsBuf, edx
    invoke lstrcatA, ADDR detailsBuf, ADDR newline

    invoke lstrcatA, ADDR detailsBuf, ADDR detailDate
    mov eax, index
    mov ebx, DATE_LEN+1
    mul ebx
    mov edx, OFFSET dates
    add edx, eax
    invoke lstrcatA, ADDR detailsBuf, edx
    invoke lstrcatA, ADDR detailsBuf, ADDR newline

    invoke lstrcatA, ADDR detailsBuf, ADDR detailTime
    mov eax, index
    mov ebx, TIME_LEN+1
    mul ebx
    mov edx, OFFSET times
    add edx, eax
    invoke lstrcatA, ADDR detailsBuf, edx
    invoke lstrcatA, ADDR detailsBuf, ADDR newline

    invoke lstrcatA, ADDR detailsBuf, ADDR detailPurpose
    mov eax, index
    mov ebx, PURPOSE_LEN+1
    mul ebx
    mov edx, OFFSET purposes
    add edx, eax
    invoke lstrcatA, ADDR detailsBuf, edx
    invoke lstrcatA, ADDR detailsBuf, ADDR newline

    invoke lstrcatA, ADDR detailsBuf, ADDR detailQueue
    mov eax, index
    inc eax
    invoke NumberToText, eax, ADDR numBuf
    invoke lstrcatA, ADDR detailsBuf, ADDR numBuf

    invoke SetWindowTextA, hDetailsBox, ADDR detailsBuf
    ret
ShowRecord ENDP


SearchAppointment PROC

    invoke GetWindowTextA, hEditID, ADDR inputID, 16
    call ParseID

    cmp eax, 0
    je search_not_found

    mov ebx, eax
    xor esi, esi
    mov ecx, recCount

search_loop:
    cmp ecx, 0
    je search_not_found

    mov eax, esi
    movzx eax, byte ptr [ids+eax]
    cmp eax, ebx
    je search_found

    inc esi
    dec ecx
    jmp search_loop

search_found:
    invoke ShowRecord, esi
    invoke SetWindowTextA, hStatus, ADDR statusReady
    ret

search_not_found:
    invoke SetWindowTextA, hStatus, ADDR msgNotFound
    invoke MessageBoxA, hMainWnd, ADDR msgNotFound, ADDR txtSearchSec, \
           MB_OK or MB_ICONWARNING
    ret
SearchAppointment ENDP

; ============================================================
; CANCEL / PHYSICALLY REMOVE APPOINTMENT
;
; Example:
;   ID 1 -> Juan
;   ID 2 -> Maria
;   ID 3 -> Pedro
;
; Cancel ID 2:
;   ID 1 -> Juan
;   ID 3 -> Pedro
;
; The Maria record is removed from the array.
; The remaining records shift left.
; The visible list is refreshed automatically.
; ============================================================
CancelAppointment PROC

    invoke GetWindowTextA, hEditID, ADDR inputID, 16
    call ParseID

    cmp eax, 0
    je cancel_not_found

    mov ebx, eax                  ; target ID
    xor esi, esi                  ; target index
    mov ecx, recCount

find_cancel:
    cmp ecx, 0
    je cancel_not_found

    mov eax, esi
    movzx eax, byte ptr [ids+eax]
    cmp eax, ebx
    je cancel_found

    inc esi
    dec ecx
    jmp find_cancel

cancel_found:
    ; If target is not the last record,
    ; copy every next record into the previous slot.
    mov eax, recCount
    dec eax
    cmp esi, eax
    jae cancel_decrement

    mov edi, esi
    inc edi

shift_loop:
    invoke CopyRecord, edi, esi

    inc esi
    inc edi

    mov eax, recCount
    dec eax
    cmp edi, eax
    jbe shift_loop

cancel_decrement:
    dec recCount

    ; Clear old final slot.
    mov eax, recCount
    invoke ClearRecord, eax

    ; Clear selected ID input.
    invoke SetWindowTextA, hEditID, NULL

    ; Clear details area.
    invoke SetWindowTextA, hDetailsBox, NULL

    ; IMPORTANT: immediately rebuild visible FCFS list.
    call RefreshList

    invoke SetWindowTextA, hStatus, ADDR statusRemoved
    invoke MessageBoxA, hMainWnd, ADDR msgCancelled, ADDR txtCancel, \
           MB_OK or MB_ICONINFORMATION
    ret

cancel_not_found:
    invoke SetWindowTextA, hStatus, ADDR msgNotFound
    invoke MessageBoxA, hMainWnd, ADDR msgNotFound, ADDR txtCancel, \
           MB_OK or MB_ICONWARNING
    ret
CancelAppointment ENDP

CopyRecord PROC sourceIndex:DWORD, destinationIndex:DWORD

    ; ID
    mov eax, sourceIndex
    mov dl, [ids+eax]
    mov eax, destinationIndex
    mov [ids+eax], dl

    ; NAME
    mov eax, sourceIndex
    mov ebx, NAME_LEN+1
    mul ebx
    mov esi, OFFSET names
    add esi, eax

    mov eax, destinationIndex
    mov ebx, NAME_LEN+1
    mul ebx
    mov edi, OFFSET names
    add edi, eax

    invoke lstrcpynA, edi, esi, NAME_LEN+1

    ; DATE
    mov eax, sourceIndex
    mov ebx, DATE_LEN+1
    mul ebx
    mov esi, OFFSET dates
    add esi, eax

    mov eax, destinationIndex
    mov ebx, DATE_LEN+1
    mul ebx
    mov edi, OFFSET dates
    add edi, eax

    invoke lstrcpynA, edi, esi, DATE_LEN+1

    ; TIME
    mov eax, sourceIndex
    mov ebx, TIME_LEN+1
    mul ebx
    mov esi, OFFSET times
    add esi, eax

    mov eax, destinationIndex
    mov ebx, TIME_LEN+1
    mul ebx
    mov edi, OFFSET times
    add edi, eax

    invoke lstrcpynA, edi, esi, TIME_LEN+1

    ; PURPOSE
    mov eax, sourceIndex
    mov ebx, PURPOSE_LEN+1
    mul ebx
    mov esi, OFFSET purposes
    add esi, eax

    mov eax, destinationIndex
    mov ebx, PURPOSE_LEN+1
    mul ebx
    mov edi, OFFSET purposes
    add edi, eax

    invoke lstrcpynA, edi, esi, PURPOSE_LEN+1

    ret
CopyRecord ENDP

ClearRecord PROC index:DWORD

    ; ID
    mov eax, index
    mov byte ptr [ids+eax], 0

    ; NAME
    mov eax, index
    mov ebx, NAME_LEN+1
    mul ebx
    mov edi, OFFSET names
    add edi, eax
    mov ecx, NAME_LEN+1
    xor eax, eax
    rep stosb

    ; DATE
    mov eax, index
    mov ebx, DATE_LEN+1
    mul ebx
    mov edi, OFFSET dates
    add edi, eax
    mov ecx, DATE_LEN+1
    xor eax, eax
    rep stosb

    ; TIME
    mov eax, index
    mov ebx, TIME_LEN+1
    mul ebx
    mov edi, OFFSET times
    add edi, eax
    mov ecx, TIME_LEN+1
    xor eax, eax
    rep stosb

    ; PURPOSE
    mov eax, index
    mov ebx, PURPOSE_LEN+1
    mul ebx
    mov edi, OFFSET purposes
    add edi, eax
    mov ecx, PURPOSE_LEN+1
    xor eax, eax
    rep stosb

    ret
ClearRecord ENDP

ParseID PROC
    xor eax, eax
    xor ecx, ecx
    mov esi, OFFSET inputID

parse_loop:
    mov dl, [esi]
    cmp dl, 0
    je parse_done

    cmp dl, '0'
    jb parse_invalid
    cmp dl, '9'
    ja parse_invalid

    ; EAX = EAX * 10 + digit
    imul eax, 10
    sub dl, '0'
    movzx edx, dl
    add eax, edx

    inc esi
    inc ecx
    jmp parse_loop

parse_invalid:
    xor eax, eax

parse_done:
    ret
ParseID ENDP

NumberToText PROC value:DWORD, destination:DWORD
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov eax, value
    mov edi, destination
    xor ecx, ecx

    cmp eax, 0
    jne number_convert

    mov byte ptr [edi], '0'
    mov byte ptr [edi+1], 0
    jmp number_done

number_convert:
    mov ebx, 10

number_divide:
    xor edx, edx
    div ebx
    push edx
    inc ecx
    cmp eax, 0
    jne number_divide

number_write:
    pop edx
    add dl, '0'
    mov [edi], dl
    inc edi
    loop number_write

    mov byte ptr [edi], 0

number_done:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
NumberToText ENDP

END start
