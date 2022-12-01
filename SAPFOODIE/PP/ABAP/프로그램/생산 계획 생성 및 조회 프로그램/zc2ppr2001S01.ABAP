*&---------------------------------------------------------------------*
*& Include          ZC2PPR2001_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE title1.
PARAMETERS:     pa_plant TYPE ZTC2PP2004-plant OBLIGATORY DEFAULT '1000' MODIF ID md1,
                pa_plnym TYPE ZTC2PP2004-plnym OBLIGATORY MODIF ID md2.
SELECT-OPTIONS: so_year  FOR  ZTC2PP2004-plnym NO-EXTENSION MODIF ID md3.

SELECTION-SCREEN SKIP 1.

PARAMETERS: pa_rd1 RADIOBUTTON GROUP rg1 USER-COMMAND radio1 DEFAULT 'X',
            pa_rd2 RADIOBUTTON GROUP rg1.
SELECTION-SCREEN END OF BLOCK bl1.


INITIALIZATION.
PERFORM set_input.

AT SELECTION-SCREEN ON pa_plnym.
  PERFORM vaild_date_check.

AT SELECTION-SCREEN OUTPUT.
  PERFORM mode_change.