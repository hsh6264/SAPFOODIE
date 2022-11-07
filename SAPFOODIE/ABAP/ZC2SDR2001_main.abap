*&---------------------------------------------------------------------*
*& Report ZC2SDR2001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc2sdr2001_top                          .  " Global Data
INCLUDE zc2sdr2001_c01                          .  " Local Class
INCLUDE zc2sdr2001_s01                          .  " Selection Screen
INCLUDE zc2sdr2001_o01                          .  " PBO-Modules
INCLUDE zc2sdr2001_i01                          .  " PAI-Modules
INCLUDE zc2sdr2001_f01                          .  " FORM-Routines



*&---------------------------------------------------------------------*
*& INITIALIZATION
*&---------------------------------------------------------------------*
INITIALIZATION.
  PERFORM set_function_key.       " EXCEL ICON 선언


*&---------------------------------------------------------------------*
*& AT SELECTION SCREEN
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN.
  PERFORM act_function_key.       " EXCEL Download 실행


*&---------------------------------------------------------------------*
*& AT SELECTION SCREEN OUTPUT
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
  PERFORM flag_listbox.     " STATFLAG LISTBOX
  PERFORM modify_screen.    " 라디오버튼 따라 아래 Selection Screen 변함.


*&---------------------------------------------------------------------*
*& AT SELECTION SCREEN ON VALUE-REQUSET FOR P_PATH
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_file.
  PERFORM get_file.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_flag.
  PERFORM f4_flag.

*&---------------------------------------------------------------------*
*& START OF SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM set_input_data.         " Screen 100 input창
  PERFORM check_before_process.   " 파일 주소 확인
  PERFORM modify_screen_2.        " 라디오버튼에따라 Action 변함.
*PERFORM set_cell_color.












*&---------------------------------------------------------------------*
*& 해아될것들
*&----------------------------------------------------