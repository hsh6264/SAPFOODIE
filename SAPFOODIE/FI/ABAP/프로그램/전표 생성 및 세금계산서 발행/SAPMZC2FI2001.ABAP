*&---------------------------------------------------------------------*
*& Module Pool      SAPMZC2FI2001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE sapmzc2fi2001_top                       .    " Global Data

INCLUDE sapmzc2fi2001_s01                       .  " Selection Scree
INCLUDE sapmzc2fi2001_c01                       .  " Class
INCLUDE sapmzc2fi2001_o01                       .  " PBO-Modules
INCLUDE sapmzc2fi2001_i01                       .  " PAI-Modules
INCLUDE sapmzc2fi2001_f01                       .  " FORM-Routines


AT SELECTION-SCREEN OUTPUT.

  PERFORM set_radio.