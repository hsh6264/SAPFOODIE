*&---------------------------------------------------------------------*
*& Include          ZC2SDR2001_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE gv_okcode.
    WHEN 'BACK' OR 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'DOWN'.
      PERFORM excel_down_smw0.
    WHEN 'ADD'.
      CLEAR gv_okcode.
      PERFORM add_data.
*      PERFORM refresh_data_2.
    WHEN 'DELETE'.
      CLEAR gv_okcode.
      PERFORM del_data.
    WHEN 'SAVE'.
      CLEAR gv_okcode.
      PERFORM save_data.
      PERFORM save_data_2.
    WHEN 'APPORVAL'.
      CLEAR gv_okcode.
      PERFORM save_data.
      PERFORM save_data_2.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  CASE gv_okcode.
    WHEN 'BACK' OR 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'APPROV'.              " 승인요청 할 시
      PERFORM checkbox_click.
      PERFORM refresh_data_3.
    WHEN 'APPCANC'.
      PERFORM APPOVAL_CANCLE.
      PERFORM refresh_data_3.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_VENDORC  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_vendorc INPUT.

  PERFORM f4_vendorc.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0210  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0210 INPUT.

  CASE gv_okcode.
    WHEN 'CLOSE'.
      CLEAR gv_okcode.
      LEAVE TO SCREEN 0.
*  	WHEN .
*  	WHEN OTHERS.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_0210  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0210 INPUT.

  LEAVE TO SCREEN 0.

ENDMODULE.