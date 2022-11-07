*&---------------------------------------------------------------------*
*& Include          SAPMZC2SD2004_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'S100'.
 SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_FCAT_LAYOUT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_fcat_layout OUTPUT.
IF GT_fCAT1 IS INITIAL AND GT_fCAT2 IS INITIAL.
    PERFORM SET_FCAT.
    PERFORM SET_LAYO.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_ALV OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_alv OUTPUT.
  PERFORM SET_GO_ALV1.
  PERFORM SET_GO_ALV2.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'FIXED'.
      PERFORM FIXED_DATA.

    WHEN 'SEARCH'.
      PERFORM SEARCH_LIST.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_screen OUTPUT.
  PERFORM SET_SCREEN_CONDITION.
ENDMODULE.