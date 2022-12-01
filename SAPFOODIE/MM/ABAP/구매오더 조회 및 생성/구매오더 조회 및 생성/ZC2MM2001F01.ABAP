*&---------------------------------------------------------------------*
*& Include          ZC2MMR2001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_fcat_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
*FORM set_fcat_layout .
*
*
*
*ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layout_2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout_2 .
    gs_layout_2-zebra      = 'X'.
    gs_layout_2-cwidth_opt = 'X'.
    gs_layout_2-sel_mode   = 'D'.
    gs_layout_2-no_toolbar = 'X'.
  
    PERFORM set_fcat_2 USING :
  *       'X' 'CMPNC'       '' 'ZTC2MM2001' 'CMPNC',
  *       'X' 'PLANT'       '' 'ZTC2MM2001' 'PLANT',
         'X' 'WAREHSCD'    '' 'ZTC2MM2001' 'WAREHSCD',
         'X' 'MATRC'       '' 'ZTC2MM2001' 'MATRC',
         ''  'MATRNM'      '' 'ZTC2MD2006' 'MATRNM',
         ''  'STCKQ'       '' 'ZTC2MM2001' 'STCKQ',
         ''  'UNIT'        '' 'ZTC2MM2001' 'UNIT',
         ''  'MMPRICE'     '' 'ZTC2MD2006' 'MMPRICE',
         ''  'CURRENCY'    '' 'ZTC2MD2006' 'CURRENCY',
         ''  'VENDORC'     '' 'ZTC2MD2006' 'VENDORC'.
  
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
  FORM set_fcat_2  USING  pv_key pv_field pv_text pv_ref_table pv_ref_field.
    gs_fcat_2-key       = pv_key.
    gs_fcat_2-fieldname = pv_field.
    gs_fcat_2-coltext   = pv_text.
    gs_fcat_2-ref_table = pv_ref_table.
    gs_fcat_2-ref_field = pv_ref_field.
  
    CASE pv_field.
      WHEN 'STCKQ'.
        gs_fcat_2-qfieldname = 'UNIT'.
      WHEN 'MMPRICE'.
        gs_fcat_2-cfieldname = 'CURRENCY'.
    ENDCASE.
  
    APPEND gs_fcat_2 TO gt_fcat_2.
    CLEAR gs_fcat_2.
  
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
          container_name = 'GCL_CONTAINER_2'.
  
      CREATE OBJECT gcl_grid_2
        EXPORTING
          i_parent = gcl_container_2.
  
      gs_variant-report = sy-repid.
  
      CALL METHOD gcl_grid_2->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant_2
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout_2
        CHANGING
          it_outtab       = gt_jego
          it_fieldcatalog = gt_fcat_2.
  
  
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_jego_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_jego_data .
  
  
  
    SELECT a~cmpnc a~plant a~warehscd a~matrc
           b~matrnm a~stckq a~unit b~vendorc c~mmprice c~currency
  
      INTO CORRESPONDING FIELDS OF TABLE gt_jego
      FROM ztc2mm2001 AS a
      INNER JOIN ztc2md2006 AS b
      ON  a~cmpnc = b~cmpnc
      AND a~matrc = b~matrc
      INNER JOIN ztc2md2006 AS c
      ON  a~matrc = c~matrc
      WHERE b~vendorc = pa_vendo
        AND a~warehscd <> '120'.
  
    SORT gt_jego BY matrc.
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_layout_3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_layout_3 .
    gs_layout_3-zebra      = 'X'.
  *  gs_layout_3-cwidth_opt = 'X'.
    gs_layout_3-sel_mode   = 'D'.
    gs_layout_3-no_toolbar = 'X'.
    gs_layout_3-stylefname = 'CELLTAB'.
  
    PERFORM set_fcat_3 USING :
  *       'X'  'CMPNC'       '' 'ZTC2MM2005' 'CMPNC'    5,
  *       'X'  'PLANT'       '' 'ZTC2MM2005' 'PLANT'    5,
  *       'X'  'PURCORNB'    '' 'ZTC2MM2005' 'PURCORNB' 12,
         'X'  'MATRC'       '' 'ZTC2MM2005' 'MATRC'    8,
         'X'  'VENDORC'     '' 'ZTC2MM2005' 'VENDORC'  10,
         'X'  'PURCYM'      '' 'ZTC2MM2005' 'PURCYM'   5,
         ''   'PURCP'       '' 'ZTC2MM2005' 'PURCP'    5,
         ''   'UNIT'        '' 'ZTC2MM2005' 'UNIT'     5,
         ''   'PURCTP'      '' 'ZTC2MM2004' 'PURCTP'   10,
         ''   'CURRENCY'    '' 'ZTC2MD2006' 'CURRENCY' 5,
         ''   'WAREHSCD'    '' 'ZTC2MM2005' 'WAREHSCD' 5.
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_fcat_3  USING  pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length .
    gs_fcat_3-key       = pv_key.
    gs_fcat_3-fieldname = pv_field.
    gs_fcat_3-coltext   = pv_text.
    gs_fcat_3-ref_table = pv_ref_table.
    gs_fcat_3-ref_field = pv_ref_field.
    gs_fcat_3-outputlen = pv_length.
  
    gs_fcat_3-edit ='X'.
  
    CASE pv_field.
      WHEN 'PURCP'.
        gs_fcat_3-qfieldname = 'UNIT'.
  
      WHEN 'PURCTP'.
        gs_fcat_3-cfieldname = 'CURRENCY'.
  
    ENDCASE.
  
    APPEND gs_fcat_3 TO gt_fcat_3.
    CLEAR gs_fcat_3.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_screen_3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_screen_3 .
  
    IF gcl_container_3 IS NOT BOUND.
      CREATE OBJECT gcl_container_3
        EXPORTING
          container_name = 'GCL_CONTAINER_3'.
  
      CREATE OBJECT gcl_grid_3
        EXPORTING
          i_parent = gcl_container_3.
  
      gs_variant-report = sy-repid.
  
      SET HANDLER : lcl_event_handler=>handle_changed_finished FOR gcl_grid_3.
  
      CALL METHOD gcl_grid_3->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified
        EXCEPTIONS
          error      = 1
          OTHERS     = 2.
  
      CALL METHOD gcl_grid_3->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant_3
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout_3
        CHANGING
          it_outtab       = gt_item
          it_fieldcatalog = gt_fcat_3.
  
  
    ENDIF.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_item_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_item_data .
  
  
    SELECT cmpnc plant purcornb matrc vendorc purcym purcp unit
           falutyq faultyr instrdd warehscd delflag
      FROM ztc2mm2005
      INTO CORRESPONDING FIELDS OF TABLE gt_item.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh_grid
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_grid_2.
  
    gs_stable_2-row = 'X'.
    gs_stable_2-col = 'X'.
  
    CALL METHOD gcl_grid_2->refresh_table_display
      EXPORTING
        is_stable      = gs_stable_2
        i_soft_refresh = space.
  
  
  ENDFORM.
  
  FORM refresh_grid_3.
  
    gs_stable_3-row = 'X'.
    gs_stable_3-col = 'X'.
  
    CALL METHOD gcl_grid_3->refresh_table_display
      EXPORTING
        is_stable      = gs_stable_3
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
  
    DATA : lv_cnt    TYPE sy-dbcnt,
           lv_answer TYPE c LENGTH 1.
  
    CLEAR :  gs_item.
    REFRESH : gt_rows.
  
    CALL METHOD gcl_grid_2->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    IF gt_rows IS INITIAL.
      MESSAGE s005 WITH TEXT-m01 DISPLAY LIKE 'E'.
      EXIT.
  
    ELSE.
  
  
  
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_jego INTO gs_jego INDEX gs_row-index.
        READ TABLE gt_item INTO gs_item INDEX gs_row-index.
  
  
        gs_item-purcym = sy-datum.
        IF gs_jego-matrc <> gs_item-matrc.
          MOVE-CORRESPONDING gs_jego TO gs_item.
          APPEND gs_item TO gt_item.
  
          PERFORM set_edit_cell.                  "특정 셀에 대한 입력 잠금
  
        ELSE.
          MESSAGE s005 WITH TEXT-m05 DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDLOOP.
  
      CLEAR : gv_numflag, gv_purcornb, gv_purcym.
  
  
  
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
  
    CALL METHOD gcl_grid_3->get_selected_rows
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
  *& Form set_edit_cell
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_edit_cell.
  
    DATA : ls_style TYPE lvc_s_styl,
           lt_style TYPE lvc_t_styl,
           lv_tabix TYPE sy-tabix.
  
    ls_style-style = cl_gui_alv_grid=>mc_style_disabled.
  
  
    ls_style-fieldname = 'CMPNC'.
    APPEND ls_style TO lt_style.
  
    ls_style-fieldname = 'CURRENCY'.
    APPEND ls_style TO lt_style.
  
    ls_style-fieldname = 'MATRC'.
    APPEND ls_style TO lt_style.
  
    ls_style-fieldname = 'PLANT'.
    APPEND ls_style TO lt_style.
  
    ls_style-fieldname = 'PURCORNB'.
    APPEND ls_style TO lt_style.
  
    ls_style-fieldname = 'PURCTP'.
    APPEND ls_style TO lt_style.
  
    ls_style-fieldname = 'PURCYM'.
    APPEND ls_style TO lt_style.
  
    ls_style-fieldname = 'UNIT'.
    APPEND ls_style TO lt_style.
  
    ls_style-fieldname = 'VENDORC'.
    APPEND ls_style TO lt_style.
  
    ls_style-fieldname = 'WAREHSCD'.
    APPEND ls_style TO lt_style.
  
  
  
  
  
    LOOP AT gt_item INTO gs_item.
      lv_tabix = sy-tabix.
  
      REFRESH gs_item-celltab.
      APPEND LINES OF lt_style TO gs_item-celltab.
  
      MODIFY gt_item FROM gs_item INDEX lv_tabix
      TRANSPORTING celltab.
  
    ENDLOOP.
  
  
  
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
  
  
  
    DATA : ls_save   TYPE ztc2mm2005,
           lt_save   LIKE TABLE OF ls_save,
           lv_cnt    TYPE i,
           lv_date   TYPE sy-datum,
           ls_save_2 TYPE ztc2mm2004,
           lt_save_2 LIKE TABLE OF ls_save_2,
           ls_jego   TYPE ztc2md2006,
           lt_jego   LIKE TABLE OF ls_jego,
           lt_money  TYPE i.
  
    IF gt_item IS NOT INITIAL .
  
  
  
      PERFORM create_order_number.              " 넘버 레인지에 의한 구매오더 번호 생성
  
      CALL METHOD gcl_grid_3->check_changed_data.
  
      LOOP AT gt_item INTO gs_item.
        lt_money  += gs_item-purctp.
        gs_item-purcornb = gv_numflag.
  
        MODIFY gt_item FROM gs_item INDEX sy-tabix
        TRANSPORTING purcornb.
  
  
      ENDLOOP.
  
  
      gs_header-cmpnc     = gs_item-cmpnc.
      gs_header-plant     = gs_item-plant.
      gs_header-purcornb  = gs_item-purcornb.
      gs_header-vendorc   = gs_item-vendorc.
      gs_header-purcym    = sy-datum.
      gs_header-orpddt    = sy-datum.
      gs_header-ormfdt    = sy-datum.
      gs_header-purctp    = lt_money.
      gs_header-currency  = 'KRW'.
      gs_header-resprid   = sy-uname.
      gs_header-modfid    = sy-uname.
      gs_header-instrdt   = gv_INSTRDT.
      gs_header-statflag  = '10'.
  
      APPEND gs_header TO gt_header.
      APPEND gs_item TO gt_item.
  
      MOVE-CORRESPONDING gt_header TO lt_save_2.
  
      MOVE-CORRESPONDING gt_item TO lt_save.
  
      REFRESH gt_data_del.
  
      IF sy-dbcnt <> 0.
        lv_cnt += sy-dbcnt.
      ENDIF.
  
  
      MODIFY ztc2mm2005 FROM TABLE lt_save.
      MODIFY ztc2mm2004 FROM TABLE lt_save_2.
  
      IF  lv_cnt > 0.
        COMMIT WORK AND WAIT.
        MESSAGE s010 WITH gs_item-purcornb.
  
  
      ELSE.
  
        lv_cnt = 0.
        ROLLBACK WORK.
        MESSAGE s005 WITH TEXT-m02.
  
      ENDIF.
  
  
  
  
      REFRESH : gt_item.
  
  
      PERFORM refresh_grid_3.
  
    ELSE.
      MESSAGE s005 WITH '주문아이템이 없습니다.' DISPLAY LIKE 'E'.
  
    ENDIF.
  
  
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
  
    DATA: lv_purcornb TYPE ztc2mm2004-purcornb,
          lv_today    TYPE ztc2mm2005-purcym.
  
    IF gv_numflag IS INITIAL.
      CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          nr_range_nr             = '01'
          object                  = 'ZC202'
        IMPORTING
          number                  = lv_purcornb
        EXCEPTIONS
          interval_not_found      = 1
          number_range_not_intern = 2
          object_not_found        = 3
          quantity_is_0           = 4
          quantity_is_not_1       = 5
          interval_overflow       = 6
          OTHERS                  = 7.
  
      CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
        EXPORTING
          date_external            = sy-datum
        IMPORTING
          date_internal            = lv_today
        EXCEPTIONS
          date_external_is_invalid = 1
          OTHERS                   = 2.
  
  *    lv_today =  lv_today+2(4).
      CONCATENATE 'MO' lv_today+2(4) lv_purcornb INTO lv_purcornb.
  
      gs_item-purcornb = lv_purcornb.
      gv_numflag = lv_purcornb.
  
    ELSE.
      gs_item-purcornb = gv_numflag.
  
  
  
    ENDIF.
  
    gv_purcym = gs_item-purcornb.
  
  
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
  *& Form set_fcat_layout
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_layout .
  
    gs_layout-zebra      = 'X'.
  *  gs_layout-cwidth_opt = 'X'.
    gs_layout-sel_mode   = 'D'.
    gs_layout-no_toolbar = 'X'.
    gs_layout-ctab_fname = 'COLOR'.
  
  
    PERFORM set_fcat USING :
           ''  'STATUS'     '승인상태' ''            'STATUS'     8,
           ''  'PURCORNB'   ''       'ZTC2MM2004' 'PURCORNB'   12,
           ''  'VENDORC'    ''       'ZTC2MM2004' 'VENDORC'    7,
           ''  'MATRTYPE'   ''       'ZTC2MD2006' 'MATRTYPE'   5,
           ''  'ORPDDT'     ''       'ZTC2MM2004' 'ORPDDT'     10,
           ''  'WAREHSCD'   ''       'ZTC2MD2006' 'WAREHSCD'   5,
           ''  'RESPRID'    ''       'ZTC2MM2004' 'RESPRID'    10,
           ''  'RETNR'      ''       'ZTC2MM2004' 'RETNR'      20.
  
  
  
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
  FORM set_fcat  USING  pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length.
    gs_fcat-key       = pv_key.
    gs_fcat-fieldname = pv_field.
    gs_fcat-coltext   = pv_text.
    gs_fcat-ref_table = pv_ref_table.
    gs_fcat-ref_field = pv_ref_field.
    gs_fcat-outputlen = pv_length.
  
  
    CASE pv_field.
      WHEN 'PURCORNB'.
        gs_fcat-hotspot = 'X'.
  
    ENDCASE.
  
  
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
      SET HANDLER : lcl_event_handler=>hotspot_click FOR gcl_grid.
  
      CALL METHOD gcl_grid->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout
        CHANGING
          it_outtab       = gt_gumeheader
          it_fieldcatalog = gt_fcat.
  
    ENDIF.
  
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_gume_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_gume_data .
  
    DATA : lv_tabix TYPE sy-tabix,
           ls_color TYPE lvc_s_scol.
  
  
  
    SELECT DISTINCT a~statflag a~purcornb a~vendorc b~matrtype
           a~orpddt a~resprid  b~warehscd a~delflag a~cmpnc a~plant a~purcym a~retnr  "c~purcfdt
      INTO CORRESPONDING FIELDS OF TABLE gt_gumeheader
      FROM ztc2mm2004 AS a
      INNER JOIN ztc2md2006 AS b
            ON a~vendorc = b~vendorc
            AND a~cmpnc  = b~cmpnc
  *  INNER JOIN ztc2mm2007 AS c
  * ON a~PURCYM = c~PURCYM
  * AND a~CMPNC = c~CMPNC
   WHERE a~orpddt    IN so_ORPD
     AND a~statflag  IN so_FLAG
     AND b~vendorc   IN so_vend
     AND a~delflag  <> 'X'
  *   AND a~statflag <> '12'.
     AND a~statflag <> '13'
     AND a~statflag <> '14'
     AND a~statflag <> '15'
  *   AND a~statflag <> '16'
     AND a~statflag <> '17'
     AND a~statflag <> '18'.
  
    IF sy-subrc <> 0.
      MESSAGE s005 WITH TEXT-m00.
      LEAVE LIST-PROCESSING.
    ENDIF.
  
    SORT gt_gumeheader BY purcornb DESCENDING.
  
    LOOP AT gt_gumeheader INTO gs_gumeheader.
      lv_tabix = sy-tabix.
  
      CASE gs_gumeheader-statflag.
        WHEN '10'.
          gs_gumeheader-status = '승인대기'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '3'.
          ls_color-color-int   = '0'.
          ls_color-color-inv   = '0'.
  
          APPEND ls_color TO gs_gumeheader-color.
  
        WHEN '11'.
          gs_gumeheader-status = '승인요청'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '7'.
          ls_color-color-int   = '0'.
          ls_color-color-inv   = '0'.
          APPEND ls_color TO gs_gumeheader-color.
  
        WHEN '12'.
          gs_gumeheader-status = '승인완료'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '5'.
          ls_color-color-int   = '0'.
          ls_color-color-inv   = '0'.
          APPEND ls_color TO gs_gumeheader-color.
  
        WHEN '16'.
          gs_gumeheader-status = '승인반려'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '7'.
          ls_color-color-int   = '1'.
          ls_color-color-inv   = '0'.
          APPEND ls_color TO gs_gumeheader-color.
      ENDCASE.
  
      MODIFY gt_gumeheader FROM gs_gumeheader INDEX lv_tabix
      TRANSPORTING status color.
  
  
    ENDLOOP.
  
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form goback_create
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM goback_create .
  
    CALL SCREEN '0100'.
    PERFORM refresh_grid_4.
  
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
  
    DATA : lv_tabix  TYPE sy-tabix,
           lv_answer TYPE c LENGTH 1.
  
    CLEAR  gs_row.
    REFRESH gt_rows.
  
    CALL FUNCTION 'POPUP_TO_CONFIRM' " 승인요청시 메세지 팝업창.
      EXPORTING
        titlebar              = '오더삭제'
        text_question         = '오더를 삭제하시겠습니까?'
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
  
  
  
      CALL METHOD gcl_grid->get_selected_rows
        IMPORTING
          et_index_rows = gt_rows.
  
      IF gt_rows IS INITIAL.
        MESSAGE s005 WITH TEXT-m01 DISPLAY LIKE 'E'.
        LEAVE LIST-PROCESSING.
      ENDIF.
      SORT gt_rows BY index DESCENDING.
  
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_gumeheader INTO gs_gumeheader INDEX gs_row-index.
        MOVE-CORRESPONDING gs_gumeheader TO gs_data_del_2.
  
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
  
        gs_data_del_2-delflag = 'X'.
  
  
        APPEND gs_data_del_2 TO gt_data_del_2.
  
  *     LOOP AT gt_item into gs_item.
  *       lv_tabix = sy-subrc.
  *       gs_item-delflag = 'X'.
  *       MODIFY gt_item from gs_item INDEX lv_tabix
  *       TRANSPORTING delflag.
  *
  *       MOVE-CORRESPONDING gs_item to gs_data_del.
  *       APPEND gs_data_del to gt_data_del.
  
  *     ENDLOOP.
  
      ENDLOOP.
  
      MODIFY ztc2mm2004 FROM TABLE gt_data_del_2.
  *    MODIFY ztc2mm2005 FROM TABLE gt_data_del.
  
      IF sy-dbcnt > 0.
        COMMIT WORK AND WAIT.
        MESSAGE s005 WITH '승인이 요청되었습니다.'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE s005 WITH '승인요청에 실패했습니다'  DISPLAY LIKE 'E'.
      ENDIF.
  
    ELSE.
      MESSAGE s005 WITH '취소되었습니다'.
    ENDIF.
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form approval_order
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM approval_order .
  
    DATA : lv_tabix  TYPE sy-tabix,
           ls_color  TYPE lvc_s_scol,
           lv_answer TYPE c LENGTH 1,
           ls_data   TYPE ztc2mm2004,
           lt_data   LIKE TABLE OF ls_data,
           lv_cnt    TYPE sy-dbcnt,
           lv_write  TYPE string,
           lv_cnt2   TYPE i.
  
  
    CLEAR : gs_row, ls_color.
    REFRESH gt_rows.
  
  
  
    CALL METHOD gcl_grid->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
  
    lv_cnt2 = lines( gt_rows ).
    IF lv_cnt2 > 1.
      MESSAGE s005 WITH '한 건씩 선택해주세요.'.
      EXIT.
    ENDIF.
  
  
  
    CONCATENATE '[구매오더번호 :' gs_gumeheader-purcornb ']' '승인요청을 진행하시겠습니까?' INTO lv_write.
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
  
  
  
  
  
      SORT gt_rows BY index DESCENDING.
  
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_gumeheader INTO gs_gumeheader INDEX gs_row-index.
  
        lv_tabix = sy-tabix.
  
        CASE gs_gumeheader-statflag.
          WHEN '10'.
            gs_gumeheader-statflag = '11'.
            gs_gumeheader-status   = '승인요청'.
            ls_color-fname         = 'STATUS'.
            ls_color-color-col     = '7'.
            ls_color-color-int     = '0'.
            ls_color-color-inv     = '0'.
            CLEAR gs_gumeheader-color.
            APPEND ls_color TO gs_gumeheader-color.
  
          WHEN '16'.
            gs_gumeheader-statflag = '11'.
            gs_gumeheader-status   = '승인요청'.
            ls_color-fname         = 'STATUS'.
            ls_color-color-col     = '7'.
            ls_color-color-int     = '0'.
            ls_color-color-inv     = '0'.
            CLEAR gs_gumeheader-color.
            APPEND ls_color TO gs_gumeheader-color.
  
  
        ENDCASE.
  
        MODIFY gt_gumeheader FROM gs_gumeheader INDEX lv_tabix
        TRANSPORTING statflag status color.
  
  
      ENDLOOP.
  
      SELECT *
      INTO CORRESPONDING FIELDS OF TABLE lt_data
      FROM ztc2mm2004
      WHERE purcornb = gs_gumeheader-purcornb.
  
  
      LOOP AT gt_gumeheader INTO gs_gumeheader.    "실데이터 수정 statflag 10->11.
  
        lv_tabix = sy-tabix.
  
        READ TABLE lt_data INTO ls_data
        WITH KEY purcornb = gs_gumeheader-purcornb.
  
        IF gs_gumeheader-statflag = '11'.
          ls_data-statflag = '11'.
  
          MODIFY lt_data FROM ls_data INDEX lv_tabix
          TRANSPORTING statflag.
  
        ENDIF.
  
      ENDLOOP.
  *    MOVE-CORRESPONDING gt_gumeheader TO lt_data.
      CALL METHOD gcl_grid->check_changed_data.
  
      MODIFY ztc2mm2004 FROM TABLE lt_data.
  
      IF sy-dbcnt > 0.
        COMMIT WORK AND WAIT.
        MESSAGE s005 WITH '승인이 요청되었습니다.'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE s005 WITH '승인요청에 실패했습니다.' DISPLAY LIKE 'E'.
      ENDIF.
  
    ELSE.
      MESSAGE s005 WITH '취소되었습니다'.
    ENDIF.
  
    PERFORM refresh_grid.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form hotspot_click
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> E_ROW_ID
  *&      --> E_COLUMN_ID
  *&---------------------------------------------------------------------*
  FORM hotspot_click  USING    pv_row_id    TYPE lvc_s_row
                               pv_column_id TYPE lvc_s_col.
  
    READ TABLE gt_gumeheader INTO gs_gumeheader INDEX pv_row_id-index.
  
    PERFORM get_gume_sebu USING gs_gumeheader-purcornb gs_gumeheader-purcym
                                gs_gumeheader-instrdt. "구매 오더 상세 조회
  
    CALL SCREEN '0102' STARTING AT 10 5.
  
  
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
  *  gs_layout_pop-stylefname = 'CELLTAB'.
  
    PERFORM set_fcat_pop USING :
    ''  'MATRC'    ' '  'ZTC2MM2005'  'MATRC',
    ''  'PURCP'    ' '  'ZTC2MM2005'  'PURCP',
    ''  'UNIT'     ' '  'ZTC2MM2005'  'UNIT',
    ''  'MMPRICE'  ' '  'ZTC2MD2006'  'MMPRICE',
  *  ''  'CURRENCY' ' '  'ZTC2MD2006'  'CURRENCY',
    ''  'MONEY' '구매총액' ''            'MONEY',
  *  ''  'PURCTP'   ' '  'ZTC2MM2004'  'PURCTP',
    ''  'CURRENCY' ' '  'ZTC2MD2006'  'CURRENCY',
    ''  'MATRNM'   ' '  'ZTC2MD2006'  'MATRNM',
    ''  'WAREHSCD' ' '  'ZTC2MM2005'  'WAREHSCD',
    ''  'RESPRID'  ' '  'ZTC2MM2004'  'RESPRID',
    ''  'ORPDDT'   ' '  'ZTC2MM2004'  'ORPDDT',
    ''  'INSTRDT'  ' '  'ZTC2MM2004'  'INSTRDT'.
  
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
  FORM set_fcat_pop  USING  pv_key pv_field pv_text pv_ref_table pv_ref_field.
  
  
    gs_fcat_pop-key       = pv_key.
    gs_fcat_pop-fieldname = pv_field.
    gs_fcat_pop-coltext   = pv_text.
    gs_fcat_pop-ref_table = pv_ref_table.
    gs_fcat_pop-ref_field = pv_ref_field.
  
  
    CASE pv_field.
  
      WHEN 'PURCP'.
        gs_fcat_pop-qfieldname  = 'UNIT'.
        IF gs_gumeheader-status = '승인대기'.
          gs_fcat_pop-edit      = 'X'.
        ENDIF.
  
        IF gs_gumeheader-status = '승인반려'.
          gs_fcat_pop-edit      = 'X'.
        ENDIF.
  
      WHEN 'MONEY'.
        gs_fcat_pop-cfieldname = 'CURRENCY'.
      WHEN 'MMPRICE'.
        gs_fcat_pop-cfieldname = 'CURRENCY'.
  
  
    ENDCASE.
  
    APPEND gs_fcat_pop TO gt_fcat_pop.
    CLEAR  gs_fcat_pop.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_screen_pop
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_screen_pop .
  
    IF gcl_container_pop IS NOT BOUND.
  
      CREATE OBJECT gcl_container_pop
        EXPORTING
          container_name = 'GCL_CONTAINER_POP'.
  
      CREATE OBJECT gcl_grid_pop
        EXPORTING
          i_parent = gcl_container_pop.
  
    ENDIF.
  
    SET HANDLER : lcl_event_handler=>handle_changed_finished2 FOR gcl_grid_pop.
  
    CALL METHOD gcl_grid_pop->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.
  
    CALL METHOD gcl_grid_pop->set_table_for_first_display
      EXPORTING
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout_pop
      CHANGING
        it_outtab       = gt_gume_sebu2
        it_fieldcatalog = gt_fcat_pop.
  
  
  
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
  *& Form get_gume_sebu
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GS_GUMEHEADER_PURCORNB
  *&---------------------------------------------------------------------*
  FORM get_gume_sebu  USING  pv_purcornb TYPE ztc2mm2004-purcornb
                             pv_purcym   TYPE ztc2mm2004-purcym
                             pv_INSTRDT  TYPE ztc2mm2004-instrdt.
  
    DATA : ls_data  LIKE gs_gume_sebu2,
           lt_data  LIKE TABLE OF ls_data,
           lv_tabix TYPE sy-tabix,
           lv_money TYPE i.
  
    REFRESH : lt_data, gt_gume_sebu2.
  
    gv_purcornb = pv_purcornb.        "팝업창 구매오더번호 출력
    gv_year    =  pv_purcym.          "팝업창 계획년월 출력
  
  
    SELECT  a~matrc  a~purcp  a~unit c~matrnm c~warehscd b~resprid b~orpddt b~instrdt b~purcornb
            c~mmprice  c~currency
            b~purctp
      FROM ztc2mm2005 AS a
      INNER JOIN ztc2mm2004 AS b
      ON  a~cmpnc    = b~cmpnc
      AND a~plant    = b~plant
      AND a~purcornb = b~purcornb
      AND a~purcym   = b~purcym
      AND a~vendorc  = b~vendorc
  
      INNER JOIN ztc2md2006 AS c
      ON  a~cmpnc = c~cmpnc
      AND a~matrc = c~matrc
      AND a~vendorc = c~vendorc
  
      INTO CORRESPONDING FIELDS OF TABLE lt_data
  
      WHERE a~purcornb = pv_purcornb.
  *      and b~INSTRDT  = pv_INSTRDT.
  
  
  
    LOOP AT lt_data INTO ls_data.
  
      ls_data-money = ls_data-purcp * ls_data-mmprice.
  
      COLLECT ls_data INTO gt_gume_sebu2.
    ENDLOOP.
  
  *  PERFORM cell_edit_pop. " 팝업창 특정셀 입력 잠금.
  
  
  
  
  
  
  ENDFORM.
  
  
  *&---------------------------------------------------------------------*
  *& Form cell_edit_pop
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM cell_edit_pop .
  
    DATA : ls_style TYPE lvc_s_styl,
           lt_style TYPE lvc_t_styl,
           lv_tabix TYPE sy-tabix.
  
    ls_style-style = cl_gui_alv_grid=>mc_style_disabled.
  
    ls_style-fieldname = 'INSTRDT'.
    APPEND ls_style TO lt_style.
  
    ls_style-fieldname = 'MATRC'.
    APPEND ls_style TO lt_style.
  
    ls_style-fieldname = 'MATRNM'.
    APPEND ls_style TO lt_style.
  
    ls_style-fieldname = 'ORPDDT'.
    APPEND ls_style TO lt_style.
  
    ls_style-fieldname = 'RESPRID'.
    APPEND ls_style TO lt_style.
  
    ls_style-fieldname = 'UNIT'.
    APPEND ls_style TO lt_style.
  
    ls_style-fieldname = 'WAREHSCD'.
    APPEND ls_style TO lt_style.
  
  
  
  
  
  
  
    LOOP AT gt_gume_sebu INTO gs_gume_sebu.
      lv_tabix = sy-tabix.
  
      REFRESH gs_gume_sebu-celltab.
      APPEND LINES OF lt_style TO gs_gume_sebu-celltab.
  
      MODIFY gt_gume_sebu FROM gs_gume_sebu INDEX lv_tabix
      TRANSPORTING celltab.
  
    ENDLOOP.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_input_screen
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_input_screen .
  
    gv_plant = '1000'.
    gv_orpddt  = sy-datum.
    gv_vencor  = pa_vendo.
    gv_resprid = sy-uname.
    gv_INSTRDT = sy-datum.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_screen
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_screen .
  
    CASE 'X'.
      WHEN ra_cre.
        LOOP AT SCREEN.
          titel = '오더 생성'.
          IF screen-group1 = 'MD2'.
            screen-invisible = 1.
            screen-input = 0.
          ENDIF.
  
          IF screen-group1 = 'MD6'.
            screen-invisible = 1.
            screen-input = 0.
          ENDIF.
  
          IF screen-name = 'PA_PLANT'.
            screen-input = 0.
          ENDIF.
  
  
          MODIFY SCREEN.
        ENDLOOP.
  
  
  
      WHEN ra_vie.
        LOOP AT SCREEN.
          titel = '승인대기 오더 조회'.
          IF screen-group1 = 'MD2'.
            screen-active = 1.
          ENDIF.
  
          IF screen-group1 = 'MD1'.
            screen-active = 0.
  
          ENDIF.
  
          IF screen-group1 = 'MD6'.
            screen-active = 0.
  
          ENDIF.
  
          IF screen-name = 'PA_PLAN2'.
            screen-input = 0.
          ENDIF.
  
          MODIFY SCREEN.
        ENDLOOP.
  
      WHEN ra_vie2.
        LOOP AT SCREEN.
          titel = '승인완료 오더 조회'.
          IF screen-group1 = 'MD6'.
            screen-active = 1.
          ENDIF.
  
          IF screen-group1 = 'MD1'.
            screen-active = 0.
  
          ENDIF.
  
          IF screen-group1 = 'MD2'.
            screen-active = 0.
  
          ENDIF.
  
          IF screen-name = 'PA_PLAN3'.
            screen-input = 0.
          ENDIF.
  
  
          MODIFY SCREEN.
        ENDLOOP.
  
    ENDCASE.
  
    SELECT SINGLE vendorn
      INTO p_venn
      FROM ztc2mD2005
      WHERE vendorc = pa_vendo.
  
    SELECT SINGLE vendorn
    INTO p_venn2
    FROM ztc2mD2005
    WHERE vendorc IN so_vend.
  
  
  
  
  
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form mod_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM mod_data.
  
    DATA : ls_save  LIKE ztc2mm2005,
           lt_save  LIKE TABLE OF ls_save,
           ls_save2 LIKE ztc2mm2004,
           lt_save2 LIKE TABLE OF ls_save2,
           lv_money TYPE dmbtr,
           lv_tabix TYPE sy-tabix.
  
    CLEAR   : ls_save.
    REFRESH : lt_save.
  
    CALL METHOD gcl_grid_pop->check_changed_data.
  
    SELECT * "아이템 수정
      INTO CORRESPONDING FIELDS OF TABLE lt_save
      FROM ztc2mm2005
      WHERE purcornb = gs_gumeheader-purcornb.
  
  
    IF sy-subrc <> 0.
      MESSAGE s005 WITH '데이터가 없습니다.'.
      EXIT.
    ENDIF.
  
    LOOP AT gt_gume_sebu2 INTO gs_gume_sebu2.
      lv_tabix = sy-tabix.
      READ TABLE lt_save INTO ls_save
       WITH KEY matrc = gs_gume_sebu2-matrc
                purcornb = gs_gume_sebu2-purcornb.
  
      IF sy-subrc = 0.
        ls_save-purcp = gs_gume_sebu2-purcp.
  
        MODIFY lt_save FROM ls_save INDEX lv_tabix
        TRANSPORTING purcp.
  
      ENDIF.
  
    ENDLOOP.
  
    MODIFY ztc2mm2005 FROM TABLE lt_save.
  
    IF sy-dbcnt = 0.
      MESSAGE s005 WITH '데이터 저장에 실패했습니다'.
      ROLLBACK WORK.
    ELSE.
      MESSAGE s005 WITH '데이터가 저장되었습니다'.
    ENDIF.
  
  *************************************************** 헤더수정
  
    CLEAR   :  ls_save2, gs_gume_sebu2.
    REFRESH :  lt_save2.
  
    SELECT *
       INTO CORRESPONDING FIELDS OF TABLE lt_save2
       FROM ztc2mm2004
       WHERE purcornb = gs_gumeheader-purcornb.
  
  
    IF sy-subrc <> 0.
      MESSAGE s005 WITH '데이터가 없습니다.'.
      EXIT.
    ENDIF.
  
    LOOP AT gt_gume_sebu2 INTO gs_gume_sebu2.
      lv_tabix = sy-tabix.
      READ TABLE lt_save2 INTO ls_save2
       WITH KEY purcornb = gs_gume_sebu2-purcornb.
  
      IF sy-subrc = 0.
  
  *      ls_save2-purctp =  gs_gume_sebu2-money.
  
        LOOP AT gt_gume_sebu2 INTO gs_gume_sebu2.
  
          lv_money += gs_gume_sebu2-money.
  
        ENDLOOP.
  
        ls_save2-purctp = lv_money.
  
        MODIFY lt_save2 FROM ls_save2 INDEX lv_tabix
        TRANSPORTING purctp.
  
      ENDIF.
  
    ENDLOOP.
  
    MODIFY ztc2mm2004 FROM TABLE lt_save2.
  
    IF sy-dbcnt = 0.
      MESSAGE s005 WITH '데이터 저장에 실패했습니다'.
      ROLLBACK WORK.
    ELSE.
      MESSAGE s005 WITH '데이터가 저장되었습니다'.
    ENDIF.
  
  
    PERFORM refresh_grid_pop.
  
  
  
  
  
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
    DATA : ls_modi    TYPE lvc_s_modi.
  
    LOOP AT pt_good_cells INTO ls_modi.
      CASE ls_modi-fieldname.
        WHEN 'PURCP'.
          READ TABLE gt_item INTO gs_item INDEX ls_modi-row_id.
  
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.
  
          gs_item-purctp = ( gs_item-purcp * gs_item-mmprice ).
  
          MODIFY gt_item FROM gs_item INDEX ls_modi-row_id
          TRANSPORTING purctp.
  
      ENDCASE.
    ENDLOOP.
  
    PERFORM refresh_grid_3.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form handle_changed_finished2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> E_MODIFIED
  *&      --> ET_GOOD_CELLS
  *&---------------------------------------------------------------------*
  FORM handle_changed_finished2  USING    pv_modified
                                          pt_good_cells TYPE lvc_t_modi.
  
    DATA : ls_modi    TYPE lvc_s_modi.
  
    LOOP AT pt_good_cells INTO ls_modi.
      CASE ls_modi-fieldname.
        WHEN 'PURCP'.
          READ TABLE gt_gume_sebu2 INTO gs_gume_sebu2 INDEX ls_modi-row_id.
  
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.
  
          gs_gume_sebu2-money = ( gs_gume_sebu2-purcp * gs_gume_sebu2-mmprice ).
  
          MODIFY gt_gume_sebu2 FROM gs_gume_sebu2 INDEX ls_modi-row_id
          TRANSPORTING money.
  
      ENDCASE.
    ENDLOOP.
  
    PERFORM refresh_grid_pop.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_plan_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  *FORM get_plan_data .
  *
  *  SELECT a~cmpnc a~plant a~purcplnb b~matrc b~purcp a~plym b~vendorc
  *    FROM ztc2mm2002 AS a
  *     INNER JOIN ztc2mm2003 AS b
  *     ON a~purcplnb = b~purcplnb
  *    INTO CORRESPONDING FIELDS OF TABLE gt_item
  *    WHERE a~plant   = pa_plant
  *      AND a~plym    = pa_plpd
  *      AND b~vendorc = pa_vendo.
  *ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form f4_werks
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM f4_ven .
    DATA : BEGIN OF ls_value,
             vendorc TYPE ztc2md2005-vendorc,
             vendorn TYPE ztc2md2005-vendorn,
           END OF ls_value,
  
           lt_value LIKE TABLE OF ls_value.
  
    REFRESH lt_value.
  
    SELECT vendorc vendorn
      INTO CORRESPONDING FIELDS OF TABLE lt_value
      FROM ztc2md2005
     WHERE vendorc BETWEEN '001' AND '007'.
  *     AND spras = sy-langu.
  
  
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield     = 'VENDORC'
        dynpprog     = sy-repid
        dynpnr       = sy-dynnr
        dynprofield  = 'PA_VENDO'
        window_title = '거래처 정보'
        value_org    = 'S'
  *     DISPLAY      = ' '
      TABLES
        value_tab    = lt_value.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form f4_flag
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM f4_flag USING pv_location.
  
    DATA : BEGIN OF ls_value,
             statflag TYPE ztc2mm2004-statflag,
             status   TYPE text4,
  
           END OF ls_value,
  
           lv_tabix TYPE sy-tabix,
           lv_field TYPE help_info-dynprofld,
           lt_value LIKE TABLE OF ls_value.
  
  
  
    CASE pv_location.
      WHEN 'LOW'.
        lv_field = 'SO_FLAG-LOW'.
    ENDCASE.
  
    REFRESH lt_value.
  
    SELECT statflag
      INTO CORRESPONDING FIELDS OF TABLE lt_value
      FROM ztc2mm2004
     WHERE statflag IN ('10','11','12','16')
       GROUP BY statflag.
  
    LOOP AT lt_value INTO ls_value.
  
      lv_tabix = sy-tabix.
  
      CASE ls_value-statflag.
        WHEN '10'.
          ls_value-status = '승인대기'.
  
        WHEN '11'.
          ls_value-status = '승인요청'.
  
        WHEN '12'.
          ls_value-status = '승인완료'.
  
        WHEN OTHERS.
          ls_value-status = '승인반려'.
  
      ENDCASE.
  
      MODIFY lt_value FROM ls_value INDEX lv_tabix
      TRANSPORTING status.
  
    ENDLOOP.
  
  
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield     = 'STATFLAG'
        dynpprog     = sy-repid
        dynpnr       = sy-dynnr
        dynprofield  = lv_field
        window_title = '승인 상태'
        value_org    = 'S'
  *     DISPLAY      = ' '
      TABLES
        value_tab    = lt_value.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form f4_ven2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM f4_ven2 USING pv_location.
  
    DATA : BEGIN OF ls_value,
             vendorc TYPE ztc2md2005-vendorc,
             vendorn TYPE ztc2md2005-vendorn,
           END OF ls_value,
  
           lt_value LIKE TABLE OF ls_value,
           lv_field TYPE help_info-dynprofld.
  
    CASE pv_location.
      WHEN 'LOW'.
        lv_field = 'SO_FLAG-LOW'.
    ENDCASE.
  
    REFRESH lt_value.
  
    SELECT vendorc vendorn
      INTO CORRESPONDING FIELDS OF TABLE lt_value
      FROM ztc2md2005
     WHERE vendorc BETWEEN '001' AND '007'.
  *     AND spras = sy-langu.
  
  
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield     = 'VENDORC'
        dynpprog     = sy-repid
        dynpnr       = sy-dynnr
        dynprofield  = 'SO_VEND'
        window_title = '거래처 정보'
        value_org    = 'S'
  *     DISPLAY      = ' '
      TABLES
        value_tab    = lt_value.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_gume_data2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_gume_data2 .
  
    DATA : lv_tabix TYPE sy-tabix,
           ls_color TYPE lvc_s_scol.
  
  
  
    SELECT DISTINCT a~statflag a~purcornb a~vendorc b~matrtype
           a~orpddt a~resprid  b~warehscd a~delflag a~cmpnc a~plant a~purcym a~retnr  "c~purcfdt
      INTO CORRESPONDING FIELDS OF TABLE gt_gumeheader
      FROM ztc2mm2004 AS a
      INNER JOIN ztc2md2006 AS b
            ON a~vendorc = b~vendorc
            AND a~cmpnc  = b~cmpnc
  *  INNER JOIN ztc2mm2007 AS c
  * ON a~PURCYM = c~PURCYM
  * AND a~CMPNC = c~CMPNC
   WHERE a~orpddt    IN so_ORPD
     AND a~statflag  IN so_FLAG
     AND b~vendorc   = pa_vendo
     AND a~delflag <> 'X'
     AND a~statflag <> '12'
     AND a~statflag <> '13'
     AND a~statflag <> '14'
     AND a~statflag <> '15'
     AND a~statflag <> '16'
     AND a~statflag <> '17'
     AND a~statflag <> '18'.
  
  
    IF sy-subrc <> 0.
      MESSAGE s005 WITH TEXT-m00.
      LEAVE LIST-PROCESSING.
    ENDIF.
  
    SORT gt_gumeheader BY purcornb DESCENDING.
  
    LOOP AT gt_gumeheader INTO gs_gumeheader.
      lv_tabix = sy-tabix.
  
      CASE gs_gumeheader-statflag.
        WHEN '10'.
          gs_gumeheader-status = '승인대기'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '3'.
          ls_color-color-int   = '0'.
          ls_color-color-inv   = '0'.
  
          APPEND ls_color TO gs_gumeheader-color.
  
        WHEN '11'.
          gs_gumeheader-status = '승인요청'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '7'.
          ls_color-color-int   = '0'.
          ls_color-color-inv   = '0'.
          APPEND ls_color TO gs_gumeheader-color.
  
        WHEN '12'.
          gs_gumeheader-status = '승인완료'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '5'.
          ls_color-color-int   = '0'.
          ls_color-color-inv   = '0'.
          APPEND ls_color TO gs_gumeheader-color.
  
        WHEN '16'.
          gs_gumeheader-status = '승인반려'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '7'.
          ls_color-color-int   = '1'.
          ls_color-color-inv   = '0'.
          APPEND ls_color TO gs_gumeheader-color.
      ENDCASE.
  
      MODIFY gt_gumeheader FROM gs_gumeheader INDEX lv_tabix
      TRANSPORTING status color.
  
  
    ENDLOOP.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_layout_4
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_layout_4 .
  
    gs_layout_4-zebra      = 'X'.
  *  gs_layout-cwidth_opt = 'X'.
    gs_layout_4-sel_mode   = 'D'.
    gs_layout_4-no_toolbar = 'X'.
    gs_layout_4-ctab_fname = 'COLOR'.
  
  
    PERFORM set_fcat_4 USING :
           ''  'STATUS'     '승인상태' ''            'STATUS'    8,
           ''  'PURCORNB'   ''       'ZTC2MM2004' 'PURCORNB'   12,
           ''  'VENDORC'    ''       'ZTC2MM2004' 'VENDORC'    7,
           ''  'MATRTYPE'   ''       'ZTC2MD2006' 'MATRTYPE'   5,
           ''  'ORPDDT'     ''       'ZTC2MM2004' 'ORPDDT'     10,
           ''  'PURCTP'     ''       'ZTC2MM2004' 'PURCTP'     10,
           ''  'CURRENCY'   ''       'ZTC2MM2004' 'CURRENCY'   6,
           ''  'WAREHSCD'   ''       'ZTC2MD2006' 'WAREHSCD'   5,
           ''  'INSTRDD'   ''        'ZTC2MM2004' 'INSTRDD'    8,
           ''  'INSTRDT'   ''        'ZTC2MM2004' 'INSTRDT'    8,
           ''  'RESPRID'    ''       'ZTC2MM2004' 'RESPRID'    10,
           ''  'RETNR'      ''       'ZTC2MM2004' 'RETNR'      20.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_4
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_8
  *&---------------------------------------------------------------------*
  FORM set_fcat_4  USING   pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length.
    gs_fcat_4-key       = pv_key.
    gs_fcat_4-fieldname = pv_field.
    gs_fcat_4-coltext   = pv_text.
    gs_fcat_4-ref_table = pv_ref_table.
    gs_fcat_4-ref_field = pv_ref_field.
    gs_fcat_4-outputlen = pv_length.
  
    CASE pv_field.
      WHEN 'PURCORNB'.
        gs_fcat_4-hotspot = 'X'.
      WHEN 'PURCTP'.
        gs_fcat_4-cfieldname = 'CURRENCY'.
  
    ENDCASE.
  
  
    APPEND gs_fcat_4 TO gt_fcat_4.
    CLEAR gs_fcat_4.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_screen_pop_4
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_screen_4 .
  
    IF gcl_container_4 IS NOT BOUND.
  
      CREATE OBJECT gcl_container_4
        EXPORTING
          container_name = 'GCL_CONTAINER_4'.
  
      CREATE OBJECT gcl_grid_4
        EXPORTING
          i_parent = gcl_container_4.
  
    ENDIF.
  
    gs_variant_4-report = sy-repid.
    SET HANDLER : lcl_event_handler=>hotspot_click2 FOR gcl_grid_4.
  
    CALL METHOD gcl_grid_4->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.
  
    CALL METHOD gcl_grid_4->set_table_for_first_display
      EXPORTING
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout_4
      CHANGING
        it_outtab       = gt_gumeheader
        it_fieldcatalog = gt_fcat_4.
  
  
  
    PERFORM refresh_grid_4.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh_grid_4
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_grid_4 .
  
  
    gs_stable_4-row = 'X'.
    gs_stable_4-col = 'X'.
  
    CALL METHOD gcl_grid_4->refresh_table_display
      EXPORTING
        is_stable      = gs_stable_4
        i_soft_refresh = space.
  
  
  
  ENDFORM.
  
  
  
  FORM get_gume_data3 .
  
    DATA : lv_tabix TYPE sy-tabix,
           ls_color TYPE lvc_s_scol.
  
  
  
    SELECT DISTINCT a~statflag a~purcornb a~vendorc b~matrtype
           a~orpddt a~resprid  b~warehscd a~delflag a~cmpnc a~plant a~purcym a~retnr  "c~purcfdt
           a~purctp a~currency a~instrdd a~instrdt
      INTO CORRESPONDING FIELDS OF TABLE gt_gumeheader
      FROM ztc2mm2004 AS a
      INNER JOIN ztc2md2006 AS b
            ON a~vendorc = b~vendorc
            AND a~cmpnc  = b~cmpnc
  *  INNER JOIN ztc2mm2007 AS c
  * ON a~PURCYM = c~PURCYM
  * AND a~CMPNC = c~CMPNC
   WHERE a~orpddt    IN so_ORPD2
     AND a~statflag  IN so_FLAG2
     AND b~vendorc   IN so_vend2
     AND a~delflag  <> 'X'
     AND a~statflag <> '10'
     AND a~statflag <> '11'
     AND a~statflag <> '16'.
  *   AND a~statflag <> '14'
  *   AND a~statflag <> '15'
  *   AND a~statflag <> '16'
  *   AND a~statflag <> '17'
  *   AND a~statflag <> '18'.
  
    IF sy-subrc <> 0.
      MESSAGE s005 WITH TEXT-m00.
      LEAVE LIST-PROCESSING.
    ENDIF.
  
    SORT gt_gumeheader BY purcornb DESCENDING.
  
    LOOP AT gt_gumeheader INTO gs_gumeheader.
      lv_tabix = sy-tabix.
  
      CASE gs_gumeheader-statflag.
        WHEN '12'.
          gs_gumeheader-status = '숭인완료'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '5'.
          ls_color-color-int   = '1'.
          ls_color-color-inv   = '0'.
  
          APPEND ls_color TO gs_gumeheader-color.
  
  
        WHEN '13'.
          gs_gumeheader-status = '입고대기'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '3'.
          ls_color-color-int   = '1'.
          ls_color-color-inv   = '0'.
  
          APPEND ls_color TO gs_gumeheader-color.
  
        WHEN '14'.
          gs_gumeheader-status = '입고완료'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '5'.
          ls_color-color-int   = '1'.
          ls_color-color-inv   = '0'.
          APPEND ls_color TO gs_gumeheader-color.
  
        WHEN '15'.
          gs_gumeheader-status = '입고지연'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '7'.
          ls_color-color-int   = '1'.
          ls_color-color-inv   = '0'.
          APPEND ls_color TO gs_gumeheader-color.
  
        WHEN '17'.
          gs_gumeheader-status = '매입확정'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '5'.
          ls_color-color-int   = '1'.
          ls_color-color-inv   = '0'.
          APPEND ls_color TO gs_gumeheader-color.
  
        WHEN '18'.
          gs_gumeheader-status = '전표생성'.
          ls_color-fname       = 'STATUS'.
          ls_color-color-col   = '4'.
          ls_color-color-int   = '1'.
          ls_color-color-inv   = '0'.
          APPEND ls_color TO gs_gumeheader-color.
      ENDCASE.
  
      MODIFY gt_gumeheader FROM gs_gumeheader INDEX lv_tabix
      TRANSPORTING status color.
  
  
    ENDLOOP.
  
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form hotspot_click2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> E_ROW_ID
  *&      --> E_COLUMN_ID
  *&---------------------------------------------------------------------*
  FORM hotspot_click2  USING    pv_row_id    TYPE lvc_s_row
                                pv_column_id TYPE lvc_s_col.
  
    READ TABLE gt_gumeheader INTO gs_gumeheader INDEX pv_row_id-index.
  
    PERFORM get_gume_sebu2 USING gs_gumeheader-purcornb gs_gumeheader-purcym
                                gs_gumeheader-instrdt. "구매 오더 상세 조회
  
    CALL SCREEN '0104' STARTING AT 30 8.
  
  
  
  
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
  *  gs_layout_pop-stylefname = 'CELLTAB'.
  
    PERFORM set_fcat_pop_2 USING :
    ''  'MATRC'    ' '  'ZTC2MM2005'  'MATRC',
    ''  'MATRNM'   ' '  'ZTC2MD2006'  'MATRNM',
    ''  'PURCP'    ' '  'ZTC2MM2005'  'PURCP',
    ''  'UNIT'     ' '  'ZTC2MM2005'  'UNIT',
    ''  'MMPRICE'  ' '  'ZTC2MD2006'  'MMPRICE',
    ''  'MONEY'    '구매총액' ''         'MONEY',
    ''  'CURRENCY' ' '  'ZTC2MD2006'  'CURRENCY',
    ''  'WAREHSCD' ' '  'ZTC2MM2005'  'WAREHSCD'.
  
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
  FORM set_fcat_pop_2  USING    pv_key pv_field pv_text pv_ref_table pv_ref_field.
  
    gs_fcat_pop_2-key       = pv_key.
    gs_fcat_pop_2-fieldname = pv_field.
    gs_fcat_pop_2-coltext   = pv_text.
    gs_fcat_pop_2-ref_table = pv_ref_table.
    gs_fcat_pop_2-ref_field = pv_ref_field.
  
  
    CASE pv_field.
  
      WHEN 'PURCP'.
        gs_fcat_pop_2-qfieldname  = 'UNIT'.
      WHEN 'MONEY'.
        gs_fcat_pop_2-cfieldname = 'CURRENCY'.
      WHEN 'MMPRICE'.
        gs_fcat_pop_2-cfieldname = 'CURRENCY'.
  
  
    ENDCASE.
  
    APPEND gs_fcat_pop_2 TO gt_fcat_pop_2.
    CLEAR  gs_fcat_pop_2.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_screen_pop_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_screen_pop_2 .
  
    IF gcl_container_pop_2 IS NOT BOUND.
  
      CREATE OBJECT gcl_container_pop_2
        EXPORTING
          container_name = 'GCL_CONTAINER_POP_2'.
  
      CREATE OBJECT gcl_grid_pop_2
        EXPORTING
          i_parent = gcl_container_pop_2.
  
    ENDIF.
  
    CALL METHOD gcl_grid_pop_2->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.
  
    CALL METHOD gcl_grid_pop_2->set_table_for_first_display
      EXPORTING
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout_pop_2
      CHANGING
        it_outtab       = gt_gume_sebu2
        it_fieldcatalog = gt_fcat_pop_2.
  
  
  
    PERFORM refresh_grid_pop_2.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form gt_fcat_pop_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM gt_fcat_pop_2 .
  
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
  *& Form get_gume_sebu2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GS_GUMEHEADER_PURCORNB
  *&      --> GS_GUMEHEADER_PURCYM
  *&      --> GS_GUMEHEADER_INSTRDT
  *&---------------------------------------------------------------------*
  FORM get_gume_sebu2  USING  pv_purcornb TYPE ztc2mm2004-purcornb
                              pv_purcym   TYPE ztc2mm2004-purcym
                              pv_INSTRDT  TYPE ztc2mm2004-instrdt.
  
    DATA : ls_data  LIKE gs_gume_sebu2,
           lt_data  LIKE TABLE OF ls_data,
           lv_tabix TYPE sy-tabix,
           lv_money TYPE i.
  
    REFRESH : lt_data, gt_gume_sebu2.
  
    gv_purcornb = pv_purcornb.        "팝업창 구매오더번호 출력
    gv_year2    =  pv_purcym.          "팝업창 계획년월 출력
  
  
    SELECT  a~matrc  a~purcp  a~unit c~matrnm c~warehscd b~resprid b~orpddt b~instrdt b~purcornb
            c~mmprice  c~currency
            b~purctp
      FROM ztc2mm2005 AS a
      INNER JOIN ztc2mm2004 AS b
      ON  a~cmpnc    = b~cmpnc
      AND a~plant    = b~plant
      AND a~purcornb = b~purcornb
      AND a~purcym   = b~purcym
      AND a~vendorc  = b~vendorc
  
      INNER JOIN ztc2md2006 AS c
      ON  a~cmpnc = c~cmpnc
      AND a~matrc = c~matrc
      AND a~vendorc = c~vendorc
  
      INTO CORRESPONDING FIELDS OF TABLE lt_data
  
      WHERE a~purcornb = pv_purcornb.
  *      and b~INSTRDT  = pv_INSTRDT.
  
  
  
    LOOP AT lt_data INTO ls_data.
  
      ls_data-money = ls_data-purcp * ls_data-mmprice.
  
      COLLECT ls_data INTO gt_gume_sebu2.
    ENDLOOP.
  
  *  PERFORM cell_edit_pop. " 팝업창 특정셀 입력 잠금.
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
  
    IF pa_vendo is not INITIAL.
  
    IF pa_vendo = 000 OR pa_vendo >= 008.
  
      MESSAGE '유효한 거래처를 입력하세요.' TYPE 'E'.
  
    ENDIF.
    ENDIF.
  ENDFORM.