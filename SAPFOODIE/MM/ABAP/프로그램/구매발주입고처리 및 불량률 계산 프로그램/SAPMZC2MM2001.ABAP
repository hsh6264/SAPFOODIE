*&---------------------------------------------------------------------*
*& Module Pool      SAPMZC2MM2001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE sapmzc2mm2001_top.                          " Global Data

INCLUDE sapmzc2mm2001_c01.                          " Local Class
INCLUDE sapmzc2mm2001_o01.                          " PBO-Modules
INCLUDE sapmzc2mm2001_i01.                          " PAI-Modules
INCLUDE sapmzc2mm2001_f01.                          " FORM-Routines


LOAD-OF-PROGRAM.
  PERFORM save_purc.
  PERFORM order_purc.
  PERFORM add_purcp.