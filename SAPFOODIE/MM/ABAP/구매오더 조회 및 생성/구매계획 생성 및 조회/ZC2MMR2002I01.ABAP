*&---------------------------------------------------------------------*
*& Include          ZC2MMR2002_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0100 INPUT.
  LEAVE TO SCREEN 0.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE gv_okcode.
    WHEN 'RIGHT'.
      CLEAR gv_okcode.
      PERFORM add_row.
      PERFORM refresh_grid.

    WHEN 'LEFT'.
      CLEAR gv_okcode.
      PERFORM delete_row.
      PERFORM refresh_grid.

    WHEN 'CREATE'.
      CLEAR gv_okcode.
      PERFORM create_data.
      PERFORM refresh_grid.

  ENDCASE.
ENDMODULE.

MODULE exit_0101 INPUT.
  LEAVE TO SCREEN 0.
ENDMODULE.

MODULE user_command_0101 INPUT.

  CASE gv_okcode2.

      WHEN 'ALLOW'.
      CLEAR gv_okcode2.
      PERFORM allow_plan.
      PERFORM refresh_grid_hd.

      WHEN 'ADD'.
        CLEAR gv_okcode2.
        PERFORM add_row2.
        PERFORM refresh_grid_ed.

      WHEN 'DELETE'.
        CLEAR gv_okcode2.
        PERFORM delete_row2.
        PERFORM refresh_grid_ed.

      WHEN 'SAVE'.
        CLEAR gv_okcode2.
        PERFORM save_data.
        PERFORM refresh_grid_hd.
        PERFORM refresh_grid_ed.

      WHEN 'ERASE'.
        CLEAR gv_okcode2.
        PERFORM erase_order.
        PERFORM get_data3.
        PERFORM refresh_grid_ed.
        PERFORM refresh_grid_hd.
  ENDCASE.

ENDMODULE.