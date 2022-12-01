*&---------------------------------------------------------------------*
*& Report ZC2PPR2003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC2PPR2003_TOP                          .    " Global Data

 INCLUDE ZC2PPR2003_s01                          .  " Selection Screen
 INCLUDE ZC2PPR2003_c01                          .  " Class
 INCLUDE ZC2PPR2003_O01                          .  " PBO-Modules
 INCLUDE ZC2PPR2003_I01                          .  " PAI-Modules
 INCLUDE ZC2PPR2003_F01                          .  " FORM-Routines


 AT SELECTION-SCREEN OUTPUT.
   PERFORM mode_change.
   PERFORM set_listbox.

START-OF-SELECTION.
  PERFORM get_header_data.
  CALL SCREEN '0100'.