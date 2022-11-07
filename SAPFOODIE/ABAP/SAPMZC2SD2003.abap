*&---------------------------------------------------------------------*
*& Module Pool      SAPMZC2SD2003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
PROGRAM sapmzc2sd2003 MESSAGE-ID zc222.

INCLUDE sapmzc2sd2003_top.
INCLUDE sapmzc2sd2003_c01.
*INCLUDE SAPMZC2SD2003_S01.
INCLUDE sapmzc2sd2003_o01.
INCLUDE sapmzc2sd2003_i01.
INCLUDE sapmzc2sd2003_f01.

LOAD-OF-PROGRAM.
  ztc2sd2006-plant = 1000.
*  PERFORM flag_listbox.