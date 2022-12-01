*&---------------------------------------------------------------------*
*& Include          SAPMZC2PP2001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form f4_ponum
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f4_ponum .

    DATA : BEGIN OF ls_ordernum,
             ponum TYPE ztc2pp2006-ponum,
           END OF ls_ordernum,
           lt_ordernum LIKE TABLE OF ls_ordernum.
  
    SELECT ponum
      INTO CORRESPONDING FIELDS OF TABLE lt_ordernum
      FROM ztc2pp2006
     WHERE postat = '22'.
  
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield     = 'PONUM'
        dynpprog     = sy-repid
        dynpnr       = sy-dynnr
        dynprofield  = 'SO_PONUM-LOW'
        window_title = '생산오더번호'
        value_org    = 'S'
  *     DISPLAY      = ' '
      TABLES
        value_tab    = lt_ordernum.
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_fin_order_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_fin_order_data .
  
    DATA : lv_domain TYPE dcobjdef-name,
           lv_value  TYPE dd07v-domvalue_l,
           lv_text   TYPE dd07v-ddtext,
           ls_color  TYPE lvc_s_scol,
           lv_tabix  TYPE sy-tabix.
  
    lv_domain = 'ZDC2PP_POSTAT'.
  
    CLEAR : gs_header_data, gt_header_data.
  
    SELECT *
      FROM ztc2pp2006
      INTO CORRESPONDING FIELDS OF TABLE gt_header_data
     WHERE plant IN so_plant
       AND ponum IN so_ponum
       AND enddt IN so_enddt
       AND postat >= '22'
      ORDER BY postat ASCENDING.
  
  
    IF sy-subrc NE 0.
      MESSAGE s009 DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  
    LOOP AT gt_header_data INTO gs_header_data.
      lv_tabix = sy-tabix.
      lv_value = gs_header_data-postat.
  
      CLEAR gs_header_data-icon.
  
      CALL FUNCTION 'ISU_DOMVALUE_TEXT_GET'
        EXPORTING
          x_name  = lv_domain
          x_value = lv_value
        IMPORTING
          y_text  = lv_text.
  
      gs_header_data-statext = lv_text.
  
  
      IF gs_header_data-postat = '23'.
        gs_header_data-icon = '@5B@'.
  
      ELSEIF gs_header_data-postat = '22'.
        gs_header_data-icon = '@5C@'.
      ENDIF.
  
      MODIFY gt_header_data FROM gs_header_data INDEX lv_tabix TRANSPORTING icon statext.
  
    ENDLOOP.
  
    PERFORM refresh_grid.
  
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
  *  gs_layout_1-ctab_fname = 'COLOR'.
  
    PERFORM set_fcat USING :
         'X'  'ICON'      ''    'GT_HEADER_DATA'   'ICON'  3, "아이콘
         'X'  'STATEXT'   '상태' 'GT_HEADER_DATA'   'STATEXT'  10, "상태
         'X'  'PONUM'     ''    'ZTC2PP2006'  'PONUM'    15,   "생산오더번호
         ' '  'STRTDT'    ''    'ZTC2PP2006'  'STRTDT'   20,  "생산 시작일
         ' '  'ENDDT'     ''    'ZTC2PP2006'  'ENDDT'    20,   "생산 종료일
         ' '  'CREATEID'  ''    'ZTC2PP2006'  'CREATEID' 12, "담당자.
         ' '  'DONEDT'    ''    'ZTC2PP2006'  'DONEDT'  20. "생산 마감일
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
  FORM set_fcat  USING   pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length.
  
    gs_fcat-key       = pv_key.
    gs_fcat-fieldname = pv_field.
    gs_fcat-coltext   = pv_text.
    gs_fcat-ref_table = pv_ref_table.
    gs_fcat-ref_field = pv_ref_field.
    gs_fcat-outputlen = pv_length.
  
    IF pv_Field = 'ICON'.
      gs_fcat-just = 'C'.
    ENDIF.
  
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
  
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
  
      gs_variant-report = sy-repid.
  
      IF gcl_handler IS NOT BOUND.
        CREATE OBJECT gcl_handler.
      ENDIF.
  
      "finish event 실행 전 코드
  
      CREATE OBJECT gcl_handler.
      SET HANDLER : gcl_handler->handle_db_click FOR gcl_grid.
  
      CALL METHOD gcl_grid->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout
        CHANGING
          it_outtab       = gt_header_data
          it_fieldcatalog = gt_fcat.
    ENDIF.
  
  
  
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
  *& Form handle_db_click
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> E_ROW
  *&      --> E_COLUMN
  *&---------------------------------------------------------------------*
  FORM handle_db_click  USING   ps_row    TYPE lvc_s_row
                                ps_column TYPE lvc_s_col.
  
    DATA : lv_input TYPE i.
  
    READ TABLE gt_header_data INTO gs_header_data INDEX ps_row-index.
  
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  
    CASE gs_header_data-postat.
      WHEN '22'.
        lv_input = 1.
      WHEN '23'.
        lv_input = 0.
    ENDCASE.
  
    CALL METHOD gcl_grid2->set_ready_for_input
      EXPORTING
        i_ready_for_input = lv_input.
  
    PERFORM get_item_data USING gs_header_data-ponum gs_header_data-postat.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_item_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GS_HEADER_DATA_PONUM
  *&---------------------------------------------------------------------*
  FORM get_item_data  USING    pv_ponum  TYPE ztc2pp2006-ponum
                               pv_postat TYPE ztc2pp2006-postat.
  
    CLEAR: gs_item, gt_item.
    DATA : lv_per(5) TYPE p DECIMALS 2,
           lv_tabix  TYPE sy-tabix.
  
    SELECT
      a~ponum a~mkits b~matrnm b~wcid a~poquan a~pmquan a~faltq a~unit a~falrsn
      INTO CORRESPONDING FIELDS OF TABLE gt_item
      FROM ztc2pp2007 AS a
  
      INNER JOIN ztc2md2006 AS b "자재 마스터 테이블
      ON a~mkits = b~matrc
  
      WHERE a~ponum = pv_ponum.
  
  
    IF sy-subrc <> 0.
      MESSAGE s005 WITH TEXT-m02 DISPLAY LIKE 'E'.
    ENDIF.
  
    LOOP AT gt_item INTO gs_item.
      lv_tabix = sy-tabix.
  
      "실적 확정일 경우, 데이터 취득시 불량률 계산.
      IF pv_postat EQ '23'.
  
        IF gs_item-faltq <> 0.
          lv_per = ( gs_item-faltq / gs_item-pmquan ) * 100. "불량률 계산
          gs_item-frate = lv_per.
          CONCATENATE gs_item-frate '%' INTO gs_item-frate.
  
        ELSE.
          lv_per = '0'.
          gs_item-frate = lv_per.
          CONCATENATE gs_item-frate '%' INTO gs_item-frate.
        ENDIF.
  
        MODIFY gt_item FROM gs_item INDEX lv_tabix
        TRANSPORTING frate.
      ENDIF.
  
    ENDLOOP.
  *
  *
  *   "불량률 계산 뒤 불량률 필드에 격납.
  *    IF gs_header_data-faltq <> 0.
  *      lv_per =  ( gs_item-FALTQ / gs_item-PMQUAN ) * 100.
  *      gs_header_data-frate = lv_per.
  *      CONCATENATE gs_header_data-frate '%' INTO gs_header_data-frate.
  *    ELSE.
  *      lv_per = '0'.
  *      gs_header_data-frate = lv_per.
  *      CONCATENATE gs_header_data-frate '%' INTO gs_header_data-frate.
  *    ENDIF.
  
    PERFORM refresh_grid2.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_10
  *&---------------------------------------------------------------------*
  FORM set_fcat2  USING  pv_key
                         pv_field
                         pv_text
                         pv_ref_table
                         pv_ref_field
                         pv_length
                         pv_edit.
    CLEAR  gs_fcat2.
  
    gs_fcat2-key       = pv_key.
    gs_fcat2-fieldname = pv_field.
    gs_fcat2-coltext   = pv_text.
    gs_fcat2-ref_table = pv_ref_table.
    gs_fcat2-ref_field = pv_ref_field.
    gs_fcat2-outputlen = pv_length.
    gs_fcat2-edit      = pv_edit.
  
  
  *  CASE pv_field.
  *   WHEN 'POQUAN'.
  *      gs_fcat_2-qfieldname = 'UNIT'.
  *  ENDCASE.
  
  
    APPEND gs_fcat2 TO gt_fcat2.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_data2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_data2 .
  
    DATA : lv_pnu(3).
  
    IF gcl_container2 IS NOT BOUND.
  *    CLEAR gv_edit.
      CREATE OBJECT gcl_container2
        EXPORTING
          container_name = 'GCL_CONTAINER2'.
  
      CREATE OBJECT gcl_grid2
        EXPORTING
          i_parent = gcl_container2.
  *
      SET HANDLER : gcl_handler->handle_changed_finished FOR gcl_grid2.
  
      CALL METHOD gcl_grid2->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified
        EXCEPTIONS
          error      = 1
          OTHERS     = 2.
  
      gs_variant2-report  = sy-repid.
  
      CLEAR gs_layout2-cwidth_opt. " 밑에 있는 ALV화면의 자동간격 조정을 없애줌.
  
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
  
    GET PARAMETER ID 'PNU' FIELD lv_pnu.
  
    IF lv_pnu IS NOT INITIAL.
      lv_pnu = ''.
      PERFORM get_fin_order_data.
      PERFORM refresh_grid.
      SET PARAMETER ID 'PNU' FIELD lv_pnu.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh_grid
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_grid2 .
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.
  
    CALL METHOD gcl_grid2->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = space.
  
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
  *  gs_layout2-stylefname = 'STYLE'.
    gs_layout2-zebra      = 'X'.
  *  gs_layout2-cwidth_opt = 'X'.
    gs_layout2-sel_mode   = 'D'.
    gs_layout2-no_toolbar = 'X'.
  *  gs_layout2-ctab_fname = 'COLOR'.
  
    REFRESH gt_fcat2.
  
    "생산오더번호 자재코드 자재명 작업장 생산계획수량
    "생산오더수량 생산실적수량 불량품 단위 불량률 불량사유
    PERFORM set_fcat2 USING:
         'X'   'PONUM'    ''      'ZTC2PP2007'   'PONUM'   12 '',
         ' '   'MKITS'    ''      'ZTC2PP2007'   'MKITS'   8  '',
         ' '   'MATRNM'   ''      'ZTC2MD2006'   'MATRNM'  26 '',
         ' '   'WCID'     ''      'ZTC2MD2006'   'WCID'     8 '',
         ' '   'POQUAN'   ''      'ZTC2PP2007'   'POQUAN'  10 '',
         ' '   'PMQUAN'   ''      'ZTC2PP2007'   'PMQUAN'  10 'X',
         ' '   'FALTQ'    ''      'ZTC2PP2007'   'FALTQ'   10 'X',
         ' '   'UNIT'     ''      'ZTC2PP2007'   'UNIT'     5 '',
         ' '   'FRATE'    '불량률'  ''             ''         5 '',
         ' '   'FALRSN'   ''      'ZTC2PP2007'   'FALRSN'   5 'X'.
  
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
        WHEN 'PMQUAN' OR 'FALTQ'.
          READ TABLE gt_item INTO gs_item INDEX ls_modi-row_id.
  
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.
  
          IF gs_item-faltq <> 0.
            lv_per = ( gs_item-faltq / gs_item-pmquan ) * 100. "불량률 계산
            gs_item-frate = lv_per.
            CONCATENATE gs_item-frate '%' INTO gs_item-frate.
  
          ELSE.
            lv_per = '0'.
            gs_item-frate = lv_per.
            CONCATENATE gs_item-frate '%' INTO gs_item-frate.
  
          ENDIF.
  
          MODIFY gt_item FROM gs_item INDEX ls_modi-row_id
          TRANSPORTING frate.
  
      ENDCASE.
  
    ENDLOOP.
  
    PERFORM refresh_grid2.
  
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
    " 도메인 벨류 관련 변수
    DATA : lv_domain TYPE dcobjdef-name,
           lv_value  TYPE dd07v-domvalue_l,
           lv_text   TYPE dd07v-ddtext.
  
    " 실적 등록 관련 변수
    DATA : ls_save  TYPE ztc2pp2006,
           lt_save  LIKE TABLE OF ls_save,
           ls_save2 TYPE ztc2pp2007,
           lt_save2 LIKE TABLE OF ls_save2,
           lv_tabix TYPE sy-tabix,
           ls_save3 TYPE ztc2mm2001,
           lt_save3 LIKE TABLE OF ls_save3,
           lv_cnt   TYPE i,
           lv_cnt2  TYPE i.
  
    "완제품 재고 변수
    DATA : BEGIN OF ls_stock.
             INCLUDE STRUCTURE ztc2mm2001.
    DATA :   pmquan TYPE ztc2pp2007-pmquan,
             FALTQ  TYPE ztc2pp2007-FALTQ,
           END OF ls_stock,
           lt_stock LIKE TABLE OF ls_stock.
  
    lv_domain = 'ZDC2PP_POSTAT'.
  
    CLEAR   : gs_selected_row, ls_save, ls_save2.
    REFRESH : gt_selected_rows, lt_save, lt_save2.
  
    CALL METHOD gcl_grid->get_selected_rows
      IMPORTING
        et_index_rows = gt_selected_rows.
  
    lv_cnt = lines( gt_selected_rows ).
    lv_cnt2 = lines( gt_item ).
  
    CLEAR : gs_header_data.
  
    IF lv_cnt EQ 0.
  
      MESSAGE s005 WITH '한 건 이상의 데이터를 선택해 주세요!' DISPLAY LIKE 'W'.
      EXIT.
    ENDIF.
  
      " 1. 갱신 할 헤더 데이터 격납.
      LOOP AT gt_selected_rows INTO gs_selected_row.
  
     READ TABLE gt_header_data INTO gs_header_data INDEX gs_selected_row-index.
  
      IF gs_header_data-postat = '23'.
       MESSAGE s005 WITH '이미 실적등록이 완료된 데이터 입니다.' DISPLAY LIKE 'W'.
       EXIT.
      ELSEIF lv_cnt2 EQ 0.
  
       MESSAGE s005 WITH '실적 아이템을 확인해주세요!' DISPLAY LIKE 'W'.
       EXIT.
     ENDIF.
  
        lv_tabix = sy-tabix.
  
        CALL FUNCTION 'ISU_DOMVALUE_TEXT_GET'
          EXPORTING
            x_name  = lv_domain
            x_value = '23'
          IMPORTING
            y_text  = lv_text.
  
        gs_header_data-statext = lv_text.
        gs_header_data-postat = '23'.
        gs_header_data-donedt = sy-datum.
        gs_header_data-icon = '@5B@'.
  
        MOVE-CORRESPONDING gs_header_data TO ls_save.
        APPEND ls_save TO lt_save.
        MODIFY gt_header_data FROM gs_header_data INDEX lv_tabix TRANSPORTING postat statext donedt icon.
  
      ENDLOOP.
  
      " 2. 갱신할 아이템 데이터 격납. 오류 : 더블클릭 하지 않을 경우, gt_item을 획득할 수 없다. select 문이 필요.
      CALL METHOD gcl_grid2->check_changed_data. "Item data ALV내용을 획득
  
      LOOP AT gt_item INTO gs_item.
  
        MOVE-CORRESPONDING gs_item TO ls_save2.
  
        ls_save2-cmpnc = '1004'.
        ls_save2-plant = '1000'.
        APPEND ls_save2 TO lt_save2.
      ENDLOOP.
  
  
  
      SELECT a~cmpnc, a~plant, a~warehscd, a~matrc, a~stckq, a~unit, b~pmquan, b~FALTQ
      FROM ztc2mm2001 AS a
      INNER JOIN @lt_save2 AS b
        ON a~matrc = b~mkits
      INTO CORRESPONDING FIELDS OF TABLE @lt_stock.
  
      LOOP AT lt_stock INTO ls_stock.
        lv_tabix = sy-tabix.
        "재고 수량 + ( 실적 수량 - 불량 수량 ) .
        ls_stock-stckq = ls_stock-stckq + ( ls_stock-pmquan - ls_stock-FALTQ ).
        MODIFY lt_stock FROM ls_stock INDEX lv_tabix TRANSPORTING stckq.
  
        MOVE-CORRESPONDING ls_stock TO ls_save3.
        APPEND ls_save3 TO lt_save3.
      ENDLOOP.
  
      CALL METHOD gcl_grid2->set_ready_for_input
        EXPORTING
          i_ready_for_input = 0.
  
  
      "헤더 데이터 DB 갱신
      MODIFY ztc2pp2006 FROM TABLE lt_save.
  
      "아이템 데이터 DB 갱신
      MODIFY ztc2pp2007 FROM TABLE lt_save2.
  
      "재고 데이터 DB 갱신
      MODIFY ztc2mm2001 FROM TABLE lt_save3.
  
  
      IF sy-dbcnt > 0.
        COMMIT WORK AND WAIT.
        MESSAGE s000.
      ENDIF.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form mode_change
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM mode_change .
    LOOP AT SCREEN.
      IF screen-name = 'SO_PLANT-LOW'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDFORM.