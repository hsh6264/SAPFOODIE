*&---------------------------------------------------------------------*
*& Report ZC2PPR2001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc2ppr2001_top                          .  " Global Data
INCLUDE zc2ppr2001_s01                          .  " Selection Screen
INCLUDE zc2ppr2001_c01                          .  " Class
INCLUDE zc2ppr2001_o01                          .  " PBO-Modules
INCLUDE zc2ppr2001_i01                          .  " PAI-Modules
INCLUDE zc2ppr2001_f01                          .  " FORM-Routines


START-OF-SELECTION.

  PERFORM set_info.                               "생산계획 정보 넣어줌.
  PERFORM get_mealkit_data.

CASE 'X'.
  WHEN pa_rd1.
  PERFORM get_list_data.                          "판매계획 list 불러옴
    CALL SCREEN '0100'.

  WHEN pa_rd2.
  PERFORM get_header_data.                        "생산계획 Header 조회
    CALL SCREEN '0110'.

ENDCASE.