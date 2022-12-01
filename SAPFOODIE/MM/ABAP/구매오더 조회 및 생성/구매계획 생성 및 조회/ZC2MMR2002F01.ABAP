*&---------------------------------------------------------------------*
*& Include          ZC2MMR2002_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form modify_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form modify_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM modify_screen .

    LOOP AT SCREEN.
      IF pa_rd1 = 'X'.
        title1 = '계획 생성'.
        IF screen-group1 = 'SC1'.
          screen-active = 1.
        ENDIF.
        IF screen-name = 'PA_PLANT'.
          screen-input = 0.
        ENDIF.
        IF screen-name = 'PA_YYMM'.
          DATA: lv_data LIKE sy-datum.
  
          CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
            EXPORTING
              date      = sy-datum      "-> 기준일
              days      = '00'          "-> 더하거나 뺄 일자수
              months    = '01'        "-> 더하거나 뺄 월수
              years     = '00'         "-> 더하거나 뺄 년수
              signum    = '+'         "-> 더할지 뺄지를 정하는 기호
            IMPORTING
              calc_date = lv_data. "-> 계산된 날짜 (SY-DATUM)
  
          CONCATENATE lv_data(6)'' INTO pa_yymm.
        ENDIF.
  
        IF screen-group1 = 'SC2'.
          screen-active = 0.
        ENDIF.
      ENDIF.
      MODIFY SCREEN.
  
  
  
      IF pa_rd2 = 'X'.
        title1 = '조회 및 수정'.
        IF screen-group1 = 'SC1'.
          screen-active = 0.
        ENDIF.
        IF screen-group1 = 'SC2'.
          screen-active = 1.
        ENDIF.
        IF screen-name = 'PA_PLT2'.
          screen-input = 0.
        ENDIF.
      ENDIF.
      MODIFY SCREEN.
    ENDLOOP.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_data .
  
    CLEAR   gs_data.
    REFRESH gt_data.
  
    SELECT a~matrc a~cmpnc b~plant a~matrnm stckq a~unit a~warehscd a~vendorc
      INTO CORRESPONDING FIELDS OF TABLE gt_data
      FROM ztc2md2006 AS a
      INNER JOIN ztc2mm2001 AS b
      ON    a~matrc    = b~matrc
      AND   a~warehscd = b~warehscd
      WHERE b~warehscd = '110'.
  
  ENDFORM.
  
  *&---------------------------------------------------------------------*
  *& Form SET_FCAT_LAYOUT
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_layout .
  
    gs_layout-zebra       = 'X'.
    gs_layout-sel_mode    = 'D'.
    gs_layout-cwidth_opt  = 'X'.
    gs_layout-no_toolbar  = 'X'.
  
    PERFORM set_fcat USING :
  
          'X'   'MATRC'     ' '   'ZTC2MD2006'   'MATRC',
          ' '   'MATRNM'    ' '   'ZTC2MD2006'   'MATRNM',
          ' '   'STCKQ'     ' '   'ZTC2MM2001'   'STCKQ',
          ' '   'UNIT'      ' '   'ZTC2MM2001'   'UNIT',
          ' '   'WAREHSCD'  ' '   'ZTC2MD2006'   'WAREHSCD'.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_fcat  USING pv_key pv_field pv_text pv_ref_table pv_ref_feild.
  
    gs_fcat-key       = pv_key.
    gs_fcat-fieldname = pv_field.
    gs_fcat-coltext   = pv_text.
    gs_fcat-ref_table = pv_ref_table.
    gs_fcat-ref_field = pv_ref_feild.
  
    CASE pv_field.
      WHEN 'PERCTP'.
        gs_fcat-qfieldname = 'UNIT'.
    ENDCASE.
  
    APPEND gs_fcat TO gt_fcat.
    CLEAR  gs_fcat.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Module DISPLAY_SCREEN OUTPUT
  *&---------------------------------------------------------------------*
  *&
  *&---------------------------------------------------------------------*
  FORM display_screen.
  
    IF gcl_container IS NOT BOUND.
  
      CREATE OBJECT gcl_container
        EXPORTING
          container_name = 'GCL_CONTAINER'.
  
      CREATE OBJECT gcl_grid
        EXPORTING
          i_parent = gcl_container.
  
      gs_variant-report = sy-repid.
  
      CALL METHOD gcl_grid->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout
        CHANGING
          it_outtab       = gt_data
          it_fieldcatalog = gt_fcat.
  
    ENDIF.
  
  
  ENDFORM.
  
  FORM set_fcat_layout2 .
  
    gs_layout2-zebra      = 'X'.
    gs_layout2-sel_mode   = 'D'.
    gs_layout2-cwidth_opt = 'X'.
    gs_layout2-no_toolbar = 'X'.
  
    PERFORM set_fcat2 USING :
          'X'   'MATRC'     ' '  'ZTC2MD2006'   'MATRC',
          ' '   'MATRNM'    ' '  'ZTC2MD2006'   'MATRNM',
          ' '   'PPQUAN'    ' '  'ZTC2PP2005'   'PPQUAN',
          ' '   'PURCP'     ' '  'ZTC2MM2003'   'PURCP',
          ' '   'UNIT'      ' '  'ZTC2MD2006'   'UNIT',
          ' '   'WAREHSCD'  ' '  'ZTC2MD2006'   'WAREHSCD'.
  
  ENDFORM.
  
  FORM display_screen2.
  
    IF gcl_container2 IS NOT BOUND.
  
      CREATE OBJECT gcl_container2
        EXPORTING
          container_name = 'GCL_CONTAINER2'.
  
      CREATE OBJECT gcl_grid2
        EXPORTING
          i_parent = gcl_container2.
  
      gs_variant-report = sy-repid.
  
      CALL METHOD gcl_grid2->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant2
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout2
        CHANGING
          it_outtab       = gt_item
          it_fieldcatalog = gt_fcat2.
  
    ENDIF.
  
  
  ENDFORM.
  
  FORM set_fcat2  USING pv_key pv_field pv_text pv_ref_table pv_ref_feild.
  
    gs_fcat2-key       = pv_key.
    gs_fcat2-fieldname = pv_field.
    gs_fcat2-coltext   = pv_text.
    gs_fcat2-ref_table = pv_ref_table.
    gs_fcat2-ref_field = pv_ref_feild.
  
    CASE pv_field.
      WHEN 'PERCTP'.
        gs_fcat2-qfieldname = 'UNIT'.
      WHEN 'PURCP'.
        gs_fcat2-qfieldname = 'UNIT'.
        gs_fcat2-edit = 'X'.
    ENDCASE.
  
    APPEND gs_fcat2 TO gt_fcat2.
    CLEAR  gs_fcat2.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_info
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_info .
  
    gv_ddate = sy-datum.
    gv_charge = sy-uname.
    gv_plant = '1000'.
  
    DATA: lv_data LIKE sy-datum.
  
    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = sy-datum    "-> 기준일
        days      = '00'        "-> 더하거나 뺄 일자수
        months    = '00'        "-> 더하거나 뺄 월수
        years     = '00'        "-> 더하거나 뺄 년수
        signum    = '+'         "-> 더할지 뺄지를 정하는 기호
      IMPORTING
        calc_date = lv_data. "-> 계산된 날짜 (SY-DATUM)
  
    CONCATENATE lv_data(6)'' INTO gv_yymm.
  
  ENDFORM.
  
  *&---------------------------------------------------------------------*
  *& Form refesh_grid
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_grid .
  
    gs_stable2-row = 'X'.
    gs_stable2-col = 'X'.
  
    CALL METHOD gcl_grid2->refresh_table_display
      EXPORTING
        is_stable      = gs_stable2
        i_soft_refresh = space.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form add_row
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM add_row .
  
    CLEAR   : gs_row, gs_item.
    REFRESH : gt_rows.
  
    CALL METHOD gcl_grid->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    IF gt_rows IS INITIAL.
  
      MESSAGE s005 WITH TEXT-m01 DISPLAY LIKE 'E'.
      EXIT.
  
    ELSE.
  
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_data INTO gs_data INDEX gs_row-index.
        READ TABLE gt_item INTO gs_item WITH KEY matrc = gs_data-matrc.
  
        IF gs_data-matrc <> gs_item-matrc.
          MOVE-CORRESPONDING gs_data TO gs_item.
          APPEND gs_item TO gt_item.
        ELSE.
          MESSAGE s005 WITH TEXT-m02 DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
  
      ENDLOOP.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form delete_row
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM delete_row .
  
    CLEAR gs_row.
    REFRESH gt_rows.
  
    CALL METHOD gcl_grid2->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
    IF gt_rows IS INITIAL.
      MESSAGE s005 WITH TEXT-m01 DISPLAY LIKE 'E'.
      EXIT.
    ELSE.
  
      SORT gt_rows BY index DESCENDING.
  
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_item INTO gs_item INDEX gs_row-index.
        MOVE-CORRESPONDING gs_item TO gs_data_del.
  
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
  
        APPEND gs_data_del TO gt_data_del.
        CLEAR gs_data_del.
  
        DELETE gt_item INDEX gs_row-index.
  
      ENDLOOP.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form create_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM create_data .
  
    IF gt_item IS NOT INITIAL.
  
  
  
      PERFORM create_order_number.
  
      DATA : ls_cheader TYPE ztc2mm2002,
             lt_cheader LIKE TABLE OF ls_cheader,
             lv_cnt     TYPE i,
             ls_citem   TYPE ztc2mm2003,
             lt_citem   LIKE TABLE OF ls_citem,
             lv_input   TYPE i,
             lv_price   TYPE ztc2md2006-mmprice.
  
  
      CALL METHOD gcl_grid2->check_changed_data.
  
      ls_cheader-cmpnc      =  '1004'.
      ls_cheader-plant      =  '1000'.
      ls_cheader-purcplnb   =  gv_purcplnb.
      ls_cheader-plym       =  pa_yymm.
      ls_cheader-plpddt     =  sy-datum. "생성일
  *  gs_header-plmfdt     =  ''. 수정일
  *  gs_header-plcfdt     =  ''. 확정일
      ls_cheader-purctp     = 0.
  *  gs_header-unit       =  유닛필요없음
      ls_cheader-currency   =  'KRW'.
      ls_cheader-resprid    =  sy-uname.
  *  gs_header-modfid     =  "수정자
      ls_cheader-statflag   =  '10'.
  
      APPEND ls_cheader TO lt_cheader.
  *  MOVE-CORRESPONDING gt_header TO lt_cheader.
  
      LOOP AT gt_item INTO gs_item.
  
        ls_citem-cmpnc    = ls_cheader-cmpnc.
        ls_citem-plant    = ls_cheader-plant.
        ls_citem-purcplnb = ls_cheader-purcplnb.
        ls_citem-matrc    = gs_item-matrc.
        ls_citem-purcp    = gs_item-purcp.
  
        CLEAR : lv_price.
  
        SELECT SINGLE mmprice
          INTO lv_price
          FROM ztc2md2006
          WHERE cmpnc = ls_citem-cmpnc
            AND matrc = ls_citem-matrc.
  
        IF sy-subrc = 0.
          ls_cheader-purctp += lv_price * ls_citem-purcp.
        ENDIF.
  
        ls_citem-uint     = gs_item-unit.
        ls_citem-vendorc  = gs_item-vendorc.
  
        APPEND ls_citem TO lt_citem.
      ENDLOOP.
      MOVE-CORRESPONDING lt_citem TO gt_mitem.
  
      REFRESH gt_data_del.
  
      MODIFY ztc2mm2002 FROM ls_cheader.
  
      IF sy-dbcnt <> 0.
        lv_cnt += sy-dbcnt.
      ENDIF.
  
      MODIFY ztc2mm2003 FROM TABLE gt_mitem.
  
      IF sy-dbcnt <> 0.
        lv_cnt += sy-dbcnt.
      ENDIF.
  
      IF  lv_cnt > 0.
        COMMIT WORK AND WAIT.
        MESSAGE s012 WITH ls_cheader-purcplnb.
  
  
      ELSE.
  
        lv_cnt = 0.
        ROLLBACK WORK.
        MESSAGE s005 WITH TEXT-m02 DISPLAY LIKE 'E'.
  
      ENDIF.
  
      REFRESH : gt_item.
  
      lv_input = 0.
  
      CALL METHOD gcl_grid2->set_ready_for_input
        EXPORTING
          i_ready_for_input = lv_input.
  
    ELSE.
      MESSAGE s005 WITH '작성된 계획이 없습니다.'.
  
  
    ENDIF.
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_data2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_data2 .
  
    DATA : ls_data LIKE gs_item,
           lt_data LIKE TABLE OF ls_data.
    DATA : gv_ppquan TYPE i,
           gv_stckq  TYPE i,
           lv_num    LIKE ls_data-versn,
           lv_tabix  TYPE sy-tabix.
  
    CLEAR   : ls_data, gs_item.
    REFRESH : gt_item, lt_data.
  
    SELECT a~matrc e~matrnm c~ppquan a~unit e~warehscd e~saveq f~stckq a~rqqty e~vendorc a~versn
      INTO CORRESPONDING FIELDS OF TABLE lt_data
      FROM ztc2pp2002 AS a
      INNER JOIN ztc2pp2001 AS b
       ON  a~cmpnc = b~cmpnc
       AND a~mkits = b~mkits
       AND a~versn = b~versn
  
      INNER JOIN ztc2pp2005 AS c
      ON a~cmpnc = c~cmpnc
      AND a~mkits = c~mkits
  
      INNER JOIN ztc2pp2004 AS d
      ON c~cmpnc = d~cmpnc
      AND c~ppnum = d~ppnum
  
      LEFT OUTER JOIN ztc2md2006 AS e
      ON a~cmpnc = e~cmpnc
      AND a~matrc = e~matrc
  
      LEFT OUTER JOIN ztc2mm2001 AS f
      ON  a~cmpnc = f~cmpnc
      AND a~matrc = f~matrc
  
     WHERE d~plnym = pa_yymm.
  
    SORT lt_data DESCENDING BY versn.  "최신 버전의 BOM데이터를 가져와야 함
    READ TABLE lt_data INTO ls_data INDEX 1.
    lv_num = ls_data-versn.
  
    LOOP AT lt_data INTO ls_data.
  
      IF ls_data-versn = lv_num.
  *      CLEAR ls_data-versn.
  
        COLLECT ls_data INTO gt_item. "완제품에 들어가는 자재가 겹치기 때문에 collect 구문으로 자재별로 합산한 값이 나오게 함
      ELSE.
        EXIT.
  
      ENDIF.
    ENDLOOP.
  
    LOOP AT gt_item INTO gs_item.
  
      READ TABLE lt_data INTO ls_data WITH KEY matrc = gs_item-matrc.
  
      IF sy-subrc = 0.
  
        gs_item-stckq = ls_data-stckq.
        gs_item-saveq = ls_data-saveq.
        gs_item-rqqty = ls_data-rqqty.
  
      ENDIF.
  
      gs_item-purcp  = ( gs_item-ppquan * gs_item-rqqty * '0.1' ) + gs_item-saveq. "구매추천수량 = ( 생산계획수량 * BOM * 0.1) + 안전재고
      gs_item-purcp  =   gs_item-purcp - gs_item-stckq.
  
      IF gs_item-purcp <= 0 . "구매추천수량을 계산 한 값이 0보다 작으면 0으로 출력
        DELETE gt_item INDEX sy-tabix.
        CONTINUE. "0이 아닌 값들은 불러오지 X -> loop문으로 다시 돌아감
      ENDIF.
  
      MODIFY gt_item FROM gs_item INDEX sy-tabix TRANSPORTING purcp stckq saveq.
  
    ENDLOOP.
  
    DELETE gt_item WHERE purcp = 0.
  
  
  ENDFORM.
  
  FORM create_order_number.
  
    DATA: lv_PURCPLNB TYPE ztc2mm2003-purcplnb.
  
  
    IF gv_numflag IS INITIAL.
      CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          nr_range_nr             = '01'
          object                  = 'ZC202'
        IMPORTING
          number                  = lv_PURCPLNB
        EXCEPTIONS
          interval_not_found      = 1
          number_range_not_intern = 2
          quantity_is_0           = 4
          quantity_is_not_1       = 5
          interval_overflow       = 6
          OTHERS                  = 7.
  
  *    CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
  *      EXPORTING
  *        date_external            = sy-datum
  *      IMPORTING
  *        date_internal            = lv_plym
  *      EXCEPTIONS
  *        date_external_is_invalid = 1
  *        OTHERS                   = 2.
  
      CONCATENATE 'MP' pa_yymm+2(4) lv_PURCPLNB INTO lv_PURCPLNB.
  
      gs_item-purcplnb = lv_PURCPLNB.
      gv_numflag = lv_PURCPLNB.
  
    ELSE.
      gs_item-purcplnb = gv_numflag.
  
  
  
    ENDIF.
  
    gv_PURCPLNB = gs_item-purcplnb.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_data3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_data3 . "0101 Screen header
  
  
    DATA : ls_color TYPE lvc_s_scol,
           lv_tabix TYPE sy-tabix.
  
    SELECT statflag plant purctp currency purcplnb plym resprid plpddt modfid plmfdt plcfdt retnr
     INTO CORRESPONDING FIELDS OF TABLE gt_s2header
      FROM ztc2mm2002
     WHERE plym IN so_yymm
       AND delflag <> 'X'.
  
    LOOP AT gt_s2header INTO gs_s2header.
      lv_tabix = sy-tabix.
  
      CASE gs_s2header-statflag.
        WHEN '10'.
          gs_s2header-status = '승인대기'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '3'.
          ls_color-color-int   = '0'.
          ls_color-color-inv   = '0'.
  
          APPEND ls_color TO gs_s2header-color.
  
        WHEN '11'.
          gs_s2header-status = '승인요청'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '7'.
          ls_color-color-int   = '0'.
          ls_color-color-inv   = '0'.
  
          APPEND ls_color TO gs_s2header-color.
  
        WHEN '12'.
          gs_s2header-status = '승인완료'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '5'.
          ls_color-color-int   = '0'.
          ls_color-color-inv   = '0'.
  
          APPEND ls_color TO gs_s2header-color.
  
        WHEN '16'.
          gs_s2header-status = '승인반려'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '6'.
          ls_color-color-int   = '0'.
          ls_color-color-inv   = '0'.
  
          APPEND ls_color TO gs_s2header-color.
      ENDCASE.
  
      MODIFY gt_s2header FROM gs_s2header INDEX lv_tabix
      TRANSPORTING status color.
  
    ENDLOOP.
  
    SORT gt_s2header BY plym ASCENDING.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_layout_hd
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_layout_hd .
  
    gs_layout_hd-zebra      = 'X'.
    gs_layout_hd-sel_mode   = 'D'.
    gs_layout_hd-cwidth_opt = 'X'.
    gs_layout_hd-no_toolbar = 'X'.
    gs_layout_hd-ctab_fname = 'COLOR'.
  
    PERFORM set_fcat_hd USING :
  
      'x'  'STATUS'   '승인상태'    ''            'STATUS'   6   'C',
      'X'  'PLANT'    ''         'ZTC2MM2002'   'PLANT'    3  'C',
      'X'  'PURCPLNB' ''         'ZTC2MM2002'   'PURCPLNB' 12 'C',
      ' '  'PLYM'     ''         'ZTC2MM2002'   'PLYM'     7  'C',
      ' '  'RESPRID'  ''         'ZTC2MM2002'   'RESPRID'  7  'C',
      ' '  'PLPDDT'   ''         'ZTC2MM2002'   'PLPDDT'   9  'C',
      ' '  'MODFID'   ''         'ZTC2MM2002'   'MODFID'   8  'C',
      ' '  'PLMFDT'   ''         'ZTC2MM2002'   'PLMFDT'   9  'C',
      ' '  'PLCFDT'   '승인요청일'  'ZTC2MM2002'   'PLCFDT'   9  'C',
      ' '  'RETNR'    '반려사유'    'ZTC2MM2002'   'RETNR'   25 'L'.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_hd
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_fcat_hd  USING pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length pv_just.
  
    gs_fcat_hd-key       = pv_key.
    gs_fcat_hd-fieldname = pv_field.
    gs_fcat_hd-coltext   = pv_text.
    gs_fcat_hd-ref_table = pv_ref_table.
    gs_fcat_hd-ref_field = pv_ref_field.
    gs_fcat_hd-outputlen = pv_length.
    gs_fcat_hd-just      = pv_just.
  
    CASE pv_field.
      WHEN 'PURCTP'.
        gs_fcat_hd-cfieldname = 'CURRENCY'.
    ENDCASE.
  
    APPEND gs_fcat_hd TO gt_fcat_hd.
    CLEAR gs_fcat_hd.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_screen_hd
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_screen_hd .
  
    IF gcl_container_hd IS NOT BOUND.
  
      CREATE OBJECT gcl_container_hd
        EXPORTING
          container_name = 'GCL_CONTAINER_HD'.
  
      CREATE OBJECT gcl_grid_hd
        EXPORTING
          i_parent = gcl_container_hd.
  
      CREATE OBJECT gcl_handler.
      SET HANDLER : gcl_handler->handle_double_click FOR gcl_grid_hd.
  
      CLEAR gs_layout_hd-cwidth_opt.
  
      CALL METHOD gcl_grid_hd->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant_hd
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout_hd
        CHANGING
          it_outtab       = gt_s2header
          it_fieldcatalog = gt_fcat_hd.
  
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
  FORM handle_double_click  USING    ps_row     TYPE lvc_s_row
                                     ps_column  TYPE lvc_s_col.
  
    DATA : lv_input TYPE i.
  
    READ TABLE gt_s2header INTO gs_s2header INDEX ps_row-index.
  
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  
    CASE gs_s2header-statflag.
      WHEN '10' OR '13' OR '16'.
        lv_input = 1.
  
      WHEN '11' OR '12'.
        lv_input = 0.
  
    ENDCASE.
  
    CALL METHOD gcl_grid_ed->set_ready_for_input
      EXPORTING
        i_ready_for_input = lv_input.
  
    CASE ps_column-fieldname.
      WHEN 'PURCPLNB'.
        PERFORM get_edit_data  USING gs_s2header-purcplnb.
    ENDCASE.
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_edit_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_edit_data USING pv_purcplnb TYPE ztc2mm2003-purcplnb.
  
  
    CLEAR : gs_pitem.
    REFRESH : gt_pitem.
  
    SELECT a~cmpnc a~plant a~purcplnb a~matrc b~matrnm a~purcp a~uint b~warehscd a~vendorc
      INTO CORRESPONDING FIELDS OF TABLE gt_pitem
      FROM ztc2mm2003 AS a
      INNER JOIN ztc2md2006 AS b
      ON a~matrc = b~matrc
      WHERE a~purcplnb = pv_purcplnb.
  
    IF sy-subrc <> 0.
      MESSAGE s005 WITH TEXT-m00 DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
  
    PERFORM refresh_grid_ed.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh_grid_ed
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_grid_ed .
  
    gs_stable_ed-row = 'X'.
    gs_stable_ed-col = 'X'.
  
    CALL METHOD gcl_grid_ed->refresh_table_display
      EXPORTING
        is_stable      = gs_stable_ed
        i_soft_refresh = space.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_layout_ed
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_layout_ed .
  
    gs_layout_ed-zebra      = 'X'.
    gs_layout_ed-sel_mode   = 'D'.
  *  gs_layout_ed-cwidth_opt = 'X'.
    gs_layout_ed-no_toolbar = 'X'.
  
    PERFORM set_fcat_ed USING :
  
      'X'  'MATRC'    ''  'ZTC2MM2003'   'MATRC' 7,
      ' '  'MATRNM'   ''  'ZTC2MD2006'   'MATRNM' 10,
      ' '  'PURCP'    ''  'ZTC2MM2003'   'PURCP' 8,
      ' '  'UINT'     ''  'ZTC2MM2003'   'UINT' 4,
      ' '  'WAREHSCD' ''  'ZTC2MM2006'   'WAREHSCD' 5.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_ed
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_fcat_ed  USING  pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length.
  
    gs_fcat_ed-key       = pv_key.
    gs_fcat_ed-fieldname = pv_field.
    gs_fcat_ed-coltext   = pv_text.
    gs_fcat_ed-ref_table = pv_ref_table.
    gs_fcat_ed-ref_field = pv_ref_field.
    gs_fcat_ed-outputlen = pv_length.
  
    CASE pv_field.
      WHEN 'PURCP'.
        gs_fcat_ed-qfieldname = 'UINT'.
        gs_fcat_ed-edit       = 'X'.
    ENDCASE.
  
    APPEND gs_fcat_ed TO gt_fcat_ed.
    CLEAR gs_fcat_ed.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Module DISPLAY_SCREEN_ED OUTPUT
  *&---------------------------------------------------------------------*
  *&
  *&---------------------------------------------------------------------*
  MODULE display_screen_ed OUTPUT.
  
    IF gcl_container_ed IS NOT BOUND.
  
      CREATE OBJECT gcl_container_ed
        EXPORTING
          container_name = 'GCL_CONTAINER_ED'.
  
      CREATE OBJECT gcl_grid_ed
        EXPORTING
          i_parent = gcl_container_ed.
  
  *      CREATE OBJECT gcl_handler.
  *      SET HANDLER : gcl_handler->handle_double_click FOR gcl_grid_ed.
  
      CLEAR gs_layout_ed-cwidth_opt.
  
      CALL METHOD gcl_grid_ed->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant_ed
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout_ed
        CHANGING
          it_outtab       = gt_pitem
          it_fieldcatalog = gt_fcat_ed.
  
    ENDIF.
  
  ENDMODULE.
  *&---------------------------------------------------------------------*
  *& Form ADD_ROW2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM add_row2 .
  
    CLEAR   : gs_row, gs_item.
    REFRESH : gt_rows.
  
    CASE gs_s2header-statflag.
      WHEN '11' OR '12'.
        MESSAGE s005 WITH TEXT-m06 DISPLAY LIKE 'E'.
        EXIT.
    ENDCASE.
  
    CALL METHOD gcl_grid->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    IF gt_rows IS INITIAL.
      MESSAGE s005 WITH TEXT-m01 DISPLAY LIKE 'E'.
      EXIT.
  
    ELSE.
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_data INTO gs_data INDEX gs_row-index.
        READ TABLE gt_Pitem INTO gs_Pitem WITH KEY matrc = gs_data-matrc.
        IF gs_data-matrc <> gs_Pitem-matrc.
          MOVE-CORRESPONDING gs_data TO gs_Pitem.
          APPEND gs_Pitem TO gt_Pitem.
        ELSE.
          MESSAGE s005 WITH TEXT-m02 DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form delete_row2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM delete_row2 .
  
    CLEAR gs_row.
    REFRESH gt_rows.
  
  
    CASE gs_s2header-statflag.
      WHEN '11' OR '12'.
        MESSAGE s005 WITH TEXT-m06 DISPLAY LIKE 'E'.
        EXIT.
    ENDCASE.
  
    CALL METHOD gcl_grid_ed->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
    IF gt_rows IS INITIAL.
      MESSAGE s005 WITH TEXT-m01 DISPLAY LIKE 'E'.
      EXIT.
    ELSE.
  
      SORT gt_rows BY index DESCENDING.
  
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_pitem INTO gs_pitem INDEX gs_row-index.
        MOVE-CORRESPONDING gs_pitem TO gs_data_del.
  
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
  
        APPEND gs_data_del TO gt_data_del.
        CLEAR gs_data_del.
  
        DELETE gt_pitem INDEX gs_row-index.
  
      ENDLOOP.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form allow_plan
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM allow_plan .
  
    DATA : lv_tabix  TYPE sy-tabix,
           ls_color  TYPE lvc_s_scol,
           lv_answer TYPE c LENGTH 1,
           ls_data   TYPE ztc2mm2002,
           lt_data   LIKE TABLE OF ls_data,
           lv_domain TYPE dcobjdef-name,
           lv_value  TYPE dd07v-domvalue_l,
           lv_text   TYPE dd07v-ddtext,
           lv_date   TYPE sy-datum,
           lv_input  TYPE i.
  
    lv_domain = 'ZDC2MM_STATFLAG'.
    lv_date = sy-datum.
  
    CLEAR : gs_row, ls_color.
    REFRESH : gt_rows.
  
    CALL METHOD gcl_grid_hd->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    IF gt_rows IS INITIAL.
      MESSAGE s005 WITH TEXT-m01 DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
  
    LOOP AT gt_rows INTO gs_row.
      READ TABLE gt_s2header INTO gs_s2header INDEX gs_row-index.
  
      CASE gs_s2header-statflag.
        WHEN '11'.
          MESSAGE e005 WITH TEXT-m07.
        WHEN '12.'.
          MESSAGE e005 WITH TEXT-m08.
      ENDCASE.
    ENDLOOP.
  
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '승인요청'
        text_question         = '승인요청을 진행하시겠습니까?'
        text_button_1         = 'Yes'
        icon_button_1         = 'ICON_SYSTEM_OKAY'
        text_button_2         = 'No'
        icon_button_2         = 'ICON_SYSTEM_CANCEL'
        display_cancel_button = ''
      IMPORTING
        answer                = lv_answer
      EXCEPTIONS
        text_not_found        = 1
        OTHERS                = 2.
  
    IF lv_answer = 1.
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_s2header INTO gs_s2header INDEX gs_row-index.
  
        CASE gs_s2header-statflag.
          WHEN '10'.
            gs_s2header-statflag = '11'.
            gs_s2header-plcfdt = lv_date.
          WHEN '16'.
            gs_s2header-statflag = '11'.
            gs_s2header-plcfdt = lv_date.
        ENDCASE.
  
        MODIFY gt_s2header FROM gs_s2header INDEX gs_row-index
        TRANSPORTING statflag plcfdt.
  
        MOVE-CORRESPONDING gs_s2header TO ls_data.
        ls_data-plant = '1000'.
        ls_data-cmpnc = '1004'.
        APPEND ls_data TO lt_data.
  
      ENDLOOP.
  
      LOOP AT gt_s2header INTO gs_s2header.
        lv_tabix = sy-tabix.
  
        CASE gs_s2header-statflag.
          WHEN '10'.
            gs_s2header-status = '승인대기'.
            ls_color-fname       = 'STATUS'.
            ls_color-color-col   = '3'.
            ls_color-color-int   = '0'.
            ls_color-color-inv   = '0'.
  
            APPEND ls_color TO gs_s2header-color.
  
          WHEN '11'.
            gs_s2header-status = '승인요청'.
            ls_color-fname       = 'STATUS'.
            ls_color-color-col   = '7'.
            ls_color-color-int   = '0'.
            ls_color-color-inv   = '0'.
  
            APPEND ls_color TO gs_s2header-color.
  
          WHEN '12'.
            gs_s2header-status = '승인완료'.
            ls_color-fname       = 'STATUS'.
            ls_color-color-col   = '5'.
            ls_color-color-int   = '0'.
            ls_color-color-inv   = '0'.
  
            APPEND ls_color TO gs_s2header-color.
  
          WHEN '13'.
            gs_s2header-status = '승인반려'.
            ls_color-fname       = 'STATUS'.
            ls_color-color-col   = '6'.
            ls_color-color-int   = '0'.
            ls_color-color-inv   = '0'.
  
            APPEND ls_color TO gs_s2header-color.
        ENDCASE.
  
        MODIFY gt_s2header FROM gs_s2header INDEX lv_tabix
        TRANSPORTING status color.
  
        CLEAR gs_s2header-color.
  
        CASE gs_s2header-statflag.
          WHEN '10'.
            ls_color-color-col = '3'.
            APPEND ls_color TO gs_s2header-color.
            MODIFY gt_s2header FROM gs_s2header INDEX lv_tabix TRANSPORTING color.
          WHEN '11'.
            ls_color-color-col = '7'.
            APPEND ls_color TO gs_s2header-color.
            MODIFY gt_s2header FROM gs_s2header INDEX lv_tabix TRANSPORTING color.
          WHEN '12'.
            ls_color-color-col = '5'.
            APPEND ls_color TO gs_s2header-color.
            MODIFY gt_s2header FROM gs_s2header INDEX lv_tabix TRANSPORTING color.
          WHEN '13'.
            ls_color-color-col = '6'.
            APPEND ls_color TO gs_s2header-color.
            MODIFY gt_s2header FROM gs_s2header INDEX lv_tabix TRANSPORTING color.
        ENDCASE.
  
      ENDLOOP.
  
      MODIFY ztc2mm2002 FROM TABLE lt_data.
  
      IF sy-dbcnt > 0.
        COMMIT WORK AND WAIT.
        MESSAGE s005 WITH '승인이 요청되었습니다.'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE s003 DISPLAY LIKE 'E'.
      ENDIF.
  
    ELSE.
      MESSAGE s005 WITH '취소되었습니다.'.
    ENDIF.
  
    lv_input = 0.
  
    CALL METHOD gcl_grid_ed->set_ready_for_input
      EXPORTING
        i_ready_for_input = lv_input.
  
    PERFORM refresh_grid_ed.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh_grid_hd
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_grid_hd .
  
    gs_stable_hd-row = 'X'.
    gs_stable_hd-col = 'X'.
  
    CALL METHOD gcl_grid_hd->refresh_table_display
      EXPORTING
        is_stable      = gs_stable_hd
        i_soft_refresh = space.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form save_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM save_data .
  
    DATA : ls_save     TYPE ztc2mm2003,
           lt_save     LIKE TABLE OF ls_save,
           ls_read     TYPE ztc2mm2003,
           lv_tabix    TYPE sy-tabix,
           ls_header   TYPE ztc2mm2002,
           lt_header   LIKE TABLE OF ls_header,
           lv_udate    TYPE sy-datum,
           lv_user     TYPE sy-uname,
           lv_purcplnb TYPE ztc2mm2003-purcplnb,
           lv_price    TYPE ztc2md2006-mmprice.
  
    lv_udate = sy-datum.
    lv_user  = sy-uname.
  
    IF gt_pitem IS INITIAL.
      MESSAGE s005 WITH '저장할 데이터가 없습니다.' DISPLAY LIKE 'E'.
    ENDIF.
  
    CALL METHOD gcl_grid_ed->check_changed_data.
  
    READ TABLE gt_pitem INTO gs_pitem INDEX 1.
  
    lv_PURCPLNB = gs_pitem-purcplnb.
  
    LOOP AT gt_pitem INTO gs_pitem.
      lv_tabix = sy-tabix.
      MOVE-CORRESPONDING gs_pitem TO ls_save.
      ls_save-plant    = '1000'.
      ls_save-cmpnc    = '1004'.
      ls_save-uint     = gs_pitem-uint.
      ls_save-purcplnb = lv_purcplnb.
      APPEND ls_save TO lt_save.
    ENDLOOP.
  
    MODIFY ztc2mm2003 FROM TABLE lt_save.
  
    LOOP AT gt_s2header INTO gs_s2header.
  
      IF ls_save-purcplnb = gs_s2header-purcplnb.
        gs_s2header-plmfdt = lv_udate.
        gs_s2header-modfid = lv_user.
  
        CASE gs_s2header-statflag.
          WHEN '11'.
            MESSAGE s005 WITH '수정이 불가능한 상태입니다.' DISPLAY LIKE 'E'.
          WHEN '12'.
            MESSAGE s005 WITH '수정이 불가능한 상태입니다.' DISPLAY LIKE 'E'.
        ENDCASE.
      ENDIF.
  
      MOVE-CORRESPONDING gs_s2header TO ls_header.
      ls_header-cmpnc    = '1004'.
      ls_header-plant    = '1000'.
      ls_header-currency = 'KRW'.
      ls_header-plmfdt   = lv_udate.
      ls_header-modfid   = lv_user.
      ls_header-purctp   = 0.
  
      APPEND ls_header TO lt_header.
  ***********
      LOOP AT gt_s2header INTO gs_s2header.
  
        CLEAR : lv_price.
  
        SELECT SINGLE mmprice
          INTO lv_price
          FROM ztc2md2006
          WHERE cmpnc = ls_save-cmpnc
            AND matrc = ls_save-matrc.
  
        IF sy-subrc = 0.
          ls_header-purctp += lv_price * ls_save-purcp.
        ENDIF.
  
        APPEND ls_header TO lt_header.
      ENDLOOP.
  *********
      MODIFY ztc2mm2002 FROM TABLE lt_header.
  
      IF sy-dbcnt > 0.
        COMMIT WORK AND WAIT.
        MESSAGE s000.
      ENDIF.
  
      PERFORM get_data3.
  
    ENDLOOP.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form erase_order
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM erase_order .
  
    DATA : lv_tabix  TYPE sy-tabix,
           lv_answer TYPE c LENGTH 1.
  
    CLEAR   gs_row.
    REFRESH gt_rows.
  
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '계획삭제'
        text_question         = '계획을 삭제하시겠습니까?'
        text_button_1         = 'Yes'
        icon_button_1         = 'ICON_STSTEM_OKAY'
        text_button_2         = 'No'
        icon_button_2         = 'ICON_SYSTEM_CANCLE'
        display_cancel_button = ''
      IMPORTING
        answer                = lv_answer
      EXCEPTIONS
        text_not_found        = 1
        OTHERS                = 2.
  
    IF lv_answer = 1.
  
      CALL METHOD gcl_grid_hd->get_selected_rows
        IMPORTING
          et_index_rows = gt_rows.
  
      IF gt_rows IS INITIAL.
        MESSAGE s000 WITH TEXT-m01 DISPLAY LIKE 'E'.
        LEAVE LIST-PROCESSING.
      ENDIF.
      SORT gt_rows BY index DESCENDING.
  
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_s2header INTO gs_s2header INDEX gs_row-index.
        MOVE-CORRESPONDING gs_s2header TO gs_data_del2.
  
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
  
        gs_data_del2-cmpnc = '1004'.
        gs_data_del2-delflag = 'X'.
  
        APPEND gs_data_del2 TO gt_data_del2.
  
        LOOP AT gt_pitem INTO gs_pitem.
          lv_tabix = sy-tabix.
  
          gs_pitem-delflag = 'X'.
          MODIFY gt_pitem FROM gs_pitem INDEX lv_tabix TRANSPORTING delflag.
  
          MOVE-CORRESPONDING gs_pitem TO gs_data_del3.
          APPEND gs_data_del3 TO gt_data_del3.
        ENDLOOP.
  
      ENDLOOP.
  
      CLEAR gt_pitem.
  
      MODIFY ztc2mm2002 FROM TABLE gt_data_del2.
      MODIFY ztc2mm2003 FROM TABLE gt_data_del3.
  
      IF sy-dbcnt > 0.
        COMMIT WORK AND WAIT.
        MESSAGE s000 WITH '승인이 요청되었습니다.'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE s005 WITH 'Data not saved'  DISPLAY LIKE 'E'.
      ENDIF.
  
    ELSE.
      MESSAGE s005 WITH '취소되었습니다'.
    ENDIF.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_grid_Ed
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*