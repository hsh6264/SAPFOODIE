*&---------------------------------------------------------------------*
*& Include          SAPMZC2SD2004_F01
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
    'X' 'SHOT'          '상태' '' '',
    'X' 'ORDERCD'       '' 'ZTC2SD2006' 'ORDERCD',
    ' ' 'ORDERDATE'     '' 'ZTC2SD2006' 'ORDERDATE',
    ' ' 'DUEDATE'       '' 'ZTC2SD2006' 'DUEDATE',
    ' ' 'VENDORN'       '' 'ZTC2MD2005' 'VENDORN',
    ' ' 'TTAMOUNT'      '' 'ZTC2SD2006' 'TTAMOUNT',
    ' ' 'WAERS'         '' 'ZTC2SD2006' 'WAERS',
    ' ' 'RESPRID'       '' 'ZTC2SD2006' 'RESPRID',
    ' ' 'OUTSTOREDT'    '' 'ZTC2SD2006' 'OUTSTOREDT'.
  
    PERFORM set_gt_fcat2 USING:
    'X' 'ORDERCD'     ''        'ZTC2SD2007' 'ORDERCD',
    'X' 'PRODCD'      ''        'ZTC2SD2007' 'PRODCD',
    ' ' 'MATRNM'      ''        'ZTC2MD2006' 'MATRNM',
    ' ' 'FIXEDQTY'    ''        'ZTC2SD2007' 'FIXEDQTY',
    ' ' 'BOXUNIT'     ''        'ZTC2SD2007'  'BOXUNIT',
    ' ' 'BOXEA'       '박스당EA'  '' '',
    ' ' 'SOITEMPRICE' '단가'      'ZTC2SD2007' 'ITEMPRICE',
    ' ' 'WAERS'       ''        'ZTC2SD2007' 'WAERS',
    ' ' 'ITEMPRICE'   ''        'ZTC2SD2007' 'ITEMPRICE'.
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
          container_name              = 'AREA1'.
  
      CREATE OBJECT go_grid1
        EXPORTING
          i_parent          = go_container1.
  
      IF go_handler IS NOT BOUND.
        CREATE OBJECT   go_handler.
      ENDIF.
  
      SET HANDLER go_handler->handle_double_click FOR go_grid1.
  
      CALL METHOD go_grid1->set_table_for_first_display
        EXPORTING
          is_layout                     = gs_layo1
        CHANGING
          it_outtab                     = gt_data1
          it_fieldcatalog               = GT_fCAT1
              .
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
          container_name              = 'AREA2'.
  
      CREATE OBJECT go_grid2
        EXPORTING
          i_parent          = go_container2.
  
  
      CALL METHOD go_grid2->set_table_for_first_display
        EXPORTING
          is_layout                     = gs_layo2
        CHANGING
          it_outtab                     = gt_data2
          it_fieldcatalog               = GT_fCAT2.
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
  *& Form SET_GT_FCAT1
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
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
  GS_fCAT1-outputlen = 10.
  
  IF pv_fieldname = 'STATFLAG'.
    GS_fCAT1-outputlen = 7.
  ELSEIF pv_fieldname = 'VENDORN'.
    gs_fcat1-outputlen = 18.
  ENDIF.
  
  CASE pv_fieldname.
    WHEN 'TTAMOUNT'.
      gs_fcat1-Cfieldname = 'WAERS'.
  ENDCASE.
  
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
  GS_fCAT2-outputlen = 11.
  
  CASE pv_fieldname.
    WHEN 'ITEMPRICE' OR 'SOITEMPRICE'.
      gs_fcat2-Cfieldname = 'WAERS'.
  ENDCASE.
  
  APPEND gs_fcat2 TO gt_fcat2.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SEARCH_LIST
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM search_list .
  DATA: lrt_orderdate LIKE RANGE OF gs_data1-orderdate,
        lrs_orderdate LIKE LINE OF lrt_orderdate.
  
  
  lrs_orderdate-sign  = 'I'.
  
  IF gv_dateup = '00000000'.
    lrs_orderdate-option = 'EQ'.
  ELSE.
    lrs_orderdate-option = 'BT'.
  ENDIF.
  
  lrs_orderdate-low    = ztc2sd2006-orderdate.
  lrs_orderdate-high    = gv_dateup.
  
  IF lrs_orderdate-low IS NOT INITIAL OR lrs_orderdate-high IS NOT INITIAL.
    APPEND lrs_orderdate TO lrt_orderdate.
  ENDIF.
  
  
    IF ztc2sd2006-vendorc IS NOT INITIAL AND ztc2sd2006-statflag IS NOT INITIAL.
      SELECT a~plant a~cmpnc a~vendorc a~saleym a~ordercd a~orderdate a~duedate a~ttamount a~waers a~odmaxwt a~weightunit a~outstoredt a~resprid a~statflag a~delflag a~dispatchcd b~vendorn
      FROM ztc2sd2006 AS a
      INNER JOIN ztc2md2005 AS b
      ON a~vendorc = b~vendorc
      INTO CORRESPONDING FIELDS OF TABLE GT_dATA1
      WHERE b~vendorc = ztc2sd2006-vendorc
      AND   a~statflag = ztc2sd2006-statflag
      AND orderdate IN lrt_orderdate
  
      AND ( a~statflag = 'E' OR a~statflag = 'F' ).
  
    ELSEIF ztc2sd2006-vendorc IS NOT INITIAL AND ztc2sd2006-statflag IS INITIAL.
      SELECT a~plant a~cmpnc a~vendorc a~saleym a~ordercd a~orderdate a~duedate a~ttamount a~waers a~odmaxwt a~weightunit a~outstoredt a~resprid a~statflag a~delflag a~dispatchcd b~vendorn
      FROM ztc2sd2006 AS a
      INNER JOIN ztc2md2005 AS b
      ON a~vendorc = b~vendorc
      INTO CORRESPONDING FIELDS OF TABLE GT_dATA1
      WHERE  b~vendorc = ztc2sd2006-vendorc
      AND    orderdate IN lrt_orderdate
  
      AND ( a~statflag = 'E' OR a~statflag = 'F' ).
  
    ELSEIF ztc2sd2006-vendorc IS INITIAL AND ztc2sd2006-statflag IS NOT INITIAL.
      SELECT a~plant a~cmpnc a~vendorc a~saleym a~ordercd a~orderdate a~duedate a~ttamount a~waers a~odmaxwt a~weightunit a~outstoredt a~resprid a~statflag a~delflag a~dispatchcd b~vendorn
      FROM ztc2sd2006 AS a
      INNER JOIN ztc2md2005 AS b
      ON a~vendorc = b~vendorc
      INTO CORRESPONDING FIELDS OF TABLE GT_dATA1
      WHERE a~statflag = ztc2sd2006-statflag
      AND   orderdate IN lrt_orderdate
  
      AND ( a~statflag = 'E' OR a~statflag = 'F' ).
  
    ELSEIF ztc2sd2006-vendorc IS INITIAL AND ztc2sd2006-statflag IS INITIAL.
      SELECT a~plant a~cmpnc a~vendorc a~saleym a~ordercd a~orderdate a~duedate a~ttamount a~waers a~odmaxwt a~weightunit a~outstoredt a~resprid a~statflag a~delflag a~dispatchcd b~vendorn
      FROM ztc2sd2006 AS a
      INNER JOIN ztc2md2005 AS b
      ON a~vendorc = b~vendorc
      INTO CORRESPONDING FIELDS OF TABLE GT_dATA1
      WHERE orderdate IN lrt_orderdate
  
      AND ( a~statflag = 'E' OR a~statflag = 'F' ).
  
    ENDIF.
  
  LOOP AT gt_data1 INTO GS_dATA1.
    IF gs_data1-statflag = 'A'.
      gs_data1-shot = '승인 대기'.
  ELSEIF gs_data1-statflag = 'B'.
      gs_data1-shot = '승인'.
  ELSEIF gs_data1-statflag = 'C'.
      gs_data1-shot = '반려'.
  ELSEIF gs_data1-statflag = 'D'.
      gs_data1-shot = '주문 접수'.
  ELSEIF gs_data1-statflag = 'E'.
      gs_data1-shot = '주문 확정'.
  ELSEIF gs_data1-statflag = 'F'.
      gs_data1-shot = '출하 확정'.
  ELSEIF gs_data1-statflag = 'G'.
      gs_data1-shot = '배송 완료'.
  ELSEIF gs_data1-statflag = 'H'.
      gs_data1-shot = '전표생성'.
  ENDIF.
    MODIFY GT_dATA1 FROM GS_dATA1.
  ENDLOOP.
  
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
                                     p_column.
  
    CLEAR gs_data1.
    READ TABLE gt_data1 INTO gs_data1 INDEX p_row-index.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  
    SELECT a~plant a~cmpnc a~vendorc a~saleym a~ordercd a~prodcd a~boxunit a~itemprice  a~waers a~itemweight a~weightunit a~statflag a~itemqty a~fixedqty b~MATrNM
      FROM ztc2sd2007 AS a
      INNER JOIN ztc2md2006 AS b
      ON a~prodcd = b~matrC
      INTO CORRESPONDING FIELDS OF TABLE gt_data2
      WHERE a~ordercd = GS_dATA1-ordercd.
  
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  
  LOOP AT GT_dATA2 INTO gs_DATA2.
    gs_data2-boxea = 10.
    IF gs_data2-fixedqty <> 0.
     gs_data2-soitemprice = GS_dATA2-itemprice / gs_data2-fixedqty.
    ELSE.
     gs_data2-soitemprice = 0.
    ENDIF.
  
    MODIFY TABLE GT_dATA2 FROM GS_dATA2.
  ENDLOOP.
  
    CALL METHOD go_grid2->refresh_table_display.
  
  "data: begin of gs_data2,
  *PLANT      type ztc2sd2007-plant,
  *CMPNC      type ztc2sd2007-cmpnc,
  *VENDORC    type ztc2sd2007-vendorc,
  *SALEYM     type ztc2sd2007-saleym,
  *ORDERCD    type ztc2sd2007-ordercd,
  *PRODCD     type ztc2sd2007-prodcd,
  *BOXUNIT    type ztc2sd2007-boxunit,
  *ITEMPRICE  type ztc2sd2007-itemprice,
  *WAERS      type ztc2sd2007-waers,
  *ITEMWEIGHT type ztc2sd2007-itemweight,
  *WEIGHTUNIT type ztc2sd2007-weightunit,
  *STATFLAG   type ztc2sd2007-statflag,
  *ITEMQTY    type ztc2sd2007-itemqty,
  *FIXEDQTY   type ztc2sd2007-fixedqty,
  *MATrNM     type ztc2md2006-matrnm,
  *  end of gs_Data2,
  *  gt_Data2 like table of gs_data2,
  *  ok_code  type sy-ucomm.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_SCREEN_CONDITION
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_screen_condition .
  CLEAR GS_dATA1.
    IF ztc2sd2006-statflag = 'A'.
      gv_statflag = '승인 대기'.
  ELSEIF ztc2sd2006-statflag = 'B'.
      gv_statflag = '승인'.
  ELSEIF ztc2sd2006-statflag = 'C'.
      gv_statflag = '반려'.
  ELSEIF ztc2sd2006-statflag = 'D'.
      gv_statflag = '주문 접수'.
  ELSEIF ztc2sd2006-statflag = 'E'.
      gv_statflag = '주문 확정'.
  ELSEIF ztc2sd2006-statflag = 'F'.
      gv_statflag = '출하 확정'.
  ELSEIF ztc2sd2006-statflag = 'G'.
      gv_statflag = '배차 확정'.
  ELSEIF ztc2sd2006-statflag = 'H'.
      gv_statflag = '전표생성'.
  ENDIF.
  
  IF ztc2sd2006-vendorc IS NOT INITIAL.
    READ TABLE GT_dATA1 INTO gs_data1 INDEX 1.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
    gv_vendorn = gs_data1-vendorn.
  ENDIF.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form FIXED_DATA
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM fixed_data .
    DATA: lv_answer TYPE c,
          ls_data   TYPE ztc2sd2006,
          LT_dATA   LIKE TABLE OF ls_data,
          ls_data1  TYPE ztc2mm2001,
          lt_data1  LIKE TABLE OF ls_data1 WITH NON-UNIQUE KEY matrC.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '출하확정'
        text_question         = '출하를 확정하시겠습니까?'
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
      SELECT cmpnc plant warehscd matrc stckq unit
        FROM ztc2mm2001
        INTO CORRESPONDING FIELDS OF TABLE lt_data1
        WHERE matrc LIKE 'CP%'.
  
      LOOP AT gt_data1 INTO gs_data1.
        gs_data1-outstoredt = sy-datum.
        gs_data1-statflag = 'F'.
        MODIFY gt_data1 FROM gs_data1.
      ENDLOOP.
  
      MOVE-CORRESPONDING gt_data1 TO lt_data.
  
  
      LOOP AT gt_data2 INTO gs_data2.
      READ TABLE lT_DATA1 INTO ls_data1 WITH TABLE KEY matrc = gs_data2-prodcd.
      ls_data1-stckq = ls_data1-stckq - gs_data2-fixedqty * 10.
      MODIFY TABLE lt_Data1 FROM ls_data1.
      ENDLOOP.
  *
  
      LOOP AT gt_data1 INTO GS_dATA1.
    IF gs_data1-statflag = 'A'.
      gs_data1-shot = '승인 대기'.
  ELSEIF gs_data1-statflag = 'B'.
      gs_data1-shot = '승인'.
  ELSEIF gs_data1-statflag = 'C'.
      gs_data1-shot = '반려'.
  ELSEIF gs_data1-statflag = 'D'.
      gs_data1-shot = '주문 접수'.
  ELSEIF gs_data1-statflag = 'E'.
      gs_data1-shot = '주문 확정'.
  ELSEIF gs_data1-statflag = 'F'.
      gs_data1-shot = '출하 확정'.
  ELSEIF gs_data1-statflag = 'G'.
      gs_data1-shot = '배송 완료'.
  ELSEIF gs_data1-statflag = 'H'.
      gs_data1-shot = '전표생성'.
  ENDIF.
    MODIFY GT_dATA1 FROM GS_dATA1.
  ENDLOOP.
  
  
      MODIFY ZTC2mm2001 FROM TABLE lt_data1.
      MODIFY ztc2sd2006 FROM TABLE lt_data.
      CALL METHOD go_grid1->refresh_table_display
              .
  
  
    ENDIF.
  
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
  
  ENDFORM.