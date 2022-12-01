*&---------------------------------------------------------------------*
*& Include          ZC2PPR2001_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0100 INPUT.

  CALL METHOD : gcl_grid_mkit->free( ), gcl_container_mkit->free( ),
                gcl_grid_sd->free( ),   gcl_container_sd->free( ).

  FREE: gcl_grid_mkit, gcl_container_mkit,
        gcl_grid_sd,   gcl_container_sd.

  LEAVE TO SCREEN 0.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE gv_okcode.

    WHEN 'ADD'.
      CLEAR gv_okcode.
      PERFORM add_row.
      PERFORM refresh_grid.

    WHEN'DELETE'.
      CLEAR gv_okcode.
      PERFORM delete_row.
      PERFORM refresh_grid.

    WHEN'CREATE'.
      CLEAR gv_okcode.
      PERFORM create_order.

    WHEN 'REFRESH'.
      CLEAR gv_okcode.
      PERFORM refresh_grid.
      CLEAR: pa_plnym, gv_plnym.

   ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0110 INPUT.

  CALL METHOD : gcl_grid_1->free( ), gcl_container_1->free( ),
                gcl_grid_2->free( ), gcl_container_2->free( ).

  FREE: gcl_grid_1, gcl_container_1,
        gcl_grid_2, gcl_container_2.

  LEAVE TO SCREEN '0'.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0110 INPUT.

  CASE gv_okcode.

    WHEN 'ADD'.
      CLEAR gv_okcode.
      PERFORM add_row_2.
      PERFORM refresh_grid_2.

    WHEN 'DELETE'.
      CLEAR gv_okcode.
      PERFORM delete_row_2.
      PERFORM refresh_grid_2.

    WHEN 'REQUEST'.
      CLEAR gv_okcode.
      PERFORM request_order.
      PERFORM refresh_grid_1.
      PERFORM refresh_grid_2.

   WHEN 'SAVE'.
      CLEAR gv_okcode.
      PERFORM save_order.
      PERFORM refresh_grid_1.
      PERFORM refresh_grid_2.


   ENDCASE.

ENDMODULE.