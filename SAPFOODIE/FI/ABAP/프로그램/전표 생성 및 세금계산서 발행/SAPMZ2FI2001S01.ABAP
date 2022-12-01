*&---------------------------------------------------------------------*
*& Include          SAPMZC2FI2001_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF SCREEN 9000 as SUBSCREEN.

SELECTION-SCREEN BEGIN OF BLOCK b0 WITH FRAME TITLE title.

  SELECTION-SCREEN BEGIN OF line.

    PARAMETERS : pa_rd1 RADIOBUTTON GROUP rg1 DEFAULT 'X' USER-COMMAND cmd.
    SELECTION-SCREEN COMMENT (15) TEXT-t01 FOR FIELD pa_rd1.

    PARAMETERS :  pa_rd2 RADIOBUTTON GROUP rg1.
    SELECTION-SCREEN COMMENT (15) text-t02 for FIELD pa_rd2.
  SELECTION-SCREEN END OF line.
SELECTION-SCREEN SKIP 1.

  SELECT-OPTIONS : so_ven  FOR ztc2md2005-vendorc MODIF ID sc1 NO INTERVALS NO-EXTENSION, "매출처
                   so_sal  FOR ztc2sd2008-saleym MODIF ID sc1 NO INTERVALS NO-EXTENSION,
                   so_ven2 FOR ztc2md2005-vendorc MODIF ID sc2 NO INTERVALS NO-EXTENSION,"매입처
                   so_pur  FOR ztc2mm2007-purcym MODIF ID sc2 NO INTERVALS NO-EXTENSION.


SELECTION-SCREEN END OF BLOCK b0.

SELECTION-SCREEN END OF SCREEN 9000.