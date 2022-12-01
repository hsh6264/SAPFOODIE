*&---------------------------------------------------------------------*
*& Include          ZC2PPR2003_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0100 INPUT.

  CALL METHOD : gcl_grid_1->free( ), gcl_container_1->free( ).

  FREE: gcl_grid_1, gcl_container_1.

  LEAVE TO SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0110 INPUT.

  CLEAR gt_stock_item.

  CALL METHOD : gcl_grid_2->free( ), gcl_container_2->free( ),gcl_grid_3->free( ), gcl_container_3->free( ).

  FREE: gcl_grid_2, gcl_container_2, gcl_grid_3, gcl_container_3.

  LEAVE TO SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE gv_okcode.
    WHEN 'START'.
      CLEAR gv_okcode.
      PERFORM stock_change .

      IF gv_err IS INITIAL.
        gv_stat = '21'.
        PERFORM set_order_status USING gv_stat.
        PERFORM save_order.
        PERFORM refresh_grid.
      ELSE.
        CLEAR : gv_err.
      ENDIF.

    WHEN 'CANCEL'.
      CLEAR gv_okcode.
      gv_stat = '20'.
      PERFORM set_order_status USING gv_stat.
      PERFORM save_order.
      PERFORM refresh_grid.

    WHEN 'FINISH'.
      CLEAR gv_okcode.
      gv_stat = '22'.
      PERFORM set_order_status USING gv_stat.
      PERFORM save_order.
      PERFORM refresh_grid.

    WHEN 'REGIST'.
      CLEAR gv_okcode.
      gv_stat = '23'.
      PERFORM set_order_status USING gv_stat.
      PERFORM refresh_grid.

    WHEN 'CREATE'.
      call transaction 'ZC2PPR2002'.
      "TODO 오더 생성 버튼 클릭시, ZC2PPR2002(생산 오더 생성 프로그램으로 이동)
      "소리에게 트랜젝션 코드 발급 요청.

    WHEN 'SAVE'.
      CLEAR gv_okcode.
      PERFORM save_order.
      PERFORM refresh_grid.

    WHEN 'REFRESH'.
      CLEAR gv_okcode.
      PERFORM get_header_data.
      PERFORM refresh_grid.


  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0110 INPUT.
  CASE gv_okcode_detail.
    WHEN 'SAVE_D'.
      CLEAR gv_okcode.
*      IF gv_overr IS INITIAL.
        PERFORM save_item_order.
*      ELSE.
*        PERFORM message.
*      ENDIF.

  ENDCASE.

ENDMODULE.