*&---------------------------------------------------------------------*
*& Include          ZC2PPR2002_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_input
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_input .

    title1 = '생산 오더 생성'.
  
    DATA: lv_data LIKE sy-datum.
    lv_data = sy-datum.
    pa_start = lv_data.
  
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
  
    cdate = sy-datum.
    createid = sy-uname.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_mealkit_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_mealkit_data .
  
    DATA: lv_tabix TYPE sy-tabix,
          ls_color TYPE lvc_s_scol.
  
    SELECT a~cmpnc a~matrc a~matrnm a~wcid a~warehscd b~stckq a~saveq a~unit
      INTO CORRESPONDING FIELDS OF TABLE gt_mkit
        FROM  ztc2md2006 AS a
          INNER JOIN ztc2mm2001 AS b
            ON a~cmpnc = b~cmpnc
           AND a~warehscd = b~warehscd
           AND a~matrc = b~matrc
       WHERE a~matrtype = 'CP'.
  
    LOOP AT gt_mkit INTO gs_mkit.
  
      lv_tabix = sy-tabix.
  
      CLEAR ls_color.
  
      ls_color-fname = 'STCKQ'.
      ls_color-color-int = '0'.
      ls_color-color-inv = '0'.
      IF gs_mkit-stckq <= gs_mkit-saveq.
        ls_color-color-col = '6'.
  
      ELSE.
        ls_color-color-col = '5'.
      ENDIF.
      APPEND ls_color TO gs_mkit-color.
  
      MODIFY gt_mkit FROM gs_mkit INDEX lv_tabix
      TRANSPORTING color.
    ENDLOOP.
  
    IF sy-subrc <> 0.
      MESSAGE s003.
      LEAVE LIST-PROCESSING.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_mkit_layout
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_mkit_layout .
  
    gs_layout_mkit-zebra      = 'X'.
    gs_layout_mkit-sel_mode   = 'D'.
    gs_layout_mkit-cwidth_opt = 'X'.
    gs_layout_mkit-no_toolbar = 'X'.
    gs_layout_mkit-ctab_fname = 'COLOR'.
  
    PERFORM set_fcat_mkit USING :
  
         'X'  'MATRC'    '제품코드'  'ZTC2MD2006' 'MATRC' ,
         ' '  'MATRNM'   '제품명'   'ZTC2MD2006' 'MATRNM',
         ' '  'WCID'     ''       'ZTC2MD2006' 'WCID'  ,
         ' '  'STCKQ'    '가용재고량'       'ZTC2MM2001' 'STCKQ' ,
         ' '  'SAVEQ'    '안전재고량'       'ZTC2MD2006' 'SAVEQ' ,
         ' '  'UNIT'     '단위'    'ZTC2MD2006' 'UNIT'.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_mkit
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_fcat_mkit  USING pv_key pv_field pv_text pv_ref_table pv_ref_field.
  
    gs_fcat_mkit-key       = pv_key.
    gs_fcat_mkit-fieldname = pv_field.
    gs_fcat_mkit-coltext   = pv_text.
    gs_fcat_mkit-ref_table = pv_ref_table.
    gs_fcat_mkit-ref_field = pv_ref_field.
  
    CASE pv_field.
      WHEN 'SAVEQ'.
        gs_fcat_mkit-qfieldname = 'UNIT'.
      WHEN 'STCKQ'.
        gs_fcat_mkit-qfieldname = 'UNIT'.
    ENDCASE.
  
    APPEND gs_fcat_mkit TO gt_fcat_mkit.
    CLEAR gs_fcat_mkit.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_mkit
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_mkit .
  
    IF gcl_container_mkit IS NOT BOUND.
  
      CREATE OBJECT gcl_container_mkit "클래스 안에 상수로 선언 되어있음.
        EXPORTING
          container_name = 'GCL_CONTAINER_MKIT'. "현재 스크린 번호
  
  
      CREATE OBJECT gcl_grid_mkit
        EXPORTING
          i_parent = gcl_container_mkit.
  
      CALL METHOD gcl_grid_mkit->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant_mkit "grid의 layout 관리에 관여
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout_mkit " Grid의 Cell의 선택 형식이나 필드 순서 등에 관여
        CHANGING
          it_outtab       = gt_mkit "Grid에 Display될 Data를 가진 Itab.
          it_fieldcatalog = gt_fcat_mkit. "Grid에 Display될 Field들의 목록
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_item_layout
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_item_layout .
  
    gs_layout_item-zebra      = 'X'.
    gs_layout_item-sel_mode   = 'D'.
    gs_layout_item-cwidth_opt = 'X'.
    gs_layout_item-no_toolbar = 'X'.
  
    PERFORM set_fcat_item USING :
  
         'X'  'MATRC'    '제품코드'  'ZTC2MD2006' 'MATRC'   8,
         ' '  'MATRNM'   '제품명'   'ZTC2MD2006' 'MATRNM'  22,
         ' '  'POQUAN'   ''       'ZTC2PP2007' 'POQUAN'  10,
         ' '  'UNIT'     '단위'    'ZTC2MD2006' 'UNIT'    3,
         ' '  'WCID'     ''       'ZTC2MD2006' 'WCID'    8,
         ' '  'WAREHSCD' ''       'ZTC2MD2006' 'WAREHSCD' 5.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_item
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_fcat_item  USING  pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length.
  
    gs_fcat_item-key       = pv_key.
    gs_fcat_item-fieldname = pv_field.
    gs_fcat_item-coltext   = pv_text.
    gs_fcat_item-ref_table = pv_ref_table.
    gs_fcat_item-ref_field = pv_ref_field.
    gs_fcat_item-outputlen = pv_length.
  
    CASE pv_field.
      WHEN 'POQUAN'.
        gs_fcat_item-qfieldname = 'UNIT'.
        gs_fcat_item-edit      = 'X'.
    ENDCASE.
  
    APPEND gs_fcat_item TO gt_fcat_item.
    CLEAR gs_fcat_item.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_item
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_item .
    IF gcl_container_item IS NOT BOUND.
  
      CREATE OBJECT gcl_container_item "클래스 안에 상수로 선언 되어있음.
        EXPORTING
          container_name = 'GCL_CONTAINER_ITEM'. "현재 스크린 번호
  
  
      CREATE OBJECT gcl_grid_item
        EXPORTING
          i_parent = gcl_container_item.
  
      CLEAR gs_layout_item-cwidth_opt.
  
      CALL METHOD gcl_grid_item->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant_item "grid의 layout 관리에 관여
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout_item " Grid의 Cell의 선택 형식이나 필드 순서 등에 관여
        CHANGING
          it_outtab       = gt_item "Grid에 Display될 Data를 가진 Itab.
          it_fieldcatalog = gt_fcat_item. "Grid에 Display될 Field들의 목록
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_input_mode
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_input_mode .
  
    LOOP AT SCREEN.
      IF screen-name = 'PA_PLANT'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  
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
  
    DATA: ls_mkit LIKE gs_mkit,
          lt_mkit LIKE TABLE OF ls_mkit.
  
    CLEAR : gs_row, gs_item.
    REFRESH : gt_rows.
  
    CALL METHOD gcl_grid_mkit->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    IF gt_rows IS INITIAL.
  
      MESSAGE s005 WITH TEXT-m01 DISPLAY LIKE 'E'.
      EXIT.
  
    ELSE.
  
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_mkit INTO gs_mkit INDEX gs_row-index.
        READ TABLE gt_item INTO gs_item WITH KEY matrc = gs_mkit-matrc.
  
        IF gs_mkit-matrc <> gs_item-matrc.
          MOVE-CORRESPONDING gs_mkit TO gs_item.
          APPEND gs_item TO gt_item.
  
        ELSE.
          MESSAGE s005 WITH TEXT-m02 DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDLOOP.
  
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
  
    gs_stable_item-row = 'X'.
    gs_stable_item-col = 'X'.
  
    CALL METHOD gcl_grid_item->refresh_table_display
      EXPORTING
        is_stable      = gs_stable_item
        i_soft_refresh = space.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form create_order
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM create_order .
  
    DATA: ls_order TYPE ztc2pp2006,
          lt_order LIKE TABLE OF ls_order,
          ls_list  TYPE ztc2pp2007,
          lt_list  LIKE TABLE OF ls_list,
          lv_cnt   TYPE i,
          lv_input TYPE i,
          lv_error.
  
    "오더 시작일이 비어있을 때 진행 못하게
    IF pa_start IS INITIAL.
      MESSAGE s005 WITH TEXT-m01 DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
  
    CALL METHOD gcl_grid_item->check_changed_data.
  
    PERFORM create_order_number.
  
    LOOP AT gt_item INTO gs_item.
      "수량이 0 일 경우 진행 못하게
      IF gs_item-poquan IS INITIAL.
        MESSAGE s005 WITH TEXT-m10 DISPLAY LIKE 'E'.
        lv_error = 'X'.
        EXIT.
      ENDIF.
  
      " 그 이외에는 오더번호 자동 채번 되어야 함.
  
      gs_item-plant  = '1000'.
      gs_item-ponum  = gv_ponum.
      gs_item-postat = '20'.
  
      MOVE-CORRESPONDING gs_item TO ls_list.
        ls_list-mkits = gs_item-matrc.
  
      APPEND ls_list TO lt_list.
  
    ENDLOOP.
  
    CHECK lv_error IS INITIAL.
  
    MODIFY ztc2pp2007 FROM TABLE lt_list.
  
  
    MOVE-CORRESPONDING ls_list TO ls_order.
    ls_order-postart  = pa_start.
    ls_order-createid = sy-uname.
    ls_order-cdate = sy-datum.
  
    APPEND ls_order TO lt_order.
  
    IF sy-dbcnt <> 0.
      lv_cnt += sy-dbcnt.
    ENDIF.
  
    MODIFY ztc2pp2006 FROM TABLE lt_order.
  
  
    IF  lv_cnt > 0.
      COMMIT WORK AND WAIT.
      MESSAGE s007 WITH ls_order-ponum.
  
    ELSE.
      lv_cnt = 0.
      ROLLBACK WORK.
      MESSAGE s005 WITH TEXT-m02.
  
    ENDIF.
  
    REFRESH : gt_item.
  
    lv_input = 0.
  
    CALL METHOD gcl_grid_item->set_ready_for_input
      EXPORTING
        i_ready_for_input = lv_input.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form create_order_number
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM create_order_number .
  
    DATA: lv_ponum   TYPE ztc2pp2006-ponum,
          lv_word(4) TYPE c.
  
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'ZPONUM'
      IMPORTING
        number                  = lv_ponum
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        OTHERS                  = 7.
  
    lv_word = pa_start+2(4).                                  "202209
  
    CONCATENATE 'PO' lv_word lv_ponum INTO lv_ponum.
  
    gv_ponum         = lv_ponum.
  
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
  
    CALL METHOD gcl_grid_item->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    IF gt_rows IS INITIAL.
      MESSAGE s005 WITH TEXT-m01 DISPLAY LIKE 'E'.
      EXIT.
    ELSE.
      SORT gt_rows BY index DESCENDING.
  
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_item INTO gs_item INDEX gs_row-index.
        MOVE-CORRESPONDING gs_item TO gs_item_del.
  
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
  
        APPEND gs_item_del TO gt_item_del.
        CLEAR gs_item_del.
  
        DELETE gt_item INDEX gs_row-index.
      ENDLOOP.
    ENDIF.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh_header_info
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_header_info .
  
    CLEAR: pa_start, gv_ponum.
  
  ENDFORM.