*&---------------------------------------------------------------------*
*& Include          SAPMZC2SD2002_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

    DATA : lv_tabix TYPE sy-tabix,
           ls_color TYPE lvc_s_scol,
           ls_data  TYPE ztc2sd2006,
           lt_data  LIKE TABLE OF ls_data,
           ls_save  TYPE ztc2sd2008,
           lt_save  LIKE TABLE OF ls_save.
  
    DATA : a TYPE i VALUE '0'.
  
    CLEAR   : gs_data, gs_data_2.
    REFRESH : gt_data, gt_data_2.
  
    RANGES: lr_vendorc FOR ztc2sd2008-vendorc,
            lr_saleym  FOR ztc2sd2008-saleym.
  
    IF gs_search-vendorc IS NOT INITIAL.             " single select 조건
      lr_vendorc-sign   = 'I'.
      lr_vendorc-option = 'EQ'.
      lr_vendorc-low    = gs_search-vendorc.
      APPEND lr_vendorc.
   ENDIF.
  
    IF gs_search-saleym IS NOT INITIAL.              " single select 조건
      lr_saleym-sign   = 'I'.
      lr_saleym-option = 'EQ'.
      lr_saleym-low    = gs_search-saleym.
      APPEND lr_saleym.
    ENDIF.
  
    SELECT *
        INTO CORRESPONDING FIELDS OF TABLE gt_data
        FROM ztc2sd2008
          WHERE vendorc IN lr_vendorc
            AND saleym  IN lr_saleym.
  
  
    SELECT vendorc saleym ttamount
      INTO CORRESPONDING FIELDS OF ls_data
      FROM ztc2sd2006
      WHERE vendorc IN lr_vendorc
        AND saleym  IN lr_saleym.
      COLLECT ls_data INTO lt_data.
    ENDSELECT.
  
  
  
    IF gt_data IS INITIAL.
      PERFORM create_saleym.                         " 마감테이블 데이터 생성
    ENDIF.
  
    SORT gt_data BY vendorc saleym ASCENDING.
    SORT lt_data BY vendorc saleym ASCENDING.
  
  
    LOOP AT gt_data INTO gs_data.
      lv_tabix = sy-tabix.
  
      CASE gs_data-statflag.                         " column 색상 변경
        WHEN 'A'.
          gs_data-statflag = '확정대기'.
          ls_color-fname = 'STATFLAG'.
          ls_color-color-col = '2'.
          ls_color-color-int = '0'.
          ls_color-color-inv = '0'.
          APPEND ls_color TO gs_data-color.
  
        WHEN 'B'.
          gs_data-statflag = '매출확정'.
          ls_color-fname = 'STATFLAG'.
          ls_color-color-col = '5'.
          ls_color-color-int = '0'.
          ls_color-color-inv = '0'.
          APPEND ls_color TO gs_data-color.
  
      ENDCASE.
  
     LOOP AT lt_data INTO ls_data.
        IF gs_data-vendorc = ls_data-vendorc AND gs_data-saleym = ls_data-saleym.
          gs_data-saletp   = ls_data-ttamount.
  *        gs_data-statflag = ls_data-statflag.
        ENDIF.
     ENDLOOP.
  
      MODIFY gt_data FROM gs_data INDEX lv_tabix
      TRANSPORTING statflag saletp color.
  
  
    ENDLOOP.
     MOVE-CORRESPONDING gt_data TO lt_save.
  
     LOOP AT lt_save INTO ls_save.
       CASE ls_save-statflag.
           WHEN '확정대기'.
          ls_save-statflag = 'A'.
           WHEN '매출확정'.
          ls_save-statflag = 'B'.
       ENDCASE.
       MODIFY lt_save FROM ls_save.
     ENDLOOP.
  MODIFY ztc2sd2008 FROM TABLE lt_save.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_layout
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_layout .
    gs_layout-zebra      = 'X'.
    gs_layout-sel_mode   = 'D'.
  *  gs_layout-cwidth_opt = 'X'.
    gs_layout-no_toolbar = 'X'.
    gs_layout-ctab_fname = 'COLOR'.
  
  
  PERFORM set_fcat USING:
        ''    'STATFLAG ' '상태'   'ZTC2SD2008'   ''         8  'C'  '',
        ''    'SALEYM '   ''      'ZTC2SD2008'   'SALEYM '  6  'C'  '',
        ''    'VENDORC'   ''      'ZTC2SD2008'   'VENDORC'  8  'C'  '',
        ''    'SALETP '   ''      'ZTC2SD2008'   'SALETP '  12 'C'  'X',
        ''    'WAERS  '   ''      'ZTC2SD2008'   'WAERS  '  7  'C'  '',
        ''    'RESPRID'   ''      'ZTC2SD2008'   'RESPRID'  8  'C'  '',
        ''    'SALEFDT'   ''      'ZTC2SD2008'   'SALEFDT'  9  'C'  ''.
  PERFORM set_fcat_sort USING:
        '1' 'SALEYM' 'X' 'X'.
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
  FORM set_fcat  USING pv_key
                       pv_field
                       pv_text
                       pv_ref_table
                       pv_ref_field
                       pv_length
                       pv_just
                       pv_sum.
  
    gs_fcat-key       = pv_key.
    gs_fcat-fieldname = pv_field.
    gs_fcat-coltext   = pv_text.
    gs_fcat-ref_table = pv_ref_table.
    gs_fcat-ref_field = pv_ref_field.
    gs_fcat-outputlen = pv_length.
    gs_fcat-just      = pv_just.
    gs_fcat-do_sum    = pv_sum.
  
    CASE pv_field.
      WHEN 'SALETP'.
        gs_fcat-cfieldname = 'WAERS'.
        gs_fcat-hotspot = 'X'.
      WHEN OTHERS.
        gs_fcat-hotspot = ''.
    ENDCASE.
  
    APPEND gs_fcat TO gt_fcat.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_layout2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_layout2 .
    gs_layout_2-zebra      = 'X'.
    gs_layout_2-sel_mode   = 'D'.
  *  gs_layout_2-cwidth_opt = 'X'.
    gs_layout_2-no_toolbar = 'X'.
    gs_layout_2-ctab_fname = 'COLOR'.
  
  PERFORM set_fcat_2 USING:
        'X'   'STATFLAG'    '상태'      'ZTC2SD2006'   ''            8  'C'  '',
        ''    'ORDERCD'     '주문번호'   'ZTC2SD2006'   ''            10  'C'  '',
        ''    'ORDERDATE'   ''         'ZTC2SD2006'   'ORDERDATE'   10  'C'  '',
        ''    'OUTSTOREDT'  ''         'ZTC2SD2006'   'OUTSTOREDT'  8  'C'  '',
        ''    'TTAMOUNT'    '총 금액'    'ZTC2SD2006'   ''            11  'C'  'X',
        ''    'WAERS'       '화폐 단위'   'ZTC2SD2006'   ''            7  'C'  ''.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_fcat_2  USING  pv_key
                          pv_field
                          pv_text
                          pv_ref_table
                          pv_ref_field
                          pv_length
                          pv_just
                          pv_sum.
  
    gs_fcat_2-key       = pv_key.
    gs_fcat_2-fieldname = pv_field.
    gs_fcat_2-coltext   = pv_text.
    gs_fcat_2-ref_table = pv_ref_table.
    gs_fcat_2-ref_field = pv_ref_field.
    gs_fcat_2-outputlen = pv_length.
    gs_fcat_2-just      = pv_just.
    gs_fcat_2-do_sum    = pv_sum.
  
      CASE pv_field.
      WHEN 'ORDERCD'.
        gs_fcat_2-hotspot = 'X'.
      WHEN 'TTAMOUNT'.
        gs_fcat_2-cfieldname = 'WAERS'.
      WHEN OTHERS.
        gs_fcat_2-hotspot = ''.
    ENDCASE.
  
    APPEND gs_fcat_2 TO gt_fcat_2.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form hotspot_click
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> E_ROW_ID
  *&      --> E_COLUMN_ID
  *&---------------------------------------------------------------------*
  FORM hotspot_click  USING    ps_row_id    TYPE lvc_s_row
                               ps_column_id TYPE lvc_s_col.
  
    READ TABLE gt_data INTO gs_data INDEX ps_row_id-index.
  
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  
    PERFORM get_data_2 USING gs_data-saleym gs_data-vendorc .
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_data_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GS_DATA_2
  *&---------------------------------------------------------------------*
  FORM get_data_2  USING pv_saleym pv_vendorc .
  
    CLEAR gs_data_2.
    REFRESH gt_data_2.
  
    DATA : lv_tabix_2 TYPE sy-tabix,
           ls_color_2 TYPE lvc_s_scol.
  
    DATA : ls_data TYPE ztc2sd2006,
           lt_data LIKE TABLE OF ls_data.
  
  
    SELECT *
      FROM ztc2sd2006
      INTO CORRESPONDING FIELDS OF TABLE gt_data_2
       WHERE saleym = pv_saleym
        AND vendorc = pv_vendorc
        AND ( statflag = 'F' or statflag = 'H' ).
  
    IF gt_data_2 IS INITIAL.
      EXIT.
    ENDIF.
  
    SORT gt_data_2 BY ordercd saleym ASCENDING.
  
    LOOP AT gt_data_2 INTO gs_data_2.
  
      lv_tabix_2 = sy-tabix.
  
      CASE gs_data_2-statflag.
  
  *      WHEN 'D'.
  *        gs_data_2-statflag = '주문접수'.
  *        ls_color_2-fname = 'STATFLAG'.
  *        ls_color_2-color-col = '2'.
  *        ls_color_2-color-int = '0'.
  *        ls_color_2-color-inv = '0'.
  *        APPEND ls_color_2 TO gs_data_2-color.
  *      WHEN 'E'.
  *        gs_data_2-statflag = '주문확정'.
  *        ls_color_2-fname = 'STATFLAG'.
  *        ls_color_2-color-col = '5'.
  *        ls_color_2-color-int = '0'.
  *        ls_color_2-color-inv = '0'.
  *        APPEND ls_color_2 TO gs_data_2-color.
        WHEN 'F'.
          gs_data_2-statflag = '배송완료'.
          ls_color_2-fname = 'STATFLAG'.
          ls_color_2-color-col = '1'.
          ls_color_2-color-int = '0'.
          ls_color_2-color-inv = '0'.
          APPEND ls_color_2 TO gs_data_2-color.
        WHEN 'H'.
          gs_data_2-statflag = '전표생성'.
          ls_color_2-fname = 'STATFLAG'.
          ls_color_2-color-col = '1'.
          ls_color_2-color-int = '0'.
          ls_color_2-color-inv = '0'.
          APPEND ls_color_2 TO gs_data_2-color.
      ENDCASE.
  
      MODIFY gt_data_2 FROM gs_data_2 INDEX lv_tabix_2
      TRANSPORTING statflag color.
  
    ENDLOOP.
  
    PERFORM refresh_grid_2.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh_grid
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_grid .
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.
  
    CALL METHOD gcl_grid->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = space.
  
  ENDFORM.
  
  FORM refresh_grid_2 .
    gs_stable_2-row = 'X'.
    gs_stable_2-col = 'X'.
  
    CALL METHOD gcl_grid_2->refresh_table_display
      EXPORTING
        is_stable      = gs_stable_2
        i_soft_refresh = space.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form hotspot_click_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> E_ROW_ID
  *&      --> E_COLUMN_ID
  *&---------------------------------------------------------------------*
  FORM hotspot_click_2  USING    pv_row_id_2   TYPE lvc_s_row
                                 pv_column_id_2 TYPE lvc_s_col.
  
     READ TABLE gt_data_2 INTO gs_data_2 INDEX pv_row_id_2-index.
  
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  
    PERFORM get_data_3 USING gs_data_2-ordercd.
    CALL SCREEN '0101' STARTING AT 10 3.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_data_3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GS_DATA_SALEYM
  *&      --> GS_DATA_VENDORC
  *&---------------------------------------------------------------------*
  FORM get_data_3  USING pv_data_ordercd.
  
    CLEAR   gs_data_3.
    REFRESH gt_data_3.
  
  
    SELECT a~ordercd a~prodcd b~matrnm a~itemqty a~boxunit a~itemprice a~waers
      INTO CORRESPONDING FIELDS OF TABLE gt_data_3
      FROM ztc2sd2007 AS a
      INNER JOIN ztc2md2006 AS b
      ON b~matrc = a~prodcd
      WHERE a~ordercd = pv_data_ordercd.
  
    IF sy-subrc <> 0.
      MESSAGE s000 WITH TEXT-m02 DISPLAY LIKE 'E'.
  *    EXIT.
    ENDIF.
  
  
  * CALL SCREEN '0101'  STARTING AT 20 3 .
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh_grid_3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_grid_pop .
  
    gs_stable_pop-row = 'X'.
    gs_stable_pop-col = 'X'.
  
    CALL METHOD gcl_grid_pop->refresh_table_display
      EXPORTING
        is_stable      = gs_stable_pop
        i_soft_refresh = space.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_layout_pop
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_layout_pop .
    gs_layout_pop-zebra      = 'X'.
    gs_layout_pop-sel_mode   = 'D'.
    gs_layout_pop-cwidth_opt = 'X'.
    gs_layout_pop-no_toolbar = 'X'.
  
    PERFORM set_fcat_pop USING :
          'X'  'ORDERCD'   ' '  'ZTC2SD2007'  'ORDERCD'  ,
          ' '  'PRODCD'    ' '  'ZTC2SD2007'  'PRODCD'   ,
          ' '  'MATRNM'    ' '  'ZTC2MD2006'  'MATRNM'   ,
          ' '  'ITEMQTY'   ' '  'ZTC2SD2007'  'ITEMQTY'  ,
          ' '  'BOXUNIT'   ' '  'ZTC2SD2007'  'BOXUNIT'  ,
          ' '  'ITEMPRICE' ' '  'ZTC2SD2007'  'ITEMPRICE',
          ' '  'WAERS'     ' '  'ZTC2SD2007'  'WAERS'    .
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_pop
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_fcat_pop  USING pv_key
                           pv_field
                           pv_text
                           pv_ref_table
                           pv_ref_field.
  
    gs_fcat_pop-key       = pv_key.
    gs_fcat_pop-fieldname = pv_field.
    gs_fcat_pop-coltext   = pv_text.
    gs_fcat_pop-ref_table = pv_ref_table.
    gs_fcat_pop-ref_field = pv_ref_field.
  
    CASE pv_field.
      WHEN 'ITEMPRICE'.
        gs_fcat_pop-cfieldname = 'WAERS'.
        gs_fcat_pop-decimals_o = 0.
  *  	WHEN
    ENDCASE.
  
    APPEND gs_fcat_pop TO gt_fcat_pop.
    CLEAR  gs_fcat_pop.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_pop
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_pop .
  
    IF gcl_container_pop IS NOT BOUND.
  
      CREATE OBJECT gcl_container_pop
        EXPORTING
          container_name   = 'GCL_CONTAINER_POP'.
  
      CREATE OBJECT gcl_grid_pop
        EXPORTING
          i_parent         = gcl_container_pop.
  
      CALL METHOD gcl_grid_pop->set_table_for_first_display
        EXPORTING
          i_save           = 'A'
          i_default        = 'X'
          is_layout        = gs_layout_pop
  
        CHANGING
          it_outtab        = gt_data_3
          it_fieldcatalog  = gt_fcat_pop.
  
    ENDIF.
  
      PERFORM refresh_grid_pop.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_data_2_clear
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_data_2_clear .
  
    CLEAR   : gs_data_2.
    REFRESH : gt_data_2.
    PERFORM refresh_grid_2.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form confirm_sale_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM confirm_sale_data .
  
  DATA : lv_tabix TYPE sy-tabix,
         ls_color TYPE lvc_s_scol.
  
  DATA : ls_data TYPE ztc2sd2008,
         lt_data LIKE TABLE OF ls_data.
  
  DATA : lv_answer TYPE c LENGTH 1.
  
  CLEAR  : gs_row, ls_color, ls_data.
  REFRESH: gt_rows, lt_data.
  
  CALL METHOD gcl_grid->get_selected_rows
    IMPORTING
      et_index_rows = gt_rows.
  
  CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '매출확정'
        text_question         = '매출을 확정하시겠습니까?'
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
     SELECT *
      INTO CORRESPONDING FIELDS OF TABLE lt_data
      FROM ztc2sd2008.
  
      IF gt_rows IS INITIAL.
        MESSAGE s000 WITH TEXT-m01 DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.
      SORT gt_rows BY index DESCENDING.
  
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_data INTO gs_data INDEX gs_row-index.
  
        lv_tabix = sy-tabix.
  
        CASE gs_data-statflag.
          WHEN '확정대기'.
            gs_data-statflag   = '매출확정'.
            gs_data-resprid    = sy-uname.
            gs_data-salefdt    = sy-datum.
            ls_color-fname     = 'STATFLAG'.
            ls_color-color-col = '5'.
            ls_color-color-int = '0'.
            ls_color-color-inv = '0'.
            CLEAR gs_data-color.
            APPEND ls_color TO gs_data-color.
  
  *          READ TABLE lt_data INTO ls_data index gs_row-index.
  *          ls_data-resprid    = sy-uname.
  *        WHEN OTHERS.
  *          MESSAGE s000 WITH TEXT-m01 DISPLAY LIKE 'E'.
  *          EXIT.
        ENDCASE.
  
        MODIFY gt_data FROM gs_data INDEX lv_tabix
        TRANSPORTING statflag color resprid salefdt.
  
       ENDLOOP.
  
  
      LOOP AT lt_data INTO ls_data.
       READ TABLE gt_data INTO gs_data
            WITH KEY vendorc = ls_data-vendorc saleym = ls_data-saleym.
  
        IF sy-subrc = 0.
          IF gs_data-statflag ='확정대기'.
            ls_data-statflag = 'A'.
  
          ELSEIF gs_data-statflag ='매출확정'.
            ls_data-statflag = 'B'.
            ls_data-resprid  = gs_data-resprid.
            ls_data-salefdt  = gs_data-salefdt.
          ENDIF.
          MODIFY lt_data FROM ls_data TRANSPORTING statflag resprid salefdt.
        ENDIF.
      ENDLOOP.
  
      CALL METHOD gcl_grid->check_changed_data.
  
  *    MOVE-CORRESPONDING gt_data TO ls_save.
  
      MODIFY ztc2sd2008 FROM TABLE lt_data.
      PERFORM get_data.
  
      IF sy-dbcnt > 0.
        COMMIT WORK AND WAIT.
        MESSAGE s000 WITH '매출이 확정되었습니다.'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE s003 DISPLAY LIKE 'E'.
      ENDIF.
  
      ELSE.
        MESSAGE s000 DISPLAY LIKE 'W' WITH '취소되었습니다'.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form create_saleym
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM create_saleym .
  
    DATA : ls_save   TYPE ztc2sd2008,
           lt_save   LIKE TABLE OF ls_save,
           lv_cnt    TYPE i.
  
    DATA : a TYPE i VALUE '0'.
  
    CLEAR  : gs_data_2.
    REFRESH: gt_data_2, gt_data.
  
    IF gs_search-vendorc IS NOT INITIAL.
       IF gs_search-saleym IS NOT INITIAL.
        SELECT *
            INTO CORRESPONDING FIELDS OF TABLE gt_data_2
            FROM ztc2sd2006
            WHERE vendorc = gs_search-vendorc
            AND   saleym  = gs_search-saleym
            AND   statflag = 'F'.
              IF gt_data_2 IS NOT INITIAL.
                LOOP AT gt_data_2 INTO gs_data_2.
                  a += gs_data_2-ttamount.
                ENDLOOP.
                gs_data_2-ttamount = a.
              ELSE.
                MESSAGE s000 WITH TEXT-m01 DISPLAY LIKE 'E'.
                EXIT.
              ENDIF.
      ELSEIF gs_search-saleym IS INITIAL.
        MESSAGE s000 WITH TEXT-m01 DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.
    ELSEIF gs_search-saleym IS NOT INITIAL.
      MESSAGE s000 WITH TEXT-m01 DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
  
  
    CALL METHOD gcl_grid->check_changed_data.
      gs_data-plant    = ztc2sd2008-plant.
      gs_data-cmpnc    = '1004'.
      gs_data-vendorc  = gs_search-vendorc.
      gs_data-saleym   = gs_search-saleym.
      gs_data-saletp   = gs_data_2-ttamount.
      gs_data-waers    = gs_data_2-waers.
      gs_data-resprid  = ''.
      gs_data-salefdt  = ''.
      gs_data-statflag = 'A'.
      APPEND gs_data TO gt_data.
    MOVE-CORRESPONDING gt_data TO lt_save.
  
    IF sy-dbcnt <> 0.
      lv_cnt += sy-dbcnt.
    ENDIF.
  
    MODIFY ztc2sd2008 FROM TABLE lt_save.
  
    IF  lv_cnt > 0.
      COMMIT WORK AND WAIT.
      MESSAGE s000 WITH TEXT-003.
    ELSE.
      lv_cnt = 0.
      ROLLBACK WORK.
      MESSAGE s000 WITH TEXT-m02.
  
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_screen
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_screen .
  
     IF gcl_container IS NOT BOUND.
  
     CREATE OBJECT gcl_container
       EXPORTING
         container_name   = 'GCL_CONTAINER'.
  
     CREATE OBJECT gcl_grid
       EXPORTING
         i_parent          = gcl_container.
  
         gs_variant-report = sy-repid.
  
     IF gcl_handler IS NOT BOUND.
        CREATE OBJECT gcl_handler.
     ENDIF.
  
     SET HANDLER : gcl_handler->hotspot_click FOR gcl_grid.
  
     CALL METHOD gcl_grid->set_table_for_first_display
       EXPORTING
         is_variant       = gs_variant
         i_save           = 'A'
         i_default        = 'X'
         is_layout        = gs_layout
  
       CHANGING
         it_outtab        = gt_data
         it_fieldcatalog  = gt_fcat
         it_sort          = gt_sort.
  
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_screen_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_screen_2 .
  
     IF gcl_container_2 IS NOT BOUND.
  
       CREATE OBJECT gcl_container_2
         EXPORTING
           container_name   = 'GCL_CONTAINER_2'.
  
       CREATE OBJECT gcl_grid_2
         EXPORTING
           i_parent          = gcl_container_2.
  
           gs_variant_2-report = sy-repid.
  
       IF gcl_handler_2 IS NOT BOUND.
          CREATE OBJECT gcl_handler_2.
       ENDIF.
  
       SET HANDLER : gcl_handler_2->hotspot_click_2 FOR gcl_grid_2.
  
       CALL METHOD gcl_grid_2->set_table_for_first_display
         EXPORTING
           is_variant       = gs_variant_2
           i_save           = 'A'
           i_default        = 'X'
           is_layout        = gs_layout_2
  
         CHANGING
           it_outtab        = gt_data_2
           it_fieldcatalog  = gt_fcat_2.
  
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_sort
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_fcat_sort  USING sv_spos
                            sv_field
                            sv_up
                            sv_subtot.
  
    gs_sort-spos      = sv_spos.
    gs_sort-fieldname = sv_field.
    gs_sort-up        = sv_up.
    gs_sort-subtot    = sv_subtot.
  
    APPEND gs_sort TO gt_sort.
  ENDFORM.