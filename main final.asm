

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
SetTextColor PROTO STDCALL :DWORD,:DWORD
SetBkMode PROTO STDCALL :DWORD,:DWORD
SetBkColor PROTO STDCALL :DWORD,:DWORD
GetStockObject PROTO STDCALL :DWORD
GetSysColor PROTO STDCALL :DWORD
GetSysColorBrush PROTO STDCALL :DWORD

;---------------------------------------------------------------------
; Constant values (equ). Using named constants instead of raw numbers
; makes the rest of the code much easier to read and explain.
;---------------------------------------------------------------------
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

; ---- Appointment storage limits ----
MAX_RECORDS equ 10      ; the queue can hold at most 10 appointments
NAME_LEN equ 40
PURPOSE_LEN equ 80
DATE_LEN equ 15
TIME_LEN equ 19

; ---- Control IDs for input boxes ----
ID_NAME equ 1001
ID_DATE equ 1002
ID_TIME equ 1003
ID_PURPOSE equ 1004
ID_APPTID equ 1005
ID_PASSWORD equ 1006

; ---- Control IDs for buttons ----
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

; ---- Control IDs for list / text areas ----
ID_LIST equ 3001
ID_DETAILSBOX equ 3002
ID_STATUS equ 3003
ID_CHECKRESULT equ 3004

;---------------------------------------------------------------------
; Structures used by the Windows API.
;---------------------------------------------------------------------
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

;---------------------------------------------------------------------
; Forward declarations of our own procedures so we can call them
; before they appear later in the file.
;---------------------------------------------------------------------
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
ShowStudentFCFS PROTO
SortFCFS PROTO
GetDateValue PROTO :DWORD
GetTimeValue PROTO :DWORD
IsRecordLess PROTO :DWORD,:DWORD

.data
;---------------------------------------------------------------------
; Text strings used by the GUI (window title, labels, messages).
; Keeping them all here (instead of scattered around the code) makes
; them easy to find and easy to explain: "this is just our string
; table."
;---------------------------------------------------------------------
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

;---------------------------------------------------------------------
; Scratch buffers. These are reused temporary areas of memory used to
; build up strings before showing them on the screen.
;---------------------------------------------------------------------
inputName db 64 dup(0)
inputDate db 32 dup(0)
inputTime db 32 dup(0)
inputPurpose db 128 dup(0)
inputID db 16 dup(0)
inputPassword db 32 dup(0)
numBuf db 16 dup(0)
listBuf db 512 dup(0)
detailsBuf db 1024 dup(0)

dateTemplate db "MM/DD/YYYY",0
timeTemplate db "00:00 AM - 00:00 AM",0
dateEditBuf db 16 dup(0)
timeEditBuf db 24 dup(0)
oldDateEditProc dd 0     ; remembers the ORIGINAL edit-box procedure
oldTimeEditProc dd 0     ; so we can "subclass" the textbox and still
                         ; fall back to normal behavior when needed

;---------------------------------------------------------------------
; APPOINTMENT DATABASE (parallel arrays)
;
; Every appointment is really just "the same index" used across six
; different arrays. Record #3, for example, is:
;     names[3], dates[3], times[3], purposes[3], ids[3], statuses[3]
; This is called a "structure of arrays" and is a very common and
; simple way to store a small fixed-size table in assembly.
;---------------------------------------------------------------------
names db MAX_RECORDS*(NAME_LEN+1) dup(0)
dates db MAX_RECORDS*(DATE_LEN+1) dup(0)
times db MAX_RECORDS*(TIME_LEN+1) dup(0)
purposes db MAX_RECORDS*(PURPOSE_LEN+1) dup(0)
ids db MAX_RECORDS dup(0)          ; the appointment ID number
statuses db MAX_RECORDS dup(0)     ; 0 = WAITING, 1 = ACCEPTED
sortIndex db MAX_RECORDS dup(0)    ; holds the FCFS sort order

recCount dd 0     ; how many appointments are currently stored
nextID dd 1       ; (kept for compatibility with the original design)

isDeanMode dd FALSE
isFcfsViewActive dd FALSE

hInstance dd 0
hMainWnd dd 0

; ---- handles to input controls ----
hEditName dd 0
hEditDate dd 0
hEditTime dd 0
hEditPurpose dd 0
hEditID dd 0
hEditPassword dd 0

; ---- handles to list / detail controls ----
hList dd 0
hDetailsBox dd 0
hStatus dd 0

; ---- fonts ----
hFont dd 0
hFontBold dd 0

; ---- handles to buttons that get enabled/disabled by Dean Mode ----
hBtnLogout dd 0
hBtnView dd 0
hBtnDetails dd 0
hBtnAccept dd 0
hBtnCancel dd 0
hBtnMove dd 0
hBtnDone dd 0
hBtnCheck dd 0
hBtnStudentFCFS dd 0

; ---- section headers (colored maroon) ----
hTitleStatic dd 0
hHdrStudent dd 0
hHdrDean dd 0
hHdrSelected dd 0
hHdrQueue dd 0

wc WNDCLASS <>
msg MSG <>

.code

;=====================================================================
; start
; Program entry point. Sets up the window class, creates the main
; window, then enters the Windows message loop.
;=====================================================================
start:
    invoke GetModuleHandleA, NULL
    mov hInstance, eax

    ; --- fill in the WNDCLASS structure describing our window ---
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

    ; --- create the two fonts used throughout the GUI ---
    invoke CreateFontA, 18,0,0,0,700,0,0,0,1,0,0,0,0,ADDR fontFace
    mov hFontBold, eax
    invoke CreateFontA, 15,0,0,0,400,0,0,0,1,0,0,0,0,ADDR fontFace
    mov hFont, eax

    invoke ShowWindow, hMainWnd, SW_SHOW
    invoke UpdateWindow, hMainWnd

message_loop:
    ; GetMessageA blocks until a new message arrives, and returns 0
    ; only when the application is asked to quit (WM_QUIT).
    invoke GetMessageA, ADDR msg, NULL, 0, 0
    cmp eax, 0
    je program_end
    invoke TranslateMessage, ADDR msg
    invoke DispatchMessageA, ADDR msg
    jmp message_loop

program_end:
    invoke ExitProcess, 0

;=====================================================================
; WndProc
; The main window procedure. Windows calls this function every time
; something happens to our window (created, a button was clicked,
; the window is closing, etc). We look at "uMsg" to
; decide which of those things happened.
;=====================================================================
WndProc PROC hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD

    cmp uMsg, WM_CREATE
    je window_create
    cmp uMsg, WM_COMMAND
    je window_command
    cmp uMsg, WM_CTLCOLORSTATIC
    je window_ctlcolor
    cmp uMsg, WM_CLOSE
    je window_close
    cmp uMsg, WM_DESTROY
    je window_destroy

    ; any message we do not specifically handle is passed to Windows'
    ; own default handler
    invoke DefWindowProcA, hWnd, uMsg, wParam, lParam
    ret

;---------------------------------------------------------------------
; Paints the section-header STATIC controls in maroon text instead of
; the default black, so they stand out visually.
;---------------------------------------------------------------------
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
    invoke SetTextColor, wParam, COLOR_MAROON
    invoke GetSysColor, COLOR_WINDOW
    invoke SetBkColor, wParam, eax
    invoke SetBkMode, wParam, OPAQUE
    invoke GetSysColorBrush, COLOR_WINDOW
    ret

;---------------------------------------------------------------------
; WM_CREATE - build every control of the GUI. This is long simply
; because there are many controls, but every block follows the same
; pattern: invoke CreateWindowExA with the control's class, text,
; style, position/size, and parent window, then (if we need it
; later) save the returned handle.
;---------------------------------------------------------------------
window_create:
    ; ---------- top title bar ----------
    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtHeader, \
        WS_CHILD or WS_VISIBLE or SS_CENTER or WS_BORDER, \
        30,15,1120,45,hWnd,0,hInstance,NULL
    mov hTitleStatic,eax
    invoke SendMessageA, hTitleStatic, WM_SETFONT, hFontBold, TRUE

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtSubHeader, \
        WS_CHILD or WS_VISIBLE or SS_CENTER, \
        30,65,1120,22,hWnd,0,hInstance,NULL
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    ; ---------- STUDENT INFORMATION panel ----------
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
    ; "subclassing": we hijack the edit box's window procedure so we
    ; can intercept every keystroke and enforce the MM/DD/YYYY mask.
    ; oldDateEditProc remembers the original procedure so we can still
    ; fall back to normal edit-box behavior for anything we don't
    ; specifically handle.
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

    ; ---------- DEAN ACCESS panel ----------
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
    invoke EnableWindow,hBtnLogout,FALSE   ; disabled until Dean logs in

    ; ---------- APPOINTMENT QUEUE panel ----------
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

    ; ---------- SELECTED APPOINTMENT panel ----------
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

    ; ---------- bottom status bar ----------
    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR statusStudent, \
        WS_CHILD or WS_VISIBLE or WS_BORDER or SS_CENTER, \
        30,775,1080,32,hWnd,ID_STATUS,hInstance,NULL
    mov hStatus,eax

    call RefreshList
    ret

;---------------------------------------------------------------------
; WM_COMMAND - fired whenever a button is clicked (or some other
; control sends a notification). wParam's low 16 bits hold the
; control ID, so we mask it and compare it against every button ID.
;---------------------------------------------------------------------
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
    ; put every input box back to its starting/template text
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
    ; any Dean-only button pressed while NOT logged in as Dean lands
    ; here, so we only need this warning message once
    invoke MessageBoxA,hMainWnd,ADDR msgDeanOnly,ADDR txtDean,MB_OK or MB_ICONWARNING
    ret

cmd_exit:
    invoke DestroyWindow,hMainWnd
    ret

window_close:
    invoke DestroyWindow,hWnd
    ret

window_destroy:
    invoke PostQuitMessage,0
    ret

WndProc ENDP


;=====================================================================
; SetDeanMode
; Turns Dean Mode on or off. This single procedure is responsible for
; enabling/disabling every Dean-only control and updating the status
; bar and queue title text to match the current mode.
;=====================================================================
SetDeanMode PROC mode:DWORD
    mov eax,mode
    mov isDeanMode,eax

    cmp eax,TRUE
    jne switch_to_student_mode

switch_to_dean_mode:
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

switch_to_student_mode:
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


;=====================================================================
; BookAppointment
; Reads Name/Date/Time/Purpose from the textboxes, validates them,
; and (if valid) stores a brand-new appointment at the next free slot
; in the parallel arrays. The new appointment's ID is simply
; "position in the array + 1", and its status always starts as
; WAITING (0).
;=====================================================================
BookAppointment PROC
    ; the queue can never hold more than MAX_RECORDS appointments
    mov eax,recCount
    cmp eax,MAX_RECORDS
    jb queue_has_room
    invoke MessageBoxA,hMainWnd,ADDR msgFull,ADDR txtHeader,MB_OK or MB_ICONWARNING
    ret

queue_has_room:
    invoke GetWindowTextA,hEditName,ADDR inputName,64
    invoke GetWindowTextA,hEditDate,ADDR inputDate,32
    invoke GetWindowTextA,hEditTime,ADDR inputTime,32
    invoke GetWindowTextA,hEditPurpose,ADDR inputPurpose,128

    ; every field is required - reject if any of them is empty
    invoke lstrlenA,ADDR inputName
    cmp eax,0
    je reject_incomplete
    invoke lstrlenA,ADDR inputDate
    cmp eax,0
    je reject_incomplete
    invoke lstrlenA,ADDR inputTime
    cmp eax,0
    je reject_incomplete
    invoke lstrlenA,ADDR inputPurpose
    cmp eax,0
    je reject_incomplete

    invoke ValidateDate, ADDR inputDate
    cmp eax,0
    je reject_bad_date

    invoke ValidateTime, ADDR inputTime
    cmp eax,1
    je time_is_valid
    cmp eax,2
    je reject_bad_time_range
    jmp reject_bad_time

time_is_valid:
    ; --- copy the four text fields into the record arrays ---
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

    ; the new appointment's ID is its position (1-based); status
    ; starts as 0 = WAITING
    mov eax,recCount
    inc eax
    mov [ids+eax-1],al
    mov byte ptr [statuses+eax-1],0
    inc recCount

    ; reset the input boxes back to their empty/template state
    invoke SetWindowTextA,hEditName,NULL
    invoke SetWindowTextA,hEditDate,ADDR dateTemplate
    invoke SetWindowTextA,hEditTime,ADDR timeTemplate
    invoke SetWindowTextA,hEditPurpose,NULL

    invoke SetWindowTextA,hStatus,ADDR statusStudent
    invoke MessageBoxA,hMainWnd,ADDR msgBooked,ADDR txtBook,MB_OK or MB_ICONINFORMATION
    ret

reject_bad_date:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalidDate,ADDR txtBook,MB_OK or MB_ICONWARNING
    ret
reject_bad_time:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalidTime,ADDR txtBook,MB_OK or MB_ICONWARNING
    ret
reject_bad_time_range:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalidTimeRange,ADDR txtBook,MB_OK or MB_ICONWARNING
    ret
reject_incomplete:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalid,ADDR txtBook,MB_OK or MB_ICONWARNING
    ret
BookAppointment ENDP


;=====================================================================
; RefreshList
; Rebuilds the Dean's appointment listbox from scratch, showing every
; stored appointment in its natural array order (record 0 first,
; record 1 second, etc - this is NOT the FCFS sorted order; that is
; produced separately by ShowStudentFCFS).
;=====================================================================
RefreshList PROC
    LOCAL currentIndex:DWORD
    LOCAL remaining:DWORD

    mov isFcfsViewActive, FALSE
    invoke SetWindowTextA,hHdrQueue,ADDR txtQueue

    cmp isDeanMode,TRUE
    je dean_may_view_list
    invoke SendMessageA,hList,LB_RESETCONTENT,0,0
    invoke SendMessageA,hList,LB_ADDSTRING,0,ADDR msgDeanOnly
    ret

dean_may_view_list:
    invoke SendMessageA,hList,LB_RESETCONTENT,0,0
    mov eax,recCount
    mov remaining,eax
    mov currentIndex,0
    cmp eax,0
    jne build_list_loop
    invoke SendMessageA,hList,LB_ADDSTRING,0,ADDR msgNoRecords
    ret

build_list_loop:
    ; Build one line of text for the current record:
    ;   "ID: n | Student: ... | Date: ... | Time: ... | Purpose: ... | Status: ..."
    invoke lstrcpyA,ADDR listBuf,ADDR prefixID
    mov eax,currentIndex
    movzx eax,byte ptr [ids+eax]
    invoke NumberToText,eax,ADDR numBuf
    invoke lstrcatA,ADDR listBuf,ADDR numBuf

    invoke lstrcatA,ADDR listBuf,ADDR prefixName
    mov eax,currentIndex
    mov ebx,NAME_LEN+1
    mul ebx
    mov edx,OFFSET names
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    invoke lstrcatA,ADDR listBuf,ADDR prefixDate
    mov eax,currentIndex
    mov ebx,DATE_LEN+1
    mul ebx
    mov edx,OFFSET dates
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    invoke lstrcatA,ADDR listBuf,ADDR prefixTime
    mov eax,currentIndex
    mov ebx,TIME_LEN+1
    mul ebx
    mov edx,OFFSET times
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    invoke lstrcatA,ADDR listBuf,ADDR prefixPurpose
    mov eax,currentIndex
    mov ebx,PURPOSE_LEN+1
    mul ebx
    mov edx,OFFSET purposes
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    invoke lstrcatA,ADDR listBuf,ADDR prefixStatus
    mov eax,currentIndex
    movzx eax,byte ptr [statuses+eax]
    cmp eax,0
    jne append_status_accepted
    invoke lstrcatA,ADDR listBuf,ADDR statusWaiting
    jmp add_line_to_list
append_status_accepted:
    invoke lstrcatA,ADDR listBuf,ADDR statusAccepted

add_line_to_list:
    invoke SendMessageA,hList,LB_ADDSTRING,0,ADDR listBuf

    mov eax,currentIndex
    inc eax
    mov currentIndex,eax
    mov eax,remaining
    dec eax
    mov remaining,eax
    cmp eax,0
    jne build_list_loop
    ret
RefreshList ENDP


;=====================================================================
; ViewSelected
; Shows the full details of whichever appointment is currently
; highlighted in the listbox. If the FCFS-sorted view is currently
; being shown, the highlighted position has to be translated back to
; the real record index using sortIndex[].
;=====================================================================
ViewSelected PROC
    invoke SendMessageA,hList,LB_GETCURSEL,0,0
    cmp eax,0FFFFFFFFh
    je nothing_selected

    cmp isFcfsViewActive,TRUE
    jne selected_is_real_index
    mov ecx,eax
    movzx eax, byte ptr [sortIndex+ecx]

selected_is_real_index:
    invoke ShowRecord,eax
    ret

nothing_selected:
    invoke MessageBoxA,hMainWnd,ADDR msgSelect,ADDR txtDetails,MB_OK or MB_ICONWARNING
    ret
ViewSelected ENDP


;=====================================================================
; ShowRecord
; Builds and displays the "Selected Appointment" details box for the
; record at the given array index.
;=====================================================================
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
    jne detail_status_accepted
    invoke lstrcatA,ADDR detailsBuf,ADDR statusWaiting
    jmp detail_status_written
detail_status_accepted:
    invoke lstrcatA,ADDR detailsBuf,ADDR statusAccepted
detail_status_written:
    invoke lstrcatA,ADDR detailsBuf,ADDR newline

    invoke lstrcatA,ADDR detailsBuf,ADDR detailQueue
    mov eax,index
    inc eax
    invoke NumberToText,eax,ADDR numBuf
    invoke lstrcatA,ADDR detailsBuf,ADDR numBuf

    invoke SetWindowTextA,hDetailsBox,ADDR detailsBuf
    ret
ShowRecord ENDP


;=====================================================================
; AcceptAppointment
; Looks up the appointment ID typed by the Dean and, if it is
; currently WAITING, changes its status to ACCEPTED.
;=====================================================================
AcceptAppointment PROC
    LOCAL currentIndex:DWORD
    LOCAL remaining:DWORD
    LOCAL wantedID:DWORD

    invoke GetWindowTextA,hEditID,ADDR inputID,16
    call ParseID
    cmp eax,0
    je id_not_found
    mov wantedID,eax

    mov currentIndex,0
    mov eax,recCount
    mov remaining,eax

find_by_id:
    cmp remaining,0
    je id_not_found
    mov eax,currentIndex
    movzx eax,byte ptr [ids+eax]
    cmp eax,wantedID
    je record_found
    mov eax,currentIndex
    inc eax
    mov currentIndex,eax
    mov eax,remaining
    dec eax
    mov remaining,eax
    jmp find_by_id

record_found:
    mov eax,currentIndex
    movzx eax,byte ptr [statuses+eax]
    cmp eax,0
    jne already_accepted

    mov eax,currentIndex
    mov byte ptr [statuses+eax],1
    call RefreshList
    invoke ShowRecord,currentIndex
    invoke MessageBoxA,hMainWnd,ADDR msgAccepted,ADDR txtAccept,MB_OK or MB_ICONINFORMATION
    ret

already_accepted:
    invoke MessageBoxA,hMainWnd,ADDR msgAlreadyAccepted,ADDR txtAccept,MB_OK or MB_ICONWARNING
    ret

id_not_found:
    invoke MessageBoxA,hMainWnd,ADDR msgNotFound,ADDR txtAccept,MB_OK or MB_ICONWARNING
    ret
AcceptAppointment ENDP


;=====================================================================
; CancelAppointment
; Removes the appointment with the given ID entirely. Every record
; that came after it is shifted one slot earlier (CopyRecord) so the
; array stays packed with no holes, and the (now unused) last slot is
; cleared.
;
; NOTE: unlike MarkDone below, cancelling does NOT renumber the
; remaining IDs - each surviving appointment keeps its original ID.
;=====================================================================
CancelAppointment PROC
    LOCAL currentIndex:DWORD
    LOCAL remaining:DWORD
    LOCAL wantedID:DWORD
    LOCAL sourceIndex:DWORD
    LOCAL destinationIndex:DWORD

    invoke GetWindowTextA,hEditID,ADDR inputID,16
    call ParseID
    cmp eax,0
    je id_not_found
    mov wantedID,eax

    mov currentIndex,0
    mov eax,recCount
    mov remaining,eax
find_by_id:
    cmp remaining,0
    je id_not_found
    mov eax,currentIndex
    movzx eax,byte ptr [ids+eax]
    cmp eax,wantedID
    je record_found
    mov eax,currentIndex
    inc eax
    mov currentIndex,eax
    mov eax,remaining
    dec eax
    mov remaining,eax
    jmp find_by_id

record_found:
    ; shift every record that comes AFTER the one being removed
    ; one position toward the front of the array
    mov eax,recCount
    dec eax
    cmp currentIndex,eax
    jae skip_shift          ; removing the very last record: nothing to shift

    mov eax,currentIndex
    inc eax
    mov sourceIndex,eax
    mov eax,currentIndex
    mov destinationIndex,eax

shift_records:
    mov eax,sourceIndex
    cmp eax,recCount
    jae skip_shift
    invoke CopyRecord,sourceIndex,destinationIndex
    mov eax,sourceIndex
    inc eax
    mov sourceIndex,eax
    mov eax,destinationIndex
    inc eax
    mov destinationIndex,eax
    jmp shift_records

skip_shift:
    dec recCount
    mov eax,recCount
    invoke ClearRecord,eax

    invoke SetWindowTextA,hEditID,NULL
    invoke SetWindowTextA,hDetailsBox,NULL
    call RefreshList
    invoke MessageBoxA,hMainWnd,ADDR msgCancelled,ADDR txtCancel,MB_OK or MB_ICONINFORMATION
    ret

id_not_found:
    invoke MessageBoxA,hMainWnd,ADDR msgNotFound,ADDR txtCancel,MB_OK or MB_ICONWARNING
    ret
CancelAppointment ENDP


;=====================================================================
; MoveAppointment
; Looks up an appointment by ID and, if the Dean typed a valid new
; date and time into the Date/Time boxes, overwrites the stored date
; and time for that record (this is the "reschedule" feature).
;=====================================================================
MoveAppointment PROC
    LOCAL currentIndex:DWORD
    LOCAL remaining:DWORD
    LOCAL wantedID:DWORD

    invoke GetWindowTextA,hEditID,ADDR inputID,16
    call ParseID
    cmp eax,0
    je id_not_found
    mov wantedID,eax

    mov currentIndex,0
    mov eax,recCount
    mov remaining,eax
find_by_id:
    cmp remaining,0
    je id_not_found
    mov eax,currentIndex
    movzx eax,byte ptr [ids+eax]
    cmp eax,wantedID
    je record_found
    mov eax,currentIndex
    inc eax
    mov currentIndex,eax
    mov eax,remaining
    dec eax
    mov remaining,eax
    jmp find_by_id

record_found:
    invoke GetWindowTextA,hEditDate,ADDR inputDate,32
    invoke GetWindowTextA,hEditTime,ADDR inputTime,32

    invoke lstrlenA,ADDR inputDate
    cmp eax,0
    je reject_incomplete
    invoke lstrlenA,ADDR inputTime
    cmp eax,0
    je reject_incomplete

    invoke ValidateDate, ADDR inputDate
    cmp eax,0
    je reject_bad_date

    invoke ValidateTime, ADDR inputTime
    cmp eax,1
    je time_is_valid
    cmp eax,2
    je reject_bad_time_range
    jmp reject_bad_time

time_is_valid:
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

reject_bad_date:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalidDate,ADDR txtMove,MB_OK or MB_ICONWARNING
    ret
reject_bad_time:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalidTime,ADDR txtMove,MB_OK or MB_ICONWARNING
    ret
reject_bad_time_range:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalidTimeRange,ADDR txtMove,MB_OK or MB_ICONWARNING
    ret
reject_incomplete:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalid,ADDR txtMove,MB_OK or MB_ICONWARNING
    ret
id_not_found:
    invoke MessageBoxA,hMainWnd,ADDR msgNotFound,ADDR txtMove,MB_OK or MB_ICONWARNING
    ret
MoveAppointment ENDP


;=====================================================================
; ShowStudentFCFS
; Displays the appointment queue sorted in First-Come-First-Served
; order (soonest date, then soonest time, then lowest ID). The actual
; sorting work is done by SortFCFS, which fills sortIndex[] with the
; record indexes in the correct order; this procedure just walks
; sortIndex[] and prints each record.
;=====================================================================
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
    jne have_records
    invoke SendMessageA,hList,LB_ADDSTRING,0,ADDR msgNoRecords
    invoke SetWindowTextA,hStatus,ADDR msgNoRecords
    ret

have_records:
    call SortFCFS

fcfs_list_loop:
    mov ecx, currentIndex
    movzx eax, byte ptr [sortIndex+ecx]
    mov recordIdx, eax

    invoke lstrcpyA,ADDR listBuf,ADDR prefixID
    mov eax,recordIdx
    movzx eax,byte ptr [ids+eax]
    invoke NumberToText,eax,ADDR numBuf
    invoke lstrcatA,ADDR listBuf,ADDR numBuf

    invoke lstrcatA,ADDR listBuf,ADDR prefixName
    mov eax,recordIdx
    mov ebx,NAME_LEN+1
    mul ebx
    mov edx,OFFSET names
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    invoke lstrcatA,ADDR listBuf,ADDR prefixDate
    mov eax,recordIdx
    mov ebx,DATE_LEN+1
    mul ebx
    mov edx,OFFSET dates
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    invoke lstrcatA,ADDR listBuf,ADDR prefixTime
    mov eax,recordIdx
    mov ebx,TIME_LEN+1
    mul ebx
    mov edx,OFFSET times
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    invoke lstrcatA,ADDR listBuf,ADDR prefixPurpose
    mov eax,recordIdx
    mov ebx,PURPOSE_LEN+1
    mul ebx
    mov edx,OFFSET purposes
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    invoke lstrcatA,ADDR listBuf,ADDR prefixStatus
    mov eax,recordIdx
    movzx eax,byte ptr [statuses+eax]
    cmp eax,0
    jne append_status_accepted
    invoke lstrcatA,ADDR listBuf,ADDR statusWaiting
    jmp add_line_to_list
append_status_accepted:
    invoke lstrcatA,ADDR listBuf,ADDR statusAccepted

add_line_to_list:
    invoke SendMessageA,hList,LB_ADDSTRING,0,ADDR listBuf

    mov eax,currentIndex
    inc eax
    mov currentIndex,eax
    mov eax,remaining
    dec eax
    mov remaining,eax
    cmp eax,0
    jne fcfs_list_loop

    invoke SetWindowTextA,hStatus,ADDR msgStudentFCFSTitle
    ret
ShowStudentFCFS ENDP


;=====================================================================
; MarkDone
; Looks up an appointment by ID, removes it from the queue (shifting
; later records forward just like CancelAppointment does), and then
; renumbers every remaining appointment's ID sequentially starting
; at 1, so the appointment IDs always match "position in queue".
;=====================================================================
MarkDone PROC
    LOCAL currentIndex:DWORD
    LOCAL remaining:DWORD
    LOCAL wantedID:DWORD
    LOCAL sourceIndex:DWORD
    LOCAL destinationIndex:DWORD

    invoke GetWindowTextA,hEditID,ADDR inputID,16
    call ParseID
    cmp eax,0
    je id_not_found
    mov wantedID,eax

    mov currentIndex,0
    mov eax,recCount
    mov remaining,eax
find_by_id:
    cmp remaining,0
    je id_not_found
    mov eax,currentIndex
    movzx eax,byte ptr [ids+eax]
    cmp eax,wantedID
    je record_found
    mov eax,currentIndex
    inc eax
    mov currentIndex,eax
    mov eax,remaining
    dec eax
    mov remaining,eax
    jmp find_by_id

record_found:
    mov eax,recCount
    dec eax
    cmp currentIndex,eax
    jae skip_shift

    mov eax,currentIndex
    inc eax
    mov sourceIndex,eax
    mov eax,currentIndex
    mov destinationIndex,eax

shift_records:
    mov eax,sourceIndex
    cmp eax,recCount
    jae skip_shift
    invoke CopyRecord,sourceIndex,destinationIndex
    mov eax,sourceIndex
    inc eax
    mov sourceIndex,eax
    mov eax,destinationIndex
    inc eax
    mov destinationIndex,eax
    jmp shift_records

skip_shift:
    dec recCount
    mov eax,recCount
    invoke ClearRecord,eax

    ; renumber every surviving appointment: 1, 2, 3, ...
    mov currentIndex,0
    mov eax,recCount
    mov remaining,eax
    mov ebx,1
renumber_ids:
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
    jmp renumber_ids

done_refresh:
    invoke SetWindowTextA,hEditID,NULL
    invoke SetWindowTextA,hDetailsBox,NULL
    call RefreshList
    invoke MessageBoxA,hMainWnd,ADDR msgDone,ADDR txtDone,MB_OK or MB_ICONINFORMATION
    ret

id_not_found:
    invoke MessageBoxA,hMainWnd,ADDR msgDoneFail,ADDR txtDone,MB_OK or MB_ICONWARNING
    ret
MarkDone ENDP


;=====================================================================
; CheckMyStatus
; Lets a student type in their appointment ID and see whether it is
; still WAITING or already DONE (an ID that can no longer be found is
; treated as DONE/removed, since MarkDone deletes finished records).
;=====================================================================
CheckMyStatus PROC
    LOCAL currentIndex:DWORD
    LOCAL remaining:DWORD
    LOCAL wantedID:DWORD

    invoke GetWindowTextA,hEditID,ADDR inputID,16
    call ParseID
    cmp eax,0
    je id_not_found
    mov wantedID,eax

    mov currentIndex,0
    mov eax,recCount
    mov remaining,eax
find_by_id:
    cmp remaining,0
    je id_not_found
    mov eax,currentIndex
    movzx eax,byte ptr [ids+eax]
    cmp eax,wantedID
    je record_found
    mov eax,currentIndex
    inc eax
    mov currentIndex,eax
    mov eax,remaining
    dec eax
    mov remaining,eax
    jmp find_by_id

record_found:
    invoke ShowRecord,currentIndex
    mov eax,currentIndex
    movzx eax,byte ptr [statuses+eax]
    cmp eax,0
    jne report_done
    invoke SetWindowTextA,hStatus,ADDR msgStatusFound
    invoke MessageBoxA,hMainWnd,ADDR msgStatusWaiting,ADDR txtCheck,MB_OK or MB_ICONINFORMATION
    ret

report_done:
    invoke SetWindowTextA,hStatus,ADDR msgStatusDone
    invoke MessageBoxA,hMainWnd,ADDR msgStatusDone,ADDR txtCheck,MB_OK or MB_ICONINFORMATION
    ret

id_not_found:
    invoke MessageBoxA,hMainWnd,ADDR msgStatusNotFound,ADDR txtCheck,MB_OK or MB_ICONWARNING
    ret
CheckMyStatus ENDP


;=====================================================================
; CopyRecord
; Copies every field (ID, status, name, date, time, purpose) from
; record "sourceIndex" into record "destinationIndex". Used while
; shifting the array after a cancellation/completion.
;=====================================================================
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


;=====================================================================
; ClearRecord
; Wipes one record slot back to all-zero bytes. Called on the last
; (now-unused) slot after the array has been shifted.
;=====================================================================
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


;=====================================================================
; ParseID
; Converts the text the user typed into the Appointment ID box (a
; string of digit characters) into a plain 32-bit number in EAX. If
; any character is not a digit, this returns 0 (treated as "invalid
; ID" everywhere it is used).
;=====================================================================
ParseID PROC
    xor eax,eax
    mov esi,OFFSET inputID
digit_loop:
    mov dl,[esi]
    cmp dl,0
    je finished
    cmp dl,'0'
    jb not_a_number
    cmp dl,'9'
    ja not_a_number
    imul eax,10
    sub dl,'0'
    movzx edx,dl
    add eax,edx
    inc esi
    jmp digit_loop
not_a_number:
    xor eax,eax
finished:
    ret
ParseID ENDP


;=====================================================================
; NumberToText
; Converts the 32-bit number in "value" into a zero-terminated
; decimal text string written to "destination". This is the opposite
; of ParseID.
;=====================================================================
NumberToText PROC value:DWORD,destination:DWORD
    push ebx
    push ecx
    push edx
    push edi

    mov eax,value
    mov edi,destination
    xor ecx,ecx

    cmp eax,0
    jne convert_digits
    mov byte ptr [edi],'0'
    mov byte ptr [edi+1],0
    jmp finished

convert_digits:
    ; repeatedly divide by 10, pushing each remainder digit onto the
    ; stack; this naturally reverses the digit order for us
    mov ebx,10
divide_loop:
    xor edx,edx
    div ebx
    push edx
    inc ecx
    cmp eax,0
    jne divide_loop

write_digits:
    pop edx
    add dl,'0'
    mov [edi],dl
    inc edi
    loop write_digits
    mov byte ptr [edi],0

finished:
    pop edi
    pop edx
    pop ecx
    pop ebx
    ret
NumberToText ENDP


;=====================================================================
; ValidateDate
; Checks that dateStr follows the exact pattern "MM/DD/YYYY", that
; the year is 2026 or later, the month is 1-12, and the day is valid
; for that month (including leap-year handling for February).
; Returns 1 if the date is valid, 0 otherwise.
;=====================================================================
ValidateDate PROC dateStr:DWORD
    LOCAL month:DWORD
    LOCAL day:DWORD
    LOCAL year:DWORD
    LOCAL maxDay:DWORD

    invoke lstrlenA, dateStr
    cmp eax, 10
    jne date_invalid

    mov esi, dateStr
    mov al, [esi+2]
    cmp al, '/'
    jne date_invalid
    mov al, [esi+5]
    cmp al, '/'
    jne date_invalid

    ; --- read the 2-digit month ---
    movzx eax, byte ptr [esi]
    cmp eax,'0'
    jb date_invalid
    cmp eax,'9'
    ja date_invalid
    sub eax,'0'
    mov ebx, eax
    movzx eax, byte ptr [esi+1]
    cmp eax,'0'
    jb date_invalid
    cmp eax,'9'
    ja date_invalid
    sub eax,'0'
    imul ebx,10
    add ebx,eax
    mov month, ebx

    ; --- read the 2-digit day ---
    movzx eax, byte ptr [esi+3]
    cmp eax,'0'
    jb date_invalid
    cmp eax,'9'
    ja date_invalid
    sub eax,'0'
    mov ebx, eax
    movzx eax, byte ptr [esi+4]
    cmp eax,'0'
    jb date_invalid
    cmp eax,'9'
    ja date_invalid
    sub eax,'0'
    imul ebx,10
    add ebx,eax
    mov day, ebx

    ; --- read the 4-digit year ---
    xor ebx,ebx
    mov ecx,6
read_year_loop:
    movzx eax, byte ptr [esi+ecx]
    cmp eax,'0'
    jb date_invalid
    cmp eax,'9'
    ja date_invalid
    sub eax,'0'
    imul ebx,10
    add ebx,eax
    inc ecx
    cmp ecx,10
    jne read_year_loop
    mov year, ebx

    ; --- range checks ---
    mov eax, year
    cmp eax, 2026
    jl date_invalid

    mov eax, month
    cmp eax, 1
    jl date_invalid
    cmp eax, 12
    jg date_invalid

    mov eax, day
    cmp eax, 1
    jl date_invalid

    ; --- work out how many days the chosen month has ---
    mov eax, month
    cmp eax,1
    je month_has_31
    cmp eax,3
    je month_has_31
    cmp eax,5
    je month_has_31
    cmp eax,7
    je month_has_31
    cmp eax,8
    je month_has_31
    cmp eax,10
    je month_has_31
    cmp eax,12
    je month_has_31
    cmp eax,4
    je month_has_30
    cmp eax,6
    je month_has_30
    cmp eax,9
    je month_has_30
    cmp eax,11
    je month_has_30
    jmp month_is_february

month_has_31:
    mov maxDay,31
    jmp check_day_range
month_has_30:
    mov maxDay,30
    jmp check_day_range

month_is_february:
    ; Leap year rule: divisible by 4 AND (not divisible by 100
    ; OR divisible by 400)
    mov eax, year
    xor edx,edx
    mov ecx,4
    div ecx
    cmp edx,0
    jne february_not_leap

    mov eax, year
    xor edx,edx
    mov ecx,100
    div ecx
    cmp edx,0
    jne february_is_leap        ; divisible by 4 but not by 100

    mov eax, year
    xor edx,edx
    mov ecx,400
    div ecx
    cmp edx,0
    jne february_not_leap       ; divisible by 100 but not by 400

february_is_leap:
    mov maxDay,29
    jmp check_day_range
february_not_leap:
    mov maxDay,28

check_day_range:
    mov eax, day
    cmp eax, maxDay
    jg date_invalid

    mov eax,1
    ret

date_invalid:
    xor eax,eax
    ret
ValidateDate ENDP


;=====================================================================
; TimeToMinutes
; Converts an hour (1-12), a minute, and an AM/PM letter into a
; "minutes since midnight" number (0-1439), so two times can be
; compared with a single cmp instruction.
;=====================================================================
TimeToMinutes PROC hourVal:DWORD, minuteVal:DWORD, ampmChar:DWORD
    mov ecx, hourVal
    mov eax, ampmChar
    cmp eax, 'A'
    jne convert_pm

    ; --- AM: 12 AM means midnight (hour 0); every other hour is
    ;     already correct in 24-hour terms ---
    cmp ecx, 12
    jne combine_hour_minute
    mov ecx, 0
    jmp combine_hour_minute

convert_pm:
    ; --- PM: 12 PM stays as hour 12 (noon); every other hour needs
    ;     +12 to become 24-hour time ---
    cmp ecx, 12
    je combine_hour_minute
    add ecx, 12

combine_hour_minute:
    mov eax, ecx
    imul eax, 60
    add eax, minuteVal
    ret
TimeToMinutes ENDP


;=====================================================================
; ValidateTime
; Checks that timeStr matches the exact pattern
;   "HH:MM AM - HH:MM AM"   (20 characters)
; with valid hours (1-12), minutes restricted to :00 or :30, and a
; valid AM/PM letter on both the start and end time.
;
; Returns:
;   0 = the text itself is not a properly formatted time
;   1 = valid, and the end time is later than the start time
;   2 = both times are individually valid, but the end time is NOT
;       later than the start time
;=====================================================================
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
    jne time_invalid

    mov esi, timeStr
    ; check every fixed "separator" character is exactly where we
    ; expect it in "HH:MM AM - HH:MM AM"
    mov al, [esi+2]
    cmp al, ':'
    jne time_invalid
    mov al, [esi+5]
    cmp al, ' '
    jne time_invalid
    mov al, [esi+7]
    cmp al, 'M'
    jne time_invalid
    mov al, [esi+8]
    cmp al, ' '
    jne time_invalid
    mov al, [esi+9]
    cmp al, '-'
    jne time_invalid
    mov al, [esi+10]
    cmp al, ' '
    jne time_invalid
    mov al, [esi+13]
    cmp al, ':'
    jne time_invalid
    mov al, [esi+16]
    cmp al, ' '
    jne time_invalid
    mov al, [esi+18]
    cmp al, 'M'
    jne time_invalid

    ; --- start hour ---
    movzx eax, byte ptr [esi]
    cmp eax,'0'
    jb time_invalid
    cmp eax,'9'
    ja time_invalid
    sub eax,'0'
    mov ebx, eax
    movzx eax, byte ptr [esi+1]
    cmp eax,'0'
    jb time_invalid
    cmp eax,'9'
    ja time_invalid
    sub eax,'0'
    imul ebx,10
    add ebx,eax
    mov sHour, ebx

    ; --- start minute ---
    movzx eax, byte ptr [esi+3]
    cmp eax,'0'
    jb time_invalid
    cmp eax,'9'
    ja time_invalid
    sub eax,'0'
    mov ebx, eax
    movzx eax, byte ptr [esi+4]
    cmp eax,'0'
    jb time_invalid
    cmp eax,'9'
    ja time_invalid
    sub eax,'0'
    imul ebx,10
    add ebx,eax
    mov sMin, ebx

    ; --- start AM/PM ---
    movzx eax, byte ptr [esi+6]
    cmp eax,'A'
    je start_ampm_ok
    cmp eax,'P'
    je start_ampm_ok
    jmp time_invalid
start_ampm_ok:
    mov sAmpm, eax

    ; --- end hour ---
    movzx eax, byte ptr [esi+11]
    cmp eax,'0'
    jb time_invalid
    cmp eax,'9'
    ja time_invalid
    sub eax,'0'
    mov ebx, eax
    movzx eax, byte ptr [esi+12]
    cmp eax,'0'
    jb time_invalid
    cmp eax,'9'
    ja time_invalid
    sub eax,'0'
    imul ebx,10
    add ebx,eax
    mov eHour, ebx

    ; --- end minute ---
    movzx eax, byte ptr [esi+14]
    cmp eax,'0'
    jb time_invalid
    cmp eax,'9'
    ja time_invalid
    sub eax,'0'
    mov ebx, eax
    movzx eax, byte ptr [esi+15]
    cmp eax,'0'
    jb time_invalid
    cmp eax,'9'
    ja time_invalid
    sub eax,'0'
    imul ebx,10
    add ebx,eax
    mov eMin, ebx

    ; --- end AM/PM ---
    movzx eax, byte ptr [esi+17]
    cmp eax,'A'
    je end_ampm_ok
    cmp eax,'P'
    je end_ampm_ok
    jmp time_invalid
end_ampm_ok:
    mov eAmpm, eax

    ; --- range checks ---
    mov eax, sHour
    cmp eax, 1
    jl time_invalid
    cmp eax, 12
    jg time_invalid
    mov eax, eHour
    cmp eax, 1
    jl time_invalid
    cmp eax, 12
    jg time_invalid

    ; only :00 and :30 are allowed (30-minute interval rule)
    mov eax, sMin
    cmp eax, 0
    je start_min_ok
    cmp eax, 30
    je start_min_ok
    jmp time_invalid
start_min_ok:
    mov eax, eMin
    cmp eax, 0
    je end_min_ok
    cmp eax, 30
    je end_min_ok
    jmp time_invalid
end_min_ok:

    invoke TimeToMinutes, sHour, sMin, sAmpm
    mov startVal, eax
    invoke TimeToMinutes, eHour, eMin, eAmpm
    mov endVal, eax

    mov eax, endVal
    cmp eax, startVal
    jg time_ok
    mov eax, 2          ; both halves valid, but end is not after start
    ret

time_ok:
    mov eax,1
    ret

time_invalid:
    xor eax,eax
    ret
ValidateTime ENDP


;=====================================================================
; GetDateValue
; Turns a stored "MM/DD/YYYY" date string for record "recIndex" into
; a single comparable integer, laid out as YYYYMMDD (year*10000 +
; month*100 + day). Two dates can then be compared with one cmp.
;=====================================================================
GetDateValue PROC recIndex:DWORD
    mov eax, recIndex
    mov ebx, DATE_LEN+1
    mul ebx
    mov esi, OFFSET dates
    add esi, eax

    ; month (2 digits)
    movzx eax, byte ptr [esi]
    sub eax,'0'
    mov ecx,eax
    movzx eax, byte ptr [esi+1]
    sub eax,'0'
    imul ecx,10
    add ecx,eax

    ; day (2 digits)
    movzx eax, byte ptr [esi+3]
    sub eax,'0'
    mov ebx,eax
    movzx eax, byte ptr [esi+4]
    sub eax,'0'
    imul ebx,10
    add ebx,eax

    ; year (4 digits)
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
    add edx,eax

    ; combine into YYYYMMDD
    mov eax, edx
    imul eax, 10000
    mov edx, ecx
    imul edx, 100
    add eax, edx
    add eax, ebx
    ret
GetDateValue ENDP


;=====================================================================
; GetTimeValue
; Turns the stored start-time portion of record "recIndex" ("HH:MM
; AM/PM ...") into minutes-since-midnight, the same way TimeToMinutes
; does, so the FCFS sort can compare times.
;=====================================================================
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
    add ecx,eax

    movzx eax, byte ptr [esi+3]
    sub eax,'0'
    mov ebx,eax
    movzx eax, byte ptr [esi+4]
    sub eax,'0'
    imul ebx,10
    add ebx,eax

    movzx eax, byte ptr [esi+6]
    cmp eax,'A'
    jne time_is_pm
    cmp ecx,12
    jne combine_hm
    mov ecx,0
    jmp combine_hm
time_is_pm:
    cmp ecx,12
    je combine_hm
    add ecx,12
combine_hm:
    mov eax,ecx
    imul eax,60
    add eax,ebx
    ret
GetTimeValue ENDP


;=====================================================================
; IsRecordLess
; Compares two records to decide their FCFS order:
;   1) earlier date comes first
;   2) if same date, earlier time comes first
;   3) if same date AND time, lower appointment ID comes first
; Returns 1 if recA should come before recB, otherwise 0.
;=====================================================================
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
    jl a_is_less
    jg a_is_not_less

    invoke GetTimeValue, recA
    mov timeA, eax
    invoke GetTimeValue, recB
    mov timeB, eax

    mov eax, timeA
    cmp eax, timeB
    jl a_is_less
    jg a_is_not_less

    mov eax, recA
    movzx eax, byte ptr [ids+eax]
    mov ecx, recB
    movzx ecx, byte ptr [ids+ecx]
    cmp eax, ecx
    jl a_is_less
    jmp a_is_not_less

a_is_less:
    mov eax,1
    ret
a_is_not_less:
    xor eax,eax
    ret
IsRecordLess ENDP


;=====================================================================
; SortFCFS
; Fills sortIndex[0..recCount-1] with the record indexes arranged in
; FCFS order. Uses a simple SELECTION SORT: for each output position,
; scan the rest of the list to find the record that belongs there
; (according to IsRecordLess), then swap it into place. Selection
; sort is one of the easiest sorting algorithms to explain out loud,
; which is why it was kept here instead of a faster but harder to
; explain algorithm.
;=====================================================================
SortFCFS PROC
    LOCAL i:DWORD
    LOCAL j:DWORD
    LOCAL minIdx:DWORD
    LOCAL idxA:DWORD
    LOCAL idxB:DWORD
    LOCAL tmp:DWORD

    ; start with sortIndex = [0, 1, 2, ... recCount-1]
    mov i,0
init_loop:
    mov eax,i
    cmp eax,recCount
    jae init_done
    mov edx,i
    mov [sortIndex+edx],dl
    mov eax,i
    inc eax
    mov i,eax
    jmp init_loop
init_done:

    mov i,0
outer_loop:
    mov eax,i
    mov ebx,recCount
    dec ebx
    cmp eax,ebx
    jge sorting_done

    ; assume position i already holds the smallest remaining record
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

    ; if the record at j belongs before the current "smallest" one,
    ; j becomes the new smallest
    invoke IsRecordLess, idxB, idxA
    cmp eax,0
    je next_j
    mov eax,j
    mov minIdx,eax
next_j:
    mov eax,j
    inc eax
    mov j,eax
    jmp inner_loop

inner_done:
    ; swap sortIndex[i] and sortIndex[minIdx] if they differ
    mov eax,minIdx
    cmp eax,i
    je no_swap_needed

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

no_swap_needed:
    mov eax,i
    inc eax
    mov i,eax
    jmp outer_loop

sorting_done:
    ret
SortFCFS ENDP


;=====================================================================
; DateEditProc
; A "subclass" procedure for the Date textbox. It intercepts every
; keystroke so the box always behaves like a fixed MM/DD/YYYY mask:
;   - typed digits go into the next digit slot and skip over the '/'
;     separators automatically
;   - Backspace clears the previous digit slot (putting the template
;     character back) and skips backward over '/'
;   - Delete clears the digit slot under the cursor without moving it
;   - non-digit keys are simply ignored (return 0 = "handled, do
;     nothing")
; Anything that is not WM_CHAR or WM_KEYDOWN is passed on to the
; original edit-box procedure (oldDateEditProc) so normal behavior
; like selection, focus, etc. keeps working.
;=====================================================================
DateEditProc PROC hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    LOCAL selStart:DWORD
    LOCAL pos:DWORD

    cmp uMsg, WM_CHAR
    je handle_char
    cmp uMsg, WM_KEYDOWN
    je handle_keydown
    invoke CallWindowProcA, oldDateEditProc, hWnd, uMsg, wParam, lParam
    ret

handle_char:
    mov eax, wParam
    cmp eax, 8                 ; 8 = Backspace character
    je handle_backspace

    cmp eax, '0'
    jb block_key
    cmp eax, '9'
    ja block_key

    invoke SendMessageA, hWnd, EM_GETSEL, 0, 0
    and eax, 0FFFFh
    mov selStart, eax

    ; skip forward over any '/' character in the template
    mov eax, selStart
find_digit_slot:
    cmp eax, 10
    jae block_key
    mov edx, OFFSET dateTemplate
    add edx, eax
    mov cl, [edx]
    cmp cl, '/'
    jne found_digit_slot
    inc eax
    jmp find_digit_slot
found_digit_slot:
    mov pos, eax

    invoke GetWindowTextA, hWnd, ADDR dateEditBuf, 16
    mov edi, OFFSET dateEditBuf
    mov eax, pos
    add edi, eax
    mov eax, wParam
    mov [edi], al
    invoke SetWindowTextA, hWnd, ADDR dateEditBuf

    ; move the caret to the next digit slot (skip '/')
    mov eax, pos
    inc eax
skip_separator_fwd:
    cmp eax, 10
    jae place_caret
    mov edx, OFFSET dateTemplate
    add edx, eax
    mov cl, [edx]
    cmp cl, '/'
    jne place_caret
    inc eax
    jmp skip_separator_fwd
place_caret:
    invoke SendMessageA, hWnd, EM_SETSEL, eax, eax
    xor eax, eax
    ret

block_key:
    xor eax, eax
    ret

handle_backspace:
    invoke SendMessageA, hWnd, EM_GETSEL, 0, 0
    and eax, 0FFFFh
    mov selStart, eax
    cmp selStart, 0
    je block_key

    mov eax, selStart
    dec eax
skip_separator_back:
    cmp eax, 0
    jle found_backspace_slot
    mov edx, OFFSET dateTemplate
    add edx, eax
    mov cl, [edx]
    cmp cl, '/'
    jne found_backspace_slot
    dec eax
    jmp skip_separator_back
found_backspace_slot:
    mov pos, eax

    invoke GetWindowTextA, hWnd, ADDR dateEditBuf, 16
    mov edi, OFFSET dateEditBuf
    mov eax, pos
    add edi, eax
    mov edx, OFFSET dateTemplate
    add edx, pos
    mov cl, [edx]
    mov [edi], cl              ; put the template character back
    invoke SetWindowTextA, hWnd, ADDR dateEditBuf
    invoke SendMessageA, hWnd, EM_SETSEL, pos, pos
    xor eax, eax
    ret

handle_keydown:
    mov eax, wParam
    cmp eax, VK_DELETE
    je handle_delete
    invoke CallWindowProcA, oldDateEditProc, hWnd, uMsg, wParam, lParam
    ret

handle_delete:
    invoke SendMessageA, hWnd, EM_GETSEL, 0, 0
    and eax, 0FFFFh
    mov pos, eax
    cmp pos, 10
    jae block_key
    mov edx, OFFSET dateTemplate
    add edx, pos
    mov cl, [edx]
    cmp cl, '/'
    je block_key

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


;=====================================================================
; TimeEditProc
; Same idea as DateEditProc, but for the Time textbox, which follows
; the pattern "HH:MM AM - HH:MM AM". This one is a bit busier because
; it also has to handle the 'A'/'P' letters for AM/PM, and it has
; more fixed separator positions (':' , ' ', '-', 'M').
;=====================================================================
TimeEditProc PROC hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    LOCAL selStart:DWORD
    LOCAL pos:DWORD

    cmp uMsg, WM_CHAR
    je handle_char
    cmp uMsg, WM_KEYDOWN
    je handle_keydown
    invoke CallWindowProcA, oldTimeEditProc, hWnd, uMsg, wParam, lParam
    ret

handle_char:
    mov eax, wParam
    cmp eax, 8
    je handle_backspace
    cmp eax, 'a'
    je handle_letter_a
    cmp eax, 'A'
    je handle_letter_a
    cmp eax, 'p'
    je handle_letter_p
    cmp eax, 'P'
    je handle_letter_p

    cmp eax, '0'
    jb block_key
    cmp eax, '9'
    ja block_key

    invoke SendMessageA, hWnd, EM_GETSEL, 0, 0
    and eax, 0FFFFh
    mov selStart, eax

    ; the caret position reported by Windows sometimes lands exactly
    ; on top of a fixed separator character; these two "remaps" push
    ; it forward to the next real digit slot
    cmp selStart, 2
    jne skip_remap_13
    mov selStart, 3
skip_remap_13:
    cmp selStart, 13
    jne check_valid_digit_slot
    mov selStart, 14
check_valid_digit_slot:
    cmp selStart, 0
    je valid_digit_slot
    cmp selStart, 1
    je valid_digit_slot
    cmp selStart, 3
    je valid_digit_slot
    cmp selStart, 4
    je valid_digit_slot
    cmp selStart, 11
    je valid_digit_slot
    cmp selStart, 12
    je valid_digit_slot
    cmp selStart, 14
    je valid_digit_slot
    cmp selStart, 15
    je valid_digit_slot
    jmp block_key

valid_digit_slot:
    mov eax, selStart
    mov pos, eax
    invoke GetWindowTextA, hWnd, ADDR timeEditBuf, 24
    mov edi, OFFSET timeEditBuf
    mov eax, pos
    add edi, eax
    mov eax, wParam
    mov [edi], al
    invoke SetWindowTextA, hWnd, ADDR timeEditBuf

    ; move the caret forward, jumping over the fixed separators
    mov eax, pos
    inc eax
    cmp eax, 2
    jne advance_check_5
    mov eax, 3
advance_check_5:
    cmp eax, 5
    jne advance_check_13
    mov eax, 6
advance_check_13:
    cmp eax, 13
    jne advance_check_16
    mov eax, 14
advance_check_16:
    cmp eax, 16
    jne place_caret
    mov eax, 17
place_caret:
    invoke SendMessageA, hWnd, EM_SETSEL, eax, eax
    xor eax, eax
    ret

handle_letter_a:
    invoke SendMessageA, hWnd, EM_GETSEL, 0, 0
    and eax, 0FFFFh
    cmp eax, 5
    je set_start_ampm
    cmp eax, 6
    je set_start_ampm
    cmp eax, 16
    je set_end_ampm
    cmp eax, 17
    je set_end_ampm
    jmp block_key
set_start_ampm:
    invoke GetWindowTextA, hWnd, ADDR timeEditBuf, 24
    mov edi, OFFSET timeEditBuf
    add edi, 6
    mov byte ptr [edi], 'A'
    invoke SetWindowTextA, hWnd, ADDR timeEditBuf
    invoke SendMessageA, hWnd, EM_SETSEL, 11, 11
    xor eax, eax
    ret
set_end_ampm:
    invoke GetWindowTextA, hWnd, ADDR timeEditBuf, 24
    mov edi, OFFSET timeEditBuf
    add edi, 17
    mov byte ptr [edi], 'A'
    invoke SetWindowTextA, hWnd, ADDR timeEditBuf
    invoke SendMessageA, hWnd, EM_SETSEL, 19, 19
    xor eax, eax
    ret

handle_letter_p:
    invoke SendMessageA, hWnd, EM_GETSEL, 0, 0
    and eax, 0FFFFh
    cmp eax, 5
    je set_start_pm
    cmp eax, 6
    je set_start_pm
    cmp eax, 16
    je set_end_pm
    cmp eax, 17
    je set_end_pm
    jmp block_key
set_start_pm:
    invoke GetWindowTextA, hWnd, ADDR timeEditBuf, 24
    mov edi, OFFSET timeEditBuf
    add edi, 6
    mov byte ptr [edi], 'P'
    invoke SetWindowTextA, hWnd, ADDR timeEditBuf
    invoke SendMessageA, hWnd, EM_SETSEL, 11, 11
    xor eax, eax
    ret
set_end_pm:
    invoke GetWindowTextA, hWnd, ADDR timeEditBuf, 24
    mov edi, OFFSET timeEditBuf
    add edi, 17
    mov byte ptr [edi], 'P'
    invoke SetWindowTextA, hWnd, ADDR timeEditBuf
    invoke SendMessageA, hWnd, EM_SETSEL, 19, 19
    xor eax, eax
    ret

block_key:
    xor eax, eax
    ret

handle_backspace:
    invoke SendMessageA, hWnd, EM_GETSEL, 0, 0
    and eax, 0FFFFh
    mov selStart, eax
    cmp selStart, 0
    je block_key

    mov eax, selStart
    dec eax
    cmp eax, 18
    jne back_check_16
    mov eax, 17
back_check_16:
    cmp eax, 16
    jne back_check_13
    mov eax, 15
back_check_13:
    cmp eax, 13
    jne back_check_10
    mov eax, 12
back_check_10:
    cmp eax, 10
    jne back_check_5
    mov eax, 6
back_check_5:
    cmp eax, 5
    jne back_check_2
    mov eax, 4
back_check_2:
    cmp eax, 2
    jne back_ready
    mov eax, 1
back_ready:
    mov pos, eax

    invoke GetWindowTextA, hWnd, ADDR timeEditBuf, 24
    mov edi, OFFSET timeEditBuf
    mov eax, pos
    add edi, eax
    cmp pos, 6
    je clear_ampm_letter
    cmp pos, 17
    je clear_ampm_letter
    mov byte ptr [edi], '0'
    jmp write_backspace
clear_ampm_letter:
    mov byte ptr [edi], 'A'
write_backspace:
    invoke SetWindowTextA, hWnd, ADDR timeEditBuf
    invoke SendMessageA, hWnd, EM_SETSEL, pos, pos
    xor eax, eax
    ret

handle_keydown:
    mov eax, wParam
    cmp eax, VK_DELETE
    je handle_delete
    invoke CallWindowProcA, oldTimeEditProc, hWnd, uMsg, wParam, lParam
    ret

handle_delete:
    invoke SendMessageA, hWnd, EM_GETSEL, 0, 0
    and eax, 0FFFFh
    mov pos, eax
    cmp pos, 0
    je delete_digit
    cmp pos, 1
    je delete_digit
    cmp pos, 3
    je delete_digit
    cmp pos, 4
    je delete_digit
    cmp pos, 11
    je delete_digit
    cmp pos, 12
    je delete_digit
    cmp pos, 14
    je delete_digit
    cmp pos, 15
    je delete_digit
    cmp pos, 6
    je delete_letter
    cmp pos, 17
    je delete_letter
    jmp block_key

delete_digit:
    invoke GetWindowTextA, hWnd, ADDR timeEditBuf, 24
    mov edi, OFFSET timeEditBuf
    mov eax, pos
    add edi, eax
    mov byte ptr [edi], '0'
    invoke SetWindowTextA, hWnd, ADDR timeEditBuf
    invoke SendMessageA, hWnd, EM_SETSEL, pos, pos
    xor eax, eax
    ret

delete_letter:
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