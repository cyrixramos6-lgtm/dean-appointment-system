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
SW_SHOW equ 5
SW_HIDE equ 0

WM_CREATE equ 0001h
WM_DESTROY equ 0002h
WM_CLOSE equ 0010h
WM_COMMAND equ 0111h
WM_SETFONT equ 0030h
WM_CTLCOLORSTATIC equ 0138h
LB_ADDSTRING equ 0180h
LB_RESETCONTENT equ 0184h
LB_GETCURSEL equ 0188h

MB_OK equ 0
MB_ICONINFORMATION equ 040h
MB_ICONWARNING equ 030h
CS_HREDRAW equ 0002h
CS_VREDRAW equ 0001h
COLOR_WINDOW equ 5
IDC_ARROW equ 32512

MAX_RECORDS equ 20
NAME_LEN equ 40
PURPOSE_LEN equ 80
DATE_LEN equ 15
TIME_LEN equ 10

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
ID_SEARCH equ 2007
ID_CANCEL equ 2008
ID_MOVE equ 2009
ID_EXIT equ 2010

ID_LIST equ 3001
ID_DETAILSBOX equ 3002
ID_STATUS equ 3003

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

WndProc PROTO :DWORD,:DWORD,:DWORD,:DWORD
RefreshList PROTO
BookAppointment PROTO
ViewSelected PROTO
SearchAppointment PROTO
CancelAppointment PROTO
MoveAppointment PROTO
ShowRecord PROTO :DWORD
CopyRecord PROTO :DWORD,:DWORD
ClearRecord PROTO :DWORD
ParseID PROTO
NumberToText PROTO :DWORD,:DWORD
SetDeanMode PROTO :DWORD

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
txtQueue db "APPOINTMENT QUEUE - FCFS",0
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
txtSearch db "SEARCH ID",0
txtCancel db "CANCEL / REMOVE",0
txtMove db "MOVE / RESCHEDULE",0
txtExit db "EXIT",0

deanPassword db "DEAN123",0

msgBooked db "Appointment request submitted. Your appointment is now in the FCFS queue.",0
msgFull db "The appointment queue is full. Maximum is 20.",0
msgInvalid db "Please complete Name, Date, Time, and Purpose.",0
msgNotFound db "Appointment ID not found.",0
msgNoRecords db "No appointments available.",0
msgSelect db "Please select an appointment from the Dean appointment list.",0
msgWrongPassword db "Incorrect Dean password.",0
msgDeanOnly db "This function is available only in Dean Mode.",0
msgLogin db "Dean Mode unlocked. The Dean can now view, search, cancel, and reschedule appointments.",0
msgLogout db "Dean Mode locked. Student Mode is active.",0
msgCancelled db "Appointment cancelled and removed from the FCFS queue.",0
msgMoved db "Appointment moved/rescheduled successfully.",0

statusStudent db "STUDENT MODE: Fill in your information and submit an appointment request.",0
statusDean db "DEAN MODE: You can view, search, cancel, and reschedule appointments.",0

prefixID db "ID: ",0
prefixName db " | Student: ",0
prefixDate db " | Date: ",0
prefixTime db " | Time: ",0
prefixPurpose db " | Purpose: ",0
detailID db "Appointment ID: ",0
detailName db "Student Name: ",0
detailDate db "Appointment Date: ",0
detailTime db "Appointment Time: ",0
detailPurpose db "Purpose: ",0
detailQueue db "FCFS Position: ",0
newline db 13,10,0

inputName db 64 dup(0)
inputDate db 32 dup(0)
inputTime db 32 dup(0)
inputPurpose db 128 dup(0)
inputID db 16 dup(0)
inputPassword db 32 dup(0)
numBuf db 16 dup(0)
listBuf db 512 dup(0)
detailsBuf db 1024 dup(0)

names db MAX_RECORDS*(NAME_LEN+1) dup(0)
dates db MAX_RECORDS*(DATE_LEN+1) dup(0)
times db MAX_RECORDS*(TIME_LEN+1) dup(0)
purposes db MAX_RECORDS*(PURPOSE_LEN+1) dup(0)
ids db MAX_RECORDS dup(0)

recCount dd 0
nextID dd 1
isDeanMode dd FALSE

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
hBtnSearch dd 0
hBtnCancel dd 0
hBtnMove dd 0

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
        WS_OVERLAPPEDWINDOW, 70, 30, 1180, 760, \
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
    cmp uMsg, WM_CLOSE
    je window_close
    cmp uMsg, WM_DESTROY
    je window_destroy

    invoke DefWindowProcA, hWnd, uMsg, wParam, lParam
    ret

window_create:
    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtHeader, \
        WS_CHILD or WS_VISIBLE, 30,20,1080,40,hWnd,0,hInstance,NULL
    invoke SendMessageA, eax, WM_SETFONT, hFontBold, TRUE

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtSubHeader, \
        WS_CHILD or WS_VISIBLE, 30,60,1080,25,hWnd,0,hInstance,NULL
    invoke SendMessageA, eax, WM_SETFONT, hFont, TRUE

    ; STUDENT AREA
    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtStudent, \
        WS_CHILD or WS_VISIBLE or BS_GROUPBOX, \
        30,100,440,350,hWnd,0,hInstance,NULL
    invoke SendMessageA, eax, WM_SETFONT, hFontBold, TRUE

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtName, \
        WS_CHILD or WS_VISIBLE,50,140,125,25,hWnd,0,hInstance,NULL
    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsEdit, NULL, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_AUTOHSCROLL, \
        180,137,250,28,hWnd,ID_NAME,hInstance,NULL
    mov hEditName,eax

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtDate, \
        WS_CHILD or WS_VISIBLE,50,185,125,25,hWnd,0,hInstance,NULL
    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsEdit, NULL, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_AUTOHSCROLL, \
        180,182,150,28,hWnd,ID_DATE,hInstance,NULL
    mov hEditDate,eax

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtTime, \
        WS_CHILD or WS_VISIBLE,50,230,125,25,hWnd,0,hInstance,NULL
    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsEdit, NULL, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_AUTOHSCROLL, \
        180,227,150,28,hWnd,ID_TIME,hInstance,NULL
    mov hEditTime,eax

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtPurpose, \
        WS_CHILD or WS_VISIBLE,50,275,125,25,hWnd,0,hInstance,NULL
    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsEdit, NULL, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_AUTOHSCROLL, \
        180,272,250,28,hWnd,ID_PURPOSE,hInstance,NULL
    mov hEditPurpose,eax

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtBook, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or BS_DEFPUSHBUTTON, \
        50,320,220,35,hWnd,ID_BOOK,hInstance,NULL

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtClear, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        280,320,150,35,hWnd,ID_CLEAR,hInstance,NULL

    ; DEAN LOGIN AREA
    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtDean, \
        WS_CHILD or WS_VISIBLE or BS_GROUPBOX, \
        30,370,440,150,hWnd,0,hInstance,NULL
    invoke SendMessageA, eax, WM_SETFONT, hFontBold, TRUE

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtPassword, \
        WS_CHILD or WS_VISIBLE,50,405,125,25,hWnd,0,hInstance,NULL

    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsEdit, NULL, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_PASSWORD or ES_AUTOHSCROLL, \
        180,402,250,28,hWnd,ID_PASSWORD,hInstance,NULL
    mov hEditPassword,eax

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtLogin, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        50,445,180,35,hWnd,ID_DEANLOGIN,hInstance,NULL

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtLogout, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        240,445,190,35,hWnd,ID_DEANLOGOUT,hInstance,NULL
    mov hBtnLogout,eax
    invoke EnableWindow,hBtnLogout,FALSE

    ; QUEUE
    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtQueue, \
        WS_CHILD or WS_VISIBLE or BS_GROUPBOX, \
        490,100,620,420,hWnd,0,hInstance,NULL
    invoke SendMessageA,eax,WM_SETFONT,hFontBold,TRUE

    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsListBox, NULL, \
        WS_CHILD or WS_VISIBLE or WS_VSCROLL or LBS_NOTIFY, \
        510,135,580,300,hWnd,ID_LIST,hInstance,NULL
    mov hList,eax
    invoke EnableWindow,hList,FALSE

    ; Details
    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtDetails, \
        WS_CHILD or WS_VISIBLE or BS_GROUPBOX, \
        30,540,1080,150,hWnd,0,hInstance,NULL

    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsStatic, NULL, \
        WS_CHILD or WS_VISIBLE or WS_BORDER, \
        50,575,1040,90,hWnd,ID_DETAILSBOX,hInstance,NULL
    mov hDetailsBox,eax
    invoke EnableWindow,hDetailsBox,FALSE

    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR statusStudent, \
        WS_CHILD or WS_VISIBLE or WS_BORDER, \
        510,445,580,55,hWnd,ID_STATUS,hInstance,NULL
    mov hStatus,eax

    ; Dean controls below queue
    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtView, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        510,465,135,35,hWnd,ID_VIEW,hInstance,NULL
    mov hBtnView,eax
    invoke EnableWindow,hBtnView,FALSE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtSelected, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        650,465,135,35,hWnd,ID_DETAILS,hInstance,NULL
    mov hBtnDetails,eax
    invoke EnableWindow,hBtnDetails,FALSE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtSearch, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        790,465,135,35,hWnd,ID_SEARCH,hInstance,NULL
    mov hBtnSearch,eax
    invoke EnableWindow,hBtnSearch,FALSE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtCancel, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        930,465,160,35,hWnd,ID_CANCEL,hInstance,NULL
    mov hBtnCancel,eax
    invoke EnableWindow,hBtnCancel,FALSE

    ; ID + Move controls
    invoke CreateWindowExA, 0, ADDR clsStatic, ADDR txtID, \
        WS_CHILD or WS_VISIBLE,510,525,110,25,hWnd,0,hInstance,NULL
    invoke CreateWindowExA, WS_EX_CLIENTEDGE, ADDR clsEdit, NULL, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_NUMBER, \
        625,522,100,28,hWnd,ID_APPTID,hInstance,NULL
    mov hEditID,eax
    invoke EnableWindow,hEditID,FALSE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtMove, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        740,520,180,35,hWnd,ID_MOVE,hInstance,NULL
    mov hBtnMove,eax
    invoke EnableWindow,hBtnMove,FALSE

    invoke CreateWindowExA, 0, ADDR clsButton, ADDR txtExit, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
        930,520,160,35,hWnd,ID_EXIT,hInstance,NULL

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
    cmp eax,ID_SEARCH
    je cmd_search
    cmp eax,ID_CANCEL
    je cmd_cancel
    cmp eax,ID_MOVE
    je cmd_move
    cmp eax,ID_EXIT
    je cmd_exit
    ret

cmd_book:
    call BookAppointment
    ret

cmd_clear:
    invoke SetWindowTextA,hEditName,NULL
    invoke SetWindowTextA,hEditDate,NULL
    invoke SetWindowTextA,hEditTime,NULL
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

cmd_search:
    cmp isDeanMode,TRUE
    jne dean_only
    call SearchAppointment
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
    invoke EnableWindow,hEditID,TRUE
    invoke EnableWindow,hBtnView,TRUE
    invoke EnableWindow,hBtnDetails,TRUE
    invoke EnableWindow,hBtnSearch,TRUE
    invoke EnableWindow,hBtnCancel,TRUE
    invoke EnableWindow,hBtnMove,TRUE
    invoke EnableWindow,hBtnLogout,TRUE
    invoke EnableWindow,hEditPassword,FALSE
    invoke SetWindowTextA,hStatus,ADDR statusDean
    invoke RefreshList
    ret

student_mode:
    invoke EnableWindow,hList,FALSE
    invoke EnableWindow,hDetailsBox,FALSE
    invoke EnableWindow,hEditID,FALSE
    invoke EnableWindow,hBtnView,FALSE
    invoke EnableWindow,hBtnDetails,FALSE
    invoke EnableWindow,hBtnSearch,FALSE
    invoke EnableWindow,hBtnCancel,FALSE
    invoke EnableWindow,hBtnMove,FALSE
    invoke EnableWindow,hBtnLogout,FALSE
    invoke EnableWindow,hEditPassword,TRUE
    invoke SetWindowTextA,hStatus,ADDR statusStudent
    invoke SendMessageA,hList,LB_RESETCONTENT,0,0
    invoke SendMessageA,hList,LB_ADDSTRING,0,ADDR msgDeanOnly
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

    mov eax,recCount
    mov ebx,nextID
    mov [ids+eax],bl

    inc nextID
    inc recCount

    invoke SetWindowTextA,hEditName,NULL
    invoke SetWindowTextA,hEditDate,NULL
    invoke SetWindowTextA,hEditTime,NULL
    invoke SetWindowTextA,hEditPurpose,NULL

    invoke MessageBoxA,hMainWnd,ADDR msgBooked,ADDR txtBook,MB_OK or MB_ICONINFORMATION
    ret

invalid_book:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalid,ADDR txtBook,MB_OK or MB_ICONWARNING
    ret
BookAppointment ENDP

RefreshList PROC
    cmp isDeanMode,TRUE
    je refresh_allowed
    ; Student must not see the appointment list.
    invoke SendMessageA,hList,LB_RESETCONTENT,0,0
    invoke SendMessageA,hList,LB_ADDSTRING,0,ADDR msgDeanOnly
    ret

refresh_allowed:
    invoke SendMessageA,hList,LB_RESETCONTENT,0,0
    mov ecx,recCount
    cmp ecx,0
    jne refresh_loop_start
    invoke SendMessageA,hList,LB_ADDSTRING,0,ADDR msgNoRecords
    ret

refresh_loop_start:
    xor esi,esi
refresh_loop:
    push ecx
    push esi
    invoke lstrcpyA,ADDR listBuf,ADDR prefixID

    mov eax,esi
    movzx eax,byte ptr [ids+eax]
    invoke NumberToText,eax,ADDR numBuf
    invoke lstrcatA,ADDR listBuf,ADDR numBuf

    invoke lstrcatA,ADDR listBuf,ADDR prefixName
    mov eax,esi
    mov ebx,NAME_LEN+1
    mul ebx
    mov edx,OFFSET names
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    invoke lstrcatA,ADDR listBuf,ADDR prefixDate
    mov eax,esi
    mov ebx,DATE_LEN+1
    mul ebx
    mov edx,OFFSET dates
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    invoke lstrcatA,ADDR listBuf,ADDR prefixTime
    mov eax,esi
    mov ebx,TIME_LEN+1
    mul ebx
    mov edx,OFFSET times
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    invoke lstrcatA,ADDR listBuf,ADDR prefixPurpose
    mov eax,esi
    mov ebx,PURPOSE_LEN+1
    mul ebx
    mov edx,OFFSET purposes
    add edx,eax
    invoke lstrcatA,ADDR listBuf,edx

    invoke SendMessageA,hList,LB_ADDSTRING,0,ADDR listBuf
    pop esi
    pop ecx
    inc esi
    dec ecx
    jz refresh_done
    jmp NEAR PTR refresh_loop

refresh_done:
    ret
RefreshList ENDP

ViewSelected PROC
    invoke SendMessageA,hList,LB_GETCURSEL,0,0
    cmp eax,0FFFFFFFFh
    je no_selection
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

    invoke lstrcatA,ADDR detailsBuf,ADDR detailQueue
    mov eax,index
    inc eax
    invoke NumberToText,eax,ADDR numBuf
    invoke lstrcatA,ADDR detailsBuf,ADDR numBuf

    invoke SetWindowTextA,hDetailsBox,ADDR detailsBuf
    ret
ShowRecord ENDP

SearchAppointment PROC
    invoke GetWindowTextA,hEditID,ADDR inputID,16
    call ParseID
    cmp eax,0
    je search_fail

    mov ebx,eax
    xor esi,esi
    mov ecx,recCount
search_loop:
    cmp ecx,0
    je search_fail
    mov eax,esi
    movzx eax,byte ptr [ids+eax]
    cmp eax,ebx
    je search_found
    inc esi
    dec ecx
    jmp search_loop
search_found:
    invoke ShowRecord,esi
    ret
search_fail:
    invoke MessageBoxA,hMainWnd,ADDR msgNotFound,ADDR txtSearch,MB_OK or MB_ICONWARNING
    ret
SearchAppointment ENDP

CancelAppointment PROC
    invoke GetWindowTextA,hEditID,ADDR inputID,16
    call ParseID
    cmp eax,0
    je cancel_fail

    mov ebx,eax
    xor esi,esi
    mov ecx,recCount
find_cancel:
    cmp ecx,0
    je cancel_fail
    mov eax,esi
    movzx eax,byte ptr [ids+eax]
    cmp eax,ebx
    je cancel_found
    inc esi
    dec ecx
    jmp find_cancel

cancel_found:
    mov eax,recCount
    dec eax
    cmp esi,eax
    jae cancel_last

    mov edi,esi
    inc edi
shift_records:
    invoke CopyRecord,edi,esi
    inc esi
    inc edi
    mov eax,recCount
    dec eax
    cmp edi,eax
    jbe shift_records

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
    ; Dean selects an appointment ID, then changes Date and Time fields.
    invoke GetWindowTextA,hEditID,ADDR inputID,16
    call ParseID
    cmp eax,0
    je move_fail

    mov ebx,eax
    xor esi,esi
    mov ecx,recCount
find_move:
    cmp ecx,0
    je move_fail
    mov eax,esi
    movzx eax,byte ptr [ids+eax]
    cmp eax,ebx
    je move_found
    inc esi
    dec ecx
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

    mov eax,esi
    mov ebx,DATE_LEN+1
    mul ebx
    mov edi,OFFSET dates
    add edi,eax
    invoke lstrcpynA,edi,ADDR inputDate,DATE_LEN+1

    mov eax,esi
    mov ebx,TIME_LEN+1
    mul ebx
    mov edi,OFFSET times
    add edi,eax
    invoke lstrcpynA,edi,ADDR inputTime,TIME_LEN+1

    call RefreshList
    invoke ShowRecord,esi
    invoke MessageBoxA,hMainWnd,ADDR msgMoved,ADDR txtMove,MB_OK or MB_ICONINFORMATION
    ret

move_invalid:
    invoke MessageBoxA,hMainWnd,ADDR msgInvalid,ADDR txtMove,MB_OK or MB_ICONWARNING
    ret

move_fail:
    invoke MessageBoxA,hMainWnd,ADDR msgNotFound,ADDR txtMove,MB_OK or MB_ICONWARNING
    ret
MoveAppointment ENDP

CopyRecord PROC sourceIndex:DWORD,destinationIndex:DWORD
    mov eax,sourceIndex
    mov dl,[ids+eax]
    mov eax,destinationIndex
    mov [ids+eax],dl

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

END start
