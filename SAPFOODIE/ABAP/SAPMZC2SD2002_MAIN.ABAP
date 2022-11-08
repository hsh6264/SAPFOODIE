*&---------------------------------------------------------------------*
*& Module Pool      SAPMZC2SD2002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE SAPMZC2SD2002_TOP                       .  " Global Data

*INCLUDE SAPMZC2SD2002_S01                       .  " Selection screen
INCLUDE SAPMZC2SD2002_C01                       .  " Local class
INCLUDE SAPMZC2SD2002_O01                       .  " PBO-Modules
INCLUDE SAPMZC2SD2002_I01                       .  " PAI-Modules
INCLUDE SAPMZC2SD2002_F01                       .  " FORM-Routines

LOAD-OF-PROGRAM.
  ztc2sd2008-plant   = 1000.
  ztc2sd2008-resprid = sy-uname.
  gs_search-saleym   = sy-datum(6).