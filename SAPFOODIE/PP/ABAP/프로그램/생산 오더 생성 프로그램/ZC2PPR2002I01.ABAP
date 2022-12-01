*&---------------------------------------------------------------------*
*& Include          ZC2PPR2002_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0100 INPUT.

  CALL METHOD : gcl_grid_mkit->free( ), gcl_container_mkit->free( ),
                gcl_grid_item->free( ),   gcl_container_item->free( ).

  FREE: gcl_grid_mkit, gcl_container_mkit,
        gcl_grid_item,   gcl_container_item.

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
*
    WHEN'CREATE'.
      CLEAR gv_okcode.
      PERFORM create_order.

    WHEN 'REFRESH'.
      CLEAR gv_okcode.
      PERFORM refresh_grid.
      PERFORM refresh_header_info.
   ENDCASE.

ENDMODULE.