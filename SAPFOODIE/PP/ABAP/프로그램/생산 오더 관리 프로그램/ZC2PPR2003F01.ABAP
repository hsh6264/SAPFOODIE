*&---------------------------------------------------------------------*
*& Include          ZC2PPR2003_F01
*&---------------------------------------------------------------------*
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
      IF screen-name = 'PA_PLANT'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_listbox
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_listbox .
  
    DATA : ls_tab    TYPE dd07v,
           lt_tab    LIKE TABLE OF ls_tab,
           lv_domain TYPE dd07l-domname.
  
    lv_domain = 'ZDC2PP_POSTAT'.
    name = 'PA_LIST'.
  
    " 도메인 fixed values get
    CALL FUNCTION 'GET_DOMAIN_VALUES'
      EXPORTING
        domname    = lv_domain
      TABLES
        values_tab = lt_tab.
  
    LOOP AT lt_tab INTO ls_tab.
      value-key = ls_tab-domvalue_L.
      value-text = ls_tab-ddtext.
      APPEND value TO list.
    ENDLOOP.
  
    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = name
        values = list.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_header_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_header_data .
  
    DATA : lv_where(200),
           lv_add(50),
           lv_domain     TYPE dcobjdef-name,
           lv_value      TYPE dd07v-domvalue_l,
           lv_text       TYPE dd07v-ddtext,
           ls_color      TYPE lvc_s_scol,
           lv_tabix      TYPE sy-tabix.
  
    lv_domain = 'ZDC2PP_POSTAT'.
  
    CLEAR : gs_odlist, gt_odlist, ls_color.
  
    lv_where = 'plant = @pa_plant AND ponum IN @pa_ponum AND postart IN @pa_pstar'.
  
    IF pa_list IS NOT INITIAL.
      lv_add = 'AND postat = @pa_list'.
      CONCATENATE lv_where lv_add INTO lv_where SEPARATED BY space.
    ENDIF.
  
    SELECT * FROM  ztc2pp2006
      INTO CORRESPONDING FIELDS OF TABLE @gt_odlist
      WHERE (lv_where).
  
    IF sy-subrc NE 0.
      MESSAGE s009 DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  
    LOOP AT gt_odlist INTO DATA(gs_odlist).
      lv_tabix = sy-tabix.
      lv_value = gs_odlist-postat.
  
      CALL FUNCTION 'ISU_DOMVALUE_TEXT_GET'
        EXPORTING
          x_name  = lv_domain
          x_value = lv_value
        IMPORTING
          y_text  = lv_text.
  
      gs_odlist-statext = lv_text.
  
      CLEAR ls_color.
      ls_color-fname = 'STATEXT'.
      ls_color-color-int = '0'.
      ls_color-color-inv = '0'.
  
      CLEAR gs_odlist-color.
  
      CASE gs_odlist-postat.
        WHEN '21'. " 생산중
          ls_color-color-col = '3'.
  
        WHEN '22'. " 생산완료
          ls_color-color-col = '7'.
  
        WHEN '23'. " 실적확정
          ls_color-color-col = '5'.
  
      ENDCASE.
  
      APPEND ls_color TO gs_odlist-color.
      MODIFY gt_odlist FROM gs_odlist INDEX lv_tabix TRANSPORTING statext color.
  
    ENDLOOP.
  
    SORT gt_odlist BY POSTART.
  
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
    gs_layout_1-zebra      = 'X'.
    gs_layout_1-sel_mode   = 'D'.
    gs_layout_1-cwidth_opt = 'X'.
    gs_layout_1-no_toolbar = 'X'.
    gs_layout_1-ctab_fname = 'COLOR'.
  
    PERFORM set_fcat USING :
  
  *      'X'  'POSTAT'    ''   'ZTC2PP2006'  'POSTAT' ,
         'X'  'STATEXT'   '상태' 'GT_ODLIST'   'STATEXT',
         'X'  'PLANT'     ''    'ZTC2PP2006'  'PLANT',
         'X'  'PONUM'     ''    'ZTC2PP2006'  'PONUM',
         ' '  'STRTDT'    ''    'ZTC2PP2006'  'STRTDT',
         ' '  'ENDDT'     ''    'ZTC2PP2006'  'ENDDT',
         ' '  'CREATEID'  ''    'ZTC2PP2006'  'CREATEID',
         ' '  'CDATE'     ''    'ZTC2PP2006'  'CDATE',
         ' '  'POSTART'   ''    'ZTC2PP2006'  'POSTART',
         ' '  'UPDATEID'  ''    'ZTC2PP2006'  'UPDATEID',
         ' '  'UDATE'     ''    'ZTC2PP2006'  'UDATE'.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_1
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_fcat  USING  pv_key pv_field pv_text pv_ref_table pv_ref_field..
  
    gs_fcat_1-key       = pv_key.
    gs_fcat_1-fieldname = pv_field.
    gs_fcat_1-coltext   = pv_text.
    gs_fcat_1-ref_table = pv_ref_table.
    gs_fcat_1-ref_field = pv_ref_field.
  
    CASE pv_field.
      WHEN 'PONUM'.
        gs_fcat_1-hotspot = 'X'.
  
    ENDCASE.
  
    APPEND gs_fcat_1 TO gt_fcat_1.
    CLEAR gs_fcat_1.
  
  
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
    IF gcl_container_1 IS NOT BOUND.
      CREATE OBJECT gcl_container_1
        EXPORTING
          dynnr     = sy-dynnr
          side      = cl_gui_docking_container=>dock_at_left
          extension = 3000.
  
      CREATE OBJECT gcl_grid_1
        EXPORTING
          i_parent = gcl_container_1.
  
      gs_variant_1-report = sy-repid.
  
      IF gcl_handler IS NOT BOUND.
        CREATE OBJECT gcl_handler.
      ENDIF.
  
      "finish event 실행 전 코드
  
      CREATE OBJECT gcl_handler.
      SET HANDLER : gcl_handler->handle_hotspot_click FOR gcl_grid_1.
  
      CALL METHOD gcl_grid_1->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant_1
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout_1
        CHANGING
          it_outtab       = gt_odlist
          it_fieldcatalog = gt_fcat_1.
  
  
    ENDIF.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form handle_click
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> E_COLUMN_ID
  *&      --> ES_ROW_NO
  *&---------------------------------------------------------------------*
  FORM handle_hotspot_click  USING    ps_column_id TYPE lvc_s_col
                                      ps_row_no    TYPE lvc_s_roid.
  
    CLEAR : gv_input.
  
    READ TABLE gt_odlist INTO gs_odlist INDEX ps_row_no-row_id.
  
    IF sy-subrc <> 0.
      EXIT.
    ELSE.
      gv_cmpnc    = gs_odlist-cmpnc.
      gv_plant    = gs_odlist-plant.
      gv_odnum    = gs_odlist-ponum.
      gv_odstar   = gs_odlist-strtdt.
      gv_odend    = gs_odlist-enddt.
      gv_mrg      = gs_odlist-createid.
      gv_postat   = gs_odlist-postat.
    ENDIF.
  
    IF gs_odlist-postat EQ '20'.
      gv_input = 1.
    ELSE.
      gv_input = 0.
    ENDIF.
  
    PERFORM get_item_data USING gs_odlist-ponum.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_item_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GS_ODLIST_PONUM
  *&---------------------------------------------------------------------*
  FORM get_item_data  USING    pv_ponum TYPE ztc2pp2006-ponum.
  
    CLEAR: gs_item, gt_item.
  
    SELECT
      a~ponum a~strtdt a~enddt a~createid a~updateid a~postart
      b~mkits b~poquan b~unit
      c~matrnm c~wcid
      d~warehsnm
      INTO CORRESPONDING FIELDS OF TABLE gt_item
      FROM ztc2pp2006 AS a           " 생산 오더 헤더 테이블
       INNER JOIN ztc2pp2007 AS b    " 생산 오더 아이템 테이블
        ON a~cmpnc = b~cmpnc
       AND a~plant = b~plant
       AND a~ponum = b~ponum
  
        INNER JOIN ztc2md2006 AS c   " 자재 마스터 테이블
          ON a~cmpnc = c~cmpnc
         AND b~mkits = c~matrc
  
          INNER JOIN ztc2md2007 AS d " 창고 마스터 테이블
            ON a~cmpnc = d~cmpnc
           AND c~warehscd = d~warehscd
  
        WHERE a~ponum = pv_ponum.
  
  
    IF sy-subrc <> 0.
      MESSAGE s005 WITH TEXT-m02 DISPLAY LIKE 'E'.
    ELSE.
      CALL SCREEN '0110' STARTING AT 20 1
      .
    ENDIF.
  
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
    gs_layout_2-sel_mode   = 'A'.
  *  gs_layout_2-cwidth_opt = 'X'.
    gs_layout_2-no_toolbar = 'X'.
  
    PERFORM set_fcat2 USING :
         'X'  'MKITS'     ''    'ZTC2PP2007'  'MKITS'    '' 7,
         ''   'MATRNM'    ''    'ZTC2MD2006'  'MATRNM'   '' 22,
         ''   'POQUAN'    '오더수량'    ''  ''   'X' 7,
         ' '  'UNIT'      ''    'ZTC2PP2007'  'UNIT'     'X' 3,
         ' '  'WCID'      ''    'ZTC2MD2006'  'WCID'     ''  9,
         ' '  'WAREHSNM'  ''    'ZTC2MD2007'  'WAREHSNM' '' 8.
  
  
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
  *&---------------------------------------------------------------------*
  FORM set_fcat2  USING  pv_key pv_field pv_text pv_ref_table pv_ref_field pv_edit pv_length.
    gs_fcat_2-key       = pv_key.
    gs_fcat_2-fieldname = pv_field.
    gs_fcat_2-coltext   = pv_text.
    gs_fcat_2-ref_table = pv_ref_table.
    gs_fcat_2-ref_field = pv_ref_field.
    gs_fcat_2-edit      = pv_edit.
    gs_fcat_2-outputlen = pv_length.
  
    CASE pv_field.
      WHEN 'POQUAN'.
        gs_fcat_2-qfieldname = 'UNIT'.
    ENDCASE.
  
    APPEND gs_fcat_2 TO gt_fcat_2.
    CLEAR gs_fcat_2.
  
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
  
    IF gcl_container_2 IS NOT BOUND.
  
      CREATE OBJECT gcl_container_2
        EXPORTING
          container_name = 'GCL_CONTAINER_2'.
  
      CREATE OBJECT gcl_grid_2
        EXPORTING
          i_parent = gcl_container_2.
  
      IF gcl_handler2 IS NOT BOUND.
        CREATE OBJECT gcl_handler2.
      ENDIF.
  
      gs_variant_2-report = sy-repid.
  
      "finish event 실행 전 코드
      CALL METHOD gcl_grid_2->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified.
  
      CREATE OBJECT gcl_handler2.
      SET HANDLER : gcl_handler2->handle_changed_finished FOR gcl_grid_2,
                    gcl_handler2->handle_db_click FOR gcl_grid_2.
  
  
  *  CLEAR gs_layout_2-cwidth_opt.
  
      CALL METHOD gcl_grid_2->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant_2 "grid의 layout 관리에 관여
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout_2 " Grid의 Cell의 선택 형식이나 필드 순서 등에 관여
        CHANGING
          it_outtab       = gt_item  "Grid에 Display될 Data를 가진 Itab.
          it_fieldcatalog = gt_fcat_2. "Grid에 Display될 Field들의 목록
  
  
      CALL METHOD gcl_grid_2->set_ready_for_input
        EXPORTING
          i_ready_for_input = gv_input.
  
    ENDIF.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_order_status
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_order_status USING gv_stat.
  
    DATA : lv_domain TYPE dcobjdef-name,
           lv_value  TYPE dd07v-domvalue_l,
           lv_text   TYPE dd07v-ddtext,
           lv_tabix  TYPE sy-tabix,
           lv_init   TYPE zec2pp_strtdt,
           lv_udate  TYPE sy-datum,
           lv_user   TYPE sy-uname,
           ls_color  TYPE lvc_s_scol,
           lv_excute.
  
    CLEAR : lv_init, lv_udate, lv_user, ls_color, lv_excute.
  
    lv_udate = sy-datum. " 오더 수정일
    lv_user  = sy-uname. " 수정자ID
  
  
    "선택한 rows get
    CALL METHOD gcl_grid_1->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    IF gt_rows IS INITIAL.
      MESSAGE s005 WITH TEXT-m01 DISPLAY LIKE 'E'.
      EXIT.
    ELSE.
      " rows가 있을 경우
      lv_domain = 'ZDC2PP_POSTAT'.
      lv_value = gv_stat.
  
      "domain text get
      CALL FUNCTION 'ISU_DOMVALUE_TEXT_GET'
        EXPORTING
          x_name  = lv_domain
          x_value = lv_value
        IMPORTING
          y_text  = lv_text.
  
      LOOP AT gt_rows INTO gs_row.
  
  
        lv_tabix = gs_row-index.
  
        READ TABLE gt_odlist INTO gs_odlist INDEX gs_row-index.
  
        CLEAR : gs_odlist-color.
  
        gs_odlist-updateid = lv_user. " 오더 수정일
        gs_odlist-udate    = lv_udate.  " 수정자ID
  
        ls_color-fname = 'STATEXT'.
        ls_color-color-int = '0'.
        ls_color-color-inv = '0'.
  
        CASE gv_stat.
          WHEN '21'. " 생산중
            gs_odlist-strtdt   = sy-datum.
            gs_odlist-statext  = lv_text.  " 상태 텍스트
            gs_odlist-postat   = gv_stat.  " 상태 코드
            ls_color-color-col = '3'.
  
          WHEN '22'. " 생산 완료
            gs_odlist-enddt    = sy-datum.
            gs_odlist-statext  = lv_text.  " 상태 텍스트
            gs_odlist-postat   = gv_stat.  " 상태 코드
            ls_color-color-col = '7'.
  
          WHEN '23'. " 실적 확정
  
            CASE gs_odlist-postat.
              WHEN '22' OR '23'.
  
                lv_excute = 'X'.
  
                SET PARAMETER ID : 'PNU' FIELD gs_odlist-ponum.
  
                PERFORM save_order.
  
                CALL TRANSACTION 'ZC2PP2001' AND SKIP FIRST SCREEN.
  
  
              WHEN OTHERS.
                MESSAGE s005 WITH TEXT-m02 DISPLAY LIKE 'E'.
                EXIT.
            ENDCASE.
  
          WHEN '20'. " 지시 취소
            gs_odlist-strtdt  = lv_init. "생산 시작일 초기화
            gs_odlist-enddt   = lv_init. "생산 종료일 초기화
            gs_odlist-statext  = lv_text.  " 상태 텍스트
            gs_odlist-postat   = gv_stat.  " 상태 코드
  
        ENDCASE.
  
        IF lv_excute IS INITIAL.
          APPEND ls_color TO gs_odlist-color.
          MODIFY gt_odlist FROM gs_odlist INDEX lv_tabix.
        ENDIF.
      ENDLOOP.
    ENDIF.
  
    PERFORM refresh_grid.
  
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
  
    gs_stable_1-row = 'X'.
    gs_stable_1-col = 'X'.
  
    CALL METHOD gcl_grid_1->refresh_table_display
      EXPORTING
        is_stable      = gs_stable_1
        i_soft_refresh = space.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form save_order
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM save_order .
    DATA : ls_save_header TYPE ztc2pp2006,
           lt_save_header LIKE TABLE OF ls_save_header.
  *
    IF gt_odlist IS INITIAL.
      MESSAGE e005 WITH '저장할 데이터가 없습니다.'.
    ENDIF.
  
    CALL METHOD gcl_grid_1->check_changed_data.
  
    LOOP AT gt_odlist INTO gs_odlist.
      MOVE-CORRESPONDING gs_odlist TO ls_save_header.
      APPEND ls_save_header TO lt_save_header.
    ENDLOOP.
  
    MODIFY ztc2pp2006 FROM TABLE lt_save_header.
  
    IF sy-dbcnt > 0 .
      COMMIT WORK AND WAIT.
    ENDIF.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form save_item_order
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM save_item_order .
  
    DATA : ls_save_item TYPE ztc2pp2007,
           lt_save_item LIKE TABLE OF ls_save_item,
           lv_tabix     TYPE sy-tabix.
  
    DATA : lv_write    TYPE string,
           lv_answer   TYPE c LENGTH 1,
           lv_check(1).
  
    DATA : BEGIN OF ls_check,
             mkits   TYPE ztc2pp2007-mkits,   " 자재코드
             poquan  TYPE ztc2pp2007-poquan,  " 생산오더수량
             matrc   TYPE ztc2pp2002-matrc,   " 자재코드
             versn   TYPE ztc2pp2002-versn,   " 버전
             rqqty   TYPE ztc2pp2002-rqqty,   " 필요수량
             stckq   TYPE ztc2mm2001-stckq,   " 재고수량
             matrnm   TYPE ztc2md2006-matrnm,
             lack(1),
           END OF ls_check,
           lt_check LIKE TABLE OF ls_check.
  
    DATA : BEGIN OF ls_matrnm,
            matrnm   TYPE ztc2md2006-matrnm,
           END OF ls_matrnm,
           lt_matrnm LIKE TABLE OF ls_matrnm.
  
    lv_write = '생산 오더를 수정하시겠습니까?'.
  
    CLEAR lv_check.
  
    SELECT a~mkits, a~poquan, b~matrc, b~versn, b~rqqty, c~stckq, d~matrnm
      FROM @gt_item AS a
      INNER JOIN ztc2pp2002 AS b
      ON a~mkits = b~mkits
      INNER JOIN ztc2mm2001 AS c
      ON b~matrc = c~matrc
      INNER JOIN ztc2md2006 AS d
      ON b~matrc = d~matrc
     WHERE b~versn = ( SELECT MAX( versn )
                          FROM ztc2pp2002
                         WHERE mkits = a~mkits
                           AND matrc = b~matrc )
      INTO CORRESPONDING FIELDS OF TABLE @lt_check.
  
    "재고 수량 체크
    LOOP AT lt_check INTO ls_check.
      lv_tabix = sy-tabix.
      ls_check-rqqty = ls_check-poquan * ( ls_check-rqqty * '0.1' ).
  
      "부족한 원자재가 1건이라도 있을 경우.
      IF ls_check-rqqty > ls_check-stckq.
        lv_check ='X'.
        APPEND ls_check-mkits TO gt_matrnm.
      ENDIF.
  
      MODIFY lt_check FROM ls_check INDEX lv_tabix TRANSPORTING rqqty .
  
  
    ENDLOOP.
  
    IF lv_check IS NOT INITIAL.
  *    SORT gt_matrnm BY matrnm.
  *    DELETE ADJACENT DUPLICATES FROM gt_matrnm COMPARING matrnm.
      PERFORM message.
    ELSE.
      LOOP AT gt_item INTO gs_item WHERE chg EQ 'X'.
  
        MOVE-CORRESPONDING gs_item TO ls_save_item.
        ls_save_item-cmpnc  = gv_cmpnc.
        ls_save_item-plant  = gv_plant.
        ls_save_item-postat = gv_postat.
        APPEND ls_save_item TO lt_save_item.
  
      ENDLOOP.
  
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = '생산 오더'
          text_question         = lv_write
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
       MODIFY ztc2pp2007 FROM TABLE lt_save_item.
  
      IF sy-dbcnt > 0 .
        COMMIT WORK AND WAIT.
        LEAVE TO SCREEN 0.
      ENDIF.
      ENDIF.
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
  
    DATA : ls_modi TYPE lvc_s_modi.
  
    LOOP AT pt_good_cells INTO ls_modi.
  
      CASE ls_modi-fieldname.
        WHEN 'POQUAN'.
          READ TABLE gt_item INTO gs_item INDEX ls_modi-row_id.
  
          IF sy-subrc NE 0.
            CONTINUE.
          ENDIF.
  
          gs_item-poquan = ls_modi-value. " new Value
          gs_item-chg    = 'X'.
  
          MODIFY gt_item FROM gs_item INDEX ls_modi-row_id TRANSPORTING poquan chg.
  
          PERFORM get_item_stock_data USING gs_item-mkits gs_item-poquan.
  
      ENDCASE.
  
    ENDLOOP.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form stock_change
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM stock_change .
  
    DATA : lv_tabix TYPE sy-tabix.
  
    "오더 넘버 테이블
    DATA : BEGIN OF ls_ponum,
             ponum TYPE ztc2pp2006-ponum,
           END OF ls_ponum,
           lt_ponum LIKE TABLE OF ls_ponum.
  
    "오더 아이템 제품명, 생산개수 격납 테이블
    DATA : BEGIN OF ls_oditem,
             mkits  TYPE ztc2pp2007-mkits,
             poquan TYPE ztc2pp2007-poquan,
           END OF ls_oditem,
           lt_oditem LIKE TABLE OF ls_oditem.
  
    " 중복 합산 테이블
    DATA : ls_add LIKE ls_oditem,
           lt_add LIKE HASHED TABLE OF ls_add WITH UNIQUE KEY mkits.
  
    " BOM item 테이블
    DATA : BEGIN OF ls_bom,
             cmpnc    TYPE ztc2pp2002-cmpnc,
             mkits    TYPE ztc2pp2002-mkits,
             matrc    TYPE ztc2pp2002-matrc,
             versn    TYPE ztc2pp2002-versn,
             rqqty    TYPE ztc2pp2002-rqqty,
             poquan   TYPE ztc2pp2007-poquan,
             plant    TYPE ztc2mm2001-plant,
             warehscd TYPE ztc2mm2001-warehscd,
             stckq    TYPE ztc2mm2001-stckq,
             unit     TYPE ztc2mm2001-unit,
           END OF ls_bom,
           lt_bom LIKE TABLE OF ls_bom.
  
    " 재고 테이블
    DATA : ls_stock TYPE ztc2mm2001,
           lt_stock LIKE TABLE OF ls_stock.
  
    "선택한 rows get
    CALL METHOD gcl_grid_1->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    IF gt_rows IS INITIAL.
      MESSAGE s005 WITH TEXT-m01 DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
  
    "1.  선택된 오더 넘버
    LOOP AT gt_rows INTO gs_row.
      READ TABLE gt_odlist INTO gs_odlist INDEX gs_row-index.
  
      ls_ponum-ponum = gs_odlist-ponum.
      APPEND ls_ponum TO lt_ponum.
    ENDLOOP.
  
    "2.  헤더 데이터에 연결된 아이템 데이터 취득.
    SORT lt_ponum BY ponum.
    DELETE ADJACENT DUPLICATES FROM lt_ponum COMPARING ponum.
  
    SELECT mkits poquan
      INTO CORRESPONDING FIELDS OF TABLE lt_oditem
      FROM ztc2pp2007
      FOR ALL ENTRIES IN lt_ponum
      WHERE ponum = lt_ponum-ponum.
  
    "3.  같은 자재코드 필드의 생산 오더 수량 합산.
    SORT lt_oditem BY mkits.
    LOOP AT lt_oditem INTO ls_add.
      COLLECT ls_add INTO lt_add.
    ENDLOOP.
  
    "4. 타겟 bom 아이템 취득.
    SORT lt_add BY mkits.
    DELETE ADJACENT DUPLICATES FROM lt_add COMPARING mkits.
  
    "5. 상위자재(mkits)의 하위자재(matrc)를 가져온다. versn은 가장 최신버전을 가져온다.
    SELECT a~cmpnc, a~mkits, a~matrc, a~versn, a~rqqty,
           b~poquan, c~plant, c~warehscd, c~stckq, c~unit
      FROM ztc2pp2002 AS a
      INNER JOIN @lt_add AS b
        ON a~mkits = b~mkits
      INNER JOIN ztc2mm2001 AS c
        ON a~matrc = c~matrc
      WHERE a~versn = ( SELECT MAX( versn )
                         FROM ztc2pp2002
                        WHERE cmpnc = a~cmpnc
                          AND mkits = a~mkits
                          AND matrc = a~matrc )
      INTO CORRESPONDING FIELDS OF TABLE @lt_bom.
  
    LOOP AT lt_bom INTO ls_bom.
      lv_tabix = sy-tabix.
  
      "계산 : 오더 수량 * ( bom 원재료 수량 * 0.1 )
      ls_bom-poquan = ls_bom-poquan * ( ls_bom-rqqty * '0.1' ).
      ls_bom-stckq = ls_bom-stckq - ls_bom-poquan.
  
      IF ls_bom-stckq < 0.
        gv_err = 'X'.
        MESSAGE s005 WITH TEXT-m05 DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.
  
      MODIFY lt_bom FROM ls_bom INDEX lv_tabix TRANSPORTING poquan stckq.
  
      MOVE-CORRESPONDING ls_bom TO ls_stock.
      APPEND ls_stock TO lt_stock.
    ENDLOOP.
  
    "테이블에 갱신 데이터 입력 후 확인할 것.
    MODIFY ztc2mm2001 FROM TABLE lt_stock.
  
    IF sy-dbcnt > 0 .
      COMMIT WORK AND WAIT.
      MESSAGE s005 WITH TEXT-m04.
    ENDIF.
  
  
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
  
    READ TABLE gt_item INTO gs_item INDEX ps_row-index.
  
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  
    PERFORM get_item_stock_data USING gs_item-mkits gs_item-poquan.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_item_stoct_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GS_ITEM_MKITS
  *&---------------------------------------------------------------------*
  FORM get_item_stock_data  USING    pv_mkits  TYPE ztc2pp2007-mkits
                                     pv_poquan TYPE ztc2pp2007-poquan.
  
    DATA : lv_tabix TYPE sy-tabix,
           ls_color TYPE lvc_s_scol.
  
    CLEAR : gt_stock_item, ls_color.
  
    "재고 수량보다 소모 원자재 수량이 많을 경우 저장 불가 플래그.
  
    SELECT a~cmpnc, a~mkits, a~matrc, a~versn, a~rqqty, b~stckq, b~unit, c~matrnm
      FROM ztc2pp2002 AS a         " BOM item 테이블
      INNER JOIN ztc2mm2001 AS b   " 재고 테이블
        ON a~matrc = b~matrc
      INNER JOIN ztc2md2006 AS c   " 자재 마스터 테이블
          ON a~cmpnc = c~cmpnc
         AND a~matrc = c~matrc
      WHERE a~versn = ( SELECT MAX( versn )
                         FROM ztc2pp2002
                        WHERE cmpnc = a~cmpnc
                          AND mkits = a~mkits
                          AND matrc = a~matrc )
        AND a~mkits = @pv_mkits
      INTO CORRESPONDING FIELDS OF TABLE @gt_stock_item.
  
    IF sy-subrc NE 0.
      MESSAGE s009 DISPLAY LIKE 'E'.
  *    LEAVE LIST-PROCESSING.
    ENDIF.
  
    ls_color-fname = 'RQQTY'.
    ls_color-color-int = '0'.
    ls_color-color-inv = '0'.
  
    LOOP AT gt_stock_item INTO gs_stock_item.
      lv_tabix = sy-tabix.
  
      gs_stock_item-rqqty = pv_poquan * ( gs_stock_item-rqqty * '0.1' ).
  
      MODIFY gt_stock_item FROM gs_stock_item INDEX lv_tabix TRANSPORTING rqqty.
  
      IF gs_stock_item-rqqty > gs_stock_item-stckq .
        gv_overr = 'X'.
        ls_color-color-col = '6'.
  
        APPEND ls_color TO gs_stock_item-color.
        MODIFY gt_stock_item FROM gs_stock_item INDEX lv_tabix TRANSPORTING color.
      ENDIF.
  
    ENDLOOP.
  
    PERFORM refresh_grid3.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_layout3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_layout3 .
    gs_layout_3-zebra      = 'X'.
    gs_layout_3-sel_mode   = 'A'.
  *  gs_layout_3-cwidth_opt = 'X'.
    gs_layout_3-no_toolbar = 'X'.
    gs_layout_3-ctab_fname = 'COLOR'.
  
    PERFORM set_fcat3 USING :
         ''   'MATRC'     ''    'ZTC2PP2002'  'MATRC'   10 , " 원자재 코드
         ''   'MATRNM'    ''    'ZTC2MD2006'  'MATRNM'  12 , " 원자재 이름
         ' '  'RQQTY'     '소모예정수량'    ''  ''   10  , " 현재 오더 수량
         ' '  'STCKQ'     ''    'ZTC2MM2001'  'STCKQ'   8 , " 재고 수량
         ' '  'UNIT'      ''    'ZTC2MM2001'  'UNIT'    8 . " 단위
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_screen3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_screen3 .
    IF gcl_container_3 IS NOT BOUND.
  
      CREATE OBJECT gcl_container_3
        EXPORTING
          container_name = 'GCL_CONTAINER_3'.
  
      CREATE OBJECT gcl_grid_3
        EXPORTING
          i_parent = gcl_container_3.
  
      gs_variant_3-report = sy-repid.
  
      CLEAR gs_layout_2-cwidth_opt.
  
      CALL METHOD gcl_grid_3->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant_3 "grid의 layout 관리에 관여
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout_3 " Grid의 Cell의 선택 형식이나 필드 순서 등에 관여
        CHANGING
          it_outtab       = gt_stock_item  "Grid에 Display될 Data를 가진 Itab.
          it_fieldcatalog = gt_fcat_3. "Grid에 Display될 Field들의 목록
  
    ENDIF.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_fcat3  USING    pv_key pv_field pv_text pv_ref_table pv_ref_field  pv_length.
  
    gs_fcat_3-key       = pv_key.
    gs_fcat_3-fieldname = pv_field.
    gs_fcat_3-coltext   = pv_text.
    gs_fcat_3-ref_table = pv_ref_table.
    gs_fcat_3-ref_field = pv_ref_field.
    gs_fcat_3-outputlen = pv_length.
  
    CASE pv_field.
      WHEN 'STCKQ' OR 'RQQTY'.
        gs_fcat_3-qfieldname = 'UNIT'.
    ENDCASE.
  
    APPEND gs_fcat_3 TO gt_fcat_3.
    CLEAR gs_fcat_3.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh_grid3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_grid3 .
    gs_stable_3-row = 'X'.
    gs_stable_3-col = 'X'.
  
    CALL METHOD gcl_grid_3->refresh_table_display
      EXPORTING
        is_stable      = gs_stable_3
        i_soft_refresh = space.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form message
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM message .
  
    DATA: lv_id      TYPE icon-id,
          lv_str(30).
  
    TABLES: icon.
  
  
    SELECT SINGLE id
     FROM icon
     INTO lv_id
     WHERE name = 'ICON_MESSAGE_WARNING'.
  
    CONCATENATE lv_id '오더 수량을 수정해주세요.' INTO lv_str SEPARATED BY space.
  
    CALL FUNCTION 'POPUP_TO_INFORM'
      EXPORTING
        titel = '경고'
        txt1  = lv_str
        txt2  = '- 원자재 수량이 부족합니다.'.
  
  
  
  ENDFORM.