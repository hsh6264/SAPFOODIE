*&---------------------------------------------------------------------*
*& Include          SAPMZC2FI2001_F01
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
    gs_layout-no_toolbar = 'X'.
  
    PERFORM set_fcat USING :
         ' '  'ICON'       ' '            'GT_DATA'      'ICON'        4  'C',
         ' '  'STATUS'     '상태'          'ZTC2MM2004'   'STATFLAG'    15 'C',
         ' '  'PURCORNB'   '구매오더번호'    'ZTC2MM2004'    'PURCORNB'    20 'C',
         ' '  'VENDORC'    '거래처'        'ZTC2MM2004'    'VENDORC'     13 'C',
         ' '  'PURCYM'     '매입년월'       'ZTC2MM2004'    'PURCYM'      13 'C',
         ' '  'RESPRID'    '담당자'         'ZTC2MM2004'   'RESPRID'     13 'C',
         ' '  'STATEMENTNB' '전표번호'        'ZTC2MD2008'   'STATEMENTNB'  13 'C'.
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
  *&      --> P_10
  *&---------------------------------------------------------------------*
  FORM set_fcat  USING  pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length pv_just.
  
    gs_fcat-key       = pv_key.
    gs_fcat-fieldname = pv_field.
    gs_fcat-coltext   = pv_text.
    gs_fcat-ref_table = pv_ref_table.
    gs_fcat-outputlen = pv_length.
    gs_fcat-just      = pv_just.
  
    CASE pv_field.
      WHEN 'PURCORNB'.
        gs_fcat-hotspot = 'X'.
      WHEN 'STATEMENTNB'.
        gs_fcat-hotspot = 'X'.
      WHEN OTHERS.
        gs_fcat-hotspot = ''.
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
  
      CREATE OBJECT gcl_handler.
      SET HANDLER : gcl_handler->handle_hotspot FOR gcl_grid.
      SET HANDLER : gcl_handler->handle_hotspot2 FOR gcl_grid.
  
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
      CASE 'X'.      "alv 필드 카탙로그 바꾸기
        WHEN pa_rd1.
          REFRESH gt_fcat.
          PERFORM set_fcat_layout.
  
          gcl_grid->set_frontend_fieldcatalog(
            EXPORTING
              it_fieldcatalog = gt_fcat
  
          ).
  
        WHEN pa_rd2.
          REFRESH gt_fcat2.
          PERFORM set_fcat_layout2.
  
          gcl_grid->set_frontend_fieldcatalog(
            EXPORTING
              it_fieldcatalog = gt_fcat2
  
          ).
      ENDCASE.
  
      PERFORM refresh_grid.
  
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
  
    gs_layout2-zebra      = 'X'.
    gs_layout2-sel_mode   = 'D'.
    gs_layout2-no_toolbar = 'X'.
  
    PERFORM set_fcat2 USING :
         ' '  'ICON'       ' '         'GT_DATA'         'ICON'       4  'C',
         ' '  'STATUS'     '상태'       'ZTC2MM2004'      'STATFLAG'   15 'C',
         ' '  'ORDERCD'   '판매오더번호'  'ZTC2SD2006'       'ORDERCD'    20 'C',
         ' '  'VENDORC'   '거래처'      'ZTC2SD2006'       'VENDORC'    13 'C',
         ' '  'SALEYM'    '매출년월'     'ZTC2SD2006'       'SALEYM'     13 'C',
         ' '  'RESPRID'   '담당자'       'ZTC2SD2006'      'RESPRID'     13 'C',
         ' '  'STATEMENTNB' '전표번호'        'ZTC2MD2008'   'STATEMENTNB'  13 'C'.
  
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
  FORM set_fcat2  USING  pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length pv_just.
  
    gs_fcat2-key       = pv_key.
    gs_fcat2-fieldname = pv_field.
    gs_fcat2-coltext   = pv_text.
    gs_fcat2-ref_table = pv_ref_table.
    gs_fcat2-outputlen = pv_length.
    gs_fcat2-just      = pv_just.
  
    CASE pv_field.
      WHEN 'ORDERCD'.
        gs_fcat2-hotspot = 'X'.
      WHEN 'STATEMENTNB'.
        gs_fcat2-hotspot = 'X'.
      WHEN OTHERS.
        gs_fcat2-hotspot = ''.
    ENDCASE.
  
    APPEND gs_fcat2 TO gt_fcat2.
    CLEAR gs_fcat2.
  
  ENDFORM.
  
  *&---------------------------------------------------------------------*
  *& Form set_radio
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_radio .
  
    LOOP AT SCREEN.
      CASE 'X'.
        WHEN pa_rd1.
          title = '매입전표 생성'.
          IF screen-group1 = 'SC2'.
            screen-active = 1.
          ENDIF.
          IF screen-group1 = 'SC1'.
            screen-active = 0.
          ENDIF.
  
  
        WHEN pa_rd2.
          title = '매출전표 생성'.
          IF screen-group1 = 'SC1'.
            screen-active = 1.
          ENDIF.
          IF screen-group1 = 'SC2'.
            screen-active = 0.
          ENDIF.
  
      ENDCASE.
  
      MODIFY SCREEN.
  
    ENDLOOP.
  
    IF gv_okcode = 'CREATE'. "나갔다가 들어오면 전표 생성건은 사라지게 하기 위해 clear
      CLEAR gv_okcode.
      EXIT.
    ENDIF.
  
    PERFORM get_data. "get_data는 loop 바깥에 배치
  
  ENDFORM.
  
  FORM refresh_grid.
  
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.
  
    CALL METHOD gcl_grid->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = space.
  
  ENDFORM.
  
  FORM get_data.
  
    DATA : lv_tabix TYPE sy-tabix.
  
    CLEAR   : gs_data.
    REFRESH : gt_data.
  
    IF pa_rd1 = 'X'.
      SELECT a~plant a~cmpnc a~purcornb a~vendorc a~purcym a~orpddt a~ormfdt a~purctp a~currency a~retnr
             a~resprid a~modfid a~instrdd a~instrdt a~statflag a~delflag b~statementnb
        INTO CORRESPONDING FIELDS OF TABLE gt_data
        FROM ztc2mm2004 AS a
        LEFT OUTER JOIN ztc2md2008 AS b
        ON a~purcornb = b~purcornb
        WHERE purcym  IN so_pur
          AND a~vendorc IN so_ven2
          AND ( statflag = '17' OR statflag = '18' ). "매입확정
    ELSEIF pa_rd2 = 'X'.
      SELECT a~plant a~cmpnc a~vendorc a~saleym a~ordercd a~orderdate a~resprid a~duedate a~ttamount a~waers a~odmaxwt
             a~weightunit a~outstoredt a~statflag a~delflag a~dispatchcd b~statementnb
        INTO CORRESPONDING FIELDS OF TABLE gt_data
        FROM ztc2sd2006 AS a
        LEFT OUTER JOIN ztc2md2008 AS b
        ON a~plant = b~plant "join을 할떄 한건만 가져오기 위해 정확한 조건들을 넣어야함!!
       AND a~cmpnc = b~cmpnc
       AND a~vendorc = b~vendorc
       AND a~ordercd = b~ordercd
        WHERE saleym  IN so_sal
          AND a~vendorc IN so_ven
          AND ( statflag = 'F' OR statflag = 'H' ) . "배차완료
    ENDIF.
  
    LOOP AT gt_data INTO gs_data.
      lv_tabix = sy-tabix.
  
      CASE gs_data-statflag.
        WHEN '17'.
          gs_data-status = '매입확정'.
          gs_data-icon = '@5C@'.
        WHEN '18'.
          gs_data-status = '전표생성'.
          gs_data-icon = '@5B@'.
        WHEN 'F'.
          gs_data-status = '매출확정'.
          gs_data-icon = '@5C@'.
        WHEN 'H'.
          gs_data-status = '전표생성'.
          gs_data-icon = '@5B@'.
      ENDCASE.
  
      MODIFY gt_data FROM gs_data INDEX lv_tabix
      TRANSPORTING status icon.
    ENDLOOP.
  
  sort gt_data DESCENDING by status.
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
  
    DATA : lv_input TYPE i.
    CLEAR gs_data.
  
    READ TABLE gt_data INTO gs_data INDEX ps_row_id-index.
  
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  
    CASE gs_data-statflag.
      WHEN '18' OR 'H'.
        lv_input = 0.
      WHEN '17' OR 'F'.
        lv_input = 1.
    ENDCASE.
  
    CALL METHOD gcl_grid3->set_ready_for_input
      EXPORTING
        i_ready_for_input = lv_input.
  
    IF ps_column_id-fieldname = 'PURCORNB'.
      PERFORM get_purc USING gs_data-purcornb.
      PERFORM refresh_grid3.
    ELSEIF ps_column_id-fieldname = 'ORDERCD'.
      PERFORM get_order USING gs_data-ordercd.
      PERFORM refresh_grid3.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_purc
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GS_DATA_PURCORNB
  *&---------------------------------------------------------------------*
  FORM get_purc  USING    pv_purcornb TYPE ztc2mm2004-purcornb.
  
  
    CLEAR  : gs_data2.
    REFRESH: gt_data2.
  
    CASE gs_data-statflag.
      WHEN '18'.
        SELECT purcornb purctp currency svalue vat total
          INTO CORRESPONDING FIELDS OF TABLE gt_data2
          FROM ztc2md2008
          WHERE purcornb = pv_purcornb.
      WHEN '17'.
        SELECT purcornb purctp currency
          INTO CORRESPONDING FIELDS OF TABLE gt_data2
          FROM ztc2mm2004
          WHERE purcornb = pv_purcornb.
    ENDCASE.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_order
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GS_DATA_ORDERCD
  *&---------------------------------------------------------------------*
  FORM get_order  USING    pv_ordercd TYPE ztc2sd2006-ordercd.
  
    CLEAR  : gs_data2.
    REFRESH: gt_data2.
  
  
    CASE gs_data-statflag.
      WHEN 'H'.
        SELECT ordercd ttamount waers svalue vat total
          INTO CORRESPONDING FIELDS OF TABLE gt_data2
          FROM ztc2md2008
          WHERE ordercd = pv_ordercd.
      WHEN 'F'.
        SELECT ordercd ttamount waers
          INTO CORRESPONDING FIELDS OF TABLE gt_data2
          FROM ztc2sd2006
          WHERE ordercd = pv_ordercd.
    ENDCASE.
  
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
  
    gs_layout3-zebra      = 'X'.
    gs_layout3-sel_mode   = 'D'.
    gs_layout3-no_toolbar = 'X'.
  
  
    PERFORM set_fcat3 USING :
         ' '  'PURCORNB'    '구매오더번호'   'ZTC2MM2004'     'PURCORNB'   14 'C' '',
         ' '  'PURCTP'      '총구매금액'     'ZTC2MM2004'     'PURCTP'    15 'C' '',
         ' '  'CURRENCY'    '화폐단위'      'ZTC2MM2004'     'CURRENCY'  10 'C' '',
         ' '  'SVALUE'      '공급가액'      'ZTC2MD2008'     'SVALUE'    13 'C' '',
         ' '  'VAT'         '부가세'       'ZTC2MD2008'      'VAT'      13 'C' '',
         ' '  'TOTAL'       '합계'         'ZTC2MD2008'     'TOTAL'     13 'C' 'X'.
  
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
  *&      --> P_8
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_fcat3  USING  pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length pv_just pv_edit.
  
    gs_fcat3-key       = pv_key.
    gs_fcat3-fieldname = pv_field.
    gs_fcat3-coltext   = pv_text.
    gs_fcat3-ref_table = pv_ref_table.
    gs_fcat3-outputlen = pv_length.
    gs_fcat3-just      = pv_just.
    gs_fcat3-edit      = pv_edit.
  
    CASE pv_field.
      WHEN 'PURCTP'.
        gs_fcat3-cfieldname = 'CURRENCY'.
      WHEN 'SVALUE'.
        gs_fcat3-cfieldname = 'CURRENCY'.
      WHEN 'VAT'.
        gs_fcat3-cfieldname = 'CURRENCY'.
      WHEN 'TOTAL'.
        gs_fcat3-cfieldname = 'CURRENCY'.
    ENDCASE.
  
    APPEND gs_fcat3 TO gt_fcat3.
    CLEAR gs_fcat3.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_layout4
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_layout4 .
    gs_layout4-zebra      = 'X'.
    gs_layout4-sel_mode   = 'D'.
    gs_layout4-no_toolbar = 'X'.
  
    PERFORM set_fcat4 USING :
         ' '  'ORDERCD'   '판매오더번호'   'ZTC2SD2006'    'ORDERCD'    14 'C' '',
         ' '  'TTAMOUNT'   '총판매금액'   'ZTC2SD2006'     'TTAMOUNT'   15 'C' '',
         ' '  'WAERS'     '화폐단위'     'ZTC2SD2006'      'WAERS'     10 'C' '',
         ' '  'SVALUE'      '공급가액'   'ZTC2MD2008'      'SVALUE'    13 'C' '',
         ' '  'VAT'         '부가세'     'ZTC2MD2008'     'VAT'       13 'C' '',
         ' '  'TOTAL'       '합계'       'ZTC2MD2008'    'TOTAL'      13 'C' 'X'.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat4
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_8
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_fcat4  USING  pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length pv_just pv_edit.
  
    gs_fcat4-key       = pv_key.
    gs_fcat4-fieldname = pv_field.
    gs_fcat4-coltext   = pv_text.
    gs_fcat4-ref_table = pv_ref_table.
    gs_fcat4-outputlen = pv_length.
    gs_fcat4-just      = pv_just.
    gs_fcat4-edit      = pv_edit.
  
    CASE pv_field.
      WHEN 'TTAMOUNT'.
        gs_fcat4-cfieldname = 'WAERS'.
      WHEN 'SVALUE'.
        gs_fcat4-cfieldname = 'WAERS'.
      WHEN 'VAT'.
        gs_fcat4-cfieldname = 'WAERS'.
      WHEN 'TOTAL'.
        gs_fcat4-cfieldname = 'WAERS'.
    ENDCASE.
  
    APPEND gs_fcat4 TO gt_fcat4.
    CLEAR gs_fcat4.
  
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
  
    IF gcl_container3 IS NOT BOUND.
  
      CREATE OBJECT gcl_container3
        EXPORTING
          container_name = 'GCL_CONTAINER3'.
  
      CREATE OBJECT gcl_grid3
        EXPORTING
          i_parent = gcl_container3.
  
      CREATE OBJECT gcl_handler3.
      SET HANDLER : gcl_handler3->handle_changed_finished FOR gcl_grid3.
  
      CALL METHOD gcl_grid3->register_edit_event     "edit 이벤트 적용하는 method
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified.
  
      gs_variant-report = sy-repid.
  
      CALL METHOD gcl_grid3->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant3
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout3
        CHANGING
          it_outtab       = gt_data2
          it_fieldcatalog = gt_fcat3.
  
    ELSE.
      CASE 'X'.      "alv 필드 카탙로그 바꾸기
        WHEN pa_rd1.
          REFRESH gt_fcat3.
          PERFORM set_fcat_layout3.
  
          gcl_grid3->set_frontend_fieldcatalog(
            EXPORTING
              it_fieldcatalog = gt_fcat3
  
          ).
  
        WHEN pa_rd2.
          REFRESH gt_fcat4.
          PERFORM set_fcat_layout4.
  
          gcl_grid3->set_frontend_fieldcatalog(
            EXPORTING
              it_fieldcatalog = gt_fcat4
  
          ).
  
      ENDCASE.
  
      PERFORM refresh_grid3.
  
    ENDIF.
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
    gs_stable3-row = 'X'.
    gs_stable3-col = 'X'.
  
    CALL METHOD gcl_grid3->refresh_table_display
      EXPORTING
        is_stable      = gs_stable3
        i_soft_refresh = space.
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
    DATA : ls_modi TYPE lvc_s_modi,
           lv_sval TYPE i,
           lv_vat  TYPE i.
  
    LOOP AT pt_good_cells INTO ls_modi.   "공급가액과 부가세 계산하기
      CASE ls_modi-fieldname.
        WHEN 'TOTAL'.
          READ TABLE gt_data2 INTO gs_data2 INDEX ls_modi-row_id.
  
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.
  
          IF gs_data2-total <> 0.
            lv_sval = gs_data2-total / '1.1'.
            lv_vat  = lv_sval * '0.1'.
  
          ELSE.
            lv_sval = 0.
            lv_vat  = 0.
          ENDIF.
  
          gs_data2-svalue = lv_sval.
          gs_data2-vat    = lv_vat.
  
          MODIFY gt_data2 FROM gs_data2 INDEX ls_modi-row_id
           TRANSPORTING svalue vat.
  
      ENDCASE.
    ENDLOOP.
  
    PERFORM refresh_grid3.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form change_stat
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM change_stat .
  
  
    DATA : lv_tabix  TYPE sy-tabix,
           lv_answer TYPE c LENGTH 1.
  
    DATA : ls_data  TYPE ztc2mm2004,
           lt_data  LIKE TABLE OF ls_data,
           ls_data2 TYPE ztc2sd2006,
           lt_data2 LIKE TABLE OF ls_data2,
           ls_data3 TYPE ztc2md2008,
           lt_data3 LIKE TABLE OF ls_data3.
  
    CLEAR   : ls_data, ls_data2, ls_data3.
    REFRESH : lt_data, lt_data2, lt_data3.
  
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '전표생성'
        text_question         = '전표를 생성하시겠습니까?'
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
  
      CALL METHOD gcl_grid3->check_changed_data. "값을 change 하는 grid를 불러와야함 그래서 grid3임
  
      CASE gs_data-statflag .
  
        WHEN '17'.
          LOOP AT gt_data2 INTO gs_data2. "밑에 수정작업을 하는 테이블을 loop돌려서 읽음
  
            READ TABLE gt_data INTO gs_data WITH KEY purcornb = gs_data2-purcornb. "gs_data2의 purcornb와 같은 값을 gt_data에서 찾아야하니 gt_data를 read
  
            IF sy-subrc = 0.    "sy-subrc를 안하면 모든 purcornb이 선택되기때문에 loop안에 한개만 선택됐다는 subrc 검사를 해줘야함
              lv_tabix = sy-tabix.
  
              gs_data-statflag = '18'. "gs_data에서 해당하는 purcornb를 찾았다면 state를 바꿔줘
              gs_data-status = '전표생성'. "get_data에도 썼지만 여기서도 status들을 바꿔주는 작업을 해야함
              gs_data-icon = '@5B@'.
  
              PERFORM create_statementnb. "상태를 18로 다 바꾼 후에 전표 생성을 여기서 하는 것 (순서의 중요성!!!)
  
              MODIFY gt_data FROM gs_data INDEX lv_tabix
             TRANSPORTING statementnb statflag status icon.
  
              MOVE-CORRESPONDING gs_data TO ls_data.
  
              APPEND ls_data TO lt_data.
              CLEAR  ls_data.   "ls_data의 데이터를 gs_data로 옮겼으니 ls_data는 마지막에 청소를 해줘야해!
  
            ENDIF.
          ENDLOOP.
  
          "입력된 전표 내용 격납.
          MOVE-CORRESPONDING gs_data2 TO ls_data3. "ls_data3에 값을 넣어야하는데 빈값이 있으니까 gs_data2를 move corresponding으로 넣어줌 근데 gs_data2에 값이 더 많아서 이거 먼저 넣어
          MOVE-CORRESPONDING gs_data  TO ls_data3.
  
          ls_data3-fiscalyear = gs_data-purcym(4). "fiscalyear는 매입년월의 4자리까지만
          ls_data3-itemnb     = 1. "아이템이 어짜피 1개밖에 없으니 하드코딩으로 1을 넣음ㅋ
  
          APPEND ls_data3 TO lt_data3.
  
        WHEN 'F'.
          LOOP AT gt_data2 INTO gs_data2.
  
            READ TABLE gt_data INTO gs_data WITH KEY ordercd = gs_data2-ordercd.
  
            IF sy-subrc = 0.
              lv_tabix = sy-tabix.
              gs_data-statflag = 'H'.
              gs_data-status = '전표생성'.
              gs_data-icon = '@5B@'.
  
              PERFORM create_statementnb.
  
              MODIFY gt_data FROM gs_data INDEX lv_tabix
              TRANSPORTING statflag status icon statementnb.
  
              MOVE-CORRESPONDING gs_data TO ls_data2.
  
              APPEND ls_data2 TO lt_data2.
              CLEAR ls_data2.
  *            MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING statflag status icon statementnb.
            ENDIF.
          ENDLOOP.
  
          MOVE-CORRESPONDING gs_data2 TO ls_data3.
          MOVE-CORRESPONDING gs_data  TO ls_data3.
  
          ls_data3-fiscalyear = gs_data-saleym(4).
          ls_data3-itemnb     = 1.
  
          APPEND ls_data3 TO lt_data3.
  
      ENDCASE.
    ELSE.
      MESSAGE s005 WITH '취소되었습니다.'.
    ENDIF.
  
  
    CASE gs_data-statflag.
      WHEN '18'.
        MODIFY ztc2mm2004 FROM TABLE lt_data.
      WHEN 'H'.
        MODIFY ztc2sd2006 FROM TABLE lt_data2.
    ENDCASE.
  
    "전표 마스터 테이블에 추가.
    MODIFY ztc2md2008 FROM TABLE lt_data3. "위에서 쌓은 lt_data3를 ztc2md2008에 한번에 넣는 작업
  
  
    IF sy-dbcnt > 0.   "modify 이후 commit 해야함
      COMMIT WORK AND WAIT.
      MESSAGE s005 WITH '전표생성이 완료되었습니다'.
  
    ELSE.
      ROLLBACK WORK.
      MESSAGE s005 WITH '작업이 취소되었습니다.' DISPLAY LIKE 'E'.
    ENDIF.
  
  
  ENDFORM.
  
  *&---------------------------------------------------------------------*
  *& Form create_fiscalyear
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM create_statementnb .
  
    DATA : lv_statementnb TYPE ztc2md2008-statementnb. "전표생성 넘버레인지
  
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'ZC202_1'
      IMPORTING
        number                  = lv_statementnb
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.
  
    CONCATENATE sy-datum+2(4) lv_statementnb INTO lv_statementnb.
  
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = lv_statementnb
      IMPORTING
        output = lv_statementnb.
  
    gs_data-statementnb  = lv_statementnb.
    gs_data2-statementnb = lv_statementnb.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form handle_hotspot2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> E_ROW_ID
  *&      --> E_COLUMN_ID
  *&---------------------------------------------------------------------*
  FORM handle_hotspot2  USING    ps_row_id    TYPE lvc_s_row
                                 ps_column_id TYPE lvc_s_col.
  
    CLEAR gs_data3.
  
    READ TABLE gt_data INTO gs_data INDEX ps_row_id-index.
  
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  
  *전표번호 상세내역 핫스팟
    IF ps_column_id-fieldname = 'STATEMENTNB'.
  
      PERFORM get_data3 USING gs_data-statementnb.
  
    ENDIF.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_data3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GS_DATA2_STATEMENTNB
  *&---------------------------------------------------------------------*
  FORM get_data3  USING    pv_statementnb.
  
    DATA : lv_tabix TYPE sy-tabix.
  
    CLEAR   : gs_data3.
    REFRESH : gt_data3.
  
    CASE 'X'.
      WHEN pa_rd1.
  
        SELECT DISTINCT a~vendorc b~busi_nb b~vendorn b~repr b~ploc b~wktp b~bzit a~svalue a~vat a~total a~currency c~matrc d~matrnm
               c~unit c~purcp c~purcym "e~itemqty e~saleym
          INTO CORRESPONDING FIELDS OF TABLE gt_data3
          FROM ztc2md2008 AS a
          INNER JOIN ztc2md2005 AS b
          ON a~vendorc = b~vendorc
  
          INNER JOIN ztc2mm2005 AS c
          ON a~purcornb = c~purcornb
         AND a~vendorc  = c~vendorc
  
          INNER JOIN ztc2md2006 AS d
          ON c~vendorc = d~vendorc
         AND c~matrc   = d~matrc
  
         WHERE a~statementnb = pv_statementnb.
  
        IF sy-subrc = 0.
          READ TABLE gt_data3 INTO gs_data3 INDEX 1. "index1를 읽음 어짜피 값이 같으니
  
          gv_svalue   = gs_data3-svalue.
          gv_vat      = gs_data3-vat.
          gv_total    = gs_data3-total.
          gv_address  = gs_data3-ploc.
          gv_bg       = gs_data3-busi_nb.
          gv_rp       = gs_data3-repr.
          gv_name     = gs_data3-vendorn.
          gv_up       = gs_data3-wktp.
          gv_bell     = gs_data3-bzit.
          gv_currency = gs_data3-currency.
  
          PERFORM refresh_grid27.
  
          cl_gui_cfw=>set_new_ok_code( 'REFRESH' ).  "alv에서는 안타서 강제로 태워야함
  
        ENDIF.
  
      WHEN pa_rd2.
  
        SELECT DISTINCT a~vendorc b~busi_nb b~vendorn b~repr b~ploc b~wktp b~bzit a~svalue a~vat a~total a~waers d~matrc d~matrnm
               c~boxunit c~itemqty c~saleym
          INTO CORRESPONDING FIELDS OF TABLE gt_data3
          FROM ztc2md2008 AS a
          INNER JOIN ztc2md2005 AS b
          ON a~vendorc = b~vendorc
  
          INNER JOIN ztc2sd2007 AS c
          ON a~cmpnc = c~cmpnc
         AND a~plant = c~plant
         AND a~ordercd = c~ordercd
         AND a~vendorc = c~vendorc
  
         INNER JOIN ztc2md2006 AS d
         ON a~cmpnc = d~cmpnc
         AND c~prodcd   = d~matrc
  
         WHERE a~statementnb = pv_statementnb.
  
        IF sy-subrc = 0.
          READ TABLE gt_data3 INTO gs_data3 INDEX 1. "index1를 읽음 어짜피 값이 같으니
  
          gv_svalue   = gs_data3-svalue.
          gv_vat      = gs_data3-vat.
          gv_total    = gs_data3-total.
          gv_address  = gs_data3-ploc.
          gv_bg       = gs_data3-busi_nb.
          gv_rp       = gs_data3-repr.
          gv_name     = gs_data3-vendorn.
          gv_up       = gs_data3-wktp.
          gv_bell     = gs_data3-bzit.
          gv_currency = gs_data3-waers.
  
          PERFORM refresh_grid27.
  
          cl_gui_cfw=>set_new_ok_code( 'REFRESH' ).  "alv에서는 안타서 강제로 태워야함
  
        ENDIF.
  
    ENDCASE.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Module SET_FCAT_LAYOUT5 OUTPUT
  *&---------------------------------------------------------------------*
  *&
  *&---------------------------------------------------------------------*
  FORM set_fcat_layout5.
  
    gs_layout5-zebra      = 'X'.
    gs_layout5-sel_mode   = 'D'.
    gs_layout5-no_toolbar = 'X'.
  
    IF gt_fcat5 IS INITIAL.
      PERFORM set_fcat5 USING :
  
           ' '  'MATRC'    '자재코드'     'ZTC2MD2006'    'MATRC'  8 'C',
           ' '  'MATRNM'    '자재명'     'ZTC2MD2006'    'MATRNM'  8 'C',
           ' '  'PURCP'    '구매수량'     'ZTC2MM2005'    'PURCP'  10 'C',
           ' '   'UNIT'     ' '         'ZTC2MM2005'   'UNIT'   10 'C',
           ' '  'PURCYM'    '매입년월'     'ZTC2MM2005'    'PURCYM'  7 'C'.
    ENDIF.
  ENDFORM.
  
  FORM set_fcat_layout6.
  
    gs_layout6-zebra      = 'X'.
    gs_layout6-sel_mode   = 'D'.
    gs_layout6-no_toolbar = 'X'.
  
    IF gt_fcat6 IS INITIAL.
      PERFORM set_fcat6 USING :
  
           ' '  'MATRC'    '자재코드'    'ZTC2MD2006'    'MATRC'    8 'C',
           ' '  'MATRNM'   '자재명'      'ZTC2MD2006'    'MATRNM'   8 'C',
           ' '  'ITEMQTY'  '판매수량'    'ZTC2SD2007'     'ITEMQTY'  10 'C',
           ' '  'BOXUNIT'  '판매단위'    'ZTC2SD2007'    'BOXUNIT'    10 'C',
           ' '  'SALEYM'   '매출년월'    'ZTC2SD2007'     'SALEYM'    7 'C'.
    ENDIF.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat5
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_13
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_fcat5  USING   pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length pv_just.
  
    gs_fcat5-key       = pv_key.
    gs_fcat5-fieldname = pv_field.
    gs_fcat5-coltext   = pv_text.
    gs_fcat5-ref_table = pv_ref_table.
    gs_fcat5-ref_field = pv_ref_field.
    gs_fcat5-outputlen = pv_length.
    gs_fcat5-just      = pv_just.
  
  
    CASE pv_field.
  
      WHEN 'SVALUE'.
        gs_fcat5-cfieldname = 'CURRENCY'.
      WHEN 'VAT'.
        gs_fcat5-cfieldname = 'CURRENCY'.
      WHEN 'TOTAL'.
        gs_fcat5-cfieldname = 'CURRENCY'.
      WHEN 'CURRENCY'.
        gs_fcat5-cfieldname = 'CURRENCY'.
      WHEN 'PURCP'.
        gs_fcat5-qfieldname = 'UNIT'.
    ENDCASE.
  
    APPEND gs_fcat5 TO gt_fcat5.
    CLEAR gs_fcat5.
  
  
  ENDFORM.
  
  FORM set_fcat6  USING   pv_key pv_field pv_text pv_ref_table pv_ref_field pv_length pv_just.
  
    gs_fcat6-key       = pv_key.
    gs_fcat6-fieldname = pv_field.
    gs_fcat6-coltext   = pv_text.
    gs_fcat6-ref_table = pv_ref_table.
    gs_fcat6-ref_field = pv_ref_field.
    gs_fcat6-outputlen = pv_length.
    gs_fcat6-just      = pv_just.
  
  
    CASE pv_field.
  
      WHEN 'SVALUE'.
        gs_fcat6-cfieldname = 'WEARS'.
      WHEN 'VAT'.
        gs_fcat6-cfieldname = 'WEARS'.
      WHEN 'TOTAL'.
        gs_fcat6-cfieldname = 'WEARS'.
      WHEN 'WEARS'.
        gs_fcat6-cfieldname = 'WEARS'.
      WHEN 'ITEMQTY'.
        gs_fcat6-qfieldname = 'UNIT'.
    ENDCASE.
  
    APPEND gs_fcat6 TO gt_fcat6.
    CLEAR gs_fcat6.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Module DISPLAY_SCREEN3 OUTPUT
  *&---------------------------------------------------------------------*
  *&
  *&---------------------------------------------------------------------*
  MODULE display_screen3 OUTPUT.
  
    IF gcl_container27 IS NOT BOUND.
  
      CREATE OBJECT gcl_container27
        EXPORTING
          container_name = 'GCL_CONTAINER27'.
  
      CREATE OBJECT gcl_grid27
        EXPORTING
          i_parent = gcl_container27.
  
      CREATE OBJECT gcl_handler3.
      SET HANDLER : gcl_handler3->handle_hotspot2 FOR gcl_grid3.
  
      gs_variant-report = sy-repid.
  
  
      CALL METHOD gcl_grid27->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant27
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout5
        CHANGING
          it_outtab       = gt_data3
          it_fieldcatalog = gt_fcat5.
  
  
    ELSE.
      CASE 'X'.      "alv 필드 카탙로그 바꾸기
        WHEN pa_rd1.
          REFRESH gt_fcat5.
          PERFORM set_fcat_layout5.
  
          gcl_grid27->set_frontend_fieldcatalog(
            EXPORTING
              it_fieldcatalog = gt_fcat5
  
          ).
  
        WHEN pa_rd2.
          REFRESH gt_fcat6.
          PERFORM set_fcat_layout6.
  
          gcl_grid27->set_frontend_fieldcatalog(
            EXPORTING
              it_fieldcatalog = gt_fcat6
  
          ).
      ENDCASE.
  
      PERFORM refresh_grid27.
  
    ENDIF.
  ENDMODULE.
  *&---------------------------------------------------------------------*
  *& Form refresh_grid27
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_grid27 .
  
    gs_stable27-row = 'X'.
    gs_stable27-col = 'X'.
  
    CALL METHOD gcl_grid27->refresh_table_display
      EXPORTING
        is_stable      = gs_stable27
        i_soft_refresh = space.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form show_tax
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM show_tax .
  
    DATA : lv_answer TYPE c LENGTH 1.
  
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '세금계산서 발행'
        text_question         = '세금계산서를 발행하시겠습니까?'
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
      MESSAGE s005 WITH '세금계산서가 발행되었습니다.'.
    ELSE.
      MESSAGE s005 WITH '세금계산서가 발행이 최소되었습니다.'.
    ENDIF.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form detail_info
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM detail_info .
  
    CLEAR  : gv_svalue, "위에 거래처 정보 clear
             gv_vat,
             gv_total,
             gv_bg,
             gv_rp,
             gv_name,
             gv_up,
             gv_bell,
             gv_address,
             gv_currency.
  
    REFRESH : gt_data3, gt_data2. "아래 alv clear
  
  
  ENDFORM.