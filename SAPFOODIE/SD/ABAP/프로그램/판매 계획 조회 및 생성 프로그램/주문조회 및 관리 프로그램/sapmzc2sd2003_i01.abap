*&---------------------------------------------------------------------*
*& Include          SAPMZC2SD2003_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit_0100 INPUT.

  CALL METHOD : gcl_grid->free( ), gcl_container->free( ),
                gcl_grid_2->free( ), gcl_container_2->free( ).

  FREE : gcl_grid, gcl_container, gcl_grid_2, gcl_container_2.

  LEAVE TO SCREEN 0.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE  gv_okcode.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      CLEAR gv_okcode.
      LEAVE TO SCREEN 0.
    WHEN 'REFRESH'.
      CLEAR gv_okcode.
      CLEAR gs_itab.
      REFRESH gt_itab.
      REFRESH gt_itab2.
      PERFORM refresh_data.
      PERFORM refresh_data_2.
    WHEN 'SAVE'.
      CLEAR gv_okcode.
      PERFORM save_data.
      PERFORM save_data2.
*      PERFORM confirm_data.
    WHEN 'VIEW'.
      CLEAR gv_okcode.
      PERFORM get_data.             " View 클릭 시 전체 조회 및 검색 조건에 맞게 조회 가능
*      PERFORM get_data3. " 검색조건에 따라 조회 가능하게
      PERFORM refresh_data.
     WHEN 'EDIT'.                   " 수정 버튼 클릭 시 수정가능
       gv_edit = 'X'.
*       PERFORM refresh_data_2.
     WHEN 'CONFIRM'.
       CLEAR gv_okcode.
       PERFORM confirm_data.
*       PERFORM refresh_data_2.
     WHEN 'CANCORDER'.
       CLEAR gv_okcode.
       PERFORM cancorder_data.
       PERFORM refresh_data.
*    WHEN 'MODIF'.
**      PERFORM get_data2.
*      PERFORM modif_data.           " 수정버튼 클릭시 Item List에서 BOX수량만 수정되게
*    WHEN 'DELETE'.
**      PERFORM DELETE_DATE.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SET_VENDORC  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE set_vendorc INPUT.

  PERFORM set_vendorc.        " 거래처명 보이는게 하는 PERFORM

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*MODULE user_command_0100 INPUT.
*
*ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_STATFLAG  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_statflag INPUT.

*  PERFORM f4_statflag.
  PERFORM flag_listbox.

ENDMODULE.