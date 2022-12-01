*&---------------------------------------------------------------------*
*& Report ZC2MMR2002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc2mmr2002_top                          .    " Global Data

 INCLUDE zc2mmr2002_s01.
 INCLUDE zc2mmr2002_c01.
 INCLUDE zc2mmr2002_o01                          .  " PBO-Modules
 INCLUDE zc2mmr2002_i01                          .  " PAI-Modules
 INCLUDE zc2mmr2002_f01                          .  " FORM-Routines

START-OF-SELECTION.

  PERFORM set_info.
  PERFORM get_data.

CASE 'X'.
  WHEN pa_rd1.
    PERFORM get_data2.
    CALL SCREEN '0100'.

  WHEN pa_rd2.
    PERFORM get_data3. "Header List
    CALL SCREEN '0101'.
ENDCASE.