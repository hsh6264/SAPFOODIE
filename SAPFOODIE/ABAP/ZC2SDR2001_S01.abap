*&---------------------------------------------------------------------*
*& Include          ZC2SDR2001_S01
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*& Radio Button Screen.
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.

  SELECTION-SCREEN BEGIN OF LINE.

    SELECTION-SCREEN COMMENT 1(10) TEXT-001.                    "처리방식
    PARAMETERS: pa_bt1 RADIOBUTTON GROUP g1 USER-COMMAND md1 DEFAULT 'X'.
    SELECTION-SCREEN COMMENT 14(10) TEXT-002 FOR FIELD pa_bt1.  "엑셀 업로드
    PARAMETERS: pa_bt2 RADIOBUTTON GROUP g1.
    SELECTION-SCREEN COMMENT 27(10) TEXT-003  FOR FIELD pa_bt2. "조회

  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK bl1.

*SELECTION-SCREEN SKIP 2.




*&---------------------------------------------------------------------*
*& Excel Uplaod Screen.
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE TEXT-t02.
  PARAMETERS: pa_plant TYPE ztc2sd2001-plant OBLIGATORY DEFAULT '1000' MODIF ID exe.
  PARAMETERS: pa_file  TYPE rlgrap-filename DEFAULT 'C:\' OBLIGATORY MODIF ID exe.
SELECTION-SCREEN END OF BLOCK bl2.





*&---------------------------------------------------------------------*
*& 조회 Screen.
*&---------------------------------------------------------------------*


SELECTION-SCREEN BEGIN OF BLOCK bl3 WITH FRAME TITLE TEXT-t03.
  PARAMETERS: p_plant2     TYPE ztc2sd2001-plant OBLIGATORY DEFAULT '1000' MODIF ID vie.
  SELECT-OPTIONS: so_plnym FOR ztc2sd2001-plnym MODIF ID vie.
  PARAMETERS: pa_flag      TYPE ztc2sd2001-statflag MODIF ID vie." (2) AS LISTBOX VISIBLE LENGTH 10  MODIF ID vie.
SELECTION-SCREEN END OF BLOCK bl3.


*&---------------------------------------------------------------------*
*& Function Key
*&---------------------------------------------------------------------*

SELECTION-SCREEN: FUNCTION KEY 1,
                  FUNCTION KEY 2.