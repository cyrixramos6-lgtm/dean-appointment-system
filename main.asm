.386
.model flat, stdcall
option casemap:none

includelib kernel32.lib
includelib user32.lib

GetModuleHandleA PROTO STDCALL :DWORD
ExitProcess PROTO STDCALL :DWORD
RegisterClassA PROTO STDCALL :DWORD
LoadCursorA PROTO STDCALL :DWORD,:DWORD
CreateWindowExA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CreateFontA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
ShowWindow PROTO STDCALL :DWORD,:DWORD
UpdateWindow PROTO STDCALL :DWORD
GetMessageA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
TranslateMessage PROTO STDCALL :DWORD
DispatchMessageA PROTO STDCALL :DWORD
DefWindowProcA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
PostQuitMessage PROTO STDCALL :DWORD
DestroyWindow PROTO STDCALL :DWORD
GetWindowTextA PROTO STDCALL :DWORD,:DWORD,:DWORD
SetWindowTextA PROTO STDCALL :DWORD,:DWORD
MessageBoxA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
SendMessageA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
EnableWindow PROTO STDCALL :DWORD,:DWORD
lstrlenA PROTO STDCALL :DWORD
lstrcpyA PROTO STDCALL :DWORD,:DWORD
lstrcatA PROTO STDCALL :DWORD,:DWORD
lstrcpynA PROTO STDCALL :DWORD,:DWORD,:DWORD
lstrcmpA PROTO STDCALL :DWORD,:DWORD
SetWindowLongA PROTO STDCALL :DWORD,:DWORD,:DWORD
CallWindowProcA PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetLocalTime PROTO STDCALL :DWORD
SetTimer PROTO STDCALL :DWORD,:DWORD,:DWORD,:DWORD
KillTimer PROTO STDCALL :DWORD,:DWORD
SetTextColor PROTO STDCALL :DWORD,:DWORD
SetBkMode PROTO STDCALL :DWORD,:DWORD
SetBkColor PROTO STDCALL :DWORD,:DWORD
GetStockObject PROTO STDCALL :DWORD
GetSysColor PROTO STDCALL :DWORD
GetSysColorBrush PROTO STDCALL :DWORD

NULL equ 0
TRUE equ 1
FALSE equ 0

WS_OVERLAPPEDWINDOW equ 00CF0000h
WS_CHILD equ 40000000h
WS_VISIBLE equ 10000000h
WS_VSCROLL equ 00200000h
WS_TABSTOP equ 00010000h
WS_BORDER equ 00800000h
WS_EX_CLIENTEDGE equ 00000200h
ES_AUTOHSCROLL equ 00000080h
ES_NUMBER equ 00002000h
ES_PASSWORD equ 00000020h
BS_PUSHBUTTON equ 00000000h
BS_DEFPUSHBUTTON equ 00000001h
BS_GROUPBOX equ 00000007h
LBS_NOTIFY equ 00000001h
SS_CENTER equ 00000001h
SW_SHOW equ 5
SW_HIDE equ 0

WM_CREATE equ 0001h
WM_DESTROY equ 0002h
WM_CLOSE equ 0010h
WM_COMMAND equ 0111h
WM_SETFONT equ 0030h
WM_CTLCOLORSTATIC equ 0138h
WM_CHAR equ 0102h
WM_KEYDOWN equ 0100h
WM_TIMER equ 0113h
LB_ADDSTRING equ 0180h
LB_RESETCONTENT equ 0184h
LB_GETCURSEL equ 0188h
EM_GETSEL equ 0B0h
EM_SETSEL equ 0B1h

MB_OK equ 0
MB_ICONINFORMATION equ 040h
MB_ICONWARNING equ 030h
CS_HREDRAW equ 0002h
CS_VREDRAW equ 0001h
COLOR_WINDOW equ 5
IDC_ARROW equ 32512
GWL_WNDPROC equ -4
VK_DELETE equ 2Eh
TRANSPARENT equ 1
OPAQUE equ 2
NULL_BRUSH equ 5
COLOR_MAROON equ 00000080h
ID_CLOCK_TIMER equ 100

MAX_RECORDS equ 10
NAME_LEN equ 40
PURPOSE_LEN equ 80
DATE_LEN equ 15
TIME_LEN equ 19

ID_NAME equ 1001
ID_DATE equ 1002
ID_TIME equ 1003
ID_PURPOSE equ 1004
ID_APPTID equ 1005
ID_PASSWORD equ 1006

ID_BOOK equ 2001
ID_CLEAR equ 2002
ID_DEANLOGIN equ 2003
ID_DEANLOGOUT equ 2004
ID_VIEW equ 2005
ID_DETAILS equ 2006
ID_ACCEPT equ 2007
ID_CANCEL equ 2008
ID_MOVE equ 2009
ID_DONE equ 2010
ID_CHECK equ 2011
ID_STUDENT_FCFS equ 2012
ID_EXIT equ 2013

ID_LIST equ 3001
ID_DETAILSBOX equ 3002
ID_STATUS equ 3003
ID_CHECKRESULT equ 3004

WNDCLASS STRUCT
    style dd ?
    lpfnWndProc dd ?
    cbClsExtra dd ?
    cbWndExtra dd ?
    hInstance dd ?
    hIcon dd ?
    hCursor dd ?
    hbrBackground dd ?
    lpszMenuName dd ?
    lpszClassName dd ?
WNDCLASS ENDS

MSG STRUCT
    hwnd dd ?
    message dd ?
    wParam dd ?
    lParam dd ?
    time dd ?
    ptX dd ?
    ptY dd ?
MSG ENDS

SYSTEMTIME STRUCT
    wYear dw ?
    wMonth dw ?
    wDayOfWeek dw ?
    wDay dw ?
    wHour dw ?
    wMinute dw ?
    wSecond dw ?
    wMilliseconds dw ?
SYSTEMTIME ENDS

WndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
RefreshList PROTO
BookAppointment PROTO
ViewSelected PROTO
AcceptAppointment PROTO
CancelAppointment PROTO
MoveAppointment PROTO
MarkDone PROTO
CheckMyStatus PROTO
ShowRecord PROTO :DWORD
CopyRecord PROTO :DWORD,:DWORD
ClearRecord PROTO :DWORD
ParseID PROTO
NumberToText PROTO :DWORD,:DWORD
SetDeanMode PROTO :DWORD
DateEditProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
TimeEditProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
ValidateDate PROTO :DWORD
ValidateTime PROTO :DWORD
TimeToMinutes PROTO :DWORD,:DWORD,:DWORD
PadNumber2 PROTO :DWORD,:DWORD
UpdateClock PROTO
ShowStudentFCFS PROTO
SortFCFS PROTO
GetDateValue PROTO :DWORD
GetTimeValue PROTO :DWORD
IsRecordLess PROTO :DWORD,:DWORD

.data
className db "DeanAppointmentSystem",0
windowTitle db "Dean Appointment System - Student / Dean Access",0

clsStatic db "STATIC",0
clsEdit db "EDIT",0
clsButton db "BUTTON",0
clsListBox db "LISTBOX",0

txtHeader db "DEAN APPOINTMENT SYSTEM",0
txtSubHeader db "STUDENT APPOINTMENT REQUEST / DEAN MANAGEMENT",0
fontFace db "Segoe UI",0
txtStudent db "STUDENT INFORMATION",0
txtDean db "DEAN ACCESS",0
txtQueue db "APPOINTMENT QUEUE",0
txtDetails db "SELECTED APPOINTMENT",0

txtName db "Student Name:",0
txtDate db "Appointment Date:",0
txtTime db "Appointment Time:",0
txtPurpose db "Purpose:",0
txtID db "Appointment ID:",0
txtPassword db "Dean Password:",0

txtBook db "SUBMIT APPOINTMENT",0
txtClear db "CLEAR",0
txtLogin db "DEAN LOGIN",0
txtLogout db "DEAN LOGOUT",0
txtView db "REFRESH LIST",0
txtSelected db "VIEW DETAILS",0
txtAccept db "ACCEPT",0
txtCancel db "CANCEL / REMOVE",0
txtMove db "MOVE / RESCHEDULE",0
txtDone db "MARK AS DONE",0
txtCheck db "CHECK MY STATUS",0
txtStudentFCFS db "VIEW FCFS LIST",0
txtExit db "EXIT",0

deanPassword db "DEAN123",0

msgBooked db "Appointment request submitted. Your appointment is now in the FCFS queue.",0
msgFull db "The appointment queue is full. Maximum is 10.",0
msgInvalid db "Please complete Name, Date, Time, and Purpose.",0
msgInvalidDate db "Invalid date. Use MM/DD/YYYY, year 2026 or later, with a day valid for the selected month.",0
msgInvalidTime db "Invalid appointment time.",13,10,"Please use 30-minute intervals only (:00 or :30).",13,10,"Example: 09:00 AM - 10:30 AM.",0
msgInvalidTimeRange db "Invalid appointment range.",13,10,"The end time must be later than the start time.",0
msgNotFound db "Appointment ID not found.",0
msgNoRecords db "No appointments available.",0
msgSelect db "Please select an appointment from the Dean appointment list.",0
msgWrongPassword db "Incorrect Dean password.",0
msgDeanOnly db "This function is available only in Dean Mode.",0
msgLogin db "Dean Mode unlocked. The Dean can now view, accept, cancel, and reschedule appointments.",0
msgLogout db "Dean Mode locked. Student Mode is active.",0
msgCancelled db "Appointment cancelled and removed from the FCFS queue.",0
msgMoved db "Appointment moved/rescheduled successfully.",0
msgDone db "Appointment marked as DONE. It has been removed from the active queue and the next FCFS appointment is now ready.",0
msgDoneFail db "Appointment ID not found or it is already DONE.",0
msgAccepted db "Appointment status changed to ACCEPTED.",0
msgAlreadyAccepted db "This appointment has already been accepted.",0
msgStatusFound db "Your appointment is in the FCFS list.",0
msgStatusWaiting db "STATUS: WAITING - Please wait for your appointment.",0
msgStatusDone db "STATUS: DONE - Your appointment has been completed.",0
msgStatusNotFound db "Appointment ID is not currently in the queue.",0
msgStudentFCFSTitle db "CURRENT FCFS APPOINTMENT LIST",0

statusStudent db "STUDENT MODE: Fill in your information and submit an appointment request.",0
statusDean db "DEAN MODE: You can view, accept, cancel, and reschedule appointments.",0

prefixID db "ID: ",0
prefixName db " | Student: ",0
prefixDate db " | Date: ",0
prefixTime db " | Time: ",0
prefixPurpose db " | Purpose: ",0
prefixStatus db " | Status: ",0
statusWaiting db "WAITING",0
statusAccepted db "ACCEPTED",0
statusDoneText db "DONE",0
detailID db "Appointment ID: ",0
detailName db "Student Name: ",0
detailDate db "Appointment Date: ",0
detailTime db "Appointment Time: ",0
detailPurpose db "Purpose: ",0
detailStatus db "Status: ",0
detailQueue db "FCFS Position: ",0
newline db 13,10,0

clockPrefix db "Current Date and Time: ",0
sepSlash db "/",0
sepColon db ":",0
sepSpace db "  ",0
clockBuf db 64 dup(0)
clockNumBuf db 8 dup(0)

inputName db 64 dup(0)
inputDate db 32 dup(0)
inputTime db 32 dup(0)
inputPurpose db 128 dup(0)
inputID db 16 dup(0)
inputPassword db 32 dup(0)
numBuf db 16 dup(0)
listBuf db 512 dup(0)
detailsBuf db 1024 dup(0)

; Masked-input template for the Date field: '/' positions are
; literal and can never be typed over, deleted, or shifted; the
; remaining positions are digit slots whose placeholder character
; is restored on Backspace/Delete.
dateTemplate db "MM/DD/YYYY",0

; Masked-input template for the Time field: a START/END range
; "00:00 AM - 00:00 AM" (19 chars). Two copies of the original
; single-time mask joined by a fixed " - " literal:
;   0,1     = start hour tens/ones digit
;   2       = ':' (literal)
;   3,4     = start minute tens/ones digit
;   5       = ' ' (literal)
;   6       = start AM/PM letter (A or P)
;   7       = 'M' (literal)
;   8,9,10  = ' ','-',' ' (literal)
;   11,12   = end hour tens/ones digit
;   13      = ':' (literal)
;   14,15   = end minute tens/ones digit
;   16      = ' ' (literal)
;   17      = end AM/PM letter (A or P)
;   18      = 'M' (literal)
; All literal positions can never be typed over, deleted, or
; shifted; the digit/letter slots reset to their placeholder
; character on Backspace/Delete.
timeTemplate db "00:00 AM - 00:00 AM",0

dateEditBuf db 16 dup(0)
timeEditBuf db 24 dup(0)
oldDateEditProc dd 0
oldTimeEditProc dd 0

names db MAX_RECORDS*(NAME_LEN+1) dup(0)
dates db MAX_RECORDS*(DATE_LEN+1) dup(0)
times db MAX_RECORDS*(TIME_LEN+1) dup(0)
purposes db MAX_RECORDS*(PURPOSE_LEN+1) dup(0)
ids db MAX_RECORDS dup(0)
statuses db MAX_RECORDS dup(0)

; sortIndex holds record-array slot numbers (0..recCount-1) in
; ascending order of appointment date, then time, then ID -
; used only for the student-facing "CURRENT FCFS APPOINTMENT
; LIST" view so it never disturbs the Dean's raw queue order.
sortIndex db MAX_RECORDS dup(0)

recCount dd 0
nextID dd 1
isDeanMode dd FALSE

; TRUE while the shared appointment display area is showing the
; sorted FCFS list (as opposed to the Dean's raw queue order).
; Used so "View Details" maps the selected list row back to the
; correct record no matter which view is currently displayed.
isFcfsViewActive dd FALSE

hInstance dd 0
hMainWnd dd 0
hEditName dd 0
hEditDate dd 0
hEditTime dd 0
hEditPurpose dd 0
hEditID dd 0
hEditPassword dd 0
hList dd 0
hDetailsBox dd 0
hStatus dd 0
hFont dd 0
hFontBold dd 0
hBtnLogout dd 0
hBtnView dd 0
hBtnDetails dd 0
hBtnAccept dd 0
hBtnCancel dd 0
hBtnMove dd 0
hBtnDone dd 0
hBtnCheck dd 0
hBtnStudentFCFS dd 0

hTitleStatic dd 0
hClockDisplay dd 0
hHdrStudent dd 0
hHdrDean dd 0
hHdrSelected dd 0
hHdrQueue dd 0

wc WNDCLASS <>
msg MSG <>

.code

start:
    invoke GetModuleHandleA, NULL
    mov hInstance, eax

    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, OFFSET WndProc
    mov wc.cbClsExtra, 0
    mov wc.cbWndExtra, 0
    mov wc.hInstance, eax
    mov wc.hIcon, 0
    invoke LoadCursorA, NULL, IDC_ARROW
    mov wc.hCursor, eax
    mov wc.hbrBackground, COLOR_WINDOW+1
    mov wc.lpszMenuName, 0
    mov wc.lpszClassName, OFFSET className
    invoke RegisterClassA, ADDR wc

    invoke CreateWindowExA, 0, ADDR className, ADDR windowTitle, \
        WS_OVERLAPPEDWINDOW, 70, 30, 1180, 900, \
        NULL, NULL, hInstance, NULL
    mov hMainWnd, eax

    invoke CreateFontA, 18,0,0,0,700,0,0,0,1,0,0,0,0,ADDR fontFace
    mov hFontBold, eax
    invoke CreateFontA, 15,0,0,0,400,0,0,0,1,0,0,0,0,ADDR fontFace
    mov hFont, eax

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
    cmp uMsg, WM_COMMAND
    je window_command
    cmp uMsg, WM_CTLCOLORSTATIC
    je window_ctlcolor
    cmp uMsg, WM_TIMER
    je window_timer
    cmp uMsg, WM_CLOSE
    je window_close
    cmp uMsg, WM_DESTROY
    je window_destroy

    invoke DefWindowProcA, hWnd, uMsg, wParam, lParam
    ret

window_ctlcolor:
    mov eax, lParam
    cmp eax, hTitleStatic
    je ctlcolor_maroon
    cmp eax, hHdrStudent
    je ctlcolor_maroon
    cmp eax, hHdrDean
    je ctlcolor_maroon
    cmp eax, hHdrSelected
    je ctlcolor_maroon
    cmp eax, hHdrQueue
    je ctlcolor_maroon
    invoke DefWindowProcA, hWnd, uMsg, wParam, lParam
    ret

ctlcolor_maroon:
    ; Opaque (not transparent) so each redraw fully erases the old
    ; text first - prevents old/new header text from overlapping
    ; when hHdrQueue's caption is switched between "APPOINTMENT
    ; QUEUE" and "CURRENT FCFS APPOINTMENT LIST".
    invoke SetTextColor, wParam, COLOR_MAROON
    invoke GetSysColor, COLOR_WINDOW
    invoke SetBkColor, wParam, eax
    invoke SetBkMode, wParam, OPAQUE
    invoke GetSysColorBrush, COLOR_WINDOW
    ret

window_timer:
    call UpdateClock
    ret

window_create:
    ; ---------------- TITLE BAR ----------------
    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtHeader, \
        WS_CHILD or WS_VISIBLE or SS_CENTER or WS_BORDER, \
        30,15,1120,45,hWnd,0,hInstance,NULL
    mov hTitleStatic,eax
    invoke SendMessageA, hTitleStatic, WM_SETFONT, hFontBold, TRUE

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtSubHeader, \
        WS_CHILD or WS_VISIBLE or SS_CENTER, \
        30,65,1120,22,hWnd,0,hInstance,NULL
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    invoke CreateWindowExA, 0, ADDR clsStatic, NULL, \
        WS_CHILD or WS_VISIBLE or SS_CENTER or WS_BORDER, \
        30,90,1120,24,hWnd,0,hInstance,NULL
    mov hClockDisplay,eax
    invoke SendMessageA, hClockDisplay, WM_SETFONT, hFont, TRUE

    ; ---------------- STUDENT INFORMATION ----------------
    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtStudent, \
        WS_CHILD or WS_VISIBLE or SS_CENTER or WS_BORDER, \
        30,125,440,26,hWnd,0,hInstance,NULL
    mov hHdrStudent,eax
    invoke SendMessageA, hHdrStudent, WM_SETFONT, hFontBold, TRUE

    invoke CreateWindowExA, 0, ADDR clsButton, NULL, \
        WS_CHILD or WS_VISIBLE or BS_GROUPBOX, \
        30,151,440,230,hWnd,0,hInstance,NULL

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtName, \
        WS_CHILD or WS_VISIBLE,50,170,125,22,hWnd,0,hInstance,NULL
    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsEdit, NULL, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_AUTOHSCROLL, \
        180,168,250,28,hWnd,ID_NAME,hInstance,NULL
    mov hEditName,eax

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtDate, \
        WS_CHILD or WS_VISIBLE,50,205,125,22,hWnd,0,hInstance,NULL
    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsEdit, NULL, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_AUTOHSCROLL, \
        180,203,150,28,hWnd,ID_DATE,hInstance,NULL
    mov hEditDate,eax
    invoke SetWindowTextA, hEditDate, ADDR dateTemplate
    invoke SendMessageA, hEditDate, EM_SETSEL, 0, 0
    invoke SetWindowLongA, hEditDate, GWL_WNDPROC, OFFSET DateEditProc
    mov oldDateEditProc, eax

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtTime, \
        WS_CHILD or WS_VISIBLE,50,240,125,22,hWnd,0,hInstance,NULL
    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsEdit, NULL, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_AUTOHSCROLL, \
        180,238,240,28,hWnd,ID_TIME,hInstance,NULL
    mov hEditTime,eax
    invoke SetWindowTextA, hEditTime, ADDR timeTemplate
    invoke SendMessageA, hEditTime, EM_SETSEL, 0, 0
    invoke SetWindowLongA, hEditTime, GWL_WNDPROC, OFFSET TimeEditProc
    mov oldTimeEditProc, eax

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtPurpose, \
        WS_CHILD or WS_VISIBLE,50,275,125,22,hWnd,0,hInstance,NULL
    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsEdit, NULL, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_AUTOHSCROLL, \
        180,273,250,28,hWnd,ID_PURPOSE,hInstance,NULL
    mov hEditPurpose,eax

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtBook, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or BS_DEFPUSHBUTTON, \
        50,315,220,35,hWnd,ID_BOOK,hInstance,NULL

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtClear, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        280,315,150,35,hWnd,ID_CLEAR,hInstance,NULL

    ; ---------------- DEAN ACCESS ----------------
    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtDean, \
        WS_CHILD or WS_VISIBLE or SS_CENTER or WS_BORDER, \
        30,391,440,26,hWnd,0,hInstance,NULL
    mov hHdrDean,eax
    invoke SendMessageA, hHdrDean, WM_SETFONT, hFontBold, TRUE

    invoke CreateWindowExA, 0, ADDR clsButton, NULL, \
        WS_CHILD or WS_VISIBLE or BS_GROUPBOX, \
        30,417,440,115,hWnd,0,hInstance,NULL

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtPassword, \
        WS_CHILD or WS_VISIBLE,50,436,125,22,hWnd,0,hInstance,NULL

    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsEdit, NULL, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_PASSWORD or ES_AUTOHSCROLL, \
        180,433,250,28,hWnd,ID_PASSWORD,hInstance,NULL
    mov hEditPassword,eax

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtLogin, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        50,476,180,35,hWnd,ID_DEANLOGIN,hInstance,NULL

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtLogout, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        240,476,190,35,hWnd,ID_DEANLOGOUT,hInstance,NULL
    mov hBtnLogout,eax
    invoke EnableWindow,hBtnLogout,FALSE

    ; ---------------- APPOINTMENT QUEUE / FCFS LIST (one shared area) ----------------
    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtQueue, \
        WS_CHILD or WS_VISIBLE or SS_CENTER or WS_BORDER, \
        490,125,620,26,hWnd,0,hInstance,NULL
    mov hHdrQueue,eax
    invoke SendMessageA, hHdrQueue, WM_SETFONT, hFontBold, TRUE

    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsListBox, NULL, \
        WS_CHILD or WS_VISIBLE or WS_VSCROLL or LBS_NOTIFY, \
        510,156,580,250,hWnd,ID_LIST,hInstance,NULL
    mov hList,eax
    invoke EnableWindow,hList,FALSE

    ; Dean controls below queue
    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtView, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        510,416,135,35,hWnd,ID_VIEW,hInstance,NULL
    mov hBtnView,eax
    invoke EnableWindow,hBtnView,FALSE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtSelected, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        650,416,135,35,hWnd,ID_DETAILS,hInstance,NULL
    mov hBtnDetails,eax
    invoke EnableWindow,hBtnDetails,FALSE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtAccept, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        790,416,135,35,hWnd,ID_ACCEPT,hInstance,NULL
    mov hBtnAccept,eax
    invoke EnableWindow,hBtnAccept,FALSE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtCancel, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        930,416,160,35,hWnd,ID_CANCEL,hInstance,NULL
    mov hBtnCancel,eax
    invoke EnableWindow,hBtnCancel,FALSE

    ; ID (now usable by students AND the Dean) + Move controls
    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtID, \
        WS_CHILD or WS_VISIBLE,510,471,110,22,hWnd,0,hInstance,NULL
    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsEdit, NULL, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_NUMBER, \
        625,468,100,28,hWnd,ID_APPTID,hInstance,NULL
    mov hEditID,eax

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtMove, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        740,466,180,35,hWnd,ID_MOVE,hInstance,NULL
    mov hBtnMove,eax
    invoke EnableWindow,hBtnMove,FALSE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtDone, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        930,466,160,35,hWnd,ID_DONE,hInstance,NULL
    mov hBtnDone,eax
    invoke EnableWindow,hBtnDone,FALSE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtCheck, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        510,511,180,35,hWnd,ID_CHECK,hInstance,NULL
    mov hBtnCheck,eax

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtStudentFCFS, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        720,511,180,35,hWnd,ID_STUDENT_FCFS,hInstance,NULL
    mov hBtnStudentFCFS,eax

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtExit, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        930,511,160,35,hWnd,ID_EXIT,hInstance,NULL

    ; ---------------- SELECTED APPOINTMENT (taller - full details, nothing clipped) ----------------
    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtDetails, \
        WS_CHILD or WS_VISIBLE or SS_CENTER or WS_BORDER, \
        30,561,1080,26,hWnd,0,hInstance,NULL
    mov hHdrSelected,eax
    invoke SendMessageA, hHdrSelected, WM_SETFONT, hFontBold, TRUE

    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsStatic, NULL, \
        WS_CHILD or WS_VISIBLE or WS_BORDER, \
        50,593,1040,170,hWnd,ID_DETAILSBOX,hInstance,NULL
    mov hDetailsBox,eax
    invoke EnableWindow,hDetailsBox,FALSE

    ; ---------------- STATUS BAR ----------------
    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR statusStudent, \
        WS_CHILD or WS_VISIBLE or WS_BORDER or SS_CENTER, \
        30,775,1080,32,hWnd,ID_STATUS,hInstance,NULL
    mov hStatus,eax

    invoke SetTimer, hWnd, ID_CLOCK_TIMER, 1000, NULL
    call UpdateClock

    call RefreshList
    ret

window_command:
    mov eax,wParam
    and eax,0FFFFh

    cmp eax,ID_BOOK
    je cmd_book
    cmp eax,ID_CLEAR
    je cmd_clear
    cmp eax,ID_DEANLOGIN
    je cmd_login
    cmp eax,ID_DEANLOGOUT
    je cmd_logout
    cmp eax,ID_VIEW
    je cmd_view
    cmp eax,ID_DETAILS
    je cmd_details
    cmp eax,ID_ACCEPT
    je cmd_accept
    cmp eax,ID_CANCEL
    je cmd_cancel
    cmp eax,ID_MOVE
    je cmd_move
    cmp eax,ID_DONE
    je cmd_done
    cmp eax,ID_CHECK
    je cmd_check
    cmp eax,ID_STUDENT_FCFS
    je cmd_student_fcfs
    cmp eax,ID_EXIT
    je cmd_exit
    ret

cmd_book:
    call BookAppointment
    ret

cmd_clear:
    invoke SetWindowTextA,hEditName,NULL
    invoke SetWindowTextA,hEditDate,ADDR dateTemplate
    invoke SetWindowTextA,hEditTime,ADDR timeTemplate
    invoke SetWindowTextA,hEditPurpose,NULL
    ret

cmd_login:
    invoke GetWindowTextA,hEditPassword,ADDR inputPassword,32
    invoke lstrcmpA,ADDR inputPassword,ADDR deanPassword
    cmp eax,0
    jne login_bad

    invoke SetDeanMode,TRUE
    invoke MessageBoxA,hMainWnd,ADDR msgLogin,ADDR txtDean,MB_OK or MB_ICONINFORMATION
    ret

login_bad:
    invoke MessageBoxA,hMainWnd,ADDR msgWrongPassword,ADDR txtDean,MB_OK or MB_ICONWARNING
    ret

cmd_logout:
    invoke SetDeanMode,FALSE
    invoke MessageBoxA,hMainWnd,ADDR msgLogout,ADDR txtDean,MB_OK or MB_ICONINFORMATION
    ret

cmd_view:
    cmp isDeanMode,TRUE
    jne dean_only
    call RefreshList
    ret

cmd_details:
    cmp isDeanMode,TRUE
    jne dean_only
    call ViewSelected
    ret

cmd_accept:
    cmp isDeanMode,TRUE
    jne dean_only
    call AcceptAppointment
    ret

cmd_cancel:
    cmp isDeanMode,TRUE
    jne dean_only
    call CancelAppointment
    ret

cmd_move:
    cmp isDeanMode,TRUE
    jne dean_only
    call MoveAppointment
    ret

cmd_done:
    cmp isDeanMode,TRUE
    jne dean_only
    call MarkDone
    ret

cmd_check:
    call CheckMyStatus
    ret

cmd_student_fcfs:
    call ShowStudentFCFS
    ret

dean_only:
    invoke MessageBoxA,hMainWnd,ADDR msgDeanOnly,ADDR txtDean,MB_OK or MB_ICONWARNING
    ret

cmd_exit:
    invoke DestroyWindow,hMainWnd
    ret

window_close:
    invoke DestroyWindow,hWnd
    ret

window_destroy:
    invoke KillTimer, hWnd, ID_CLOCK_TIMER
    invoke PostQuitMessage,0
    ret

WndProc ENDP

SetDeanMode PROC mode:DWORD
    mov eax,mode
    mov isDeanMode,eax

    cmp eax,TRUE
    jne student_mode

    invoke EnableWindow,hList,TRUE
    invoke EnableWindow,hDetailsBox,TRUE
    invoke EnableWindow,hBtnView,TRUE
    invoke EnableWindow,hBtnDetails,TRUE
    invoke EnableWindow,hBtnAccept,TRUE
    invoke EnableWindow,hBtnCancel,TRUE
    invoke EnableWindow,hBtnMove,TRUE
    invoke EnableWindow,hBtnDone,TRUE
    invoke EnableWindow,hBtnStudentFCFS,TRUE
    invoke EnableWindow,hBtnLogout,TRUE
    invoke EnableWindow,hEditPassword,FALSE
    invoke SetWindowTextA,hStatus,ADDR statusDean
    invoke SetWindowTextA,hHdrQueue,ADDR txtQueue
    invoke RefreshList
    ret

student_mode:
    invoke EnableWindow,hList,FALSE
    invoke EnableWindow,hDetailsBox,FALSE
    invoke EnableWindow,hBtnView,FALSE
    invoke EnableWindow,hBtnDetails,FALSE
    invoke EnableWindow,hBtnAccept,FALSE
    invoke EnableWindow,hBtnCancel,FALSE
    invoke EnableWindow,hBtnMove,FALSE
    invoke EnableWindow,hBtnDone,FALSE
    invoke EnableWindow,hBtnStudentFCFS,TRUE
    invoke EnableWindow,hBtnLogout,FALSE
    invoke EnableWindow,hEditPassword,TRUE
    invoke SetWindowTextA,hStatus,ADDR statusStudent
    invoke SetWindowTextA,hHdrQueue,ADDR msgStudentFCFSTitle
    invoke SendMessageA,hList,LB_RESETCONTENT,0,0
    invoke SendMessageA,hList,LB_ADDSTRING,0,ADDR msgStudentFCFSTitle
    invoke SetWindowTextA,hDetailsBox,NULL
    ret
SetDeanMode ENDP

BookAppointment PROC
    mov eax,recCount
    cmp eax,MAX_RECORDS
    jb book_ok
    invoke MessageBoxA,hMainWnd,ADDR msgFull,ADDR txtHeader,MB_OK or MB_ICONWARNING
    ret

book_ok:
    invoke GetWindowTextA,hEditName,ADDR inputName,64
    invoke GetWindowTextA,hEditDate,ADDR inputDate,32
    invoke GetWindowTextA,hEditTime,ADDR inputTime,32
    invoke GetWindowTextA,hEditPurpose,ADDR inputPurpose,128

    invoke lstrlenA,ADDR inputName
    cmp eax,0
    je invalid_book
    invoke lstrlenA,ADDR inputDate
    cmp eax,0
    je invalid_book
    invoke lstrlenA,ADDR inputTime
    cmp eax,0
    je invalid_book
    invoke lstrlenA,ADDR inputPurpose
    cmp eax,0
    je invalid_book

    invoke ValidateDate, ADDR inputDate
    cmp eax,0
    je invalid_date_book

    invoke ValidateTime, ADDR inputTime
    cmp eax,1
    je time_ok_book
    cmp eax,2
    je invalid_time_range_book
    jmp invalid_time_book

time_ok_book:
    mov eax,recCount
    mov ebx,NAME_LEN+1
    mul ebx
    mov edi,OFFSET names
    add edi,eax
    invoke lstrcpynA,edi,ADDR inputName,NAME_LEN+1

    mov eax,recCount
    mov ebx,DATE_LEN+1
    mul ebx
    mov edi,OFFSET dates
    add edi,eax
    invoke lstrcpynA,edi,ADDR inputDate,DATE_LEN+1

    mov eax,recCount
    mov ebx,TIME_LEN+1
    mul ebx
    mov edi,OFFSET times
    add edi,eax
    invoke lstrcpynA,edi,ADDR inputTime,TIME_LEN+1

    mov eax,recCount
    mov ebx,PURPOSE_LEN+1
    mul ebx
    mov edi,OFFSET purposes
    add edi,eax
    invoke lstrcpynA,edi,ADDR inputPurpose,PURPOSE_LEN+1

    ; Appointment IDs are ONLY 1-10 and follow FCFS order.
    mov eax,recCount
    inc eax
    mov [ids+eax-1],al
    mov byte ptr [statuses+eax-1],0

    inc recCount

    invoke SetWindowTextA,hEditName,NULL
    invoke SetWindowTextA,hEditDate,ADDR dateTemplate
    invoke SetWindowTextA,hEditTime,ADDR timeTemplate
    invoke SetWindowTextA,hEditPurpose,NULL

    mov eax,recCount
    dec eax
    movzx eax,byte ptr [ids+eax]
    invoke NumberToText,eax,ADDR numBuf
    invoke SetWindowTextA,hStatus,ADDR statusStudent
    invoke MessageBoxA,hMainWnd,ADDR msgBooked,ADDR txtBook,MB_OK or MB_ICONINFORMATION
    ret

invalid_date_book:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalidDate,ADDR txtBook,MB_OK or MB_ICONWARNING
    ret

invalid_time_book:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalidTime,ADDR txtBook,MB_OK or MB_ICONWARNING
    ret

invalid_time_range_book:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalidTimeRange,ADDR txtBook,MB_OK or MB_ICONWARNING
    ret

invalid_book:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalid,ADDR txtBook,MB_OK or MB_ICONWARNING
    ret
BookAppointment ENDP

RefreshList PROC
    LOCAL currentIndex:DWORD
    LOCAL remaining:DWORD

    mov isFcfsViewActive, FALSE
    invoke SetWindowTextA,hHdrQueue,ADDR txtQueue

    cmp isDeanMode,TRUE
    je refresh_allowed

    invoke SendMessageA,hList,LB_RESETCONTENT,0,0
    invoke SendMessageA,hList,LB_ADDSTRING,0,ADDR msgDeanOnly
    ret

refresh_allowed:
    invoke SendMessageA,hList,LB_RESETCONTENT,0,0

    mov eax,recCount
    mov remaining,eax
    mov currentIndex,0

    cmp eax,0
    jne refresh_loop

    invoke SendMessageA,hList,LB_ADDSTRING,0,ADDR msgNoRecords
    ret

refresh_loop:
    ; ID
    invoke lstrcpyA,ADDR listBuf,ADDR prefixID
    mov eax,currentIndex
    movzx eax,byte ptr [ids+eax]
    invoke NumberToText,eax,ADDR numBuf
    invoke lstrcatA,ADDR listBuf,ADDR numBuf

    ; Name
    invoke lstrcatA,ADDR listBuf,ADDR prefixName
    mov eax,currentIndex
    mov ebx,NAME_LEN+1
    mul ebx
    mov edx,OFFSET names
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    ; Date
    invoke lstrcatA,ADDR listBuf,ADDR prefixDate
    mov eax,currentIndex
    mov ebx,DATE_LEN+1
    mul ebx
    mov edx,OFFSET dates
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    ; Time
    invoke lstrcatA,ADDR listBuf,ADDR prefixTime
    mov eax,currentIndex
    mov ebx,TIME_LEN+1
    mul ebx
    mov edx,OFFSET times
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    ; Purpose
    invoke lstrcatA,ADDR listBuf,ADDR prefixPurpose
    mov eax,currentIndex
    mov ebx,PURPOSE_LEN+1
    mul ebx
    mov edx,OFFSET purposes
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    ; Status
    invoke lstrcatA,ADDR listBuf,ADDR prefixStatus
    mov eax,currentIndex
    movzx eax,byte ptr [statuses+eax]
    cmp eax,0
    jne refresh_done_status

    invoke lstrcatA,ADDR listBuf,ADDR statusWaiting
    jmp refresh_add

refresh_done_status:
    invoke lstrcatA,ADDR listBuf,ADDR statusAccepted

refresh_add:
    invoke SendMessageA,hList,LB_ADDSTRING,0,ADDR listBuf

    mov eax,currentIndex
    inc eax
    mov currentIndex,eax

    mov eax,remaining
    dec eax
    mov remaining,eax

    cmp eax,0
    jne refresh_loop

    ret
RefreshList ENDP

ViewSelected PROC
    invoke SendMessageA,hList,LB_GETCURSEL,0,0
    cmp eax,0FFFFFFFFh
    je no_selection

    cmp isFcfsViewActive,TRUE
    jne viewsel_direct

    ; The list is currently showing the sorted FCFS view, so map
    ; the selected row through sortIndex to get the real record slot.
    mov ecx,eax
    movzx eax, byte ptr [sortIndex+ecx]

viewsel_direct:
    invoke ShowRecord,eax
    ret
no_selection:
    invoke MessageBoxA,hMainWnd,ADDR msgSelect,ADDR txtDetails,MB_OK or MB_ICONWARNING
    ret
ViewSelected ENDP

ShowRecord PROC index:DWORD
    invoke lstrcpyA,ADDR detailsBuf,ADDR detailID
    mov eax,index
    movzx eax,byte ptr [ids+eax]
    invoke NumberToText,eax,ADDR numBuf
    invoke lstrcatA,ADDR detailsBuf,ADDR numBuf
    invoke lstrcatA,ADDR detailsBuf,ADDR newline

    invoke lstrcatA,ADDR detailsBuf,ADDR detailName
    mov eax,index
    mov ebx,NAME_LEN+1
    mul ebx
    mov edx,OFFSET names
    add edx,eax
    invoke lstrcatA,ADDR detailsBuf,edx
    invoke lstrcatA,ADDR detailsBuf,ADDR newline

    invoke lstrcatA,ADDR detailsBuf,ADDR detailDate
    mov eax,index
    mov ebx,DATE_LEN+1
    mul ebx
    mov edx,OFFSET dates
    add edx,eax
    invoke lstrcatA,ADDR detailsBuf,edx
    invoke lstrcatA,ADDR detailsBuf,ADDR newline

    invoke lstrcatA,ADDR detailsBuf,ADDR detailTime
    mov eax,index
    mov ebx,TIME_LEN+1
    mul ebx
    mov edx,OFFSET times
    add edx,eax
    invoke lstrcatA,ADDR detailsBuf,edx
    invoke lstrcatA,ADDR detailsBuf,ADDR newline

    invoke lstrcatA,ADDR detailsBuf,ADDR detailPurpose
    mov eax,index
    mov ebx,PURPOSE_LEN+1
    mul ebx
    mov edx,OFFSET purposes
    add edx,eax
    invoke lstrcatA,ADDR detailsBuf,edx
    invoke lstrcatA,ADDR detailsBuf,ADDR newline

    invoke lstrcatA,ADDR detailsBuf,ADDR detailStatus
    mov eax,index
    movzx eax,byte ptr [statuses+eax]
    cmp eax,0
    jne showrecord_accepted
    invoke lstrcatA,ADDR detailsBuf,ADDR statusWaiting
    jmp showrecord_status_done
showrecord_accepted:
    invoke lstrcatA,ADDR detailsBuf,ADDR statusAccepted
showrecord_status_done:
    invoke lstrcatA,ADDR detailsBuf,ADDR newline

    invoke lstrcatA,ADDR detailsBuf,ADDR detailQueue
    mov eax,index
    inc eax
    invoke NumberToText,eax,ADDR numBuf
    invoke lstrcatA,ADDR detailsBuf,ADDR numBuf

    invoke SetWindowTextA,hDetailsBox,ADDR detailsBuf
    ret
ShowRecord ENDP

AcceptAppointment PROC
    LOCAL currentIndex:DWORD
    LOCAL remaining:DWORD
    LOCAL wantedID:DWORD

    invoke GetWindowTextA,hEditID,ADDR inputID,16
    call ParseID
    cmp eax,0
    je accept_fail

    mov wantedID,eax
    mov currentIndex,0
    mov eax,recCount
    mov remaining,eax

accept_find:
    cmp remaining,0
    je accept_fail

    mov eax,currentIndex
    movzx eax,byte ptr [ids+eax]
    cmp eax,wantedID
    je accept_found

    mov eax,currentIndex
    inc eax
    mov currentIndex,eax

    mov eax,remaining
    dec eax
    mov remaining,eax
    jmp accept_find

accept_found:
    mov eax,currentIndex
    movzx eax,byte ptr [statuses+eax]
    cmp eax,0
    jne accept_already

    mov eax,currentIndex
    mov byte ptr [statuses+eax],1

    call RefreshList
    invoke ShowRecord,currentIndex
    invoke MessageBoxA,hMainWnd,ADDR msgAccepted,ADDR txtAccept,MB_OK or MB_ICONINFORMATION
    ret

accept_already:
    invoke MessageBoxA,hMainWnd,ADDR msgAlreadyAccepted,ADDR txtAccept,MB_OK or MB_ICONWARNING
    ret

accept_fail:
    invoke MessageBoxA,hMainWnd,ADDR msgNotFound,ADDR txtAccept,MB_OK or MB_ICONWARNING
    ret
AcceptAppointment ENDP

CancelAppointment PROC
    LOCAL currentIndex:DWORD
    LOCAL remaining:DWORD
    LOCAL wantedID:DWORD
    LOCAL sourceIndex:DWORD
    LOCAL destinationIndex:DWORD

    invoke GetWindowTextA,hEditID,ADDR inputID,16
    call ParseID
    cmp eax,0
    je cancel_fail

    mov wantedID,eax
    mov currentIndex,0
    mov eax,recCount
    mov remaining,eax

find_cancel:
    cmp remaining,0
    je cancel_fail

    mov eax,currentIndex
    movzx eax,byte ptr [ids+eax]
    cmp eax,wantedID
    je cancel_found

    mov eax,currentIndex
    inc eax
    mov currentIndex,eax

    mov eax,remaining
    dec eax
    mov remaining,eax
    jmp find_cancel

cancel_found:
    mov eax,recCount
    dec eax
    cmp currentIndex,eax
    jae cancel_last

    mov eax,currentIndex
    inc eax
    mov sourceIndex,eax
    mov eax,currentIndex
    mov destinationIndex,eax

shift_records:
    mov eax,sourceIndex
    mov ebx,eax
    mov eax,recCount
    dec eax
    cmp ebx,eax
    ja shift_finished

    invoke CopyRecord,sourceIndex,destinationIndex

    mov eax,sourceIndex
    inc eax
    mov sourceIndex,eax

    mov eax,destinationIndex
    inc eax
    mov destinationIndex,eax
    jmp shift_records

shift_finished:
cancel_last:
    dec recCount
    mov eax,recCount
    invoke ClearRecord,eax
    invoke SetWindowTextA,hEditID,NULL
    invoke SetWindowTextA,hDetailsBox,NULL
    call RefreshList
    invoke MessageBoxA,hMainWnd,ADDR msgCancelled,ADDR txtCancel,MB_OK or MB_ICONINFORMATION
    ret

cancel_fail:
    invoke MessageBoxA,hMainWnd,ADDR msgNotFound,ADDR txtCancel,MB_OK or MB_ICONWARNING
    ret
CancelAppointment ENDP

MoveAppointment PROC
    LOCAL currentIndex:DWORD
    LOCAL remaining:DWORD
    LOCAL wantedID:DWORD

    ; Dean selects an appointment ID, then changes Date and Time fields.
    invoke GetWindowTextA,hEditID,ADDR inputID,16
    call ParseID
    cmp eax,0
    je move_fail

    mov wantedID,eax
    mov currentIndex,0
    mov eax,recCount
    mov remaining,eax

find_move:
    cmp remaining,0
    je move_fail

    mov eax,currentIndex
    movzx eax,byte ptr [ids+eax]
    cmp eax,wantedID
    je move_found

    mov eax,currentIndex
    inc eax
    mov currentIndex,eax

    mov eax,remaining
    dec eax
    mov remaining,eax
    jmp find_move

move_found:
    invoke GetWindowTextA,hEditDate,ADDR inputDate,32
    invoke GetWindowTextA,hEditTime,ADDR inputTime,32
    invoke lstrlenA,ADDR inputDate
    cmp eax,0
    je move_invalid
    invoke lstrlenA,ADDR inputTime
    cmp eax,0
    je move_invalid

    invoke ValidateDate, ADDR inputDate
    cmp eax,0
    je move_invalid_date

    invoke ValidateTime, ADDR inputTime
    cmp eax,1
    je move_time_ok
    cmp eax,2
    je move_invalid_time_range
    jmp move_invalid_time

move_time_ok:
    mov eax,currentIndex
    mov ebx,DATE_LEN+1
    mul ebx
    mov edi,OFFSET dates
    add edi,eax
    invoke lstrcpynA,edi,ADDR inputDate,DATE_LEN+1

    mov eax,currentIndex
    mov ebx,TIME_LEN+1
    mul ebx
    mov edi,OFFSET times
    add edi,eax
    invoke lstrcpynA,edi,ADDR inputTime,TIME_LEN+1

    call RefreshList
    invoke ShowRecord,currentIndex
    invoke MessageBoxA,hMainWnd,ADDR msgMoved,ADDR txtMove,MB_OK or MB_ICONINFORMATION
    ret

move_invalid_date:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalidDate,ADDR txtMove,MB_OK or MB_ICONWARNING
    ret

move_invalid_time:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalidTime,ADDR txtMove,MB_OK or MB_ICONWARNING
    ret

move_invalid_time_range:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalidTimeRange,ADDR txtMove,MB_OK or MB_ICONWARNING
    ret

move_invalid:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalid,ADDR txtMove,MB_OK or MB_ICONWARNING
    ret

move_fail:
    invoke MessageBoxA,hMainWnd,ADDR msgNotFound,ADDR txtMove,MB_OK or MB_ICONWARNING
    ret
MoveAppointment ENDP

; ============================================================
; ShowStudentFCFS - displays the shared appointment list area
; sorted by appointment date, then time, then Appointment ID
; (tie-breaker). Does not create a second list; it replaces the
; contents of the same hList control the Dean queue view uses.
; ============================================================
ShowStudentFCFS PROC
    LOCAL currentIndex:DWORD
    LOCAL remaining:DWORD
    LOCAL recordIdx:DWORD

    mov isFcfsViewActive, TRUE
    invoke SetWindowTextA,hHdrQueue,ADDR msgStudentFCFSTitle

    invoke SendMessageA,hList,LB_RESETCONTENT,0,0

    mov eax,recCount
    mov remaining,eax
    mov currentIndex,0

    cmp eax,0
    jne fcfs_have_records

    invoke SendMessageA,hList,LB_ADDSTRING,0,ADDR msgNoRecords
    invoke SetWindowTextA,hStatus,ADDR msgNoRecords
    ret

fcfs_have_records:
    call SortFCFS

student_fcfs_loop:
    mov ecx, currentIndex
    movzx eax, byte ptr [sortIndex+ecx]
    mov recordIdx, eax

    ; ID
    invoke lstrcpyA,ADDR listBuf,ADDR prefixID
    mov eax,recordIdx
    movzx eax,byte ptr [ids+eax]
    invoke NumberToText,eax,ADDR numBuf
    invoke lstrcatA,ADDR listBuf,ADDR numBuf

    ; Student name
    invoke lstrcatA,ADDR listBuf,ADDR prefixName
    mov eax,recordIdx
    mov ebx,NAME_LEN+1
    mul ebx
    mov edx,OFFSET names
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    ; Date
    invoke lstrcatA,ADDR listBuf,ADDR prefixDate
    mov eax,recordIdx
    mov ebx,DATE_LEN+1
    mul ebx
    mov edx,OFFSET dates
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    ; Time
    invoke lstrcatA,ADDR listBuf,ADDR prefixTime
    mov eax,recordIdx
    mov ebx,TIME_LEN+1
    mul ebx
    mov edx,OFFSET times
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    ; Purpose
    invoke lstrcatA,ADDR listBuf,ADDR prefixPurpose
    mov eax,recordIdx
    mov ebx,PURPOSE_LEN+1
    mul ebx
    mov edx,OFFSET purposes
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    ; Status
    invoke lstrcatA,ADDR listBuf,ADDR prefixStatus
    mov eax,recordIdx
    movzx eax,byte ptr [statuses+eax]
    cmp eax,0
    jne student_fcfs_accepted

    invoke lstrcatA,ADDR listBuf,ADDR statusWaiting
    jmp student_fcfs_add

student_fcfs_accepted:
    invoke lstrcatA,ADDR listBuf,ADDR statusAccepted

student_fcfs_add:
    invoke SendMessageA,hList,LB_ADDSTRING,0,ADDR listBuf

    mov eax,currentIndex
    inc eax
    mov currentIndex,eax

    mov eax,remaining
    dec eax
    mov remaining,eax

    cmp eax,0
    jne student_fcfs_loop

student_fcfs_finished:
    invoke SetWindowTextA,hStatus,ADDR msgStudentFCFSTitle
    ret
ShowStudentFCFS ENDP

MarkDone PROC
    LOCAL currentIndex:DWORD
    LOCAL remaining:DWORD
    LOCAL wantedID:DWORD
    LOCAL sourceIndex:DWORD
    LOCAL destinationIndex:DWORD

    invoke GetWindowTextA,hEditID,ADDR inputID,16
    call ParseID
    cmp eax,0
    je done_fail

    mov wantedID,eax
    mov currentIndex,0
    mov eax,recCount
    mov remaining,eax

done_find:
    cmp remaining,0
    je done_fail

    mov eax,currentIndex
    movzx eax,byte ptr [ids+eax]
    cmp eax,wantedID
    je done_found

    mov eax,currentIndex
    inc eax
    mov currentIndex,eax

    mov eax,remaining
    dec eax
    mov remaining,eax
    jmp done_find

done_found:
    mov eax,recCount
    dec eax
    cmp currentIndex,eax
    jae done_last

    mov eax,currentIndex
    inc eax
    mov sourceIndex,eax
    mov eax,currentIndex
    mov destinationIndex,eax

done_shift:
    mov eax,sourceIndex
    mov ebx,eax
    mov eax,recCount
    cmp ebx,eax
    jae done_last

    invoke CopyRecord,sourceIndex,destinationIndex

    mov eax,sourceIndex
    inc eax
    mov sourceIndex,eax

    mov eax,destinationIndex
    inc eax
    mov destinationIndex,eax
    jmp done_shift

done_last:
    dec recCount
    mov eax,recCount
    invoke ClearRecord,eax

    ; Renumber the active queue 1..recCount.
    mov currentIndex,0
    mov eax,recCount
    mov remaining,eax
    mov ebx,1

renumber_done_queue:
    cmp remaining,0
    je done_refresh
    mov eax,currentIndex
    mov [ids+eax],bl
    inc ebx

    mov eax,currentIndex
    inc eax
    mov currentIndex,eax

    mov eax,remaining
    dec eax
    mov remaining,eax
    jmp renumber_done_queue

done_refresh:
    invoke SetWindowTextA,hEditID,NULL
    invoke SetWindowTextA,hDetailsBox,NULL
    call RefreshList
    invoke MessageBoxA,hMainWnd,ADDR msgDone,ADDR txtDone,MB_OK or MB_ICONINFORMATION
    ret

done_fail:
    invoke MessageBoxA,hMainWnd,ADDR msgDoneFail,ADDR txtDone,MB_OK or MB_ICONWARNING
    ret
MarkDone ENDP

CheckMyStatus PROC
    LOCAL currentIndex:DWORD
    LOCAL remaining:DWORD
    LOCAL wantedID:DWORD

    invoke GetWindowTextA,hEditID,ADDR inputID,16
    call ParseID
    cmp eax,0
    je check_not_found

    mov wantedID,eax
    mov currentIndex,0
    mov eax,recCount
    mov remaining,eax

check_find:
    cmp remaining,0
    je check_not_found

    mov eax,currentIndex
    movzx eax,byte ptr [ids+eax]
    cmp eax,wantedID
    je check_found

    mov eax,currentIndex
    inc eax
    mov currentIndex,eax

    mov eax,remaining
    dec eax
    mov remaining,eax
    jmp check_find

check_found:
    invoke ShowRecord,currentIndex
    mov eax,currentIndex
    movzx eax,byte ptr [statuses+eax]
    cmp eax,0
    jne check_done

    invoke SetWindowTextA,hStatus,ADDR msgStatusFound
    invoke MessageBoxA,hMainWnd,ADDR msgStatusWaiting,ADDR txtCheck,MB_OK or MB_ICONINFORMATION
    ret

check_done:
    invoke SetWindowTextA,hStatus,ADDR msgStatusDone
    invoke MessageBoxA,hMainWnd,ADDR msgStatusDone,ADDR txtCheck,MB_OK or MB_ICONINFORMATION
    ret

check_not_found:
    invoke MessageBoxA,hMainWnd,ADDR msgStatusNotFound,ADDR txtCheck,MB_OK or MB_ICONWARNING
    ret
CheckMyStatus ENDP

CopyRecord PROC sourceIndex:DWORD,destinationIndex:DWORD
    mov eax,sourceIndex
    mov dl,[ids+eax]
    mov eax,destinationIndex
    mov [ids+eax],dl

    mov eax,sourceIndex
    mov dl,[statuses+eax]
    mov eax,destinationIndex
    mov [statuses+eax],dl

    mov eax,sourceIndex
    mov ebx,NAME_LEN+1
    mul ebx
    mov esi,OFFSET names
    add esi,eax
    mov eax,destinationIndex
    mov ebx,NAME_LEN+1
    mul ebx
    mov edi,OFFSET names
    add edi,eax
    invoke lstrcpynA,edi,esi,NAME_LEN+1

    mov eax,sourceIndex
    mov ebx,DATE_LEN+1
    mul ebx
    mov esi,OFFSET dates
    add esi,eax
    mov eax,destinationIndex
    mov ebx,DATE_LEN+1
    mul ebx
    mov edi,OFFSET dates
    add edi,eax
    invoke lstrcpynA,edi,esi,DATE_LEN+1

    mov eax,sourceIndex
    mov ebx,TIME_LEN+1
    mul ebx
    mov esi,OFFSET times
    add esi,eax
    mov eax,destinationIndex
    mov ebx,TIME_LEN+1
    mul ebx
    mov edi,OFFSET times
    add edi,eax
    invoke lstrcpynA,edi,esi,TIME_LEN+1

    mov eax,sourceIndex
    mov ebx,PURPOSE_LEN+1
    mul ebx
    mov esi,OFFSET purposes
    add esi,eax
    mov eax,destinationIndex
    mov ebx,PURPOSE_LEN+1
    mul ebx
    mov edi,OFFSET purposes
    add edi,eax
    invoke lstrcpynA,edi,esi,PURPOSE_LEN+1
    ret
CopyRecord ENDP

ClearRecord PROC index:DWORD
    mov eax,index
    mov byte ptr [ids+eax],0
    mov byte ptr [statuses+eax],0

    mov eax,index
    mov ebx,NAME_LEN+1
    mul ebx
    mov edi,OFFSET names
    add edi,eax
    mov ecx,NAME_LEN+1
    xor eax,eax
    rep stosb

    mov eax,index
    mov ebx,DATE_LEN+1
    mul ebx
    mov edi,OFFSET dates
    add edi,eax
    mov ecx,DATE_LEN+1
    xor eax,eax
    rep stosb

    mov eax,index
    mov ebx,TIME_LEN+1
    mul ebx
    mov edi,OFFSET times
    add edi,eax
    mov ecx,TIME_LEN+1
    xor eax,eax
    rep stosb

    mov eax,index
    mov ebx,PURPOSE_LEN+1
    mul ebx
    mov edi,OFFSET purposes
    add edi,eax
    mov ecx,PURPOSE_LEN+1
    xor eax,eax
    rep stosb
    ret
ClearRecord ENDP

ParseID PROC
    xor eax,eax
    mov esi,OFFSET inputID
parse_loop:
    mov dl,[esi]
    cmp dl,0
    je parse_done
    cmp dl,'0'
    jb parse_bad
    cmp dl,'9'
    ja parse_bad
    imul eax,10
    sub dl,'0'
    movzx edx,dl
    add eax,edx
    inc esi
    jmp parse_loop
parse_bad:
    xor eax,eax
parse_done:
    ret
ParseID ENDP

NumberToText PROC value:DWORD,destination:DWORD
    push ebx
    push ecx
    push edx
    push edi

    mov eax,value
    mov edi,destination
    xor ecx,ecx
    cmp eax,0
    jne number_convert
    mov byte ptr [edi],'0'
    mov byte ptr [edi+1],0
    jmp number_done

number_convert:
    mov ebx,10
number_divide:
    xor edx,edx
    div ebx
    push edx
    inc ecx
    cmp eax,0
    jne number_divide

number_write:
    pop edx
    add dl,'0'
    mov [edi],dl
    inc edi
    loop number_write
    mov byte ptr [edi],0

number_done:
    pop edi
    pop edx
    pop ecx
    pop ebx
    ret
NumberToText ENDP

; ============================================================
; PadNumber2 - writes value (0-99) as a zero-padded 2 digit
; ASCII string (plus null terminator) to destination.
; ============================================================
PadNumber2 PROC value:DWORD, destination:DWORD
    push ebx
    push ecx
    push edx

    mov eax, value
    xor edx, edx
    mov ebx, 10
    div ebx
    mov ecx, destination
    add al, '0'
    mov [ecx], al
    mov al, dl
    add al, '0'
    mov [ecx+1], al
    mov byte ptr [ecx+2], 0

    pop edx
    pop ecx
    pop ebx
    ret
PadNumber2 ENDP

; ============================================================
; UpdateClock - reads the current local date/time from Windows
; and displays it on the dashboard clock control. Called once
; at startup and once per second via WM_TIMER.
; ============================================================
UpdateClock PROC
    LOCAL curTime:SYSTEMTIME

    invoke GetLocalTime, ADDR curTime

    invoke lstrcpyA, ADDR clockBuf, ADDR clockPrefix

    movzx eax, curTime.wMonth
    invoke PadNumber2, eax, ADDR clockNumBuf
    invoke lstrcatA, ADDR clockBuf, ADDR clockNumBuf
    invoke lstrcatA, ADDR clockBuf, ADDR sepSlash

    movzx eax, curTime.wDay
    invoke PadNumber2, eax, ADDR clockNumBuf
    invoke lstrcatA, ADDR clockBuf, ADDR clockNumBuf
    invoke lstrcatA, ADDR clockBuf, ADDR sepSlash

    movzx eax, curTime.wYear
    invoke NumberToText, eax, ADDR clockNumBuf
    invoke lstrcatA, ADDR clockBuf, ADDR clockNumBuf
    invoke lstrcatA, ADDR clockBuf, ADDR sepSpace

    movzx eax, curTime.wHour
    invoke PadNumber2, eax, ADDR clockNumBuf
    invoke lstrcatA, ADDR clockBuf, ADDR clockNumBuf
    invoke lstrcatA, ADDR clockBuf, ADDR sepColon

    movzx eax, curTime.wMinute
    invoke PadNumber2, eax, ADDR clockNumBuf
    invoke lstrcatA, ADDR clockBuf, ADDR clockNumBuf
    invoke lstrcatA, ADDR clockBuf, ADDR sepColon

    movzx eax, curTime.wSecond
    invoke PadNumber2, eax, ADDR clockNumBuf
    invoke lstrcatA, ADDR clockBuf, ADDR clockNumBuf

    invoke SetWindowTextA, hClockDisplay, ADDR clockBuf
    ret
UpdateClock ENDP

; ============================================================
; ValidateDate - validates a "MM/DD/YYYY" string (as produced
; by the masked Date field). Returns eax=1 if the date is a
; real calendar date with year 2026 or later; eax=0 otherwise.
; Rejects incomplete masks, bad separators, month outside
; 1-12, day outside the valid range for that month, and
; correctly accounts for leap years in February.
; ============================================================
ValidateDate PROC dateStr:DWORD
    LOCAL month:DWORD
    LOCAL day:DWORD
    LOCAL year:DWORD
    LOCAL maxDay:DWORD

    invoke lstrlenA, dateStr
    cmp eax, 10
    jne validate_date_fail

    mov esi, dateStr
    mov al, [esi+2]
    cmp al, '/'
    jne validate_date_fail
    mov al, [esi+5]
    cmp al, '/'
    jne validate_date_fail

    ; Month digits at offsets 0,1
    movzx eax, byte ptr [esi]
    cmp eax,'0'
    jb validate_date_fail
    cmp eax,'9'
    ja validate_date_fail
    sub eax,'0'
    mov ebx, eax
    movzx eax, byte ptr [esi+1]
    cmp eax,'0'
    jb validate_date_fail
    cmp eax,'9'
    ja validate_date_fail
    sub eax,'0'
    imul ebx,10
    add ebx,eax
    mov month, ebx

    ; Day digits at offsets 3,4
    movzx eax, byte ptr [esi+3]
    cmp eax,'0'
    jb validate_date_fail
    cmp eax,'9'
    ja validate_date_fail
    sub eax,'0'
    mov ebx, eax
    movzx eax, byte ptr [esi+4]
    cmp eax,'0'
    jb validate_date_fail
    cmp eax,'9'
    ja validate_date_fail
    sub eax,'0'
    imul ebx,10
    add ebx,eax
    mov day, ebx

    ; Year digits at offsets 6,7,8,9
    xor ebx,ebx
    mov ecx,6
year_loop:
    movzx eax, byte ptr [esi+ecx]
    cmp eax,'0'
    jb validate_date_fail
    cmp eax,'9'
    ja validate_date_fail
    sub eax,'0'
    imul ebx,10
    add ebx,eax
    inc ecx
    cmp ecx,10
    jne year_loop
    mov year, ebx

    mov eax, year
    cmp eax, 2026
    jl validate_date_fail

    mov eax, month
    cmp eax, 1
    jl validate_date_fail
    cmp eax, 12
    jg validate_date_fail

    mov eax, day
    cmp eax, 1
    jl validate_date_fail

    mov eax, month
    cmp eax,1
    je vdate_month_31
    cmp eax,3
    je vdate_month_31
    cmp eax,5
    je vdate_month_31
    cmp eax,7
    je vdate_month_31
    cmp eax,8
    je vdate_month_31
    cmp eax,10
    je vdate_month_31
    cmp eax,12
    je vdate_month_31
    cmp eax,4
    je vdate_month_30
    cmp eax,6
    je vdate_month_30
    cmp eax,9
    je vdate_month_30
    cmp eax,11
    je vdate_month_30
    jmp vdate_month_feb

vdate_month_31:
    mov maxDay,31
    jmp vdate_check_day

vdate_month_30:
    mov maxDay,30
    jmp vdate_check_day

vdate_month_feb:
    mov eax, year
    xor edx,edx
    mov ecx,4
    div ecx
    cmp edx,0
    jne vdate_feb_not_leap

    mov eax, year
    xor edx,edx
    mov ecx,100
    div ecx
    cmp edx,0
    jne vdate_feb_leap

    mov eax, year
    xor edx,edx
    mov ecx,400
    div ecx
    cmp edx,0
    jne vdate_feb_not_leap

vdate_feb_leap:
    mov maxDay,29
    jmp vdate_check_day

vdate_feb_not_leap:
    mov maxDay,28

vdate_check_day:
    mov eax, day
    cmp eax, maxDay
    jg validate_date_fail

    mov eax,1
    ret

validate_date_fail:
    xor eax,eax
    ret
ValidateDate ENDP

; ============================================================
; TimeToMinutes - converts a 12-hour clock reading (hourVal
; 1-12, minuteVal 0/30, ampmChar 'A' or 'P') into minutes-since-
; midnight (0-1439), for chronological comparison.
; ============================================================
TimeToMinutes PROC hourVal:DWORD, minuteVal:DWORD, ampmChar:DWORD
    mov ecx, hourVal
    mov eax, ampmChar
    cmp eax, 'A'
    jne ttm_pm

    cmp ecx, 12
    jne ttm_combine
    mov ecx, 0
    jmp ttm_combine

ttm_pm:
    cmp ecx, 12
    je ttm_combine
    add ecx, 12

ttm_combine:
    mov eax, ecx
    imul eax, 60
    add eax, minuteVal
    ret
TimeToMinutes ENDP

; ============================================================
; ValidateTime - validates a "hh:mm AM - hh:mm AM" (or PM)
; START/END range string, as produced by the masked Time field.
; Requires both hours 1-12, both minutes 00 or 30 only (30-
; minute increments), and the end time strictly later than the
; start time.
; Returns eax=1 if valid.
; Returns eax=0 if the format/interval is invalid (bad mask,
; bad hour, or a minute other than :00/:30).
; Returns eax=2 if the format is fine but the end time is not
; later than the start time.
; ============================================================
ValidateTime PROC timeStr:DWORD
    LOCAL sHour:DWORD
    LOCAL sMin:DWORD
    LOCAL sAmpm:DWORD
    LOCAL eHour:DWORD
    LOCAL eMin:DWORD
    LOCAL eAmpm:DWORD
    LOCAL startVal:DWORD
    LOCAL endVal:DWORD

    invoke lstrlenA, timeStr
    cmp eax, 19
    jne vtime_fail

    mov esi, timeStr

    ; Fixed literal positions
    mov al, [esi+2]
    cmp al, ':'
    jne vtime_fail
    mov al, [esi+5]
    cmp al, ' '
    jne vtime_fail
    mov al, [esi+7]
    cmp al, 'M'
    jne vtime_fail
    mov al, [esi+8]
    cmp al, ' '
    jne vtime_fail
    mov al, [esi+9]
    cmp al, '-'
    jne vtime_fail
    mov al, [esi+10]
    cmp al, ' '
    jne vtime_fail
    mov al, [esi+13]
    cmp al, ':'
    jne vtime_fail
    mov al, [esi+16]
    cmp al, ' '
    jne vtime_fail
    mov al, [esi+18]
    cmp al, 'M'
    jne vtime_fail

    ; Start hour digits at offsets 0,1
    movzx eax, byte ptr [esi]
    cmp eax,'0'
    jb vtime_fail
    cmp eax,'9'
    ja vtime_fail
    sub eax,'0'
    mov ebx, eax
    movzx eax, byte ptr [esi+1]
    cmp eax,'0'
    jb vtime_fail
    cmp eax,'9'
    ja vtime_fail
    sub eax,'0'
    imul ebx,10
    add ebx,eax
    mov sHour, ebx

    ; Start minute digits at offsets 3,4
    movzx eax, byte ptr [esi+3]
    cmp eax,'0'
    jb vtime_fail
    cmp eax,'9'
    ja vtime_fail
    sub eax,'0'
    mov ebx, eax
    movzx eax, byte ptr [esi+4]
    cmp eax,'0'
    jb vtime_fail
    cmp eax,'9'
    ja vtime_fail
    sub eax,'0'
    imul ebx,10
    add ebx,eax
    mov sMin, ebx

    ; Start AM/PM letter at offset 6
    movzx eax, byte ptr [esi+6]
    cmp eax,'A'
    je vtime_s_ampm_ok
    cmp eax,'P'
    je vtime_s_ampm_ok
    jmp vtime_fail
vtime_s_ampm_ok:
    mov sAmpm, eax

    ; End hour digits at offsets 11,12
    movzx eax, byte ptr [esi+11]
    cmp eax,'0'
    jb vtime_fail
    cmp eax,'9'
    ja vtime_fail
    sub eax,'0'
    mov ebx, eax
    movzx eax, byte ptr [esi+12]
    cmp eax,'0'
    jb vtime_fail
    cmp eax,'9'
    ja vtime_fail
    sub eax,'0'
    imul ebx,10
    add ebx,eax
    mov eHour, ebx

    ; End minute digits at offsets 14,15
    movzx eax, byte ptr [esi+14]
    cmp eax,'0'
    jb vtime_fail
    cmp eax,'9'
    ja vtime_fail
    sub eax,'0'
    mov ebx, eax
    movzx eax, byte ptr [esi+15]
    cmp eax,'0'
    jb vtime_fail
    cmp eax,'9'
    ja vtime_fail
    sub eax,'0'
    imul ebx,10
    add ebx,eax
    mov eMin, ebx

    ; End AM/PM letter at offset 17
    movzx eax, byte ptr [esi+17]
    cmp eax,'A'
    je vtime_e_ampm_ok
    cmp eax,'P'
    je vtime_e_ampm_ok
    jmp vtime_fail
vtime_e_ampm_ok:
    mov eAmpm, eax

    ; Hours must be 1-12
    mov eax, sHour
    cmp eax, 1
    jl vtime_fail
    cmp eax, 12
    jg vtime_fail

    mov eax, eHour
    cmp eax, 1
    jl vtime_fail
    cmp eax, 12
    jg vtime_fail

    ; Minutes must be exactly 00 or 30 (30-minute intervals only)
    mov eax, sMin
    cmp eax, 0
    je vtime_smin_ok
    cmp eax, 30
    je vtime_smin_ok
    jmp vtime_fail
vtime_smin_ok:

    mov eax, eMin
    cmp eax, 0
    je vtime_emin_ok
    cmp eax, 30
    je vtime_emin_ok
    jmp vtime_fail
vtime_emin_ok:

    invoke TimeToMinutes, sHour, sMin, sAmpm
    mov startVal, eax
    invoke TimeToMinutes, eHour, eMin, eAmpm
    mov endVal, eax

    mov eax, endVal
    cmp eax, startVal
    jg vtime_ok

    mov eax, 2
    ret

vtime_ok:
    mov eax,1
    ret

vtime_fail:
    xor eax,eax
    ret
ValidateTime ENDP

; ============================================================
; GetDateValue - parses record recIndex's stored "MM/DD/YYYY"
; date into a single comparable integer: year*10000 + month*100
; + day. Used only for FCFS sorting; the date is assumed to
; already be valid (checked by ValidateDate at entry time).
; ============================================================
GetDateValue PROC recIndex:DWORD
    mov eax, recIndex
    mov ebx, DATE_LEN+1
    mul ebx
    mov esi, OFFSET dates
    add esi, eax

    movzx eax, byte ptr [esi]
    sub eax,'0'
    mov ecx,eax
    movzx eax, byte ptr [esi+1]
    sub eax,'0'
    imul ecx,10
    add ecx,eax          ; ecx = month

    movzx eax, byte ptr [esi+3]
    sub eax,'0'
    mov ebx,eax
    movzx eax, byte ptr [esi+4]
    sub eax,'0'
    imul ebx,10
    add ebx,eax           ; ebx = day

    xor edx,edx
    movzx eax, byte ptr [esi+6]
    sub eax,'0'
    add edx,eax
    movzx eax, byte ptr [esi+7]
    sub eax,'0'
    imul edx,10
    add edx,eax
    movzx eax, byte ptr [esi+8]
    sub eax,'0'
    imul edx,10
    add edx,eax
    movzx eax, byte ptr [esi+9]
    sub eax,'0'
    imul edx,10
    add edx,eax            ; edx = year

    mov eax, edx
    imul eax, 10000
    mov edx, ecx
    imul edx, 100
    add eax, edx
    add eax, ebx
    ret
GetDateValue ENDP

; ============================================================
; GetTimeValue - parses the START time out of record recIndex's
; stored "hh:mm AM - hh:mm AM" range (the start segment occupies
; the same offsets 0,1,3,4,6 as the original single-time mask)
; into minutes-since-midnight (0-1439) for chronological
; comparison. Assumed already valid (checked by ValidateTime).
; ============================================================
GetTimeValue PROC recIndex:DWORD
    mov eax, recIndex
    mov ebx, TIME_LEN+1
    mul ebx
    mov esi, OFFSET times
    add esi, eax

    movzx eax, byte ptr [esi]
    sub eax,'0'
    mov ecx,eax
    movzx eax, byte ptr [esi+1]
    sub eax,'0'
    imul ecx,10
    add ecx,eax           ; ecx = hour12 (1-12)

    movzx eax, byte ptr [esi+3]
    sub eax,'0'
    mov ebx,eax
    movzx eax, byte ptr [esi+4]
    sub eax,'0'
    imul ebx,10
    add ebx,eax            ; ebx = minute

    movzx eax, byte ptr [esi+6]  ; 'A' or 'P'
    cmp eax,'A'
    jne gtv_pm

    cmp ecx,12
    jne gtv_combine
    mov ecx,0
    jmp gtv_combine

gtv_pm:
    cmp ecx,12
    je gtv_combine
    add ecx,12

gtv_combine:
    mov eax,ecx
    imul eax,60
    add eax,ebx
    ret
GetTimeValue ENDP

; ============================================================
; IsRecordLess - returns eax=1 if record recA should sort
; before record recB in the FCFS list (earlier date, then
; earlier time, then lower Appointment ID), else eax=0.
; ============================================================
IsRecordLess PROC recA:DWORD, recB:DWORD
    LOCAL dateA:DWORD
    LOCAL dateB:DWORD
    LOCAL timeA:DWORD
    LOCAL timeB:DWORD

    invoke GetDateValue, recA
    mov dateA, eax
    invoke GetDateValue, recB
    mov dateB, eax

    mov eax, dateA
    cmp eax, dateB
    jl isless_true
    jg isless_false

    invoke GetTimeValue, recA
    mov timeA, eax
    invoke GetTimeValue, recB
    mov timeB, eax

    mov eax, timeA
    cmp eax, timeB
    jl isless_true
    jg isless_false

    mov eax, recA
    movzx eax, byte ptr [ids+eax]
    mov ecx, recB
    movzx ecx, byte ptr [ids+ecx]
    cmp eax, ecx
    jl isless_true
    jmp isless_false

isless_true:
    mov eax,1
    ret
isless_false:
    xor eax,eax
    ret
IsRecordLess ENDP

; ============================================================
; SortFCFS - fills sortIndex[0..recCount-1] with the record
; slots 0..recCount-1 permuted into ascending FCFS order
; (date, then time, then ID). Simple selection sort - at most
; MAX_RECORDS (10) entries, so O(n^2) is more than fast enough.
; ============================================================
SortFCFS PROC
    LOCAL i:DWORD
    LOCAL j:DWORD
    LOCAL minIdx:DWORD
    LOCAL idxA:DWORD
    LOCAL idxB:DWORD
    LOCAL tmp:DWORD

    mov i,0
sort_init_loop:
    mov eax,i
    cmp eax,recCount
    jae sort_init_done
    mov edx,i
    mov [sortIndex+edx],dl
    mov eax,i
    inc eax
    mov i,eax
    jmp sort_init_loop
sort_init_done:

    mov i,0
outer_loop:
    mov eax,i
    mov ebx,recCount
    dec ebx
    cmp eax,ebx
    jge sort_done

    mov eax,i
    mov minIdx,eax

    mov eax,i
    inc eax
    mov j,eax
inner_loop:
    mov eax,j
    cmp eax,recCount
    jae inner_done

    mov ecx,j
    movzx eax, byte ptr [sortIndex+ecx]
    mov idxB, eax

    mov ecx,minIdx
    movzx eax, byte ptr [sortIndex+ecx]
    mov idxA, eax

    invoke IsRecordLess, idxB, idxA
    cmp eax,0
    je inner_no_update
    mov eax,j
    mov minIdx,eax
inner_no_update:

    mov eax,j
    inc eax
    mov j,eax
    jmp inner_loop
inner_done:

    mov eax,minIdx
    cmp eax,i
    je sort_no_swap

    mov ecx,i
    movzx eax, byte ptr [sortIndex+ecx]
    mov tmp,eax

    mov ecx,minIdx
    movzx eax, byte ptr [sortIndex+ecx]
    mov edx,i
    mov [sortIndex+edx],al

    mov ecx,minIdx
    mov eax,tmp
    mov [sortIndex+ecx],al

sort_no_swap:
    mov eax,i
    inc eax
    mov i,eax
    jmp outer_loop

sort_done:
    ret
SortFCFS ENDP

; ============================================================
; DateEditProc - subclass proc for the Appointment Date field.
; Enforces the fixed "MM/DD/YYYY" mask: only digits may be
; typed into the M/D/Y slots; the two '/' characters are
; literal and can never be entered, removed, or shifted.
; ============================================================
DateEditProc PROC hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    LOCAL selStart:DWORD
    LOCAL pos:DWORD

    cmp uMsg, WM_CHAR
    je date_char
    cmp uMsg, WM_KEYDOWN
    je date_keydown

    invoke CallWindowProcA, oldDateEditProc, hWnd, uMsg, wParam, lParam
    ret

date_char:
    mov eax, wParam
    cmp eax, 8
    je date_backspace
    cmp eax, '0'
    jb date_char_block
    cmp eax, '9'
    ja date_char_block

    ; Digit typed - find the next available digit slot at/after the caret.
    invoke SendMessageA, hWnd, EM_GETSEL, 0, 0
    and eax, 0FFFFh
    mov selStart, eax

    mov eax, selStart
find_digit_fwd_date:
    cmp eax, 10
    jae date_char_block
    mov edx, OFFSET dateTemplate
    add edx, eax
    mov cl, [edx]
    cmp cl, '/'
    jne found_digit_fwd_date
    inc eax
    jmp find_digit_fwd_date
found_digit_fwd_date:
    mov pos, eax

    invoke GetWindowTextA, hWnd, ADDR dateEditBuf, 16
    mov edi, OFFSET dateEditBuf
    mov eax, pos
    add edi, eax
    mov eax, wParam
    mov [edi], al

    invoke SetWindowTextA, hWnd, ADDR dateEditBuf

    mov eax, pos
    inc eax
skip_lit_fwd_date:
    cmp eax, 10
    jae set_caret_date
    mov edx, OFFSET dateTemplate
    add edx, eax
    mov cl, [edx]
    cmp cl, '/'
    jne set_caret_date
    inc eax
    jmp skip_lit_fwd_date
set_caret_date:
    invoke SendMessageA, hWnd, EM_SETSEL, eax, eax
    xor eax, eax
    ret

date_char_block:
    xor eax, eax
    ret

date_backspace:
    invoke SendMessageA, hWnd, EM_GETSEL, 0, 0
    and eax, 0FFFFh
    mov selStart, eax
    cmp selStart, 0
    je date_char_block

    mov eax, selStart
    dec eax
skip_lit_back_date:
    cmp eax, 0
    jle found_back_date
    mov edx, OFFSET dateTemplate
    add edx, eax
    mov cl, [edx]
    cmp cl, '/'
    jne found_back_date
    dec eax
    jmp skip_lit_back_date
found_back_date:
    mov pos, eax

    invoke GetWindowTextA, hWnd, ADDR dateEditBuf, 16
    mov edi, OFFSET dateEditBuf
    mov eax, pos
    add edi, eax
    mov edx, OFFSET dateTemplate
    add edx, pos
    mov cl, [edx]
    mov [edi], cl

    invoke SetWindowTextA, hWnd, ADDR dateEditBuf
    invoke SendMessageA, hWnd, EM_SETSEL, pos, pos
    xor eax, eax
    ret

date_keydown:
    mov eax, wParam
    cmp eax, VK_DELETE
    je date_delete
    invoke CallWindowProcA, oldDateEditProc, hWnd, uMsg, wParam, lParam
    ret

date_delete:
    invoke SendMessageA, hWnd, EM_GETSEL, 0, 0
    and eax, 0FFFFh
    mov pos, eax
    cmp pos, 10
    jae date_char_block

    mov edx, OFFSET dateTemplate
    add edx, pos
    mov cl, [edx]
    cmp cl, '/'
    je date_char_block

    invoke GetWindowTextA, hWnd, ADDR dateEditBuf, 16
    mov edi, OFFSET dateEditBuf
    mov eax, pos
    add edi, eax
    mov [edi], cl
    invoke SetWindowTextA, hWnd, ADDR dateEditBuf
    invoke SendMessageA, hWnd, EM_SETSEL, pos, pos
    xor eax, eax
    ret
DateEditProc ENDP

; ============================================================
; TimeEditProc - subclass proc for the Appointment Time field.
; Enforces the fixed START/END range mask
; "00:00 AM - 00:00 AM" (19 chars) - two copies of the original
; single-time mask ("00:00 AM") joined by a fixed " - " literal:
;   0,1   = start hour tens/ones digit
;   2     = ':' (literal)
;   3,4   = start minute tens/ones digit
;   5     = ' ' (literal)
;   6     = start AM/PM letter (typed via the A or P key)
;   7     = 'M' (literal)
;   8,9,10= ' ','-',' ' (literal, fixed separator)
;   11,12 = end hour tens/ones digit
;   13    = ':' (literal)
;   14,15 = end minute tens/ones digit
;   16    = ' ' (literal)
;   17    = end AM/PM letter (typed via the A or P key)
;   18    = 'M' (literal)
; Only digits are accepted at 0,1,3,4,11,12,14,15; only the
; letters A/P are accepted landing on 6 or 17. Backspace/Delete
; reset a slot to its placeholder instead of shifting the fixed
; layout. Digit slots always hold two digits (hour is always
; shown zero-padded, e.g. 09:00 AM), and the actual 30-minute-
; interval / start-before-end rules are enforced separately by
; ValidateTime when the appointment is submitted.
; ============================================================
TimeEditProc PROC hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    LOCAL selStart:DWORD
    LOCAL pos:DWORD

    cmp uMsg, WM_CHAR
    je time_char
    cmp uMsg, WM_KEYDOWN
    je time_keydown

    invoke CallWindowProcA, oldTimeEditProc, hWnd, uMsg, wParam, lParam
    ret

time_char:
    mov eax, wParam
    cmp eax, 8
    je time_backspace

    cmp eax, 'a'
    je time_letter_a
    cmp eax, 'A'
    je time_letter_a
    cmp eax, 'p'
    je time_letter_p
    cmp eax, 'P'
    je time_letter_p

    cmp eax, '0'
    jb time_char_block
    cmp eax, '9'
    ja time_char_block

    ; Digit typed - only valid landing on the hour/minute slots
    ; (0,1,3,4 for start; 11,12,14,15 for end). Caret positions
    ; that fall on the ':' separators are redirected forward to
    ; the next digit slot.
    invoke SendMessageA, hWnd, EM_GETSEL, 0, 0
    and eax, 0FFFFh
    mov selStart, eax

    cmp selStart, 2
    jne tc_remap13
    mov selStart, 3
tc_remap13:
    cmp selStart, 13
    jne tc_checkvalid
    mov selStart, 14
tc_checkvalid:
    cmp selStart, 0
    je time_digit_place
    cmp selStart, 1
    je time_digit_place
    cmp selStart, 3
    je time_digit_place
    cmp selStart, 4
    je time_digit_place
    cmp selStart, 11
    je time_digit_place
    cmp selStart, 12
    je time_digit_place
    cmp selStart, 14
    je time_digit_place
    cmp selStart, 15
    je time_digit_place
    jmp time_char_block

time_digit_place:
    mov eax, selStart
    mov pos, eax

    invoke GetWindowTextA, hWnd, ADDR timeEditBuf, 24
    mov edi, OFFSET timeEditBuf
    mov eax, pos
    add edi, eax
    mov eax, wParam
    mov [edi], al
    invoke SetWindowTextA, hWnd, ADDR timeEditBuf

    ; Advance caret past any fixed literal(s) that follow.
    mov eax, pos
    inc eax
    cmp eax, 2
    jne tc_adv_chk5
    mov eax, 3
tc_adv_chk5:
    cmp eax, 5
    jne tc_adv_chk13
    mov eax, 6
tc_adv_chk13:
    cmp eax, 13
    jne tc_adv_chk16
    mov eax, 14
tc_adv_chk16:
    cmp eax, 16
    jne tc_adv_setcaret
    mov eax, 17
tc_adv_setcaret:
    invoke SendMessageA, hWnd, EM_SETSEL, eax, eax
    xor eax, eax
    ret

time_letter_a:
    invoke SendMessageA, hWnd, EM_GETSEL, 0, 0
    and eax, 0FFFFh
    cmp eax, 5
    je ta_start_ok
    cmp eax, 6
    je ta_start_ok
    cmp eax, 16
    je ta_end_ok
    cmp eax, 17
    je ta_end_ok
    jmp time_char_block
ta_start_ok:
    invoke GetWindowTextA, hWnd, ADDR timeEditBuf, 24
    mov edi, OFFSET timeEditBuf
    add edi, 6
    mov byte ptr [edi], 'A'
    invoke SetWindowTextA, hWnd, ADDR timeEditBuf
    invoke SendMessageA, hWnd, EM_SETSEL, 11, 11
    xor eax, eax
    ret
ta_end_ok:
    invoke GetWindowTextA, hWnd, ADDR timeEditBuf, 24
    mov edi, OFFSET timeEditBuf
    add edi, 17
    mov byte ptr [edi], 'A'
    invoke SetWindowTextA, hWnd, ADDR timeEditBuf
    invoke SendMessageA, hWnd, EM_SETSEL, 19, 19
    xor eax, eax
    ret

time_letter_p:
    invoke SendMessageA, hWnd, EM_GETSEL, 0, 0
    and eax, 0FFFFh
    cmp eax, 5
    je tp_start_ok
    cmp eax, 6
    je tp_start_ok
    cmp eax, 16
    je tp_end_ok
    cmp eax, 17
    je tp_end_ok
    jmp time_char_block
tp_start_ok:
    invoke GetWindowTextA, hWnd, ADDR timeEditBuf, 24
    mov edi, OFFSET timeEditBuf
    add edi, 6
    mov byte ptr [edi], 'P'
    invoke SetWindowTextA, hWnd, ADDR timeEditBuf
    invoke SendMessageA, hWnd, EM_SETSEL, 11, 11
    xor eax, eax
    ret
tp_end_ok:
    invoke GetWindowTextA, hWnd, ADDR timeEditBuf, 24
    mov edi, OFFSET timeEditBuf
    add edi, 17
    mov byte ptr [edi], 'P'
    invoke SetWindowTextA, hWnd, ADDR timeEditBuf
    invoke SendMessageA, hWnd, EM_SETSEL, 19, 19
    xor eax, eax
    ret

time_char_block:
    xor eax, eax
    ret

time_backspace:
    invoke SendMessageA, hWnd, EM_GETSEL, 0, 0
    and eax, 0FFFFh
    mov selStart, eax
    cmp selStart, 0
    je time_char_block

    ; Map (selStart-1) back to the nearest editable slot at or
    ; before it, skipping over any run of fixed literals.
    mov eax, selStart
    dec eax
    cmp eax, 18
    jne tb_chk16
    mov eax, 17
tb_chk16:
    cmp eax, 16
    jne tb_chk13
    mov eax, 15
tb_chk13:
    cmp eax, 13
    jne tb_chk10
    mov eax, 12
tb_chk10:
    cmp eax, 10
    jne tb_chk5
    mov eax, 6
tb_chk5:
    cmp eax, 5
    jne tb_chk2
    mov eax, 4
tb_chk2:
    cmp eax, 2
    jne tb_ready
    mov eax, 1
tb_ready:
    mov pos, eax

    invoke GetWindowTextA, hWnd, ADDR timeEditBuf, 24
    mov edi, OFFSET timeEditBuf
    mov eax, pos
    add edi, eax

    cmp pos, 6
    je tb_letter
    cmp pos, 17
    je tb_letter
    mov byte ptr [edi], '0'
    jmp tb_write
tb_letter:
    mov byte ptr [edi], 'A'
tb_write:
    invoke SetWindowTextA, hWnd, ADDR timeEditBuf
    invoke SendMessageA, hWnd, EM_SETSEL, pos, pos
    xor eax, eax
    ret

time_keydown:
    mov eax, wParam
    cmp eax, VK_DELETE
    je time_delete
    invoke CallWindowProcA, oldTimeEditProc, hWnd, uMsg, wParam, lParam
    ret

time_delete:
    invoke SendMessageA, hWnd, EM_GETSEL, 0, 0
    and eax, 0FFFFh
    mov pos, eax

    cmp pos, 0
    je td_digit
    cmp pos, 1
    je td_digit
    cmp pos, 3
    je td_digit
    cmp pos, 4
    je td_digit
    cmp pos, 11
    je td_digit
    cmp pos, 12
    je td_digit
    cmp pos, 14
    je td_digit
    cmp pos, 15
    je td_digit
    cmp pos, 6
    je td_letter
    cmp pos, 17
    je td_letter
    jmp time_char_block

td_digit:
    invoke GetWindowTextA, hWnd, ADDR timeEditBuf, 24
    mov edi, OFFSET timeEditBuf
    mov eax, pos
    add edi, eax
    mov byte ptr [edi], '0'
    invoke SetWindowTextA, hWnd, ADDR timeEditBuf
    invoke SendMessageA, hWnd, EM_SETSEL, pos, pos
    xor eax, eax
    ret

td_letter:
    invoke GetWindowTextA, hWnd, ADDR timeEditBuf, 24
    mov edi, OFFSET timeEditBuf
    mov eax, pos
    add edi, eax
    mov byte ptr [edi], 'A'
    invoke SetWindowTextA, hWnd, ADDR timeEditBuf
    invoke SendMessageA, hWnd, EM_SETSEL, pos, pos
    xor eax, eax
    ret
TimeEditProc ENDP

END start