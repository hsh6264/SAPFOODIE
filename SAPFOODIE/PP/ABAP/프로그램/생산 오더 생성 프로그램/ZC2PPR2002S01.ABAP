*&---------------------------------------------------------------------*
*& Include          ZC2PPR2002_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE title1.
PARAMETERS:     pa_plant TYPE ZTC2PP2006-plant OBLIGATORY DEFAULT '1000',
                pa_start TYPE ZTC2PP2006-postart OBLIGATORY.

SELECTION-SCREEN END OF BLOCK bl1.


INITIALIZATION.
PERFORM set_input.