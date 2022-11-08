*&---------------------------------------------------------------------*
*& Include          ZC2R20001_AUTOCAR_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'S100'.
 SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CLEAR_OK_CODE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE clear_ok_code OUTPUT.
  CLEAR OK_CODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_FCAT_LAYO OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_fcat_layo OUTPUT.
  IF GT_fCAT1 IS INITIAL AND GT_fCAT2 IS INITIAL.
    PERFORM SET_FCAT.
    PERFORM SET_LAYO.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_ALV OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_alv OUTPUT.
  PERFORM SET_GO_ALV1.
  PERFORM SET_GO_ALV2.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_DATA OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_data OUTPUT.
  IF GV_FLAG = ' '.
    select SINGLE EMPLYID EMPLYNM EMPLYGD
      FROM ZTC2MD2004
      INTO CORRESPONDING FIELDS OF ZTC2MD2004
      WHERE EMPLYID = SY-UNAME.
    IF SY-SUBRC <> 0.
      EXIT.
    ENDIF.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_FCAT_LAYO110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_fcat_layo110 OUTPUT.
  IF GT_fCAT3 IS INITIAL AND GT_fCAT4 IS INITIAL.
    PERFORM SET_FCAT_110.
    PERFORM SET_LAYO_110.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_ALV110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_alv110 OUTPUT.
  PERFORM SET_GO_ALV3.
  PERFORM SET_GO_ALV4.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_DATA110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_data110 OUTPUT.
  clear: gs_Data5, gs_Data4.
  CLEAR   GS_DATA2-CURRMAXWT .
  IF gv_flag_110 = ''.
  refresh gt_Data5.
  loop at gt_Data4 into gs_data4.
    if gs_Data2-dispatchcd = gs_data4-dispatchcd.
      MOVE-CORRESPONDING gs_Data4 to gs_data5.
      GS_DATA5-dispatchcd = GS_DATA2-DISPATCHCD.
      append gs_data5 to gt_Data5.
    endif.
  endloop.
  ENDIF.
  LOOP AT GT_dATA5 INTO GS_DATA5.
    GS_DATA2-CURRMAXWT += GS_DATA5-odmaxwt.
  ENDLOOP.
*  SORT GT_dATA5 BY DISPATCHCD.
  SORT GT_DATAalv1 BY ORDERCD.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0110 OUTPUT.
 SET PF-STATUS 'S110'.
 SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CHECK_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE check_screen OUTPUT.
*  IF GV_AGAIN = 'X'.
*    perform concat_cnt CHANGING LV_CBCNT lv_cccnt.
*   GS_DATA2-DISPATCHCD = LV_CBCNT.
*   GS_DATA2-CARCODE    = LV_CCCNT.
*  ENDIF.
  IF GV_OUPDA = 'X'.
    IF GV_FLAGCHECK_SCREEN = ' '.
       CLEAR gs_data2.
      REFRESH GT_DATA5.
      perform concat_cnt CHANGING GV_CBCNT Gv_cccnt.
      GS_DATA2-DISPATCHCD = GV_CBCNT.
      GS_DATA2-CARCODE    = GV_CCCNT.
      GV_FLAGCHECK_SCREEN = 'X'.
*          READ TABLE GT_DATA3 INTO GS_DATA3 INDEX gv_bcnt.
      GS_DATA2-AREACD     = ZTC2MD2005-AREACD.
      IF ZTC2MD2005-AREACD IS INITIAL.
        GS_DATA2-AREACD     = 'FR'.
      ENDIF.
    gs_data2-carnum     = GS_DATA3-carnum.
    gs_data2-WEIGHTUNIT = GS_DATA3-weightunit.
    gs_Data2-CARDRIVE   = GS_dATA3-cardrive.
    gs_Data2-allMAXWT   = gs_data3-maxwt.
    read table gt_data3 into gs_data3 index 1.
    gs_data2-cmpnc = 1004.
    gs_Data2-carnum = gs_Data3-carnum.
    gs_data2-cardrive = gs_data3-cardrive.
    GV_OUPDA = ' '.
    ENDIF.
  ENDIF.
ENDMODULE.