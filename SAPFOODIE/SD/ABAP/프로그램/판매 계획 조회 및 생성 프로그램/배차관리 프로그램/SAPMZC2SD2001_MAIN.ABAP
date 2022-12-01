*&---------------------------------------------------------------------*
*& Module Pool      ZC2R20001_AUTOCAR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE SAPMZC2SD2001_TOP.
*INCLUDE ZC2R20001_AUTOCAR_TOP                   .    " Global Data

INCLUDE SAPMZC2SD2001_c01.
INCLUDE SAPMZC2SD2001_O01.
* INCLUDE ZC2R20001_AUTOCAR_O01                   .  " PBO-Modules
INCLUDE SAPMZC2SD2001_I01.
* INCLUDE ZC2R20001_AUTOCAR_I01                   .  " PAI-Modules
INCLUDE SAPMZC2SD2001_F01.
* INCLUDE ZC2R20001_AUTOCAR_F01                   .  " FORM-Routines

load-of-PROGRAM.
ZTC2SD2006-PLANT = 1000.
GV_EMPLYGD = '사원'.