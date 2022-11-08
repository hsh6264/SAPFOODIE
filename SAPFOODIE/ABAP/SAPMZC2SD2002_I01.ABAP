*&---------------------------------------------------------------------*
*& Include          SAPMZC2SD2002_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0100 INPUT.

*    CALL METHOD : gcl_grid->free( ), gcl_container->free( ).
*
*    FREE : gcl_grid, gcl_container.

    LEAVE TO SCREEN 0.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

CASE gv_okcode.
    WHEN 'SEARCH'.
      CLEAR gv_okcode.
      PERFORM get_data.           " 마감테이블 데이터 검색
      PERFORM get_data_2_clear.   " parameter 변경 시 두번째 ALV 수정
      PERFORM refresh_grid.
    WHEN 'CONFIRMED'.
      CLEAR gv_okcode.
      PERFORM confirm_sale_data.
      PERFORM refresh_grid.

ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0101 INPUT.

*    CALL METHOD : gcl_grid_pop->free( ), gcl_container_pop->free( ).
*
*    FREE : gcl_grid_pop, gcl_container_pop.

    LEAVE TO SCREEN 0.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.

  CASE gv_okcode.
    WHEN 'CLOSE'.
      CLEAR gv_okcode.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.