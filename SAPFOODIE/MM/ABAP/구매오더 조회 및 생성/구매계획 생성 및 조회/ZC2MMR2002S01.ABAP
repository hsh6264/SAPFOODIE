*&---------------------------------------------------------------------*
*& Include          ZC2MMR2002_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK BL1 WITH FRAME TITLE title1.

  PARAMETERS : pa_plant TYPE ztc2mm2002-plant DEFAULT '1000' OBLIGATORY MODIF ID sc1,
               pa_yymm  TYPE ztc2pp2004-plnym MODIF ID sc1.

  PARAMETERS :     pa_plt2 TYPE ztc2mm2002-plant DEFAULT '1000' OBLIGATORY MODIF ID sc2.
  SELECT-OPTIONS : so_yymm for ztc2pp2004-plnym MODIF ID sc2.

  SELECTION-SCREEN skip 1.

  PARAMETERS : pa_rd1 RADIOBUTTON GROUP rg1 DEFAULT 'X' USER-COMMAND CMD,
               pa_rd2 RADIOBUTTON GROUP rg1.

SELECTION-SCREEN END OF BLOCK bl1.

INITIALIZATION.
title1 = '계획 생성'.

at SELECTION-SCREEN OUTPUT.

  PERFORM modify_screen.