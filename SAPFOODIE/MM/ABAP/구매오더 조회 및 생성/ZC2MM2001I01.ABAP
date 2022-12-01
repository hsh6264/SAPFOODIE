*&---------------------------------------------------------------------*
*& Include          ZC2MMR2001_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0100 INPUT.

  DATA :  lv_answer TYPE c LENGTH 1.

  CASE gv_okcode.

*  IF SY-dbcnt > 0.

    WHEN 'BACK'.

      CALL FUNCTION 'POPUP_TO_CONFIRM' " 종료시 메세지 팝업창.
        EXPORTING
          titlebar              = '프로그램 종료'
          text_question         = '프로그램 종료시 작성중인 데이터가 모두 사라집니다. 프로그램을 종료하시겠습니까? '
          text_button_1         = '종료'
          icon_button_1         = 'ICON_SYSTEM_OKAY'
          text_button_2         = '취소'
          icon_button_2         = 'ICON_SYSTEM_CANCEL'
          display_cancel_button = ''
        IMPORTING
          answer                = lv_answer
        EXCEPTIONS
          text_not_found        = 1
          OTHERS                = 2.

      IF lv_answer = 1.

        LEAVE TO SCREEN 0.

      ELSE.
        MESSAGE s000 WITH '취소되었습니다'.
      ENDIF.

    WHEN 'CANC'.
      LEAVE PROGRAM.
    WHEN 'EXIT'.
      LEAVE PROGRAM.

  ENDCASE.
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
      PERFORM refresh_grid_3.

    WHEN'DELETE'.
      CLEAR gv_okcode.
      PERFORM delete_row.
      PERFORM refresh_grid_3.

    WHEN'CREATE'.
      CLEAR gv_okcode.
      PERFORM save_order.
      PERFORM refresh_grid_3.

    WHEN'INQUIRY'.
      CLEAR gv_okcode.
      PERFORM get_gume_data2.
      CALL SCREEN '0101'.
      PERFORM refresh_grid.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0101 INPUT.

  CASE gv_okcode2.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'CANC'.
      LEAVE PROGRAM.
    WHEN 'EXIT'.
      LEAVE PROGRAM.

  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.

  CASE gv_okcode2.
    WHEN 'GOBACK'.
      CLEAR gv_okcode2.
      PERFORM goback_create.
      PERFORM refresh_grid.
    WHEN 'DELETE2'.
      CLEAR gv_okcode2.
      PERFORM delete_row2.
      PERFORM get_gume_data. "두번쨰 페이지 데이터 불러오기.
      PERFORM refresh_grid.
    WHEN 'APPROVAL'.
      CLEAR gv_okcode2.
      PERFORM approval_order.
      PERFORM refresh_grid.
    WHEN 'REFRESH'.
      PERFORM get_gume_data. "두번쨰 페이지 데이터 불러오기.
      PERFORM refresh_grid.
  ENDCASE.

ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  EXIT_0102  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0102 INPUT.

  LEAVE TO SCREEN 0.



ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0102  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0102 INPUT.

  CASE gv_okcode3.
    WHEN 'CLOSE'.
      CLEAR gv_okcode3.
      LEAVE TO SCREEN 0.

    WHEN 'MODIFY'.
      CLEAR gv_okcode3.
      PERFORM mod_data. "구매수량을 수정한 데이터 저장.
  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0103  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0103 INPUT.

   LEAVE TO SCREEN 0.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0103  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0103 INPUT.

CASE gv_okcode4.
    WHEN 'CREATE'.
      CLEAR gv_okcode4.
      PERFORM goback_create.
      PERFORM refresh_grid_4.

    WHEN 'REFRESH'.
      CLEAR gv_okcode4.
*      PERFORM get_gume_data3. "두번쨰 페이지 데이터 불러오기.
      PERFORM refresh_grid_4.
  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0104  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0104 INPUT.
 LEAVE TO SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0104  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0104 INPUT.

    CASE gv_okcode5.

    WHEN 'CLOSE'.
      CLEAR gv_okcode4.
      LEAVE TO SCREEN 0.

  ENDCASE.
ENDMODULE.