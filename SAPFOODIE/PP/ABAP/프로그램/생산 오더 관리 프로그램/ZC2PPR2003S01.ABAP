*&---------------------------------------------------------------------*
*& Include          ZC2PPR2003_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
PARAMETERS:     pa_plant TYPE ZTC2PP2006-plant OBLIGATORY DEFAULT '1000'.
SELECT-OPTIONS: pa_ponum FOR ZTC2PP2006-ponum.
SELECT-OPTIONS: pa_pstar  FOR  ZTC2PP2006-postart.
PARAMETERS: pa_list(10) AS LISTBOX VISIBLE LENGTH 10 .

SELECTION-SCREEN END OF BLOCK bl1.