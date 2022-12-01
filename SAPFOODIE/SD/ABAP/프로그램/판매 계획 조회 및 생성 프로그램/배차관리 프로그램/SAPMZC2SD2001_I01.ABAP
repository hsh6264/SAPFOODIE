*&---------------------------------------------------------------------*
*& Include          ZC2R20001_AUTOCAR_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE OK_CODE.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'SEARCH'.
      perform refresh.
     WHEN 'OAUTO'.
       PERFORM OAUTO.
     WHEN 'AAUTO'.
       PERFORM AAUTO.
     when 'OUPDA'.
       gv_oupda = 'X'.
       GV_FLAGCHECK_SCREEN = ''.
       perform oupda.
     WHEN 'DELETE'.
       PERFORM DELETE_DATA2.
     WHEN 'COMMIT'.
       PERFORM COMMIT_DB.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_FIELD  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_field INPUT.
  if ZTC2MD2005-AREACD is INITIAL.
    message '지역코드를 입력해주세요.' type 'E' .
  endif.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  CHECK_FIELD1  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE check_field1 INPUT.
  IF ZTC2SD2006-DUEDATE IS INITIAL.
        message '납기일자를 입력해주세요.' type 'E' .
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0110 INPUT.
  CASE OK_CODE.
    WHEN 'OKAY'.
*      GV_OUPDA = 'X'.
      PERFORM OK_BATCHA.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    when 'IN'.
      gv_flag_110 = 'X'.
      PERFORM IN_DATA.

    WHEN 'OUT'.
      gv_flag_110 = 'X'.
      PERFORM OUT_dATA.

  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_110 INPUT.
  CASE OK_CODE.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
    WHEN 'CANC'.
      gv_bcnt -= 1.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.