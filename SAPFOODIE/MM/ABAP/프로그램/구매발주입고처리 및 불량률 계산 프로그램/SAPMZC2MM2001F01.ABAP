*&---------------------------------------------------------------------*
*& Include          ZC2MMR2003_F01
*&---------------------------------------------------------------------*
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
    gs_layout-cwidth_opt = 'X'.
    gs_layout-no_toolbar = 'X'.
    gs_layout-ctab_fname = 'COLOR'.
  
    PERFORM set_fcat USING :
  
    ' '   'STATUS'       '입고상태'    ''             'STATUS'     13 'C',
    ' '   'PURCORNB'     ' '         'ZTC2MM2004'   'PURCORNB'  13 'C',
    ' '   'ORPDDT'       ' '         'ZTC2MM2004'   'ORPDDT'    13 'C',
    ' '   'VENDORC'      ' '         'ZTC2MM2004'   'VENDORC'   13 'C',
    ' '   'INSTRDT'      ' '         'ZTC2MM2004'   'INSTRDT'   13 'C',
    ' '   'INSTRDD'      ' '         'ZTC2MM2005'   'INSTRDD'   13 'C',
    ' '   'EMAILI'       '이메일 전송'  ''             ''          13 'C'.
  
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
  FORM set_fcat  USING    pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length pv_just.
  
    gs_fcat-key       = pv_key.
    gs_fcat-fieldname = pv_field.
    gs_fcat-coltext   = pv_text.
    gs_fcat-ref_table = pv_ref_table.
    gs_fcat-ref_field = pv_ref_field.
    gs_fcat-outputlen = pv_length.
    gs_fcat-just      = pv_just.
  
    CASE pv_field.
      WHEN 'PURCORNB'.
        gs_fcat-hotspot = 'X'.
    ENDCASE.
  
    IF pv_field         = 'EMAILI'.
      gs_fcat-hotspot   = 'X'.
      gs_fcat-just      = 'C'.
    ENDIF.
  
    APPEND gs_fcat TO gt_fcat.
    CLEAR  gs_fcat.
  
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
          container_name = 'GCL_CONTAINER'.
  
      CREATE OBJECT gcl_grid
        EXPORTING
          i_parent = gcl_container.
  
      CREATE OBJECT gcl_handler.
      SET HANDLER : gcl_handler->handle_hotspot FOR gcl_grid.
  
      CLEAR gs_layout-cwidth_opt.
  
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
    ELSE.
  
    ENDIF.
  
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
  
    DATA : lv_tabix TYPE sy-tabix.
  
    CLEAR : gs_data.
  
  
    IF gv_flag = ' '.
  *초기화면 get data
      SELECT DISTINCT a~statflag a~orpddt a~instrdt a~purcornb a~vendorc a~instrdd
                      c~respr c~email
        INTO CORRESPONDING FIELDS OF TABLE gt_data
        FROM ztc2mm2004 AS a
       INNER JOIN ztc2mm2005 AS b
          ON a~cmpnc    = b~cmpnc
         AND a~plant    = b~plant
         AND a~vendorc  = b~vendorc
         AND a~purcym   = b~purcym
      AND  a~purcornb = b~purcornb
       INNER JOIN ztc2md2005 AS c
         ON  b~vendorc  = c~vendorc
     WHERE a~statflag = '12'.
  
  * 테이블에 email icon 삽입
      LOOP AT gt_data INTO gs_data.
        gs_data-emaili = icon_mail.
        MODIFY gt_data FROM gs_data.
      ENDLOOP.
  
      PERFORM set_cell_color.
    ENDIF.
  
    SORT gt_data BY purcornb ASCENDING.
  
  
    IF gv_flag = 'X'.
      PERFORM refresh_grid.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form execute_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM execute_data .
  
  *Module Pool Select Option
    RANGES: lr_purc FOR ztc2mm2004-purcornb,
            lr_stat FOR ztc2mm2004-statflag,
            lr_ven  FOR ztc2mm2004-vendorc.
  
    IF gs_execute-purcornb IS NOT INITIAL.
      lr_purc-sign   = 'I'.
      lr_purc-option = 'EQ'.
      lr_purc-low    = gs_execute-purcornb.
  
      APPEND lr_purc.
    ENDIF.
  
    IF gs_execute-statflag IS NOT INITIAL.
      lr_stat-sign   = 'I'.
      lr_stat-option = 'EQ'.
      lr_stat-low    = gs_execute-statflag.
  
      APPEND lr_stat.
    ENDIF.
  
    IF gs_execute-vendorc IS NOT INITIAL.
      lr_ven-sign   = 'I'.
      lr_ven-option = 'EQ'.
      lr_ven-low    = gs_execute-vendorc.
  
      APPEND lr_ven.
    ENDIF.
  
    REFRESH gt_data.
  
    SELECT DISTINCT a~statflag a~orpddt a~instrdt a~purcornb a~vendorc a~instrdd
                    c~respr c~email
      INTO CORRESPONDING FIELDS OF TABLE gt_data
      FROM ztc2mm2004 AS a
     INNER JOIN ztc2mm2005 AS b
        ON a~cmpnc    = b~cmpnc
       AND a~plant    = b~plant
       AND a~vendorc  = b~vendorc
       AND a~purcym   = b~purcym
       AND a~purcornb = b~purcornb
     INNER JOIN ztc2md2005 AS c
       ON  b~vendorc  = c~vendorc
    WHERE a~purcornb IN lr_purc
      AND a~vendorc  IN lr_ven
      AND a~statflag IN lr_stat.
  
  * 테이블에 email icon 삽입
    LOOP AT gt_data INTO gs_data.
      gs_data-emaili = icon_mail.
      MODIFY gt_data FROM gs_data.
    ENDLOOP.
  
  *조건검색후에도 셀색깔 유지
    PERFORM set_cell_color.
  
  *조건검색후에도 테이블에 email icon 삽입
    LOOP AT gt_data INTO gs_data.
      gs_data-emaili = icon_mail.
      MODIFY gt_data FROM gs_data.
    ENDLOOP.
  
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
  *&---------------------------------------------------------------------*
  *& Form handle_hotspot
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> E_ROW_ID
  *&      --> E_COLUMN_ID
  *&---------------------------------------------------------------------*
  FORM handle_hotspot  USING  ps_row_id    TYPE lvc_s_row
                              ps_column_id TYPE lvc_s_col.
  
    CLEAR gs_data.
  
    READ TABLE gt_data INTO gs_data INDEX ps_row_id-index.
  
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  
  * get purcornb detail
    IF ps_column_id-fieldname = 'PURCORNB'.
  
      PERFORM get_purdt USING gs_data-purcornb.
  * get email 작성
    ELSEIF ps_column_id-fieldname = 'EMAILI'.
  
      PERFORM get_email USING gs_data-email gs_data-respr.
  
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_purdt
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GS_DATA_PURCORNB
  *&---------------------------------------------------------------------*
  FORM get_purdt  USING pv_purcornb TYPE ztc2mm2004-purcornb.
  
    DATA   : ls_data LIKE gs_data2,
             lt_data LIKE TABLE OF ls_data.
  
    CLEAR  : gs_data2, ls_data.
    REFRESH: gt_data2, lt_data.
  
  * 구매 상세내역 sql
    SELECT a~matrtype a~matrc a~matrnm a~mmprice
           b~purcp b~unit b~vendorc
           c~currency c~purctp c~purcornb
      INTO CORRESPONDING FIELDS OF TABLE lt_data
      FROM ztc2md2006 AS a
      INNER JOIN ztc2mm2005 AS b
        ON a~cmpnc = b~cmpnc
       AND a~matrc = b~matrc
      INNER JOIN ztc2mm2004 AS c
        ON b~cmpnc     = c~cmpnc
       AND b~plant     = c~plant
       AND b~vendorc   = c~vendorc
       AND b~purcym    = c~purcym
      AND  b~purcornb  = c~purcornb
     WHERE c~purcornb = pv_purcornb.
  
  * 구매 상세내역 중복 합치기
    LOOP AT lt_data INTO ls_data.
  
      ls_data-purctp = ls_data-purcp * ls_data-mmprice. "구매 총액 계산
  
      COLLECT ls_data INTO gt_data2.
    ENDLOOP.
  
    IF sy-subrc NE 0.
      MESSAGE s003.
      EXIT.
    ENDIF.
  
    CALL SCREEN '0101'  STARTING AT 20 3 .
  
  
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
  
    ' '   'MATRTYPE'     ' '   'ZTC2MD2006'   'MATRTYPE' 10 'C',
    ' '   'MATRC'        ' '   'ZTC2MD2006'   'MATRC' 10 'C',
    ' '   'MATRNM'       ' '   'ZTC2MD2006'   'MATRNM' 10 'C',
    ' '   'PURCP'        ' '   'ZTC2MM2005'   'PURCP' 10 'C',
    ' '   'UNIT'         ' '   'ZTC2MM2005'   'UNIT' 10 'C',
    ' '   'MMPRICE'      ' '   'ZTC2MD2006'   'MMPRICE' 10 'C',
    ' '   'PURCTP'       ' '   'ZTC2MM2004'   'PURCTP' 10 'C',
    ' '   'CURRENCY'     ' '   'ZTC2MM2004'   'CURRENCY' 10 'C'.
  
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
  FORM set_fcat_pop  USING  pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length pv_just.
  
    gs_fcat_pop-key       = pv_key.
    gs_fcat_pop-fieldname = pv_field.
    gs_fcat_pop-coltext   = pv_text.
    gs_fcat_pop-ref_table = pv_ref_table.
    gs_fcat_pop-ref_field = pv_ref_field.
    gs_fcat_pop-outputlen = pv_length.
    gs_fcat_pop-just      = pv_just.
  
    CASE pv_field.
      WHEN 'PURCP'.
        gs_fcat_pop-qfieldname = 'UNIT'.
      WHEN 'PURCTP'.
        gs_fcat_pop-cfieldname = 'CURRENCY'.
      WHEN 'MMPRICE'.
        gs_fcat_pop-cfieldname = 'CURRENCY'.
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
          container_name = 'GCL_CONTAINER_POP'.
  
      CREATE OBJECT gcl_grid_pop
        EXPORTING
          i_parent = gcl_container_pop.
  
      CLEAR gs_layout_pop-cwidth_opt.
  
      CALL METHOD gcl_grid_pop->set_table_for_first_display
        EXPORTING
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout_pop
        CHANGING
          it_outtab       = gt_data2
          it_fieldcatalog = gt_fcat_pop.
  
  
  
    ENDIF.
  
    PERFORM refresh_grid_pop.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh_grid_pop
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
  *& Form display_screen2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_screen2 .
  
  *Text edit
    IF gcl_container_2 IS NOT BOUND.
      CREATE OBJECT gcl_container_2
        EXPORTING
          container_name = 'EMAIL'.
  
      CREATE OBJECT gcl_edit_2
        EXPORTING
          wordwrap_mode = gcl_edit_2->wordwrap_at_windowborder
          parent        = gcl_container_2.
  
      CALL METHOD gcl_edit_2->set_toolbar_mode
        EXPORTING
          toolbar_mode = 0.
  
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_email
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GS_DATA_EMAIL
  *&      --> GS_DATA_RESPR
  *&---------------------------------------------------------------------*
  FORM get_email  USING    pv_data_email  LIKE gs_data-email
                           pv_data_respr  LIKE gs_data-respr.
  
  *102번 화면에 거래처 담당자명과 email 정보 불러오기
    ztc2md2005-respr = pv_data_respr.
    ztc2md2005-email = pv_data_email.
  
    CALL SCREEN '0102' STARTING AT 10 10.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_cell_color
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_cell_color .
  
    DATA : lv_tabix TYPE sy-tabix,
           ls_color TYPE lvc_s_scol,
           lt_color TYPE lvc_t_scol.
  
    LOOP AT gt_data INTO gs_data.
      lv_tabix = sy-tabix.
  
  
      IF gs_data-instrdt < sy-datum AND gs_data-instrdd IS INITIAL. "지연
        gs_data-statflag = '15'.
        ls_color-fname = 'STATUS'.
      ENDIF.
  
      CASE gs_data-statflag.
        WHEN '12'.
          ls_color-fname   = 'STATUS'.
          gs_data-status   = '입고대기'.
          ls_color-color-col = '3'.
          ls_color-color-int = '1'.
          ls_color-color-inv = '0'.
        WHEN '14'.
          ls_color-fname   = 'STATUS'.
          ls_color-color-col = '5'.
          ls_color-color-int = '1'.
          ls_color-color-inv = '0'.
          gs_data-status   = '입고완료'.
        WHEN '15'.
          ls_color-fname   = 'STATUS'.
          ls_color-color-col = '6'.
          ls_color-color-int = '1'.
          ls_color-color-inv = '0'.
          gs_data-status   = '입고지연'.
  
      ENDCASE.
  
      APPEND ls_color TO gs_data-color.
  
      MODIFY gt_data FROM gs_data INDEX lv_tabix
      TRANSPORTING color status.
  
    ENDLOOP.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form instock_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM instock_data .
  
    DATA : ls_data2 LIKE gs_data3,
           lt_data2 LIKE TABLE OF ls_data2,
           lv_cnt   type i.
  
    CLEAR  : gs_data3, ls_data2.
    REFRESH: gt_data3, lt_data2.
  
    CALL METHOD gcl_grid->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    IF gt_rows IS INITIAL.
      MESSAGE s003.
      EXIT.
    ENDIF.
  
    lv_cnt = lines( gt_rows ).
    IF lv_cnt > 1.
      MESSAGE s005 WITH '한 줄만 선택하세요.'.
      EXIT.
    ENDIF.
  
    LOOP AT gt_rows INTO gs_row.
      READ TABLE gt_data INTO gs_data INDEX gs_row-index.
    ENDLOOP.
  
  * 입고처리 sql
    SELECT c~matrnm
           a~purcornb a~orpddt a~vendorc
           a~cmpnc a~plant a~purcym a~ormfdt a~purctp a~currency
           a~resprid a~modfid a~instrdt a~statflag a~delflag
           b~purcp b~instq b~faultyr b~matrc b~unit b~warehscd b~falutyq
  
      INTO CORRESPONDING FIELDS OF TABLE lt_data2
      FROM ztc2mm2004 AS a
     INNER JOIN ztc2mm2005 AS b
        ON a~vendorc  = b~vendorc
       AND a~purcornb = b~purcornb
  *    a~cmpnc    = b~cmpnc
  *     AND a~plant    = b~plant
       AND a~purcym   = b~purcym
     INNER JOIN ztc2md2006 AS c
        ON b~cmpnc    = c~cmpnc
       AND b~matrc    = c~matrc
  *     AND b~unit     = c~unit
  *     and b~warehscd = c~warehscd
     WHERE a~purcornb = gs_data-purcornb.
  
    LOOP AT lt_data2 INTO ls_data2.
      COLLECT ls_data2 INTO gt_data3.
    ENDLOOP.
  
    IF sy-subrc NE 0.
      MESSAGE s003.
      EXIT.
    ENDIF.
  
    CALL SCREEN '0103'  STARTING AT 20 3 .
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_layout_pop_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_layout_pop_2 .
  
    gs_layout_pop_2-zebra      = 'X'.
    gs_layout_pop_2-sel_mode   = 'D'.
    gs_layout_pop_2-cwidth_opt = 'X'.
    gs_layout_pop_2-no_toolbar = 'X'.
  
    PERFORM set_fcat_pop_2 USING :
  
    ' '   'PURCORNB'   ' '      'ZTC2MM2004'   'PURCORNB' 13 'C',
    ' '   'ORPDDT'     ' '      'ZTC2MM2004'   'ORPDDT' 13 'C',
    ' '   'VENDORC'    ' '      'ZTC2MM2004'   'VENDORC' 13 'C',
    ' '   'MATRC'      ' '      'ZTC2MM2005'   'MATRC' 10 'C',
    ' '   'MATRNM'     ' '      'ZTC2MD2006 '   'MATRNM' 10 'C',
    ' '   'INSTRDT'    ' '      'ZTC2MM2004'   'INSTRDT' 10 'C',
    ' '   'RESPRID'    ' '      'ZTC2MM2004'   'RESPRID' 10 'C',
    ' '   'PURCP'      ' '      'ZTC2MM2005'   'PURCP' 10 'C',
    ' '   'INSTQ'      ' '      'ZTC2MM2005'   'INSTQ' 10 'C',
    ' '   'FALUTYQ'    ' '      'ZTC2MM2005'   'FALUTYQ' 10 'C',
    ' '   'UNIT'       ' '      'ZTC2MM2005'   'UNIT' 10 'C',
    ' '   'FAULTYP'    '불량률'   ''             'FAULTYP' 10 'C'.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_pop_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_fcat_pop_2  USING   pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length pv_just.
  
    gs_fcat_pop_2-key       = pv_key.
    gs_fcat_pop_2-fieldname = pv_field.
    gs_fcat_pop_2-coltext   = pv_text.
    gs_fcat_pop_2-ref_table = pv_ref_table.
    gs_fcat_pop_2-ref_field = pv_ref_field.
    gs_fcat_pop_2-outputlen = pv_length.
    gs_fcat_pop_2-just      = pv_just.
  
    CASE pv_field.
      WHEN 'PURCP'.
        gs_fcat_pop_2-qfieldname = 'UNIT'.
      WHEN 'INSTQ'.
        gs_fcat_pop_2-qfieldname = 'UNIT'.
        gs_fcat_pop_2-edit       = 'X'.
      WHEN 'FALUTYQ'.
        gs_fcat_pop_2-qfieldname = 'UNIT'.
        gs_fcat_pop_2-edit       = 'X'.
  
    ENDCASE.
  
    APPEND gs_fcat_pop_2 TO gt_fcat_pop_2.
    CLEAR  gs_fcat_pop_2.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_pop_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_pop_2 .
  
    IF gcl_container_pop_2 IS NOT BOUND.
  
      CREATE OBJECT gcl_container_pop_2
        EXPORTING
          container_name = 'GCL_CONTAINER_POP_2'.
  
      CREATE OBJECT gcl_grid_pop_2
        EXPORTING
          i_parent = gcl_container_pop_2.
  
      SET HANDLER : gcl_handler->handle_changed_finished FOR gcl_grid_pop_2.
  
      CLEAR gs_layout_pop_2-cwidth_opt.
  
      CALL METHOD gcl_grid_pop_2->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified
        EXCEPTIONS
          error      = 1
          OTHERS     = 2.
  
    ENDIF.
  
    CALL METHOD gcl_grid_pop_2->set_table_for_first_display
      EXPORTING
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout_pop_2
      CHANGING
        it_outtab       = gt_data3
        it_fieldcatalog = gt_fcat_pop_2.
  
    PERFORM refresh_grid_pop_2.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh_grid_pop_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_grid_pop_2 .
  
    gs_stable_pop_2-row = 'X'.
    gs_stable_pop_2-col = 'X'.
  
    CALL METHOD gcl_grid_pop_2->refresh_table_display
      EXPORTING
        is_stable      = gs_stable_pop_2
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
  FORM save_data . "입고처리 후 데이터 저장
  
    DATA : ls_save    TYPE ztc2mm2005,
           lt_save    LIKE TABLE OF ls_save,
           ls_save2   TYPE ztc2mm2004,
           lt_save2   LIKE TABLE OF ls_save2,
           ls_save3   TYPE ztc2mm2001,
           lt_save3   LIKE TABLE OF ls_save3,
           ls_save4   TYPE ztc2mm2007,
           lt_save4   LIKE TABLE OF ls_save4,
           lv_tabix   TYPE sy-tabix,
           lv_purcym  TYPE ztc2mm2004-purcym,
           lv_purconb TYPE ztc2mm2004-purcornb,
           ls_color   TYPE lvc_s_scol,
           lt_color   TYPE lvc_t_scol,
           lv_cnt     TYPE i.
  
    CLEAR   : ls_save, ls_save2.
    REFRESH : lt_save, lt_save2.
  
    CALL METHOD gcl_grid_pop_2->check_changed_data.
    CALL METHOD gcl_grid->check_changed_data.
  
    READ TABLE gt_data3 INTO gs_data3 INDEX 1.
    lv_purcym = gs_data3-purcym.
    lv_purconb = gs_data3-purcornb.
  
    LOOP AT gt_data3 INTO gs_data3.
      CLEAR ls_save3.
  
      lv_tabix = sy-tabix.
      gs_data3-instrdd = sy-datum.
      MOVE-CORRESPONDING gs_data3 TO ls_save.
  
      ls_save-cmpnc = '1004'.
      ls_save-plant = '1000'.
      ls_save-purcornb = lv_purconb.
  
      APPEND ls_save TO lt_save.
  
      READ TABLE gt_add INTO gs_add WITH KEY matrc = gs_data3-matrc warehscd = gs_data3-warehscd. "입고처리한 데이터를 재고 테이블에 저장
  
      IF sy-subrc = 0.
        gs_add-stckq += gs_Data3-instq.
        MODIFY gt_add FROM gs_add INDEX sy-tabix.
      ENDIF.
  
      READ TABLE gt_purc INTO gs_purc WITH KEY matrc = gs_data3-matrc purcornb = gs_data3-purcornb. "입고처리한 데이터 (재고수량, 불량률) 를 구매오더 아이템 테이블에 저장
      IF sy-subrc = 0.
        gs_purc-instq += gs_data3-instq.
        gs_purc-falutyq += gs_data3-falutyq.
        MODIFY gt_purc FROM gs_purc INDEX sy-tabix.
      ENDIF.
  
    ENDLOOP.
  
    READ TABLE gt_purcp INTO gs_purcp WITH KEY vendorc = gs_data3-vendorc purcym = gs_data3-purcym.
  
    IF sy-subrc = 0.
      gs_purcp-purctp += gs_data3-purctp.
      MODIFY gt_purcp FROM gs_purcp INDEX sy-tabix.
    ENDIF.
  
  
    MODIFY ztc2mm2005 FROM TABLE gt_purc.
    MODIFY ztc2mm2001 FROM TABLE gt_add.
    MODIFY ztc2mm2007 FROM TABLE gt_purcp.
    MODIFY ztc2mm2005 FROM TABLE lt_save.
  
    CALL METHOD gcl_grid->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    lv_cnt = lines( gt_rows ).
    IF lv_cnt > 1.
      MESSAGE s000 WITH '한 줄만 선택하세요.'.
      EXIT.
    ENDIF.
  
    LOOP AT gt_rows INTO gs_row.
      READ TABLE gt_data INTO gs_data INDEX gs_row-index.
  
      lv_tabix = sy-tabix.
  
      CASE gs_data-statflag.
        WHEN '12'.
          gs_data-statflag = '14'.
          gs_data-status   = '입고완료'.
          gs_data-instrdd = sy-datum.
  
          ls_color-fname         = 'STATUS'.
          ls_color-color-col     = '5'.
          ls_color-color-int     = '1'.
          ls_color-color-inv     = '0'.
          CLEAR gs_data-color.
          APPEND ls_color TO gs_data-color.
  
      ENDCASE.
  
      MODIFY gt_data FROM gs_data INDEX lv_tabix
      TRANSPORTING statflag status color instrdd.
  
    ENDLOOP.
  
    " 여기까지가 ALV의 출력화면 수정작업.
    " 아래부터는 실제 DB를 수정해보자.
  
    SELECT *
    FROM ztc2mm2004
    INTO CORRESPONDING FIELDS OF TABLE lt_save2
    WHERE purcornb = gs_data-purcornb.
  
    "내가 누른 구매오더에 해당되는 데이터를 전부 가져왔음 /  lt_save2 = 04
  
    LOOP AT gt_data INTO gs_data.
  
      lv_tabix = sy-tabix.
  
      READ TABLE lt_save2 INTO ls_save2
       WITH KEY purcornb = gs_data-purcornb.
  
      IF sy-subrc = 0.
  
        IF gs_data-statflag = '14'.
          ls_save2-statflag = '14'.
          ls_save2-instrdd = sy-datum.
  
          MODIFY lt_save2 FROM ls_save2 INDEX sy-tabix
          TRANSPORTING statflag instrdd.
        ENDIF.
  
      ENDIF.
  
    ENDLOOP.
  
    MODIFY ztc2mm2004 FROM TABLE lt_save2.
  
    IF sy-dbcnt > 0.
      COMMIT WORK AND WAIT.
      MESSAGE s005 WITH '입고가 완료되었습니다'.
  
    ELSE.
      ROLLBACK WORK.
      MESSAGE s005 WITH '작업이 취소되었습니다.' DISPLAY LIKE 'E'.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form handle_changed_finished
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> E_MODIFIED
  *&      --> ET_GOOD_CELLS
  *&---------------------------------------------------------------------*
  FORM handle_changed_finished  USING    pv_modified
                                         pt_good_cells TYPE lvc_t_modi.
  
    DATA : ls_modi   TYPE lvc_s_modi,
           lv_per(5) TYPE p DECIMALS 2.
  
    LOOP AT pt_good_cells INTO ls_modi.
  
      CASE ls_modi-fieldname.
        WHEN 'PURCP' OR 'FALUTYQ'.
          READ TABLE gt_data3 INTO gs_data3 INDEX ls_modi-row_id.
  
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.
  
          IF gs_data3-purcp <> 0.
            lv_per = ( gs_data3-falutyq / gs_data3-purcp ) * 100.  "불량률 계산
  
            gs_data3-faultyp = lv_per.
            CONCATENATE gs_data3-faultyp '%' INTO gs_data3-faultyp. "불량률 계산 후 %기호 붙이기
  
          ELSE.                                                     "gs_data3-falutyq = 0.
            lv_per = '0'.
  
            gs_data3-faultyp = lv_per.
            CONCATENATE gs_data3-faultyp '%' INTO gs_data3-faultyp.
  
          ENDIF.
  
          MODIFY gt_data3 FROM gs_data3 INDEX ls_modi-row_id
           TRANSPORTING faultyp.
  
      ENDCASE.
  
    ENDLOOP.
  
    PERFORM refresh_grid_pop_2.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_statflag
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_statflag .
  
    DATA : lv_name  TYPE vrm_id,
           lt_value TYPE vrm_values,
           ls_value LIKE LINE OF lt_value.
  
    lv_name = 'GS_EXECUTE-STATFLAG'. "입고상태 변환
  
    ls_value-key = '12'.
    ls_value-text = '입고대기'.
    APPEND ls_value TO lt_value.
  
    ls_value-key = '14'.
    ls_value-text = '입고완료'.
    APPEND ls_value TO lt_value.
  
    ls_value-key = '15'.
    ls_value-text = '입고지연'.
    APPEND ls_value TO lt_value.
  
    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = lv_name
        values = lt_value.
  
    IF gs_execute-statflag IS INITIAL.
      gs_execute-statflag = '12'.
    ENDIF.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form f4_vendorc
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM f4_vendorc .
  
    DATA : BEGIN OF ls_value,
             vendorc TYPE ztc2md2005-vendorc,
             vendorn TYPE ztc2md2005-vendorn,
           END OF ls_value,
  
           lt_value LIKE TABLE OF ls_value.
  
    REFRESH lt_value.
  
    SELECT vendorc vendorn
      INTO CORRESPONDING FIELDS OF TABLE lt_value
      FROM ztc2md2005
     WHERE vendorc BETWEEN '001' AND '007'.  "search help의 value range 조정
  *     AND spras = sy-langu.
  
  
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield     = 'VENDORC'
        dynpprog     = sy-repid
        dynpnr       = sy-dynnr
        dynprofield  = 'GS_EXECUTE-VENDORC'
        window_title = '거래처 정보'
        value_org    = 'S'
      TABLES
        value_tab    = lt_value.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form save_purc
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM save_purc .
  
    SELECT *
      FROM ztc2mm2001
      INTO CORRESPONDING FIELDS OF TABLE gt_add.
  
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form order_purc
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM order_purc .
  
    SELECT *
    FROM ztc2mm2005
    INTO CORRESPONDING FIELDS OF TABLE gt_purc.
  
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form add_purcp
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM add_purcp .
  
    SELECT *
    FROM ztc2mm2007
    INTO CORRESPONDING FIELDS OF TABLE gt_purcp.
  
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  
  ENDFORM.