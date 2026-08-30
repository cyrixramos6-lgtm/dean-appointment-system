.386
.model flat, stdcall
option casemap:none

; ============================================================
; CPE-TRACK - Student Attendance Management System
; MASM32 / Visual Studio MASM-compatible Win32 GUI
;
; IMPORTANT:
; This version intentionally does NOT use chr$ and does NOT
; redefine ListView constants/structures already supplied by
; MASM32 windows.inc. Those were the main causes of the
; previous A2005/A2006/A2081/A2114/A2166 errors.
; ============================================================

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\gdi32.inc
include \masm32\include\comctl32.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\comctl32.lib

MAX_STUDENTS EQU 32
NAME_LEN     EQU 64
ID_LEN       EQU 32
DATE_LEN     EQU 20
STATUS_LEN   EQU 16

IDC_NAME     EQU 1001
IDC_ID       EQU 1002
IDC_DATE     EQU 1003
IDC_STATUS   EQU 1004
IDC_ADD      EQU 1005
IDC_VIEW     EQU 1006
IDC_REPORT   EQU 1007
IDC_CLEAR    EQU 1008
IDC_EXIT     EQU 1009
IDC_LIST     EQU 1010

; ------------------------------------------------------------
; Private control/message constants. Unique names prevent
; collisions with MASM32 windows.inc.
; ------------------------------------------------------------
MY_EM_SETCUEBANNER       EQU 1501h
MY_LVS_REPORT            EQU 0001h
MY_LVS_SINGLESEL         EQU 0004h
MY_LVS_SHOWSELALWAYS     EQU 0008h
MY_LVS_EX_GRIDLINES      EQU 00000001h
MY_LVS_EX_FULLROWSELECT  EQU 00000020h
MY_LVIF_TEXT             EQU 0001h
MY_LVNI_SELECTED         EQU 0002h
MY_LVCF_TEXT             EQU 0004h
MY_LVCF_WIDTH            EQU 0002h
MY_LVCF_SUBITEM          EQU 0008h
MY_CB_ADDSTRING          EQU 0143h
MY_CB_GETCURSEL          EQU 0147h
MY_CB_GETLBTEXT          EQU 0148h
MY_CB_SETCURSEL          EQU 014Eh
MY_LVM_SETEXTENDEDLISTVIEWSTYLE EQU 1036h
MY_LVM_INSERTITEM        EQU 1007h
MY_LVM_SETITEMTEXT       EQU 102Eh
MY_LVM_GETNEXTITEM       EQU 100Ch
MY_LVM_INSERTCOLUMN      EQU 1061h

; ------------------------------------------------------------
; Local structures with UNIQUE field names.
; This avoids collisions with fields/macros from windows.inc.
; ------------------------------------------------------------
MY_LVCOLUMN STRUCT
    colMask     DWORD ?
    colFmt      DWORD ?
    colCx       DWORD ?
    colText     DWORD ?
    colMax      DWORD ?
    colSubItem  DWORD ?
    colImage    DWORD ?
    colOrder    DWORD ?
MY_LVCOLUMN ENDS

MY_LVITEM STRUCT
    itemMask    DWORD ?
    itemIndex   DWORD ?
    itemSub     DWORD ?
    itemState   DWORD ?
    itemStateMx DWORD ?
    itemText    DWORD ?
    itemMax     DWORD ?
    itemImage   DWORD ?
    itemParam   DWORD ?
    itemIndent  DWORD ?
MY_LVITEM ENDS

.data

AppTitle        db "CPE-TRACK - Student Attendance System",0
ClassName       db "CPETRACK_WINDOW",0

; Window/control class names - no chr$ macro required.
szSTATIC        db "STATIC",0
szEDIT          db "EDIT",0
szBUTTON        db "BUTTON",0
szCOMBOBOX      db "COMBOBOX",0
szLISTVIEW      db "SysListView32",0

; Main headings
TxtLogo         db "CPE-TRACK",0
TxtSubtitle     db "STUDENT ATTENDANCE MANAGEMENT SYSTEM",0
TxtLimit        db "LIMIT: 32 STUDENTS",0
TxtEntry        db "ENTER STUDENT ATTENDANCE",0
TxtRecord       db "ATTENDANCE RECORD - FIRST COME FIRST SERVE",0
TxtSummary      db "ATTENDANCE SUMMARY",0

; Labels
TxtName         db "Name:",0
TxtStudentID    db "Student ID:",0
TxtDate         db "Date:",0
TxtStatus       db "Status:",0

; Cue banners
TxtNameHint     db "Enter student name",0
TxtIDHint       db "Enter student ID",0
TxtDateHint     db "MM/DD/YYYY",0

; Buttons
TxtAdd          db "+  ADD STUDENT",0
TxtView         db "VIEW SELECTED",0
TxtReport       db "GENERATE REPORT",0
TxtClear        db "CLEAR INPUT",0
TxtExit         db "EXIT SYSTEM",0

; ListView headings
HdrNo           db "No.",0
HdrName         db "Name",0
HdrID           db "Student ID",0
HdrDate         db "Date",0
HdrStatus       db "Status",0

; Status choices
StatusPresent   db "Present",0
StatusAbsent    db "Absent",0
StatusLate      db "Late",0

; Summary labels
TxtTotal        db "TOTAL STUDENTS",0
TxtPresent      db "TOTAL PRESENT",0
TxtAbsent       db "TOTAL ABSENT",0
TxtLate         db "TOTAL LATE",0

; Footer
TxtFooter       db "Students Entered: 0 / 32",0
TxtFCFS         db "First Come, First Serve (FCFS)",0

; Messages
MsgFull         db "Attendance is full. The maximum is 32 students.",0
MsgNeedName     db "Please enter the student name.",0
MsgNeedID       db "Please enter the student ID.",0
MsgNeedDate     db "Please enter the date.",0
MsgAdded        db "Student attendance added successfully.",0
MsgNoSelection  db "Please select a student from the attendance record first.",0
MsgReportOK     db "Attendance report generated as attendance_report.txt.",0
MsgReportErr    db "Unable to create attendance_report.txt.",0
MsgConfirmExit  db "Exit CPE-TRACK?",0
MsgViewTitle    db "Selected Student",0

; Formatting strings
FmtNo           db "%02u",0
FmtNumber       db "%u",0
FmtSelected     db "No.: %s",13,10,"Name: %s",13,10,
                db "Student ID: %s",13,10,"Date: %s",13,10,
                db "Status: %s",0

FmtReportHead   db "CPE-TRACK - STUDENT ATTENDANCE REPORT",13,10
                db "======================================",13,10
                db "No. | Name | Student ID | Date | Status",13,10,13,10,0

FmtReportLine   db "%02u | %s | %s | %s | %s",13,10,0

; Temporary buffers
tmpName         db NAME_LEN dup(0)
tmpID           db ID_LEN dup(0)
tmpDate         db DATE_LEN dup(0)
tmpStatus       db STATUS_LEN dup(0)
tmpNo           db 16 dup(0)
tmpNumber       db 128 dup(0)
msgBuffer       db 512 dup(0)
reportBuffer    db 1024 dup(0)

fileName        db "attendance_report.txt",0
FontName        db "Segoe UI",0
emptyString     db 0

; ------------------------------------------------------------
; Storage for 32 records.
; Each record remains at its original position.
; Therefore the ListView is always FCFS order.
; ------------------------------------------------------------
studentNames    db (MAX_STUDENTS * NAME_LEN) dup(0)
studentIDs      db (MAX_STUDENTS * ID_LEN) dup(0)
studentDates    db (MAX_STUDENTS * DATE_LEN) dup(0)
studentStatuses db (MAX_STUDENTS * STATUS_LEN) dup(0)

; Handles
hInstance       dd 0
hMainWnd        dd 0
hList           dd 0
hNameEdit       dd 0
hIDEdit         dd 0
hDateEdit       dd 0
hStatusCombo    dd 0
hFont           dd 0

hTotalStatic    dd 0
hPresentStatic  dd 0
hAbsentStatic   dd 0
hLateStatic     dd 0
hFooterStatic   dd 0

; Counters
recordCount     dd 0
presentCount    dd 0
absentCount     dd 0
lateCount       dd 0

icc             INITCOMMONCONTROLSEX <sizeof INITCOMMONCONTROLSEX, ICC_LISTVIEW_CLASSES>
wc              WNDCLASSEXA <>
msg             MSG <>

.code

; ============================================================
; Apply application font
; ============================================================
SetControlFont PROC hCtl:DWORD
    invoke SendMessageA, hCtl, WM_SETFONT, hFont, TRUE
    ret
SetControlFont ENDP

; ============================================================
; Create a STATIC control
; ============================================================
CreateLabel PROC hParent:DWORD, x:DWORD, y:DWORD, w:DWORD, h:DWORD, pText:DWORD
    LOCAL hCtl:DWORD

    invoke CreateWindowExA, 0, addr szSTATIC, pText, \
        WS_CHILD or WS_VISIBLE, x, y, w, h, hParent, 0, hInstance, 0

    mov hCtl, eax
    invoke SetControlFont, hCtl
    mov eax, hCtl
    ret
CreateLabel ENDP

; ============================================================
; Create a BUTTON control
; ============================================================
CreateButton PROC hParent:DWORD, x:DWORD, y:DWORD, w:DWORD, h:DWORD, pText:DWORD, ctrlID:DWORD
    LOCAL hCtl:DWORD

    invoke CreateWindowExA, 0, addr szBUTTON, pText, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or BS_PUSHBUTTON, \
        x, y, w, h, hParent, ctrlID, hInstance, 0

    mov hCtl, eax
    invoke SetControlFont, hCtl
    mov eax, hCtl
    ret
CreateButton ENDP

; ============================================================
; Update totals on screen
; ============================================================
UpdateSummary PROC
    LOCAL buffer[64]:BYTE

    invoke wsprintfA, addr buffer, addr FmtNumber, recordCount
    invoke SetWindowTextA, hTotalStatic, addr buffer

    invoke wsprintfA, addr buffer, addr FmtNumber, presentCount
    invoke SetWindowTextA, hPresentStatic, addr buffer

    invoke wsprintfA, addr buffer, addr FmtNumber, absentCount
    invoke SetWindowTextA, hAbsentStatic, addr buffer

    invoke wsprintfA, addr buffer, addr FmtNumber, lateCount
    invoke SetWindowTextA, hLateStatic, addr buffer

    invoke wsprintfA, addr buffer, addr FmtNumber, recordCount
    invoke lstrcpyA, addr tmpNumber, addr FooterPrefix
    invoke lstrcatA, addr tmpNumber, addr buffer
    invoke lstrcatA, addr tmpNumber, addr FooterSuffix
    invoke SetWindowTextA, hFooterStatic, addr tmpNumber

    ret
UpdateSummary ENDP

; Footer pieces
.data
FooterPrefix    db "Students Entered: ",0
FooterSuffix    db " / 32",0

.code

; ============================================================
; Insert a record at the END of the ListView.
; index = 0..31. Appending guarantees FCFS.
; ============================================================
InsertListRow PROC index:DWORD
    LOCAL item:MY_LVITEM
    LOCAL pName:DWORD
    LOCAL pID:DWORD
    LOCAL pDate:DWORD
    LOCAL pStatus:DWORD

    ; Name address
    mov eax, index
    imul eax, NAME_LEN
    add eax, OFFSET studentNames
    mov pName, eax

    ; ID address
    mov eax, index
    imul eax, ID_LEN
    add eax, OFFSET studentIDs
    mov pID, eax

    ; Date address
    mov eax, index
    imul eax, DATE_LEN
    add eax, OFFSET studentDates
    mov pDate, eax

    ; Status address
    mov eax, index
    imul eax, STATUS_LEN
    add eax, OFFSET studentStatuses
    mov pStatus, eax

    ; -------------------------
    ; Column 0: No.
    ; -------------------------
    mov eax, index
    inc eax
    invoke wsprintfA, addr tmpNo, addr FmtNo, eax

    invoke RtlZeroMemory, addr item, SIZEOF MY_LVITEM
    mov item.itemMask, MY_LVIF_TEXT
    mov eax, index
    mov item.itemIndex, eax
    mov item.itemSub, 0
    mov item.itemText, OFFSET tmpNo

    invoke SendMessageA, hList, MY_LVM_INSERTITEM, 0, addr item

    ; -------------------------
    ; Column 1: Name
    ; -------------------------
    invoke RtlZeroMemory, addr item, SIZEOF MY_LVITEM
    mov item.itemMask, MY_LVIF_TEXT
    mov eax, index
    mov item.itemIndex, eax
    mov item.itemSub, 1
    mov eax, pName
    mov item.itemText, eax

    invoke SendMessageA, hList, MY_LVM_SETITEMTEXT, index, addr item

    ; -------------------------
    ; Column 2: Student ID
    ; -------------------------
    invoke RtlZeroMemory, addr item, SIZEOF MY_LVITEM
    mov item.itemMask, MY_LVIF_TEXT
    mov eax, index
    mov item.itemIndex, eax
    mov item.itemSub, 2
    mov eax, pID
    mov item.itemText, eax

    invoke SendMessageA, hList, MY_LVM_SETITEMTEXT, index, addr item

    ; -------------------------
    ; Column 3: Date
    ; -------------------------
    invoke RtlZeroMemory, addr item, SIZEOF MY_LVITEM
    mov item.itemMask, MY_LVIF_TEXT
    mov eax, index
    mov item.itemIndex, eax
    mov item.itemSub, 3
    mov eax, pDate
    mov item.itemText, eax

    invoke SendMessageA, hList, MY_LVM_SETITEMTEXT, index, addr item

    ; -------------------------
    ; Column 4: Status
    ; -------------------------
    invoke RtlZeroMemory, addr item, SIZEOF MY_LVITEM
    mov item.itemMask, MY_LVIF_TEXT
    mov eax, index
    mov item.itemIndex, eax
    mov item.itemSub, 4
    mov eax, pStatus
    mov item.itemText, eax

    invoke SendMessageA, hList, MY_LVM_SETITEMTEXT, index, addr item

    ret
InsertListRow ENDP

; ============================================================
; Add a student
; ============================================================
AddStudent PROC
    LOCAL index:DWORD
    LOCAL sel:DWORD
    LOCAL pName:DWORD
    LOCAL pID:DWORD
    LOCAL pDate:DWORD
    LOCAL pStatus:DWORD

    ; Check 32-student limit.
    mov eax, recordCount
    cmp eax, MAX_STUDENTS
    jb @AddNotFull

    invoke MessageBoxA, hMainWnd, addr MsgFull, addr AppTitle, \
        MB_OK or MB_ICONWARNING
    ret

@AddNotFull:

    ; Read Name
    invoke GetWindowTextA, hNameEdit, addr tmpName, NAME_LEN
    cmp eax, 0
    jne @NameOK

    invoke MessageBoxA, hMainWnd, addr MsgNeedName, addr AppTitle, \
        MB_OK or MB_ICONWARNING
    ret

@NameOK:

    ; Read Student ID
    invoke GetWindowTextA, hIDEdit, addr tmpID, ID_LEN
    cmp eax, 0
    jne @IDOK

    invoke MessageBoxA, hMainWnd, addr MsgNeedID, addr AppTitle, \
        MB_OK or MB_ICONWARNING
    ret

@IDOK:

    ; Read Date
    invoke GetWindowTextA, hDateEdit, addr tmpDate, DATE_LEN
    cmp eax, 0
    jne @DateOK

    invoke MessageBoxA, hMainWnd, addr MsgNeedDate, addr AppTitle, \
        MB_OK or MB_ICONWARNING
    ret

@DateOK:

    ; Get status selection.
    invoke SendMessageA, hStatusCombo, MY_CB_GETCURSEL, 0, 0
    mov sel, eax

    cmp eax, CB_ERR
    jne @StatusOK
    mov sel, 0

@StatusOK:
    invoke SendMessageA, hStatusCombo, MY_CB_GETLBTEXT, sel, addr tmpStatus

    ; Current record index = number already entered.
    mov eax, recordCount
    mov index, eax

    ; Calculate destination addresses.
    mov eax, index
    imul eax, NAME_LEN
    add eax, OFFSET studentNames
    mov pName, eax

    mov eax, index
    imul eax, ID_LEN
    add eax, OFFSET studentIDs
    mov pID, eax

    mov eax, index
    imul eax, DATE_LEN
    add eax, OFFSET studentDates
    mov pDate, eax

    mov eax, index
    imul eax, STATUS_LEN
    add eax, OFFSET studentStatuses
    mov pStatus, eax

    ; Store data.
    invoke lstrcpyA, pName, addr tmpName
    invoke lstrcpyA, pID, addr tmpID
    invoke lstrcpyA, pDate, addr tmpDate
    invoke lstrcpyA, pStatus, addr tmpStatus

    ; Update status total.
    cmp sel, 0
    jne @CheckAbsent

    inc presentCount
    jmp @StatusCountDone

@CheckAbsent:
    cmp sel, 1
    jne @CountLate

    inc absentCount
    jmp @StatusCountDone

@CountLate:
    inc lateCount

@StatusCountDone:

    ; Append record to ListView.
    invoke InsertListRow, index

    inc recordCount
    invoke UpdateSummary

    ; Clear input fields for next FCFS entry.
    invoke SetWindowTextA, hNameEdit, addr emptyString
    invoke SetWindowTextA, hIDEdit, addr emptyString
    invoke SetWindowTextA, hDateEdit, addr emptyString
    invoke SendMessageA, hStatusCombo, MY_CB_SETCURSEL, 0, 0
    invoke SetFocus, hNameEdit

    invoke MessageBoxA, hMainWnd, addr MsgAdded, addr AppTitle, \
        MB_OK or MB_ICONINFORMATION

    ret
AddStudent ENDP

; ============================================================
; View selected student
; ============================================================
ViewSelected PROC
    LOCAL selected:DWORD
    LOCAL pName:DWORD
    LOCAL pID:DWORD
    LOCAL pDate:DWORD
    LOCAL pStatus:DWORD

    invoke SendMessageA, hList, MY_LVM_GETNEXTITEM, -1, MY_LVNI_SELECTED
    mov selected, eax

    cmp eax, -1
    jne @SelectionOK

    invoke MessageBoxA, hMainWnd, addr MsgNoSelection, addr AppTitle, \
        MB_OK or MB_ICONWARNING
    ret

@SelectionOK:

    mov eax, selected
    imul eax, NAME_LEN
    add eax, OFFSET studentNames
    mov pName, eax

    mov eax, selected
    imul eax, ID_LEN
    add eax, OFFSET studentIDs
    mov pID, eax

    mov eax, selected
    imul eax, DATE_LEN
    add eax, OFFSET studentDates
    mov pDate, eax

    mov eax, selected
    imul eax, STATUS_LEN
    add eax, OFFSET studentStatuses
    mov pStatus, eax

    mov eax, selected
    inc eax
    invoke wsprintfA, addr tmpNo, addr FmtNo, eax

    invoke wsprintfA, addr msgBuffer, addr FmtSelected, \
        addr tmpNo, pName, pID, pDate, pStatus

    invoke MessageBoxA, hMainWnd, addr msgBuffer, addr MsgViewTitle, \
        MB_OK or MB_ICONINFORMATION

    ret
ViewSelected ENDP

; ============================================================
; Generate attendance_report.txt
; ============================================================
GenerateReport PROC
    LOCAL hFile:DWORD
    LOCAL bytesWritten:DWORD
    LOCAL headerLen:DWORD
    LOCAL i:DWORD
    LOCAL pName:DWORD
    LOCAL pID:DWORD
    LOCAL pDate:DWORD
    LOCAL pStatus:DWORD
    LOCAL lineLen:DWORD
    LOCAL lineNo:DWORD

    invoke CreateFileA, addr fileName, GENERIC_WRITE, FILE_SHARE_READ, \
        NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL

    mov hFile, eax

    cmp eax, INVALID_HANDLE_VALUE
    jne @FileOK

    invoke MessageBoxA, hMainWnd, addr MsgReportErr, addr AppTitle, \
        MB_OK or MB_ICONERROR
    ret

@FileOK:

    ; Store lstrlen result BEFORE the next invoke.
    ; This avoids the previous "register value overwritten by INVOKE"
    ; warning.
    invoke lstrlenA, addr FmtReportHead
    mov headerLen, eax

    invoke WriteFile, hFile, addr FmtReportHead, headerLen, \
        addr bytesWritten, NULL

    mov i, 0

@ReportLoop:
    mov eax, i
    cmp eax, recordCount
    jae @ReportDone

    mov eax, i
    inc eax
    mov lineNo, eax

    mov eax, i
    imul eax, NAME_LEN
    add eax, OFFSET studentNames
    mov pName, eax

    mov eax, i
    imul eax, ID_LEN
    add eax, OFFSET studentIDs
    mov pID, eax

    mov eax, i
    imul eax, DATE_LEN
    add eax, OFFSET studentDates
    mov pDate, eax

    mov eax, i
    imul eax, STATUS_LEN
    add eax, OFFSET studentStatuses
    mov pStatus, eax

    invoke wsprintfA, addr reportBuffer, addr FmtReportLine, \
        lineNo, pName, pID, pDate, pStatus

    invoke lstrlenA, addr reportBuffer
    mov lineLen, eax

    invoke WriteFile, hFile, addr reportBuffer, lineLen, \
        addr bytesWritten, NULL

    inc i
    jmp @ReportLoop

@ReportDone:
    invoke CloseHandle, hFile

    invoke MessageBoxA, hMainWnd, addr MsgReportOK, addr AppTitle, \
        MB_OK or MB_ICONINFORMATION

    ret
GenerateReport ENDP

; ============================================================
; Create all GUI controls
; ============================================================
CreateControls PROC hWnd:DWORD
    LOCAL lvc:MY_LVCOLUMN

    ; --------------------------------------------------------
    ; Header
    ; --------------------------------------------------------
    invoke CreateLabel, hWnd, 45, 18, 600, 42, addr TxtLogo
    invoke CreateLabel, hWnd, 47, 58, 650, 28, addr TxtSubtitle
    invoke CreateLabel, hWnd, 1030, 28, 230, 32, addr TxtLimit

    ; Section titles
    invoke CreateLabel, hWnd, 28, 112, 545, 34, addr TxtEntry
    invoke CreateLabel, hWnd, 592, 112, 650, 34, addr TxtRecord
    invoke CreateLabel, hWnd, 28, 520, 1220, 34, addr TxtSummary

    ; Input labels
    invoke CreateLabel, hWnd, 48, 164, 120, 28, addr TxtName
    invoke CreateLabel, hWnd, 48, 214, 120, 28, addr TxtStudentID
    invoke CreateLabel, hWnd, 48, 264, 120, 28, addr TxtDate
    invoke CreateLabel, hWnd, 48, 314, 120, 28, addr TxtStatus

    ; --------------------------------------------------------
    ; Name edit
    ; --------------------------------------------------------
    invoke CreateWindowExA, WS_EX_CLIENTEDGE, addr szEDIT, addr emptyString, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_AUTOHSCROLL, \
        170, 158, 370, 36, hWnd, IDC_NAME, hInstance, NULL
    mov hNameEdit, eax
    invoke SetControlFont, hNameEdit
    invoke SendMessageA, hNameEdit, MY_EM_SETCUEBANNER, 0, addr TxtNameHint

    ; --------------------------------------------------------
    ; Student ID edit
    ; --------------------------------------------------------
    invoke CreateWindowExA, WS_EX_CLIENTEDGE, addr szEDIT, addr emptyString, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_AUTOHSCROLL, \
        170, 208, 370, 36, hWnd, IDC_ID, hInstance, NULL
    mov hIDEdit, eax
    invoke SetControlFont, hIDEdit
    invoke SendMessageA, hIDEdit, MY_EM_SETCUEBANNER, 0, addr TxtIDHint

    ; --------------------------------------------------------
    ; Date edit
    ; --------------------------------------------------------
    invoke CreateWindowExA, WS_EX_CLIENTEDGE, addr szEDIT, addr emptyString, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or ES_AUTOHSCROLL, \
        170, 258, 370, 36, hWnd, IDC_DATE, hInstance, NULL
    mov hDateEdit, eax
    invoke SetControlFont, hDateEdit
    invoke SendMessageA, hDateEdit, MY_EM_SETCUEBANNER, 0, addr TxtDateHint

    ; --------------------------------------------------------
    ; Status combo box
    ; --------------------------------------------------------
    invoke CreateWindowExA, WS_EX_CLIENTEDGE, addr szCOMBOBOX, addr emptyString, \
        WS_CHILD or WS_VISIBLE or WS_TABSTOP or CBS_DROPDOWNLIST, \
        170, 308, 370, 160, hWnd, IDC_STATUS, hInstance, NULL
    mov hStatusCombo, eax
    invoke SetControlFont, hStatusCombo

    invoke SendMessageA, hStatusCombo, MY_CB_ADDSTRING, 0, addr StatusPresent
    invoke SendMessageA, hStatusCombo, MY_CB_ADDSTRING, 0, addr StatusAbsent
    invoke SendMessageA, hStatusCombo, MY_CB_ADDSTRING, 0, addr StatusLate
    invoke SendMessageA, hStatusCombo, MY_CB_SETCURSEL, 0, 0

    ; --------------------------------------------------------
    ; Buttons
    ; --------------------------------------------------------
    invoke CreateButton, hWnd, 48, 370, 492, 48, addr TxtAdd, IDC_ADD
    invoke CreateButton, hWnd, 48, 430, 238, 44, addr TxtView, IDC_VIEW
    invoke CreateButton, hWnd, 302, 430, 238, 44, addr TxtReport, IDC_REPORT
    invoke CreateButton, hWnd, 48, 480, 238, 36, addr TxtClear, IDC_CLEAR
    invoke CreateButton, hWnd, 302, 480, 238, 36, addr TxtExit, IDC_EXIT

    ; --------------------------------------------------------
    ; Attendance ListView
    ; --------------------------------------------------------
    invoke CreateWindowExA, WS_EX_CLIENTEDGE, addr szLISTVIEW, addr emptyString, \
        WS_CHILD or WS_VISIBLE or MY_LVS_REPORT or MY_LVS_SINGLESEL or MY_LVS_SHOWSELALWAYS, \
        592, 158, 650, 350, hWnd, IDC_LIST, hInstance, NULL
    mov hList, eax
    invoke SetControlFont, hList

    invoke SendMessageA, hList, MY_LVM_SETEXTENDEDLISTVIEWSTYLE, 0, \
        MY_LVS_EX_FULLROWSELECT or MY_LVS_EX_GRIDLINES

    ; --------------------------------------------------------
    ; ListView column 0 - No.
    ; --------------------------------------------------------
    invoke RtlZeroMemory, addr lvc, SIZEOF MY_LVCOLUMN
    mov lvc.colMask, MY_LVCF_TEXT or MY_LVCF_WIDTH or MY_LVCF_SUBITEM
    mov lvc.colCx, 55
    mov lvc.colText, OFFSET HdrNo
    mov lvc.colSubItem, 0
    invoke SendMessageA, hList, MY_LVM_INSERTCOLUMN, 0, addr lvc

    ; Column 1 - Name
    invoke RtlZeroMemory, addr lvc, SIZEOF MY_LVCOLUMN
    mov lvc.colMask, MY_LVCF_TEXT or MY_LVCF_WIDTH or MY_LVCF_SUBITEM
    mov lvc.colCx, 185
    mov lvc.colText, OFFSET HdrName
    mov lvc.colSubItem, 1
    invoke SendMessageA, hList, MY_LVM_INSERTCOLUMN, 1, addr lvc

    ; Column 2 - Student ID
    invoke RtlZeroMemory, addr lvc, SIZEOF MY_LVCOLUMN
    mov lvc.colMask, MY_LVCF_TEXT or MY_LVCF_WIDTH or MY_LVCF_SUBITEM
    mov lvc.colCx, 120
    mov lvc.colText, OFFSET HdrID
    mov lvc.colSubItem, 2
    invoke SendMessageA, hList, MY_LVM_INSERTCOLUMN, 2, addr lvc

    ; Column 3 - Date
    invoke RtlZeroMemory, addr lvc, SIZEOF MY_LVCOLUMN
    mov lvc.colMask, MY_LVCF_TEXT or MY_LVCF_WIDTH or MY_LVCF_SUBITEM
    mov lvc.colCx, 120
    mov lvc.colText, OFFSET HdrDate
    mov lvc.colSubItem, 3
    invoke SendMessageA, hList, MY_LVM_INSERTCOLUMN, 3, addr lvc

    ; Column 4 - Status
    invoke RtlZeroMemory, addr lvc, SIZEOF MY_LVCOLUMN
    mov lvc.colMask, MY_LVCF_TEXT or MY_LVCF_WIDTH or MY_LVCF_SUBITEM
    mov lvc.colCx, 130
    mov lvc.colText, OFFSET HdrStatus
    mov lvc.colSubItem, 4
    invoke SendMessageA, hList, MY_LVM_INSERTCOLUMN, 4, addr lvc

    ; --------------------------------------------------------
    ; Summary labels
    ; --------------------------------------------------------
    invoke CreateLabel, hWnd, 100, 570, 200, 28, addr TxtTotal
    invoke CreateLabel, hWnd, 380, 570, 200, 28, addr TxtPresent
    invoke CreateLabel, hWnd, 660, 570, 200, 28, addr TxtAbsent
    invoke CreateLabel, hWnd, 940, 570, 200, 28, addr TxtLate

    ; Summary number controls
    invoke CreateLabel, hWnd, 100, 605, 200, 55, addr emptyString
    mov hTotalStatic, eax
    invoke SetWindowTextA, hTotalStatic, addr emptyString

    invoke CreateLabel, hWnd, 380, 605, 200, 55, addr emptyString
    mov hPresentStatic, eax
    invoke SetWindowTextA, hPresentStatic, addr emptyString

    invoke CreateLabel, hWnd, 660, 605, 200, 55, addr emptyString
    mov hAbsentStatic, eax
    invoke SetWindowTextA, hAbsentStatic, addr emptyString

    invoke CreateLabel, hWnd, 940, 605, 200, 55, addr emptyString
    mov hLateStatic, eax
    invoke SetWindowTextA, hLateStatic, addr emptyString

    ; Footer
    invoke CreateLabel, hWnd, 45, 675, 350, 32, addr TxtFooter
    mov hFooterStatic, eax

    invoke CreateLabel, hWnd, 950, 675, 290, 32, addr TxtFCFS

    invoke UpdateSummary
    ret
CreateControls ENDP

; ============================================================
; Window procedure
; ============================================================
WndProc PROC hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM

    LOCAL commandID:DWORD

    .if uMsg == WM_CREATE

        invoke CreateFontA, 20, 0, 0, 0, FW_BOLD, FALSE, FALSE, FALSE, \
            DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, \
            DEFAULT_QUALITY, DEFAULT_PITCH or FF_SWISS, addr FontName
        mov hFont, eax

        invoke CreateControls, hWnd

        xor eax, eax
        ret

    .elseif uMsg == WM_COMMAND

        mov eax, wParam
        and eax, 0FFFFh
        mov commandID, eax

        .if commandID == IDC_ADD
            invoke AddStudent

        .elseif commandID == IDC_VIEW
            invoke ViewSelected

        .elseif commandID == IDC_REPORT
            invoke GenerateReport

        .elseif commandID == IDC_CLEAR
            invoke SetWindowTextA, hNameEdit, addr emptyString
            invoke SetWindowTextA, hIDEdit, addr emptyString
            invoke SetWindowTextA, hDateEdit, addr emptyString
            invoke SendMessageA, hStatusCombo, MY_CB_SETCURSEL, 0, 0
            invoke SetFocus, hNameEdit

        .elseif commandID == IDC_EXIT
            invoke SendMessageA, hWnd, WM_CLOSE, 0, 0
        .endif

        xor eax, eax
        ret

    .elseif uMsg == WM_CLOSE

        invoke MessageBoxA, hWnd, addr MsgConfirmExit, addr AppTitle, \
            MB_OKCANCEL or MB_ICONWARNING

        cmp eax, IDOK
        jne @DoNotClose

        invoke DestroyWindow, hWnd

@DoNotClose:
        xor eax, eax
        ret

    .elseif uMsg == WM_DESTROY

        cmp hFont, 0
        je @NoFont

        invoke DeleteObject, hFont

@NoFont:
        invoke PostQuitMessage, 0

        xor eax, eax
        ret
    .endif

    invoke DefWindowProcA, hWnd, uMsg, wParam, lParam
    ret
WndProc ENDP

.data
; FontName is declared in the main data section above.

; ============================================================
; Program entry point
; ============================================================
start PROC

    ; Get module instance.
    invoke GetModuleHandleA, NULL
    mov hInstance, eax

    ; Initialize ListView common controls.
    invoke InitCommonControlsEx, addr icc

    ; Clear and fill WNDCLASSEXA.
    invoke RtlZeroMemory, addr wc, SIZEOF WNDCLASSEXA

    mov wc.cbSize, SIZEOF WNDCLASSEXA
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, OFFSET WndProc
    mov eax, hInstance
    mov wc.hInstance, eax

    invoke LoadCursorA, NULL, IDC_ARROW
    mov wc.hCursor, eax

    invoke GetSysColorBrush, COLOR_WINDOW
    mov wc.hbrBackground, eax

    mov wc.lpszClassName, OFFSET ClassName

    invoke RegisterClassExA, addr wc

    ; Create main window.
    invoke CreateWindowExA, 0, addr ClassName, addr AppTitle, \
        WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU or WS_MINIMIZEBOX, \
        80, 30, 1280, 760, NULL, NULL, hInstance, NULL

    mov hMainWnd, eax

    invoke ShowWindow, hMainWnd, SW_SHOWNORMAL
    invoke UpdateWindow, hMainWnd

    ; Standard Windows message loop.
@MessageLoop:
    invoke GetMessageA, addr msg, NULL, 0, 0

    cmp eax, 0
    je @ExitProgram

    invoke TranslateMessage, addr msg
    invoke DispatchMessageA, addr msg

    jmp @MessageLoop

@ExitProgram:
    mov eax, msg.wParam
    invoke ExitProcess, eax

    ret
start ENDP

END start
