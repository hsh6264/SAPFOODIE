*&---------------------------------------------------------------------*
*& Report ZC2PPR2002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC2PPR2002_TOP                          .    " Global Data

INCLUDE ZC2PPR2002_S01                          .  " Selection-Screen
INCLUDE ZC2PPR2002_O01                          .  " PBO-Modules
INCLUDE ZC2PPR2002_I01                          .  " PAI-Modules
INCLUDE ZC2PPR2002_F01                          .  " FORM-Routines


AT SELECTION-SCREEN OUTPUT.
  PERFORM set_input_mode.


START-OF-SELECTION.

 PERFORM set_info.                               "생산계획 정보 넣어줌.
 PERFORM get_mealkit_data.

CALL SCREEN '0100'.