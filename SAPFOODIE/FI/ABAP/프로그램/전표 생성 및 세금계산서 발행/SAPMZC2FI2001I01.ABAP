*&---------------------------------------------------------------------*
*& Include          SAPMZC2FI2001_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0100 INPUT.

  LEAVE TO SCREEN 0.

ENDMODULE.

MODULE user_command_0100 INPUT.

  CASE gv_okcode.
    WHEN 'SEARCH'.
      CLEAR gv_okcode.
      PERFORM get_data.
      PERFORM refresh_grid.
    WHEN 'CREATE'.
*      CLEAR gv_okcode.
      PERFORM change_stat.
      PERFORM refresh_grid.
    WHEN 'PUBLISH'.
      PERFORM show_tax.
    WHEN 'CMD'. "라디오 버튼 refresh
      CLEAR gv_okcode.
      PERFORM detail_info.
  ENDCASE.

ENDMODULE.