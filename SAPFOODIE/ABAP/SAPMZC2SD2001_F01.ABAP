*&---------------------------------------------------------------------*
*& Include          ZC2R20001_AUTOCAR_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SET_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat .
    PERFORM set_gt_fcat1 USING:
    'X' 'ORDERCD'    '' 'ZTC2SD2006' 'ORDERCD',
    'X' 'VENDORC'    '' 'ZTC2SD2006' 'VENDORC',
    'X' 'SALEYM'     '' 'ZTC2SD2006' 'SALEYM',
    ' ' 'DUEDATE' '' 'ZTC2SD2006' 'DUEDATE',
    ' ' 'ODMAXWT'    '' 'ZTC2SD2006' 'ODMAXWT',
    ' ' 'WEIGHTUNIT' '' 'ZTC2SD2006' 'WEIGHTUNIT',
    ' ' 'RESPRID'    '' 'ZTC2SD2006' 'RESPRID',
    ' ' 'AREACD'     '' 'ZTC2MD2005' 'AREACD',
    ' ' 'PLOC'       '' 'ZTC2MD2005' 'PLOC' .
  
    PERFORM set_gt_fcat2 USING:
    'X' 'DISPATCHCD'    '' 'ZTC2SD2004' 'DISPATCHCD',
    'X' 'CARCODE'       '' 'ZTC2SD2004' 'CARCODE',
    ' ' 'CARNUM'        '' 'ZTC2SD2003' 'CARNUM',
    ' ' 'CURRMAXWT'     '' 'ZTC2SD2004' 'CURRMAXWT',
    ' ' 'ALLMAXWT'         '' 'ZTC2SD2003' 'MAXWT',
    ' ' 'WEIGHTUNIT'    '' 'ZTC2SD2003' 'WEIGHTUNIT',
    ' ' 'AREACD'        '' 'ZTC2SD2003' 'AREACD',
    ' ' 'CARDRIVE'      '' 'ZTC2SD2003' 'CARDRIVE'.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_LAYO
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_layo .
    gs_layo1-zebra = 'X'.
    gs_layo1-no_toolbar = 'X'.
    gs_layo1-sel_mode = 'D'.
    gs_layo2-zebra = 'X'.
    gs_layo2-no_toolbar = 'X'.
    gs_layo2-sel_mode = 'D'.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_GO_ALV1
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_go_alv1 .
    IF go_container1 IS NOT BOUND.
      CREATE OBJECT go_container1
        EXPORTING
          container_name = 'AREA1'.
  
      CREATE OBJECT go_grid1
        EXPORTING
          i_parent = go_container1.
  
      CALL METHOD go_grid1->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layo1
        CHANGING
          it_outtab       = gt_dataalv1
          it_fieldcatalog = GT_fCAT1.
    ELSE.
      CALL METHOD go_grid1->refresh_table_display
  *      EXPORTING
  *        is_stable      =
  *        i_soft_refresh =
  *      EXCEPTIONS
  *        finished       = 1
  *        others         = 2
        .
      IF sy-subrc <> 0.
  *     Implement suitable error handling here
      ENDIF.
  
    ENDIF.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_GO_ALV2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_go_alv2 .
    IF go_container2 IS NOT BOUND.
      CREATE OBJECT go_container2
        EXPORTING
          container_name = 'AREA2'.
  
      CREATE OBJECT go_grid2
        EXPORTING
          i_parent = go_container2.
  
  
      IF go_handler IS NOT BOUND.
        CREATE OBJECT go_handler.
      ENDIF.
  
      SET HANDLER go_handler->handle_double_click FOR go_grid2.
  
      CALL METHOD go_grid2->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layo2
        CHANGING
          it_outtab       = gt_data2
          it_fieldcatalog = GT_fCAT2.
    ELSE.
      CALL METHOD go_grid2->refresh_table_display
  *      EXPORTING
  *        is_stable      =
  *        i_soft_refresh =
  *      EXCEPTIONS
  *        finished       = 1
  *        others         = 2
        .
      IF sy-subrc <> 0.
  *     Implement suitable error handling here
      ENDIF.
  
    ENDIF.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_GO_ALV3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_go_alv3 .
    IF go_container3 IS NOT BOUND.
      CREATE OBJECT go_container3
        EXPORTING
          container_name = 'AREA3'.
  
      CREATE OBJECT go_grid3
        EXPORTING
          i_parent = go_container3.
  
      CALL METHOD go_grid3->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layo3
        CHANGING
          it_outtab       = GT_DATAalv1
          it_fieldcatalog = gt_fcat3.
    ELSE.
      CALL METHOD go_grid3->refresh_table_display
  *      EXPORTING
  *        is_stable      =
  *        i_soft_refresh =
  *      EXCEPTIONS
  *        finished       = 1
  *        others         = 2
        .
      IF sy-subrc <> 0.
  *     Implement suitable error handling here
      ENDIF.
  
  
    ENDIF.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_GT_FCAT1
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_gt_fcat1  USING    pv_key
                              pv_fieldname
                              pv_coltext
                              pv_ref_table
                              pv_ref_field.
  
    CLEAR gs_fcat1.
  
    gs_fcat1-key       = pv_key.
    gs_fcat1-fieldname = pv_fieldname.
    gs_fcat1-coltext   = pv_coltext.
    GS_fCAT1-ref_table = PV_REF_tABLE.
    gs_fcat1-ref_field = PV_rEF_FIELD.
  
    IF pv_fieldname = 'PLOC'.
      gs_fcat1-outputlen = 25.
    ELSEIF pv_fieldname = 'AREACD'.
      gs_fcat1-outputlen = 7.
    ELSE.
      GS_fCAT1-outputlen = 12.
    ENDIF.
  
    APPEND gs_fcat1 TO gt_fcat1.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_GT_FCAT2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_gt_fcat2  USING    pv_key
                              pv_fieldname
                              pv_coltext
                              pv_ref_table
                              pv_ref_field.
    CLEAR gs_fcat2.
    gs_fcat2-key       = pv_key.
    gs_fcat2-fieldname = pv_fieldname.
    gs_fcat2-coltext   = pv_coltext.
    GS_fCAT2-ref_table = PV_REF_tABLE.
    gs_fcat2-ref_field = PV_rEF_FIELD.
    GS_fCAT2-outputlen = 14.
    APPEND gs_fcat2 TO gt_fcat2.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_GT_FCAT3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_gt_fcat3  USING    pv_key
                              pv_fieldname
                              pv_coltext
                              pv_ref_table
                              pv_ref_field.
  
    CLEAR gs_fcat3.
    gs_fcat3-key       = pv_key.
    gs_fcat3-fieldname = pv_fieldname.
    gs_fcat3-coltext   = pv_coltext.
    GS_fCAT3-ref_table = PV_rEF_TABLE.
    GS_fCAT3-ref_field = pv_ref_field.
  
    IF pv_fieldname = 'PLOC'.
      gs_fcat3-outputlen = 25.
    ELSEIF pv_fieldname = 'AREACD'.
      gs_fcat3-outputlen = 7.
    ELSE.
      GS_fCAT3-outputlen = 10.
    ENDIF.
  
  
    APPEND gs_fcat3 TO gt_fcat3.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form OAUTO
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM oauto .
    DATA lv_odmaxwt LIKE gs_dataALV1-odmaxwt.
    DATA: lv_cnt1     TYPE i,
          lv_cnt2     TYPE i,
          lv_cnt3     TYPE i,
          lv_cnt4     TYPE i,
          lv_cnt5     TYPE i,
          lv_bcnt     TYPE  i,
          lv_icnt1    TYPE i,
          lv_icnt2    TYPE i,
          lv_check,
          lv_checkout,
          lv_exit,
          lv_cbcnt    TYPE c LENGTH 5,
          lv_cccnt    TYPE c LENGTH 5.
  
    CLEAR: gt_dataloop1, gs_dataloop1.
    "PERFORM문으로 하기.
  
    PERFORM owswt_cnt CHANGING lv_cnt1 lv_cnt2 lv_cnt3 lv_cnt4 lv_cnt5.
  *
    LOOP AT gt_dataalv1 INTO gs_dataalv1.
      IF GS_dATAALV1-odmaxwt >= ( GV_maxwt DIV 4 * 3 + 1 ) AND GS_dATAALV1-odmaxwt <= ( GV_maxwt DIV 4 * 4 ).
        lv_icnt1 = 1.
        lv_icnt2 = 1.
        PERFORM EXIT_cnt CHANGING lv_cnt1 lv_cnt2 lv_cnt3 lv_cnt4 lv_exit .
        IF lv_exit = 'X'.
          MESSAGE 'error' TYPE 'E'.
        ENDIF.
        PERFORM set_dataloop CHANGING lv_odmaxwt lv_checkout.
        PERFORM concat_cnt CHANGING lv_cbcnt lv_cccnt.
        PERFORM patchloopout CHANGING LV_CbCNT.
        LOOP AT gt_dataloop1 INTO gs_dataloop1.
          IF  GS_dATAALV1-odmaxwt <= ( GV_maxwt DIV 4 * 1 ) AND gs_dataloop1-duedate = gs_dataalv1-duedate.
            IF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) < Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              PERFORM patchloopin CHANGING LV_CbCNT.
              lv_icnt1 += 1.
              PERFORM delete.
              IF lv_cnt1 = lv_icnt1.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                LV_checkout = ''.
                EXIT.
              ENDIF.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) = Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              PERFORM patchloopin CHANGING LV_CbCNT.
              lv_icnt1 += 1.
              READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
              IF sy-subrc <> 0 .
                MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                EXIT.
              ENDIF.
              PERFORM delete.
              PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
              lv_check = 'X'.
              lv_checkout = ''.
              EXIT.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) > Gv_maxwt.
              lv_icnt1 += 1.
              IF lv_cnt1 = lv_icnt1.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                EXIT.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
  
        IF lv_check = 'X'.
          EXIT.
        ELSEIF lv_checkout = 'X'.
          READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
          IF sy-subrc <> 0 ."여기가 문제다 지금
            MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
            EXIT.
          ENDIF.
          PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
          EXIT.
        ENDIF.
  
      ELSEIF GS_dATAALV1-odmaxwt >= ( GV_maxwt DIV 4 * 2 + 1 ) AND GS_dATAALV1-odmaxwt <= ( GV_maxwt DIV 4 * 3 ).
        lv_icnt1 = 1.
        lv_icnt2 = 1.
        PERFORM EXIT_cnt CHANGING lv_cnt1 lv_cnt2 lv_cnt3 lv_cnt4 lv_exit.
        IF lv_exit = 'X'.
          MESSAGE 'error' TYPE 'E'.
        ENDIF.
        PERFORM set_dataloop CHANGING lv_odmaxwt lv_checkout.
        PERFORM concat_cnt CHANGING lv_cbcnt lv_cccnt.
        PERFORM patchloopout CHANGING LV_CbCNT.
        LOOP AT gt_dataloop1 INTO gs_dataloop1.
          IF (  GS_dATAALV1-odmaxwt >= ( GV_maxwt DIV 4 * 1 + 1 ) AND GS_dATaloop1-odmaxwt <= ( GV_maxwt DIV 4 * 2 ) ) AND gs_dataloop1-duedate = gs_dataalv1-duedate.
            IF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) < Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              PERFORM patchloopin CHANGING LV_CbCNT.
              lv_icnt2 += 1.
              PERFORM delete.
              IF lv_cnt2 = lv_icnt2.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                EXIT.
              ENDIF.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) = Gv_maxwt.
              lv_icnt2 += 1.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              PERFORM patchloopin CHANGING LV_CbCNT.
              READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
              IF sy-subrc <> 0 .
                MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                EXIT.
              ENDIF.
              PERFORM delete.
              PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
              lv_check = 'X'.
              lv_checkout = ''.
              EXIT.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) > Gv_maxwt.
              lv_icnt2 += 1.
              IF lv_cnt2 = lv_icnt2.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                EXIT.
              ENDIF.
            ENDIF.
          ELSEIF  GS_dATAALV1-odmaxwt <= ( GV_maxwt DIV 4 * 1 ) AND gs_dataloop1-duedate = gs_dataalv1-duedate.
            IF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) < Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              PERFORM patchloopin CHANGING LV_CbCNT.
              lv_icnt1 += 1.
              PERFORM delete.
              IF lv_cnt1 = lv_icnt1.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                EXIT.
              ENDIF.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) = Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              PERFORM patchloopin CHANGING LV_CbCNT.
              lv_icnt1 += 1.
              READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
              IF sy-subrc <> 0 .
                MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                EXIT.
              ENDIF.
              PERFORM delete.
              PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
              lv_check = 'X'.
              lv_checkout = ''.
              EXIT.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) > Gv_maxwt.
              lv_icnt1 += 1.
              IF lv_cnt1 = lv_icnt1.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                EXIT.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
        IF lv_check = 'X'.
          EXIT.
        ELSEIF lv_checkout = 'X'.
          READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
          IF sy-subrc <> 0 .
            MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
            EXIT.
          ENDIF.
          PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
          EXIT.
        ENDIF.
  
  
      ELSEIF  GS_dATAALV1-odmaxwt >= ( GV_maxwt DIV 4 * 1 + 1 ) AND GS_dATAALV1-odmaxwt <= ( GV_maxwt DIV 4 * 2 ).
        lv_icnt1 = 1.
        lv_icnt2 = 1.
        PERFORM EXIT_cnt CHANGING lv_cnt1 lv_cnt2 lv_cnt3 lv_cnt4 lv_exit.
        IF lv_exit = 'X'.
          MESSAGE 'error' TYPE 'E'.
        ENDIF.
        PERFORM set_dataloop CHANGING lv_odmaxwt lv_checkout.
        PERFORM concat_cnt CHANGING lv_cbcnt lv_cccnt.
        PERFORM patchloopout CHANGING LV_CbCNT.
        LOOP AT gt_dataloop1 INTO gs_dataloop1.
          IF (  GS_dATAALV1-odmaxwt >= ( GV_maxwt DIV 4 * 1 + 1 ) AND GS_dATaloop1-odmaxwt <= ( GV_maxwt DIV 4 * 2 ) ) AND gs_dataloop1-duedate = gs_dataalv1-duedate.
            IF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) < Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              PERFORM patchloopin CHANGING LV_CbCNT.
              lv_icnt2 += 1."이거 약간 쎄하다 주의
              PERFORM delete.
              IF lv_cnt2 = lv_icnt2.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                EXIT.
              ENDIF.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) = Gv_maxwt.
              lv_icnt2 += 1.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              PERFORM patchloopin CHANGING LV_CbCNT.
              READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
              IF sy-subrc <> 0 .
                MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                EXIT.
              ENDIF.
              PERFORM delete.
              PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
              lv_check = 'X'.
              lv_checkout = ''.
              EXIT.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) > Gv_maxwt.
              lv_icnt2 += 1.
              IF lv_cnt2 = lv_icnt2.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                EXIT.
              ENDIF.
            ENDIF.
          ELSEIF  GS_dATAALV1-odmaxwt <= ( GV_maxwt DIV 4 * 1 ) AND gs_dataloop1-duedate = gs_dataalv1-duedate.
            IF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) < Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              lv_icnt1 += 1.
              PERFORM patchloopin CHANGING LV_CbCNT.
              PERFORM delete.
              IF lv_cnt1 = lv_icnt1.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                EXIT.
              ENDIF.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) = Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              PERFORM patchloopin CHANGING LV_CbCNT.
              lv_icnt1 += 1.
              READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
              IF sy-subrc <> 0 .
                MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                EXIT.
              ENDIF.
              PERFORM delete.
              PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
              lv_check = 'X'.
              lv_checkout = ''.
              EXIT.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) > Gv_maxwt.
              lv_icnt1 += 1.
              IF lv_cnt1 = lv_icnt1.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                EXIT.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
        IF lv_check = 'X'.
          EXIT.
        ELSEIF lv_checkout = 'X'.
          READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
          IF sy-subrc <> 0 .
            MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
            EXIT.
          ENDIF.
          PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
          EXIT.
        ENDIF.
  
      ELSEIF GS_dATAALV1-odmaxwt <= ( GV_maxwt DIV 4 * 1 ).
        lv_icnt1 = 1.
        PERFORM EXIT_cnt CHANGING lv_cnt1 lv_cnt2 lv_cnt3 lv_cnt4 lv_exit.
        IF lv_exit = 'X'.
          MESSAGE 'error' TYPE 'E'.
        ENDIF.
        PERFORM set_dataloop CHANGING lv_odmaxwt lv_checkout.
        PERFORM concat_cnt CHANGING lv_cbcnt lv_cccnt.
        PERFORM patchloopout CHANGING LV_CbCNT.
        LOOP AT gt_dataloop1 INTO gs_dataloop1.
          IF  GS_dATAALV1-odmaxwt <= ( GV_maxwt DIV 4 * 1 ) AND gs_dataloop1-duedate = gs_dataalv1-duedate.
            IF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) < Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              lv_icnt1 += 1.
              PERFORM patchloopin CHANGING LV_CbCNT.
              PERFORM delete.
              IF lv_cnt1 = lv_icnt1.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                EXIT.
              ENDIF.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) = Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              PERFORM patchloopin CHANGING LV_CbCNT.
              lv_icnt1 += 1.
              READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
              IF sy-subrc <> 0 .
                MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                EXIT.
              ENDIF.
              PERFORM delete.
              PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
              lv_check = 'X'.
              lv_checkout = ''.
              EXIT.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) > Gv_maxwt.
              lv_icnt1 += 1.
              IF lv_cnt1 = lv_icnt1.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                EXIT.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
  
  
        IF lv_check = 'X'.
          EXIT.
        ELSEIF lv_checkout = 'X'.
          READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
          IF sy-subrc <> 0 .
            MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
            EXIT.
          ENDIF.
          PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
          EXIT.
        ENDIF.
      ENDIF.
    ENDLOOP.
  *     gv_bcnt -= 1.
    CALL METHOD go_grid1->refresh_table_display.
    CALL METHOD go_grid2->refresh_table_display.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form AAUTO
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM aauto .
    DATA lv_odmaxwt LIKE gs_dataALV1-odmaxwt.
    DATA: lv_cnt1     TYPE i,
          lv_cnt2     TYPE i,
          lv_cnt3     TYPE i,
          lv_cnt4     TYPE i,
          lv_cnt5     TYPE i,
          lv_bcnt     TYPE  i,
          lv_icnt1    TYPE i VALUE 1,
          lv_icnt2    TYPE i VALUE 1,
          lv_icnt3    TYPE i VALUE 1,
          lv_icnt4    TYPE i VALUE 1,
          lv_icnt5    TYPE i,
          lv_check,
          lv_checkout,
          lv_exit,
          lv_cbcnt    TYPE c LENGTH 5,
          lv_cccnt    TYPE c LENGTH 5.
  
    CLEAR: gt_dataloop1, gs_dataloop1.
    "PERFORM문으로 하기.
  
  *     perform owswt_cnt CHANGING lv_cnt1 lv_cnt2 lv_cnt3 lv_cnt4 lv_cnt5.
  *
    LOOP AT gt_dataalv1 INTO gs_dataalv1.
      PERFORM owswt_cnt CHANGING lv_cnt1 lv_cnt2 lv_cnt3 lv_cnt4 lv_cnt5.
      lv_icnt5 += 1.
      IF GS_dATAALV1-odmaxwt >= ( GV_maxwt DIV 4 * 3 + 1 ) AND GS_dATAALV1-odmaxwt <= ( GV_maxwt DIV 4 * 4 ).
        lv_icnt1 = 1.
        lv_icnt4 = 1.
        PERFORM EXIT_cnt CHANGING lv_cnt1 lv_cnt2 lv_cnt3 lv_cnt4 lv_exit .
        IF lv_exit = 'X'.
          EXIT.
        ENDIF.
        PERFORM set_dataloop CHANGING lv_odmaxwt lv_checkout.
        PERFORM concat_cnt CHANGING lv_cbcnt lv_cccnt.
        PERFORM patchloopout CHANGING LV_CbCNT.
        LOOP AT gt_dataloop1 INTO gs_dataloop1.
          IF GS_dATaloop1-odmaxwt <= ( GV_maxwt DIV 4 * 1 ) AND gs_dataloop1-duedate = gs_dataalv1-duedate.
            IF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) < Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              lv_icnt1 += 1.
              lv_icnt4 += 1.
              PERFORM patchloopin CHANGING LV_CbCNT.
              PERFORM delete.
              IF lv_cnt1 = lv_icnt1.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                LV_checkout = ''.
                CLEAR: lv_odmaxwt.
                lv_cnt1 -= lv_icnt4.
                lv_cnt2 -= lv_icnt4.
                lv_cnt3 -= lv_icnt4.
                lv_cnt4 -= lv_icnt4.
                EXIT.
              ENDIF.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) = Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              PERFORM patchloopin CHANGING LV_CbCNT.
              PERFORM delete.
              lv_icnt1 += 1.
              lv_icnt4 += 1.
              READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
              IF sy-subrc <> 0 .
                MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                EXIT.
              ENDIF.
              PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
              lv_check = 'X'.
              lv_checkout = ''.
              CLEAR: lv_odmaxwt.
              lv_cnt1 -= lv_icnt4.
              lv_cnt2 -= lv_icnt4.
              lv_cnt3 -= lv_icnt4.
              lv_cnt4 -= lv_icnt4.
              EXIT.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) > Gv_maxwt.
              lv_icnt1 += 1.
              IF lv_cnt1 = lv_icnt1.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                CLEAR: lv_odmaxwt.
                lv_cnt1 -= lv_icnt4.
                lv_cnt2 -= lv_icnt4.
                lv_cnt3 -= lv_icnt4.
                lv_cnt4 -= lv_icnt4.
                EXIT.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
  
  
        IF lv_check = 'X'.
          CONTINUE.
        ELSEIF lv_checkout = 'X'.
          PERFORM concat_cnt CHANGING lv_cbcnt lv_cccnt.
          READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
          IF sy-subrc <> 0 ."여기가 문제다 지금
            MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
            EXIT.
          ENDIF.
          PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
          CLEAR: lv_odmaxwt.
          CONTINUE.
        ENDIF.
  
  
  
      ELSEIF GS_dATAALV1-odmaxwt >= ( GV_maxwt DIV 4 * 2 + 1 ) AND GS_dATAALV1-odmaxwt <= ( GV_maxwt DIV 4 * 3 ).
        lv_icnt1 = 1.
        lv_icnt2 = 1.
        lv_icnt3 = 1.
        lv_icnt4 = 1.
        PERFORM EXIT_cnt CHANGING lv_cnt1 lv_cnt2 lv_cnt3 lv_cnt4 lv_exit.
        IF lv_exit = 'X'.
          EXIT.
        ENDIF.
        PERFORM set_dataloop CHANGING lv_odmaxwt lv_checkout.
        PERFORM concat_cnt CHANGING lv_cbcnt lv_cccnt.
        PERFORM patchloopout CHANGING LV_CbCNT.
        LOOP AT gt_dataloop1 INTO gs_dataloop1.
          IF ( GS_dATaloop1-odmaxwt >= ( GV_maxwt DIV 4 * 1 + 1 ) AND GS_dATaloop1-odmaxwt <= ( GV_maxwt DIV 4 * 2 ) ) AND gs_dataloop1-duedate = gs_dataalv1-duedate.
            IF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) < Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              lv_icnt2 += 1.
              lv_icnt3 += 1.
              PERFORM patchloopin CHANGING LV_CbCNT.
              PERFORM delete.
              IF lv_cnt2 = lv_icnt2.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                lv_cnt2 -= lv_icnt3.
                lv_cnt3 -= lv_icnt3.
                lv_cnt4 -= lv_icnt3.
                EXIT.
              ENDIF.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) = Gv_maxwt.
              lv_icnt2 += 1.
              lv_icnt3 += 1.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              PERFORM patchloopin CHANGING LV_CbCNT.
              PERFORM delete.
              READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
              IF sy-subrc <> 0 .
                MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                EXIT.
              ENDIF.
              lv_check = 'X'.
              lv_checkout = ''.
              CLEAR: lv_odmaxwt.
              lv_cnt2 -= lv_icnt3.
              lv_cnt3 -= lv_icnt3.
              lv_cnt4 -= lv_icnt3.
              EXIT.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) > Gv_maxwt.
              lv_icnt2 += 1.
              IF lv_cnt2 = lv_icnt2.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                lv_cnt2 -= lv_icnt3.
                lv_cnt3 -= lv_icnt3.
                lv_cnt4 -= lv_icnt3.
                EXIT.
              ENDIF.
            ENDIF.
  
  
          ELSEIF GS_dATaloop1-odmaxwt <= ( GV_maxwt DIV 4 * 1 ) AND gs_dataloop1-duedate = gs_dataalv1-duedate.
            IF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) < Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              PERFORM patchloopin CHANGING LV_CbCNT.
              PERFORM delete.
              lv_icnt1 += 1.
              lv_icnt4 += 1.
              IF lv_cnt1 = lv_icnt1.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                CLEAR: lv_odmaxwt.
                lv_cnt1 -= lv_icnt4.
                lv_cnt2 -= lv_icnt4.
                lv_cnt3 -= lv_icnt4.
                lv_cnt4 -= lv_icnt4.
                EXIT.
              ENDIF.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) = Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              lv_icnt1 += 1.
              lv_icnt4 += 1.
              PERFORM patchloopin CHANGING LV_CbCNT.
              PERFORM delete.
              READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
              IF sy-subrc <> 0 .
                MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                EXIT.
              ENDIF.
              PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
              lv_check = 'X'.
              lv_checkout = ''.
              CLEAR: lv_odmaxwt.
              lv_cnt1 -= lv_icnt4.
              lv_cnt2 -= lv_icnt4.
              lv_cnt3 -= lv_icnt4.
              lv_cnt4 -= lv_icnt4.
              EXIT.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) > Gv_maxwt.
              lv_icnt1 += 1.
              IF lv_cnt1 = lv_icnt1.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                CLEAR: lv_odmaxwt.
                lv_cnt1 -= lv_icnt4.
                lv_cnt2 -= lv_icnt4.
                lv_cnt3 -= lv_icnt4.
                lv_cnt4 -= lv_icnt4.
                EXIT.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
  
        IF lv_check = 'X'.
          CONTINUE.
        ELSEIF lv_checkout = 'X'.
          READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
          IF sy-subrc <> 0 .
            MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
            EXIT.
          ENDIF.
          PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
          CONTINUE.
        ENDIF.
  
      ELSEIF GS_dATAALV1-odmaxwt >= ( GV_maxwt DIV 4 * 1 + 1 ) AND GS_dATAALV1-odmaxwt <= ( GV_maxwt DIV 4 * 2 ).
        lv_icnt1 = 1.
        lv_icnt2 = 1.
        lv_icnt3 = 1.
        lv_icnt4 = 1.
        PERFORM EXIT_cnt CHANGING lv_cnt1 lv_cnt2 lv_cnt3 lv_cnt4 lv_exit.
        IF lv_exit = 'X'.
          EXIT.
        ENDIF.
        PERFORM set_dataloop CHANGING lv_odmaxwt lv_checkout.
        PERFORM concat_cnt CHANGING lv_cbcnt lv_cccnt.
        PERFORM patchloopout CHANGING LV_CbCNT.
        LOOP AT gt_dataloop1 INTO gs_dataloop1.
          IF ( GS_dATaloop1-odmaxwt >= ( GV_maxwt DIV 4 * 1 + 1 ) AND GS_dATaloop1-odmaxwt <= ( GV_maxwt DIV 4 * 2 ) ) AND gs_dataloop1-duedate = gs_dataalv1-duedate.
            IF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) < Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              lv_icnt2 += 1.
              lv_icnt3 += 1.
              PERFORM patchloopin CHANGING LV_CbCNT.
              PERFORM delete.
              IF lv_cnt2 = lv_icnt2.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                lv_cnt2 -= lv_icnt3.
                lv_cnt3 -= lv_icnt3.
                lv_cnt4 -= lv_icnt3.
                EXIT.
              ENDIF.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) = Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              lv_icnt2 += 1.
              lv_icnt3 += 1.
              PERFORM patchloopin CHANGING LV_CbCNT.
              PERFORM delete.
              READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
              IF sy-subrc <> 0 .
                MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                EXIT.
              ENDIF.
              PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
              lv_check = 'X'.
              lv_checkout = ''.
              CLEAR: lv_odmaxwt.
              lv_cnt2 -= lv_icnt3.
              lv_cnt3 -= lv_icnt3.
              lv_cnt4 -= lv_icnt3.
              EXIT.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) > Gv_maxwt.
              lv_icnt2 += 1.
              IF lv_cnt2 = lv_icnt2.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                lv_cnt2 -= lv_icnt3.
                lv_cnt3 -= lv_icnt3.
                lv_cnt4 -= lv_icnt3.
                EXIT.
              ENDIF.
            ENDIF.
  
          ELSEIF GS_dATaloop1-odmaxwt <= ( GV_maxwt DIV 4 * 1 ) AND gs_dataloop1-duedate = gs_dataalv1-duedate.
            IF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) < Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              PERFORM patchloopin CHANGING LV_CbCNT.
              PERFORM delete.
              lv_icnt1 += 1.
              lv_icnt4 += 1.
              IF lv_cnt1 = lv_icnt1.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                CLEAR: lv_odmaxwt.
                lv_cnt1 -= lv_icnt4.
                lv_cnt2 -= lv_icnt4.
                lv_cnt3 -= lv_icnt4.
                lv_cnt4 -= lv_icnt4.
                EXIT.
              ENDIF.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) = Gv_maxwt.
              lv_icnt1 += 1.
              lv_icnt4 += 1.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              PERFORM patchloopin CHANGING LV_CbCNT.
              PERFORM delete.
              READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
              IF sy-subrc <> 0 .
                MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                EXIT.
              ENDIF.
              PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
              lv_check = 'X'.
              lv_checkout = ''.
              CLEAR: lv_odmaxwt.
              lv_cnt1 -= lv_icnt4.
              lv_cnt2 -= lv_icnt4.
              lv_cnt3 -= lv_icnt4.
              lv_cnt4 -= lv_icnt4.
              EXIT.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) > Gv_maxwt.
              lv_icnt1 += 1.
              IF lv_cnt1 = lv_icnt1.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                CLEAR: lv_odmaxwt.
                lv_cnt1 -= lv_icnt4.
                lv_cnt2 -= lv_icnt4.
                lv_cnt3 -= lv_icnt4.
                lv_cnt4 -= lv_icnt4.
                EXIT.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
  
  
        IF gt_dataalv1 IS INITIAL.
          IF lv_ODMAXWT = 0.
          ELSE.
            IF sy-subrc <> 0 .
              MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
              EXIT.
            ENDIF.
            PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
            lv_check = 'X'.
            lv_checkout = ''.
            CLEAR: lv_odmaxwt.
            EXIT.
          ENDIF.
        ELSEIF lv_check = 'X'.
          CONTINUE.
        ELSEIF lv_checkout = 'X'.
          READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
          IF sy-subrc <> 0 .
            MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
            EXIT.
          ENDIF.
          PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
          CONTINUE.
        ENDIF.
  
      ELSEIF GS_dATAALV1-odmaxwt <= ( GV_maxwt DIV 4 * 1 ).
        lv_icnt1 = 1.
        lv_icnt2 = 1.
        lv_icnt3 = 1.
        lv_icnt4 = 1.
        PERFORM EXIT_cnt CHANGING lv_cnt1 lv_cnt2 lv_cnt3 lv_cnt4 lv_exit.
        IF lv_exit = 'X'.
          EXIT.
        ENDIF.
        PERFORM set_dataloop CHANGING lv_odmaxwt lv_checkout.
        PERFORM concat_cnt CHANGING lv_cbcnt lv_cccnt.
        PERFORM patchloopout CHANGING LV_CbCNT.
        LOOP AT gt_dataloop1 INTO gs_dataloop1.
          IF GS_dATaloop1-odmaxwt <= ( GV_maxwt DIV 4 * 1 ) AND gs_dataloop1-duedate = gs_dataalv1-duedate.
            IF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) < Gv_maxwt.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              PERFORM patchloopin CHANGING LV_CbCNT.
              PERFORM delete.
              lv_icnt1 += 1.
              lv_icnt4 += 1.
              IF lv_cnt1 = lv_icnt1.
                READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                CLEAR: lv_odmaxwt.
                lv_cnt1 -= lv_icnt4.
                lv_cnt2 -= lv_icnt4.
                lv_cnt3 -= lv_icnt4.
                lv_cnt4 -= lv_icnt4.
                EXIT.
              ENDIF.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) = Gv_maxwt OR lv_cnt1 = lv_icnt1.
              lv_odmaxwt = lv_odmaxwt + gs_dataloop1-odmaxwt.
              PERFORM patchloopin CHANGING LV_CbCNT.
              PERFORM delete.
              lv_icnt1 += 1.
              lv_icnt4 += 1.
              READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
              IF sy-subrc <> 0 .
                MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                EXIT.
              ENDIF.
              PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
              lv_check = 'X'.
              lv_checkout = ''.
              CLEAR: lv_odmaxwt.
              lv_cnt1 -= lv_icnt4.
              lv_cnt2 -= lv_icnt4.
              lv_cnt3 -= lv_icnt4.
              lv_cnt4 -= lv_icnt4.
              EXIT.
            ELSEIF ( lv_odmaxwt + gs_dataloop1-odmaxwt ) > Gv_maxwt.
              lv_icnt1 += 1.
              IF lv_cnt1 = lv_icnt1.
                IF sy-subrc <> 0 .
                  MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
                  EXIT.
                ENDIF.
                PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
                lv_check = 'X'.
                lv_checkout = ''.
                CLEAR: lv_odmaxwt.
                lv_cnt1 -= lv_icnt4.
                lv_cnt2 -= lv_icnt4.
                lv_cnt3 -= lv_icnt4.
                lv_cnt4 -= lv_icnt4.
                EXIT.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.
  
  
        IF gt_dataalv1 IS INITIAL.
          IF lv_ODMAXWT = 0.
          ELSE.
            IF sy-subrc <> 0 .
              MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
              EXIT.
            ENDIF.
            PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
            lv_check = 'X'.
            lv_checkout = ''.
            CLEAR: lv_odmaxwt.
            EXIT.
          ENDIF.
        ELSEIF lv_check = 'X'.
          CONTINUE.
        ELSEIF lv_checkout = 'X'.
          READ TABLE GT_dATA3 INTO GS_dATA3 WITH TABLE KEY carcode = lv_cccnt.
          IF sy-subrc <> 0 .
            MESSAGE 'no car' TYPE 'S' DISPLAY LIKE 'E'.
            EXIT.
          ENDIF.
          PERFORM set_gt_data2 CHANGING lv_cbcnt gs_dataloop1-areacd lv_odmaxwt lv_cccnt lv_check lv_checkout.
          CONTINUE.
        ENDIF.
      ENDIF.
    ENDLOOP.
  *     gv_bcnt -= 1.
    CALL METHOD go_grid1->refresh_table_display.
    CALL METHOD go_grid2->refresh_table_display.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh .
  
    CLEAR: gs_data1.
    CLEAR: gs_dataalv1.
    REFRESH GT_dATAALV1.
  
    IF gv_flag = '' .
      SELECT COUNT(*)
        FROM ztc2sd2003
        INTO gv_carleft.
  
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
  
      SELECT a~ploc a~areacd b~ordercd  b~vendorc b~saleym b~odmaxwt b~weightunit b~resprid b~duedate
        FROM ZTC2md2005 AS a
        INNER JOIN ztc2sd2006 AS b
        ON a~vendorc = b~vendorc
  *   ON  B~PLANT = C~PLANT
  *   AND B~CMPNC = C~CMPNC
  **CMPNC = C~AREACD
        INTO CORRESPONDING FIELDS OF TABLE gt_data1
        WHERE b~statflag = 'E'.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
  
      SELECT carcode carnum maxwt areacd cardrive
        FROM ztc2sd2003
        INTO CORRESPONDING FIELDS OF TABLE GT_dATA3.
  
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
  
      SORT gt_Data3 BY areacd ASCENDING.
  *
  *  loop at gt_data1 into gs_Data1.
  *    if gs_data1-odmaxwt <= 250.
  *      GS_dATA1-OWSWT = 1.
  *      modify table GT_dATA1 from gs_data1.
  *    elseif 251 <= gs_data1-odmaxwt and gs_data1-odmaxwt <= 500.
  *      GS_dATA1-OWSWT = 2.
  *      modify table GT_dATA1 from gs_data1.
  *    elseif 501 <= gs_data1-odmaxwt and gs_data1-odmaxwt <= 750.
  *      GS_dATA1-OWSWT = 3.
  *      modify table GT_dATA1 from gs_data1.
  *    elseif 751 <= gs_data1-odmaxwt and gs_data1-odmaxwt <= 1000.
  *      GS_dATA1-OWSWT = 4.
  *      modify table GT_dATA1 from gs_data1.
  *    endif.
  *  endloop.
    ENDIF.
  
  
    gv_flag = 'X'.
  *     select count(*)
  *   from ZTC2SD2003
  *   into GV_AREALEFT
  *   WHERE AREACD = ZTC2MD2005-AREACD.
  
    IF sy-subrc <> 0 AND ztc2md2005-areacd IS NOT INITIAL..
      EXIT.
    ENDIF.
  
  
    IF ztc2sd2006-duedate IS INITIAL AND ztc2md2005-areacd IS INITIAL.
      gt_dataalv1 = GT_dATA1.
    ELSEIF ztc2sd2006-duedate IS INITIAL AND ztc2md2005-areacd IS NOT INITIAL.
      LOOP AT gt_data1 INTO gs_data1.
        IF GS_dATA1-areacd = ztc2md2005-areacd.
          APPEND gs_data1 TO gt_dataalv1.
        ENDIF.
      ENDLOOP.
    ELSEIF ztc2sd2006-duedate IS NOT INITIAL AND ztc2md2005-areacd IS INITIAL.
      LOOP AT GT_dATA1 INTO GS_dATA1.
        IF gs_data1-duedate = ztc2sd2006-duedate.
          APPEND gs_data1 TO gt_dataalv1.
        ENDIF.
      ENDLOOP.
    ELSEIF ztc2sd2006-duedate IS NOT INITIAL AND ztc2md2005-areacd IS NOT INITIAL.
      LOOP AT gt_data1 INTO gs_data1.
        IF GS_dATA1-areacd = ztc2md2005-areacd AND gs_data1-duedate = ztc2sd2006-duedate.
          APPEND gs_data1 TO gt_dataalv1.
        ENDIF.
      ENDLOOP.
    ENDIF.
  
    SORT gt_data1 BY duedate DESCENDING odmaxwt DESCENDING.
    SORT gt_dataalv1 BY duedate DESCENDING odmaxwt DESCENDING.
  
    CALL METHOD go_grid1->refresh_table_display.
    CALL METHOD go_grid2->refresh_table_display.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form oupda
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM oupda .
  *  DATA:    LV_CBCNT TYPE C LENGTH 5,
  *           LV_CCCNT TYPE C LENGTH 5.
  *
  *  perform concat_cnt CHANGING LV_CBCNT lv_cccnt.
    CALL SCREEN 110 STARTING AT 10 10.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form concat_cnt
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      <-- LV_CBCNT
  *&---------------------------------------------------------------------*
  FORM concat_cnt  CHANGING p_cbcnt p_cccnt.
    gv_bcnt += 1.
    p_cbcnt = gv_bcnt.
    CONDENSE p_cbcnt.
    IF     gv_bcnt DIV 10 = 0.
      CONCATENATE 'C' '000' p_cbcnt INTO p_cccnt.
      CONCATENATE 'D' '000' p_cbcnt INTO p_cbcnt.
    ELSEIF gv_bcnt DIV 10 = 1.
      CONCATENATE 'C' '00'  p_cbcnt INTO p_cccnt.
      CONCATENATE 'D' '00'  p_cbcnt INTO p_cbcnt.
    ELSEIF gv_bcnt DIV 10 = 10.
      CONCATENATE 'C' '0'   p_cbcnt INTO p_cccnt.
      CONCATENATE 'D' '0'   p_cbcnt INTO p_cbcnt.
    ELSEIF gv_bcnt DIV 10 = 100.
      CONCATENATE 'C'       p_cbcnt INTO p_cccnt.
      CONCATENATE 'D'       p_cbcnt INTO p_cbcnt.
    ENDIF.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form owswt_cnt
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      <-- LV_CNT1
  *&      <-- LV_CNT2
  *&      <-- LV_CNT3
  *&      <-- LV_CNT4
  *&---------------------------------------------------------------------*
  FORM owswt_cnt  CHANGING p_cnt1
                           p_cnt2
                           p_cnt3
                           p_cnt4
                           p_cnt5.
  
    DATA: lv_flag,
          l_cnt1      TYPE i,
          l_cnt2      TYPE i,
          l_cnt3      TYPE i,
          l_cnt4      TYPE i,
          ls_dataalv1 LIKE gs_dataalv1,
          lt_dataalv1 LIKE TABLE OF ls_dataalv1.
  
  
    MOVE-CORRESPONDING GT_dATAALV1 TO lt_dataalv1.
  
    LOOP AT lt_dataalv1 INTO ls_dataalv1.
      IF lv_flag = ''.
        READ TABLE gt_Data3 INTO gs_data3 INDEX 1.
        Gv_maxwt = gs_Data3-maxwt.
        CLEAR gs_data3.
        lv_flag = 'X'.
      ENDIF.
  
      IF      LS_dATAALV1-odmaxwt >= ( GV_maxwt DIV 4 * 3 + 1 ) AND LS_dATAALV1-odmaxwt <= ( GV_maxwt DIV 4 * 4 ).
        l_cnt4 += 1.
      ELSEIF LS_dATAALV1-odmaxwt >= ( GV_maxwt DIV 4 * 2 + 1 ) AND LS_dATAALV1-odmaxwt <= ( GV_maxwt DIV 4 * 3 ).
        l_cnt3 += 1.
      ELSEIF LS_dATAALV1-odmaxwt >= ( GV_maxwt DIV 4 * 1 + 1 ) AND LS_dATAALV1-odmaxwt <= ( GV_maxwt DIV 4 * 2 ).
        l_cnt2 += 1.
      ELSEIF LS_dATAALV1-odmaxwt <= ( GV_maxwt DIV 4 * 1 ).
        l_cnt1 += 1.
      ENDIF.
      p_cnt5 += 1.
    ENDLOOP.
  
    p_cnt4 = l_cnt4.
    p_cnt3 = l_cnt3.
    p_cnt2 = l_cnt2.
    p_cnt1 = l_cnt1.
  
  
    p_cnt4 = p_cnt4 + p_cnt3 + p_cnt2 + p_cnt1.
    p_cnt3 = p_cnt3 + p_cnt2 + p_cnt1.
    p_cnt2 = p_cnt2 + p_cnt1.
    p_cnt1 = p_cnt1.
  *       IF GS_dATAALV1-odmaxwt <= ( GS_DATA3-maxwt DIV 4 * 4 ).
  *         p_CNT4 += 1.
  *       ELSEIF GS_dATAALV1-odmaxwt = 3.
  *         p_CNT3 += 1.
  *       ELSEIF GS_dATAALV1-ODMAXWT = 2.
  *         p_CNT2 += 1.
  *       ELSEIF GS_dATAALV1-ODMAXWT = 1.
  *         p_CNT1 += 1.
  *       ENDIF.
  *     ENDLOOP.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_GT_DATA2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      <-- LV_CBCNT
  *&      <-- GS_DATALOOP1_AREACD
  *&      <-- LV_ODMAXWT
  *&      <-- LV_CCCNT
  *&      <-- LV_CHECK
  *&      <-- LV_CHECKOUT
  *&---------------------------------------------------------------------*
  FORM set_gt_data2  CHANGING p_cbcnt
                              p_data1_areacd
                              p_odmaxwt
                              p_cccnt
                              p_check
                              p_checkout.
    gs_data2-dispatchcd = P_cBCNT.
    gs_data2-areacd     = P_DATA1_areacd.
    gs_data2-carnum     = gs_data3-carnum.
    gs_data2-currmaxwt  = p_odmaxwt.
    gs_data2-weightunit = 'KG'.
    gs_Data2-cardrive   = GS_dATA3-cardrive.
    gs_Data2-allMAXWT   = gs_data3-maxwt.
    gs_data2-carcode    = P_Cccnt.
    APPEND gs_data2 TO gt_data2.
    gv_carleft -= 1.
  *                  GV_AREALEFT -= 1.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form EXIT_cnt
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      <-- LV_CNT1
  *&      <-- LV_CNT2
  *&      <-- LV_CNT3
  *&      <-- LV_CNT4
  *&      <-- LV_EXIT
  *&---------------------------------------------------------------------*
  FORM EXIT_cnt  CHANGING p_cnt1
                          p_cnt2
                          p_cnt3
                          p_cnt4
                          p_exit.
    IF P_cnt1 = 1 AND P_cnt2 = 1 AND P_cnt3 = 1 AND P_cnt4 = 1.
      p_exit = 'X'.
    ELSEIF P_cnt1 = 0 AND P_cnt2 = 1 AND P_cnt3 = 1 AND P_cnt4 = 1.
      p_exit = 'X'.
    ELSEIF P_cnt1 = 1 AND P_cnt2 = 2 AND P_cnt3 = 2 AND P_cnt4 = 2.
      p_exit = 'X'.
    ELSEIF P_cnt1 = 2 AND P_cnt2 = 2 AND P_cnt3 = 2 AND P_cnt4 = 2.
      p_exit = 'X'.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_DATALOOP
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      <-- LV_ODMAXWT
  *&      <-- LV_CHECKOUT
  *&---------------------------------------------------------------------*
  FORM set_dataloop  CHANGING p_odmaxwt
                              p_checkout.
    CLEAR p_checkout.
    p_odmaxwt = gs_dataalv1-odmaxwt.
    gt_dataloop1 = GT_dATAALV1.
    DELETE TABLE gt_data1 FROM GS_DATAalv1.
    DELETE TABLE gt_dataloop1 FROM gs_dataalv1.
    DELETE TABLE gt_Dataalv1  FROM GS_DATAalv1.
    IF GS_dATAALV1-odmaxwt <= ( GV_maxwt DIV 4 * 1 ).
      P_checkout = 'X'.
    ENDIF.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form handle_double_click
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> E_ROW
  *&      --> E_COLUMN
  *&---------------------------------------------------------------------*
  FORM handle_double_click  USING    p_row TYPE lvc_s_row
                                     p_column TYPE lvc_s_col.
  
    CLEAR gs_data2.
    READ TABLE gt_data2 INTO gs_data2 INDEX p_row-index.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  
    CALL SCREEN 110 STARTING AT 10 10.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_FCAT_110
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_110 .
    PERFORM set_gt_fcat3 USING:
    'X' 'ORDERCD'    '' 'ZTC2SD2006' 'ORDERCD',
    'X' 'VENDORC'    '' 'ZTC2SD2006' 'VENDORC',
    'X' 'SALEYM'     '' 'ZTC2SD2006' 'SALEYM',
    ' ' 'DUEDATE' '' 'ZTC2SD2006' 'DUEDATE',
    ' ' 'ODMAXWT'    '' 'ZTC2SD2006' 'ODMAXWT',
    ' ' 'WEIGHTUNIT' '' 'ZTC2SD2006' 'WEIGHTUNIT',
    ' ' 'RESPRID'    '' 'ZTC2SD2006' 'RESPRID',
    ' ' 'AREACD'     '' 'ZTC2MD2005' 'AREACD',
    ' ' 'PLOC'       '' 'ZTC2MD2005' 'PLOC' .
  
    PERFORM set_gt_fcat4 USING:
    'X' 'ORDERCD'    '' 'ZTC2SD2006' 'ORDERCD',
    'X' 'DISPATCHCD'    '' 'ZTC2SD2004' 'DISPATCHCD',
    'X' 'VENDORC'    '' 'ZTC2SD2006' 'VENDORC',
    'X' 'SALEYM'     '' 'ZTC2SD2006' 'SALEYM',
    ' ' 'DUEDATE' '' 'ZTC2SD2006' 'DUEDATE',
    ' ' 'ODMAXWT'    '' 'ZTC2SD2006' 'ODMAXWT',
    ' ' 'WEIGHTUNIT' '' 'ZTC2SD2006' 'WEIGHTUNIT',
    ' ' 'RESPRID'    '' 'ZTC2SD2006' 'RESPRID',
    ' ' 'AREACD'     '' 'ZTC2MD2005' 'AREACD',
    ' ' 'PLOC'       '' 'ZTC2MD2005' 'PLOC' .
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_LAYO_110
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_layo_110 .
    gs_layo3-zebra = 'X'.
    gs_layo4-zebra = 'X'.
    gs_layo3-sel_mode = 'D'.
    gs_layo4-sel_mode = 'D'.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_GO_ALV4
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_go_alv4 .
    IF GO_container4 IS NOT BOUND.
      CREATE OBJECT go_container4
        EXPORTING
          container_name = 'AREA4'.
  
      CREATE OBJECT go_grid4
        EXPORTING
          i_parent = go_container4.
  
      CALL METHOD go_grid4->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layo4
        CHANGING
          it_outtab       = gt_data5
          it_fieldcatalog = gt_fcat4.
    ELSE.
      CALL METHOD go_grid4->refresh_table_display
  *      EXPORTING
  *        is_stable      =
  *        i_soft_refresh =
  *      EXCEPTIONS
  *        finished       = 1
  *        others         = 2
        .
      IF sy-subrc <> 0.
  *     Implement suitable error handling here
      ENDIF.
  
    ENDIF.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_GT_FCAT4
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_gt_fcat4  USING    pv_key
                              pv_fieldname
                              pv_coltext
                              pv_ref_table
                              pv_ref_field.
  
    CLEAR gs_fcat4.
    gs_fcat4-key       = pv_key.
    gs_fcat4-fieldname = pv_fieldname.
    gs_fcat4-coltext   = pv_coltext.
    GS_fCAT4-ref_table = PV_rEF_TABLE.
    GS_fCAT4-ref_field = pv_ref_field.
  
    IF pv_fieldname = 'PLOC'.
      gs_fcat4-outputlen = 20.
    ELSEIF pv_fieldname = 'AREACD'.
      gs_fcat4-outputlen = 7.
    ELSE.
      GS_fCAT4-outputlen = 9.
    ENDIF.
  
  
    APPEND gs_fcat4 TO gt_fcat4.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form IN_DATA
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM in_data .
    REFRESH gt_rows.
    CLEAR: gs_row, gs_data5.
    DATA lt_data5 LIKE TABLE OF gs_data5.
    LT_dATA5 = GT_dATA5.
  
    CALL METHOD gO_GRID4->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    LOOP AT gt_rows INTO gs_row.
      READ TABLE lt_data5 INTO gs_data5 INDEX gs_row-index.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
      MOVE-CORRESPONDING gs_data5 TO GS_dATAALV1.
      INSERT GS_dATAALV1 INTO TABLE gt_dataalv1.
      DELETE TABLE gt_data5 FROM GS_dATA5.
    ENDLOOP.
  
    CALL METHOD go_grid4->refresh_table_display.
    CALL METHOD go_grid3->refresh_table_display.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form OUT_dATA
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM OUT_dATA .
    CLEAR: gs_row, gs_dataalv1.
    REFRESH gt_rows.
    DATA: lt_dataalv1 LIKE TABLE OF gs_dataalv1.
    lt_dataalv1 = GT_DATAalv1.
  
    CALL METHOD gO_GRID3->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    LOOP AT gt_rows INTO gs_row.
      READ TABLE lt_dataalv1 INTO gs_dataalv1 INDEX gs_row-index.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
      MOVE-CORRESPONDING GS_dATAALV1 TO gs_data5.
      GS_dATA5-dispatchcd = GS_dATA2-dispatchcd.
      INSERT GS_dATA5 INTO TABLE gt_data5.
      DELETE TABLE gt_dataalv1 FROM GS_dATAALV1.
    ENDLOOP.
  
    CALL METHOD go_grid4->refresh_table_display.
    CALL METHOD go_grid3->refresh_table_display.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form delete
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM delete .
    DELETE TABLE gt_data1 FROM gs_dataloop1.
    DELETE TABLE gt_dataalv1 FROM gs_dataloop1.
    DELETE TABLE gt_Dataloop1 FROM gs_dataloop1.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form patch
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM patchloopin CHANGING p_cbcnt.
    MOVE-CORRESPONDING gs_dataloop1 TO gs_data4.
    gs_data4-dispatchcd  = p_CBCNT.
    INSERT gs_Data4 INTO TABLE gt_Data4.
  ENDFORM.
  
  *&---------------------------------------------------------------------*
  *& Form patch
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM patchloopout CHANGING p_cbcnt.
    MOVE-CORRESPONDING GS_DATAalv1 TO gs_data4.
    gs_data4-dispatchcd  = p_CBCNT.
    INSERT gs_Data4 INTO TABLE gt_Data4.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form OK_BATCHA
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM ok_batcha .
    APPEND LINES OF gt_data5 TO GT_dATA4.
  *  MOVE-CORRESPONDING GS_DATA2 to gs_data4.
  *  gs_data4-dispatchcd  = GS_DATA2-dispatchcd.
  *  IF gv_oupda = ''.
  *    MODIFY TABLE GT_DATA2 FROM GS_DATA2.
  *  ELSE.
    gv_carleft -= 1.
    gs_data2-weightunit = 'KG'.
    gs_data2-allmaxwt = 4000.
    DELETE TABLE gt_data3 WITH TABLE KEY carcode = gs_data3-carcode.
    INSERT gs_data2 INTO TABLE gt_data2.
    MODIFY TABLE gt_data2 FROM gs_data2.
    CLEAR gv_oupda.
  *  ENDIF.
    CLEAR GS_dATA3.
    CLEAR gs_data2.
  *  REFRESH GT_DATA5.
    CALL METHOD go_grid2->refresh_table_display.
    CALL METHOD go_grid1->refresh_table_display.
    LEAVE TO SCREEN 0.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form DELETE_DATA2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM delete_data2 .
    REFRESH gt_rows.
    CLEAR: gs_row, gs_data5.
    CALL METHOD gO_GRID2->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    LOOP AT gt_rows INTO gs_row.
      READ TABLE gt_data2 INTO gs_data2 INDEX gs_row-index.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
      DELETE TABLE gt_data2 FROM gs_data2.
      CLEAR gs_dataalv1.
      LOOP AT gt_data4 INTO gs_data4.
        IF GS_dATA2-dispatchcd = gs_data4-dispatchcd.
          MOVE-CORRESPONDING gs_data4 TO gs_dataalv1.
          INSERT GS_dATAALV1 INTO TABLE GT_dATAALV1.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
    GV_bCNT -= 1.
    gv_carleft += 1.
    CALL METHOD go_grid2->refresh_table_display.
    CALL METHOD go_grid1->refresh_table_display.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form COMMIT_DB
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM commit_db .
    DATA: lv_answer TYPE c.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '배차확정'
        text_question         = '배차확정을 확정하시겠습니까?'
        text_button_1         = 'YES'
        icon_button_1         = 'ICON_SYSTEM_OKAY'
        text_button_2         = 'NO'
        icon_button_2         = 'ICON_SYSTEM_CANCEL'
        display_cancel_button = ''
      IMPORTING
        answer                = lv_answer
      EXCEPTIONS
        text_not_found        = 1
        OTHERS                = 2.
  
    IF lv_answer = 1.
      SELECT plant cmpnc vendorc saleym ordercd orderdate ttamount waers odmaxwt weightunit duedate resprid OUTSTOREDT
     statflag delflag dispatchcd
        FROM ztc2sd2006
        INTO CORRESPONDING FIELDS OF TABLE gt_commitdata1.
  
      LOOP AT gt_commitdata1 INTO gs_commitdata1.
        READ TABLE gt_data4 INTO gs_data4 WITH KEY gs_commitdata1-ordercd.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
        gs_commitdata1-dispatchcd = GS_dATA4-dispatchcd.
  *    MODIFY ZTC2MD2006 FROM GS_COMMITDATA1.
        MODIFY gt_commitdata1 FROM gs_commitdata1 TRANSPORTING dispatchcd.
      ENDLOOP.
  
      MODIFY ztc2sd2006 FROM TABLE gt_commitdata1.
  
  
      LOOP AT gt_data2 INTO gs_data2.
        gs_commitdata2-plant = 1000.
        gs_commitdata2-cmpnc = 1004.
        gs_commitdata2-carcode = gs_data2-carcode.
        gs_commitdata2-currmaxwt = GS_dATA2-currmaxwt.
        gs_commitdata2-weightunit = 'KG'.
        gs_commitdata2-dispatchcd = gs_data2-dispatchcd.
        APPEND gs_commitdata2 TO gt_commitdata2.
      ENDLOOP.
      MODIFY ztc2sd2004 FROM TABLE gt_commitdata2.
  
  
  
    ELSE.
      EXIT.
    ENDIF.
  
  
  IF sy-dbcnt > 0.
        COMMIT WORK AND WAIT.
        MESSAGE '매출이 확정되었습니다.' TYPE 'S'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE s003 DISPLAY LIKE 'E'.
      ENDIF.
  
  ENDFORM.