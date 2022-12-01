*&---------------------------------------------------------------------*
*& Include          ZC2PPR2001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_mealkit_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_mealkit_data .

    SELECT matrc matrnm unit warehscd wcid
      INTO CORRESPONDING FIELDS OF TABLE gt_mkit
      FROM  ztc2md2006
      WHERE matrtype = 'CP'.
  
      SORT gt_mkit BY matrc ASCENDING.
  
  ENDFORM.
  
  *&---------------------------------------------------------------------*
  *& Form get_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_list_data.
  
    CLEAR: gs_list, gt_list.
  
    SELECT c~matrc c~matrnm a~sdplqty c~unit
      INTO CORRESPONDING FIELDS OF TABLE gt_list
      FROM ztc2sd2002 AS a
  
      INNER JOIN ztc2sd2001 AS b
       ON   a~plant = b~plant
       AND  a~cmpnc = b~cmpnc
       AND a~sdplno = b~sdplno
  
      INNER JOIN ztc2md2006 AS c
       ON  a~cmpnc  = c~cmpnc
      AND  a~prodcd = c~matrc
  
      WHERE b~plnym = pa_plnym.
  
    LOOP AT gt_list INTO gs_list.
  
      gs_list-sdplqty = gs_list-sdplqty * 10.
      gs_list-ppquan  = gs_list-sdplqty * '1.05' . "재고량 고려하여.
  
      MODIFY gt_list FROM gs_list.
  
    ENDLOOP.
  
    SORT gt_list BY matrc ASCENDING.
  
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
  
    DATA: lv_domain TYPE dcobjdef-name,
          lv_value  TYPE dd07v-domvalue_l,
          lv_text   TYPE dd07v-ddtext,
          ls_color  TYPE lvc_s_scol,
          lv_tabix  TYPE sy-tabix.
  
    lv_domain = 'ZDC2PP_PPSTAT'.
  
    CLEAR: gs_header, gt_header.
  
    SELECT plant ppnum plnym createid cdate updateid udate ddate retnr ppstat cmpnc
      INTO CORRESPONDING FIELDS OF TABLE gt_header
      FROM  ztc2pp2004
      WHERE plnym IN so_year.
  
  
    LOOP AT gt_header INTO gs_header.
      lv_tabix = sy-tabix.
      lv_value = gs_header-ppstat.
  
      CALL FUNCTION 'ISU_DOMVALUE_TEXT_GET'
        EXPORTING
          x_name  = lv_domain
          x_value = lv_value
        IMPORTING
          y_text  = lv_text.
  
      gs_header-statext = lv_text.
  
      MODIFY gt_header FROM gs_header INDEX lv_tabix TRANSPORTING statext.
  
      CLEAR ls_color.
  
  
      CASE gs_header-ppstat.
        WHEN '10'.
          ls_color-fname = 'STATEXT'.
          ls_color-color-col = '3'.
          ls_color-color-int = '0'.
          ls_color-color-inv = '0'.
          APPEND ls_color TO gs_header-color.
          MODIFY gt_header FROM gs_header INDEX lv_tabix
          TRANSPORTING color.
  
        WHEN '11'.
          ls_color-fname = 'STATEXT'.
          ls_color-color-col = '7'.
          ls_color-color-int = '0'.
          ls_color-color-inv = '0'.
          APPEND ls_color TO gs_header-color.
          MODIFY gt_header FROM gs_header INDEX lv_tabix
          TRANSPORTING color.
  
        WHEN '12'.
          ls_color-fname = 'STATEXT'.
          ls_color-color-col = '5'.
          ls_color-color-int = '0'.
          ls_color-color-inv = '0'.
          APPEND ls_color TO gs_header-color.
          MODIFY gt_header FROM gs_header INDEX lv_tabix
          TRANSPORTING color.
  
        WHEN '13'.
          ls_color-fname = 'STATEXT'.
          ls_color-color-col = '6'.
          ls_color-color-int = '0'.
          ls_color-color-inv = '0'.
          APPEND ls_color TO gs_header-color.
          MODIFY gt_header FROM gs_header INDEX lv_tabix
          TRANSPORTING color.
  
      ENDCASE.
  
    ENDLOOP.
  
    SORT gt_header BY plnym ASCENDING.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_item_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        tex
  *&---------------------------------------------------------------------*
  FORM get_item_data USING pv_ppnum TYPE ztc2pp2004-ppnum
                           pv_plnym TYPE ztc2pp2004-plnym.
  
    CLEAR: gs_item, gt_item.
  
    SELECT a~mkits e~matrnm a~ppquan a~unit e~wcid a~ppnum a~cmpnc
      INTO CORRESPONDING FIELDS OF TABLE gt_item
      FROM ztc2pp2005 AS a
  
      INNER JOIN ztc2pp2004 AS b
       ON a~cmpnc = b~cmpnc
      AND a~plant = b~plant
      AND a~ppnum = b~ppnum
  
     INNER JOIN ztc2md2006 AS e
      ON a~cmpnc = e~cmpnc
     AND a~mkits = e~matrc
  
    WHERE a~ppnum = pv_ppnum.
  
    IF sy-subrc <> 0.
      MESSAGE s000 WITH TEXT-m02 DISPLAY LIKE 'E'.
    ENDIF.
  
    SORT gt_item BY mkits+2(4) ASCENDING.
  
    PERFORM refresh_grid_2.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form MODE_CHANGE
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
  
      CASE 'X'.
        "pa_rd2 관련 필드 안보이게
        WHEN pa_rd1.
          title1 = '계획 생성'.
          CASE screen-group1.
            WHEN 'MD3'.
              screen-active = 0.
              MODIFY SCREEN.
          ENDCASE.
  
        "pa_rd1 관련 필드 안보이게
        WHEN pa_rd2.
          title1 = '조회 및 수정'.
          CASE screen-group1.
            WHEN 'MD2'.
              screen-active = 0.
              MODIFY SCREEN.
          ENDCASE.
  
      ENDCASE.
    ENDLOOP.
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
  
    PERFORM set_fcat_mkit USING :
  
         'X'  'MATRC'    '제품코드'  'ZTC2MD2006' 'MATRC' ,
         ' '  'MATRNM'   '제품명'   'ZTC2MD2006' 'MATRNM',
         ' '  'WCID'     '작업장'   'ZTC2MD2006' 'WCID' ,
         ' '  'WAREHSCD' '창고코드'    'ZTC2MD2006' 'WAREHSCD' ,
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
  *& Form set_fcat_sd_layout
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_sd_layout .
  
    gs_layout_sd-zebra      = 'X'.
    gs_layout_sd-sel_mode   = 'D'.
    gs_layout_sd-cwidth_opt = 'X'.
    gs_layout_sd-no_toolbar = 'X'.
  
    PERFORM set_fcat_sd USING :
  
         'X'  'MATRC'    '제품코드'   'ZTC2MD2006' 'MATRC' 7,
         ' '  'MATRNM'   '제품명'     'ZTC2MD2006' 'MATRNM' 22,
         ' '  'SDPLQTY'  '판매계획수량' 'ZTC2SD2002' 'SDPLQTY' 10,
         ' '  'PPQUAN'   '생산계획수량' 'ZTC2PP2005' 'PPQUAN' 10,
         ' '  'UNIT'     '단위'      'ZTC2MD2006' 'UNIT' 3.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_sd
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_fcat_sd  USING pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length.
  
    gs_fcat_sd-key       = pv_key.
    gs_fcat_sd-fieldname = pv_field.
    gs_fcat_sd-coltext   = pv_text.
    gs_fcat_sd-ref_table = pv_ref_table.
    gs_fcat_sd-ref_field = pv_ref_field.
    gs_fcat_sd-outputlen = pv_length.
  
    CASE pv_field.
      WHEN 'SDPLQTY'.
        gs_fcat_sd-qfieldname = 'UNIT'.
      WHEN 'PPQUAN'.
        gs_fcat_sd-qfieldname = 'UNIT'.
        gs_fcat_sd-edit      = 'X'.
    ENDCASE.
  
    APPEND gs_fcat_sd TO gt_fcat_sd.
    CLEAR gs_fcat_sd.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_sd
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_sd .
  
    IF gcl_container_sd IS NOT BOUND.
  
      CREATE OBJECT gcl_container_sd "클래스 안에 상수로 선언 되어있음.
        EXPORTING
          container_name = 'GCL_CONTAINER_SD'. "현재 스크린 번호
  
  
      CREATE OBJECT gcl_grid_sd
        EXPORTING
          i_parent = gcl_container_sd.
  
      CLEAR gs_layout_sd-cwidth_opt.
  
      CALL METHOD gcl_grid_sd->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant_sd
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout_sd
        CHANGING
          it_outtab       = gt_list
          it_fieldcatalog = gt_fcat_sd.
    ENDIF.
  
  ENDFORM.
  
  *&---------------------------------------------------------------------*
  *& Form set_input
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_input .
  
    title1 = '계획 생성'.
  
    DATA: lv_data LIKE sy-datum.
  
    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = sy-datum     "-> 기준일
        days      = '00'     "-> 더하거나 뺄 일자수
        months    = '01'     "-> 더하거나 뺄 월수
        years     = '00'     "-> 더하거나 뺄 년수
        signum    = '+'     "-> 더할지 뺄지를 정하는 기호
      IMPORTING
        calc_date = lv_data. "-> 계산된 날짜 (SY-DATUM)
  
    CONCATENATE lv_data(6)'' INTO pa_plnym.
  
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
  
    gs_stable_sd-row = 'X'.
    gs_stable_sd-col = 'X'.
  
    DATA: lv_input TYPE i.
  
    CALL METHOD gcl_grid_sd->refresh_table_display
      EXPORTING
        is_stable      = gs_stable_sd
        i_soft_refresh = space.
  
      lv_input = 1.
  
    CALL METHOD gcl_grid_sd->set_ready_for_input
      EXPORTING
        i_ready_for_input = lv_input.
  
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
  
    CLEAR : gs_row, gs_list.
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
        READ TABLE gt_list INTO gs_list WITH KEY matrc = gs_mkit-matrc.
  
  
  "delete한 후에 다시 add할 경우 추가 될 수 있도록..
  
        CASE gs_mkit-matrc.
          WHEN gs_list-matrc.
            MESSAGE s005 WITH TEXT-m02 DISPLAY LIKE 'E'.
            EXIT.
  
          WHEN OTHERS.
            MOVE-CORRESPONDING gs_mkit TO gs_list.
            APPEND gs_list TO gt_list.
        ENDCASE.
  
      ENDLOOP.
    ENDIF.
  
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
  *& Form delete_row
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM delete_row .
  
    CLEAR : gs_row, gs_item, gs_item_del.
    REFRESH : gt_rows, gt_item, gt_item_del.
  
    CALL METHOD gcl_grid_sd->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    IF gt_rows IS INITIAL.
      MESSAGE s005 WITH TEXT-m01 DISPLAY LIKE 'E'.
      EXIT.
    ELSE.
      SORT gt_rows BY index DESCENDING.
  
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_list INTO gs_list INDEX gs_row-index.
        MOVE-CORRESPONDING gs_list TO gs_list_del.
  
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
  
        APPEND gs_list_del TO gt_list_del.
        CLEAR gs_list_del.
  
        DELETE gt_list INDEX gs_row-index.
  
  
      ENDLOOP.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_1_layout
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_1_layout .
  
    gs_layout_1-zebra      = 'X'.
    gs_layout_1-sel_mode   = 'D'.
    gs_layout_1-cwidth_opt = 'X'.
    gs_layout_1-no_toolbar = 'X'.
    gs_layout_1-ctab_fname = 'COLOR'.
  
    PERFORM set_fcat_1 USING :
  
         "'X'  'PPSTAT'   '' 'ZTC2PP2004' 'PPSTAT' ,
         'X'  'STATEXT'  '상태' 'GT_HEADER' 'STATEXT' 7,
         'X'  'PLANT'    '' 'ZTC2PP2004' 'PLANT'  4,
         'X'  'PPNUM'    '' 'ZTC2PP2004' 'PPNUM'  10,
         ' '  'PLNYM'    '' 'ZTC2PP2004' 'PLNYM'  8,
         ' '  'CREATEID' '' 'ZTC2PP2004' 'CREATEID' 8,
         ' '  'CDATE'    '생성일자' 'ZTC2PP2004' 'CDATE'   8,
         ' '  'UPDATEID' '' 'ZTC2PP2004' 'UPDATEID' 7,
         ' '  'UDATE'    '수정일자' 'ZTC2PP2004' 'UDATE'   9,
         ' '  'DDATE'    '' 'ZTC2PP2004' 'DDATE' 9, "이거 나중에 text 지워보기
         ' '  'RETNR'    '' 'ZTC2PP2004' 'RETNR' 20.
  
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
  FORM set_fcat_1  USING  pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length.
  
    gs_fcat_1-key       = pv_key.
    gs_fcat_1-fieldname = pv_field.
    gs_fcat_1-coltext   = pv_text.
    gs_fcat_1-ref_table = pv_ref_table.
    gs_fcat_1-ref_field = pv_ref_field.
    gs_fcat_1-outputlen = pv_length.
  
  
    APPEND gs_fcat_1 TO gt_fcat_1.
    CLEAR gs_fcat_1.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_1
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_1 .
  
    IF gcl_container_1 IS NOT BOUND.
  
      CREATE OBJECT gcl_container_1 "클래스 안에 상수로 선언 되어있음.
        EXPORTING
          container_name = 'GCL_CONTAINER_1'. "현재 스크린 번호
  
  
      CREATE OBJECT gcl_grid_1
        EXPORTING
          i_parent = gcl_container_1.
  
      CREATE OBJECT gcl_handler.
      SET HANDLER : gcl_handler->handle_db_click FOR gcl_grid_1.
  
      CLEAR gs_layout_1-cwidth_opt.
      CALL METHOD gcl_grid_1->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant_1 "grid의 layout 관리에 관여
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout_1 " Grid의 Cell의 선택 형식이나 필드 순서 등에 관여
        CHANGING
          it_outtab       = gt_header  "Grid에 Display될 Data를 가진 Itab.
          it_fieldcatalog = gt_fcat_1. "Grid에 Display될 Field들의 목록
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_2_layout
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_2_layout .
  
    gs_layout_2-zebra      = 'X'.
    gs_layout_2-sel_mode   = 'D'.
    gs_layout_2-cwidth_opt = 'X'.
    gs_layout_2-no_toolbar = 'X'.
  
    PERFORM set_fcat_2 USING :
  
         'X'  'MKITS'   '제품코드' 'ZTC2PP2004' 'MKITS' 7,
         ' '  'MATRNM'  '제품명'  'ZTC2MD2006' 'MATRNM'  22,
         ' '  'PPQUAN'  '수량'   'ZTC2PP2005' 'PPQUAN'  4,
         ' '  'UNIT'    '단위'   'ZTC2PP2005' 'UNIT' 3,
         ' '  'WCID'    '작업장'  'ZTC2MD2006' 'WCID' 4.
  
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
  FORM set_fcat_2  USING   pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length.
  
    gs_fcat_2-key       = pv_key.
    gs_fcat_2-fieldname = pv_field.
    gs_fcat_2-coltext   = pv_text.
    gs_fcat_2-ref_table = pv_ref_table.
    gs_fcat_2-ref_field = pv_ref_field.
    gs_fcat_2-outputlen = pv_length.
  
    CASE pv_field.
      WHEN 'PPQUAN'.
        gs_fcat_2-qfieldname = 'UNIT'.
        gs_fcat_2-edit       = 'X'.
    ENDCASE.
  
    APPEND gs_fcat_2 TO gt_fcat_2.
    CLEAR gs_fcat_2.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_2 .
  
    IF gcl_container_2 IS NOT BOUND.
  
      CREATE OBJECT gcl_container_2
        EXPORTING
          container_name = 'GCL_CONTAINER_2'.
  
      CREATE OBJECT gcl_grid_2
        EXPORTING
          i_parent = gcl_container_2.
  
      CLEAR gs_layout_2-cwidth_opt.
  
      CALL METHOD gcl_grid_2->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant_2 "grid의 layout 관리에 관여
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout_2 " Grid의 Cell의 선택 형식이나 필드 순서 등에 관여
        CHANGING
          it_outtab       = gt_item  "Grid에 Display될 Data를 가진 Itab.
          it_fieldcatalog = gt_fcat_2. "Grid에 Display될 Field들의 목록
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh_grid_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_grid_2 .
  
    gs_stable_2-row = 'X'.
    gs_stable_2-col = 'X'.
    CLEAR gs_fcat_2-edit.
  
    CALL METHOD gcl_grid_2->refresh_table_display
      EXPORTING
        is_stable      = gs_stable_2
        i_soft_refresh = space.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form add_row_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM add_row_2 .
    CLEAR : gs_row, gs_item.
    REFRESH : gt_rows, gt_click.
  
  
    IF gt_item IS INITIAL.
      MESSAGE s005 WITH TEXT-001 DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
  
    CASE gs_header-ppstat.
      WHEN '11' OR '12'.
        MESSAGE s005 WITH TEXT-010 DISPLAY LIKE 'E'.
        EXIT.
    ENDCASE.
  
    CALL METHOD gcl_grid_mkit->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    CALL METHOD gcl_grid_1->get_selected_rows
      IMPORTING
        et_index_rows = gt_click.
  
    IF gt_rows IS INITIAL.
  
      MESSAGE s005 WITH TEXT-m01 DISPLAY LIKE 'E'.
      EXIT.
  
    ELSE.
  
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_mkit INTO gs_mkit INDEX gs_row-index.
        READ TABLE gt_item INTO gs_item WITH KEY mkits = gs_mkit-matrc.
  
        IF gs_mkit-matrc <> gs_item-mkits.
          gs_item-mkits = gs_mkit-matrc.
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
  *& Form delete_row_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM delete_row_2 .
    CLEAR gs_row.
    REFRESH gt_rows.
  
  
    CASE gs_header-ppstat.
      WHEN '11' OR '12'.
        MESSAGE s005 WITH TEXT-010 DISPLAY LIKE 'E'.
        EXIT.
    ENDCASE.
  
    CALL METHOD gcl_grid_2->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    IF gt_rows IS INITIAL.
      MESSAGE s005 WITH TEXT-m01 DISPLAY LIKE 'E'.
      EXIT.
    ELSE.
      SORT gt_rows BY index DESCENDING.
  
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_item INTO gs_list INDEX gs_row-index.
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
  *& Form handle_double_click
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> E_ROW
  *&      --> E_COLUMN
  *&---------------------------------------------------------------------*
  FORM handle_db_click  USING   ps_row    TYPE lvc_s_row
                                ps_column TYPE lvc_s_col.
  
    DATA : lv_input TYPE i.
  
    READ TABLE gt_header INTO gs_header INDEX ps_row-index.
  
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  
    CASE gs_header-ppstat.
      WHEN '10'.
        lv_input = 1.
  
      WHEN '11'.
        lv_input = 0.
  
      WHEN '12'.
        lv_input = 0.
  
      WHEN '13'.
        lv_input = 1.
  
    ENDCASE.
  
    CALL METHOD gcl_grid_2->set_ready_for_input
      EXPORTING
        i_ready_for_input = lv_input.
  
    PERFORM get_item_data USING gs_header-ppnum gs_header-plnym.
  
  
  
  
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
  
    CLEAR: gs_header, gt_header.
  
    IF gs_list IS INITIAL.
      MESSAGE s005 WITH TEXT-m04 DISPLAY LIKE 'E'.
      EXIT.
  
    ELSEIF pa_plnym IS INITIAL.
      MESSAGE s005 WITH TEXT-m09 DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
  
    PERFORM create_order_number.
  
    DATA: ls_order TYPE ztc2pp2004,
          lt_order LIKE TABLE OF ls_order,
          ls_list  TYPE ztc2pp2005,
          lt_list  LIKE TABLE OF ls_list,
          lv_cnt   TYPE i,
          lv_input TYPE i.
  
    CALL METHOD gcl_grid_sd->check_changed_data.
  
    ls_order-cmpnc = '1004'.
    ls_order-plant = '1000'.
    ls_order-ppnum = gv_plnym.
    ls_order-plnym = pa_plnym.
    ls_order-cdate = sy-datum.
    ls_order-ppstat = '10'.
    ls_order-createid = sy-uname.
  
    APPEND ls_order TO lt_order.
  
    LOOP AT gt_list INTO gs_list.
  
      ls_list-cmpnc  = ls_order-cmpnc.
      ls_list-plant  = ls_order-plant.
      ls_list-ppnum  = ls_order-ppnum.
      ls_list-mkits  = gs_list-matrc.
      ls_list-ppquan = gs_list-ppquan.
      ls_list-unit   = gs_list-unit.
  
      APPEND ls_list TO lt_list.
    ENDLOOP.
    MOVE-CORRESPONDING lt_list TO gt_ppitem.
  
    REFRESH gt_list_del.
  
    IF sy-dbcnt <> 0.
      lv_cnt += sy-dbcnt.
    ENDIF.
  
    MODIFY ztc2pp2004 FROM TABLE lt_order.
    MODIFY ztc2pp2005 FROM TABLE gt_ppitem.
  
    IF  lv_cnt > 0.
      COMMIT WORK AND WAIT.
      MESSAGE s006 WITH ls_order-ppnum.
  
    ELSE.
      lv_cnt = 0.
      ROLLBACK WORK.
      MESSAGE s005 WITH TEXT-m02.
  
    ENDIF.
  
    REFRESH : gt_list.
  
    lv_input = 0.
  
    CALL METHOD gcl_grid_sd->set_ready_for_input
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
  
    DATA: lv_ppnum   TYPE ztc2pp2004-ppnum,
          lv_plym    TYPE ztc2pp2004-plnym,
          lv_word(4) TYPE c.
  
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'ZPPNUM'
      IMPORTING
        number                  = lv_ppnum
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        OTHERS                  = 7.
  
    lv_word = pa_plnym+2(4).                                  "202209
  
    CONCATENATE 'PP' lv_word lv_ppnum INTO lv_ppnum.
  
    gs_header-ppnum  = lv_ppnum.
    gv_plnym         = lv_ppnum.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh_grid_1
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_grid_1 .
  
    gs_stable_1-row = 'X'.
    gs_stable_1-col = 'X'.
  
    CALL METHOD gcl_grid_1->refresh_table_display
      EXPORTING
        is_stable      = gs_stable_1
        i_soft_refresh = space.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form request_order
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM request_order .
  
    DATA : lv_tabix  TYPE sy-tabix,
           ls_color  TYPE lvc_s_scol,
           lv_answer TYPE c LENGTH 1,
           ls_data   TYPE ztc2pp2004,
           lt_data   LIKE TABLE OF ls_data,
           lv_domain TYPE dcobjdef-name,
           lv_value  TYPE dd07v-domvalue_l,
           lv_text   TYPE dd07v-ddtext,
           lv_date   TYPE sy-datum,
           lv_write  TYPE string,
           lv_input  TYPE i.
  
    lv_domain = 'ZDC2PP_PPSTAT'.
    lv_date   = sy-datum.
  
    CLEAR : gs_row, ls_color.
    REFRESH gt_rows.
  
  
    CALL METHOD gcl_grid_1->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    IF gt_rows IS INITIAL.
      MESSAGE s005 WITH TEXT-m01 DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
  
    LOOP AT gt_rows INTO gs_row.
      READ TABLE gt_header INTO gs_header INDEX gs_row-index.
  
      CASE gs_header-ppstat.
          WHEN '11'.
          MESSAGE e005 WITH TEXT-m03.
          EXIT.
      ENDCASE.
    ENDLOOP.
  
    CONCATENATE '[생산계획번호 :' gs_header-ppnum ']' '승인요청을 진행하시겠습니까?' INTO lv_write.
  
    CALL FUNCTION 'POPUP_TO_CONFIRM' " 승인요청시 메세지 팝업창.
      EXPORTING
        titlebar              = '승인요청'
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
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_header INTO gs_header INDEX gs_row-index.
  
        CASE gs_header-ppstat.
          WHEN '10'.
            gs_header-ppstat = '11'.
            gs_header-ddate  = lv_date.
        ENDCASE.
  
        MODIFY gt_header FROM gs_header INDEX gs_row-index
        TRANSPORTING ppstat ddate.
  
        MOVE-CORRESPONDING gs_header TO ls_data.
        APPEND ls_data TO lt_data.
  
      ENDLOOP.
      "
      LOOP AT gt_header INTO gs_header.
        lv_tabix = sy-tabix.
        lv_value = gs_header-ppstat.
  
        CALL FUNCTION 'ISU_DOMVALUE_TEXT_GET'
          EXPORTING
            x_name  = lv_domain
            x_value = lv_value
          IMPORTING
            y_text  = lv_text.
  
        gs_header-statext = lv_text.
  
        MODIFY gt_header FROM gs_header INDEX lv_tabix TRANSPORTING statext.
  
        CLEAR ls_color.
        ls_color-fname = 'STATEXT'.
        ls_color-color-int = '0'.
        ls_color-color-inv = '0'.
  
        CLEAR gs_header-color.
  
        CASE gs_header-ppstat.
          WHEN '10'.
            ls_color-color-col = '3'.
            APPEND ls_color TO gs_header-color.
            MODIFY gt_header FROM gs_header INDEX lv_tabix
            TRANSPORTING color.
  
          WHEN '11'.
            ls_color-color-col = '7'.
            APPEND ls_color TO gs_header-color.
            MODIFY gt_header FROM gs_header INDEX lv_tabix
            TRANSPORTING color.
  
          WHEN '12'.
            ls_color-color-col = '5'.
            APPEND ls_color TO gs_header-color.
            MODIFY gt_header FROM gs_header INDEX lv_tabix
            TRANSPORTING color.
  
          WHEN '13'.
            ls_color-color-col = '6'.
            APPEND ls_color TO gs_header-color.
            MODIFY gt_header FROM gs_header INDEX lv_tabix
            TRANSPORTING color.
  
        ENDCASE.
  
      ENDLOOP.
  
      MODIFY ztc2pp2004 FROM TABLE lt_data.
  
      IF sy-dbcnt > 0.
        COMMIT WORK AND WAIT.
        MESSAGE s005 WITH '승인이 요청되었습니다.'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE s003 DISPLAY LIKE 'E'.
      ENDIF.
  
    ELSE.
      MESSAGE s005 WITH '취소되었습니다'.
    ENDIF.
  
  
      lv_input = 0.
  
    CALL METHOD gcl_grid_2->set_ready_for_input
      EXPORTING
        i_ready_for_input = lv_input.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form save_order
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM save_order.
  
    DATA: ls_save   TYPE ztc2pp2005,
          lt_save   LIKE TABLE OF ls_save,
          ls_read   TYPE ztc2pp2005,
          lv_tabix  TYPE sy-tabix,
          lv_ppnum  TYPE ztc2pp2005-ppnum,
          ls_header TYPE ztc2pp2004,
          lt_header LIKE TABLE OF ls_header,
          lv_udate  TYPE sy-datum,
          lv_user   TYPE sy-uname,
          lv_answer TYPE c LENGTH 1,
          lv_text   TYPE string.
  
    lv_udate = sy-datum.
    lv_user  = sy-uname.
  
    IF gt_item IS INITIAL.
      MESSAGE e005 WITH '저장할 데이터가 없습니다.'.
    ENDIF.
  
    READ TABLE gt_item INTO gs_item INDEX 1.
    CONCATENATE '[생산계획번호 :' gs_item-ppnum ']' '저장하시겠습니까?' INTO lv_text.
  
    CALL FUNCTION 'POPUP_TO_CONFIRM' " 승인요청시 메세지 팝업창.
      EXPORTING
        titlebar              = '계획저장'
        text_question         = lv_text
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
  
    CALL METHOD gcl_grid_2->check_changed_data.
  
    READ TABLE gt_item INTO gs_item INDEX 1.
    lv_ppnum = gs_item-ppnum.
    LOOP AT gt_item INTO gs_item.
      lv_tabix = sy-tabix.
      MOVE-CORRESPONDING gs_item TO ls_save.
      ls_save-cmpnc = '1004'.
      ls_save-plant = '1000'.
      ls_save-ppnum = lv_ppnum.
  
      APPEND ls_save TO lt_save.
  
    ENDLOOP.
  
    MODIFY ztc2pp2005 FROM TABLE lt_save.
  
    LOOP AT gt_header INTO gs_header.
  
      IF ls_save-ppnum = gs_header-ppnum.
        gs_header-udate    = lv_udate.
        gs_header-updateid = lv_user.
  
        CASE gs_header-ppstat.
          WHEN '11'.
            MESSAGE e005 WITH '수정이 불가능한 상태입니다.'.
          WHEN '12'.
            MESSAGE e005 WITH '수정이 불가능한 상태입니다.'.
        ENDCASE.
      ENDIF.
  
      MOVE-CORRESPONDING gs_header TO ls_header.
      APPEND ls_header TO lt_header.
  
      MODIFY ztc2pp2004 FROM TABLE lt_header.
  
      IF sy-dbcnt > 0 .
        COMMIT WORK AND WAIT.
        MESSAGE s000.
      ENDIF.
  
      PERFORM get_header_data.
  
    ENDLOOP.
  
    ELSE.
      MESSAGE s005 WITH '취소되었습니다'.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form vaild_date_check
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM vaild_date_check .
  
    IF pa_plnym+4(2) > 13 OR pa_plnym+4(2) < 1.
      MESSAGE '유효한 날짜를 입력하세요.' TYPE 'E'.
    ENDIF.
  
  ENDFORM.