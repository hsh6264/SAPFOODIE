*&---------------------------------------------------------------------*
*& Include          ZC2SDR2001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form ACT_FUNCTION_KEY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM act_function_key .

    CASE sscrfields-ucomm.
      WHEN 'FC01'.
        PERFORM excel_down_smw0.
  *      PERFORM form_download.          " SMW0를 이용한 Excel Download - 사용금지, 다른 Excel Upload됨.
      WHEN 'FC02'.
        PERFORM excel_down_ole2.        " ol2를 이용한 Excel Download - 이거 사용해야함.
    ENDCASE.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form excel_down_smw0
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM excel_down_smw0.
  
  * IF pa_bt1 = 'X'.
  *
  *   ls_key-objid = 'ZTC2SD2001_EXCEL'.
  *   ls_key-relid = 'MI'.
  *
  *
  *
  * ENDIF.
  
  
    CASE 'X'.
      WHEN pa_bt1.
  *      ls_key-objid = '[SAPFOODIE]2022.12 판매계획'.
        ls_key-objid = 'ZC2SDR2001'.
  *      ls_key-objid = 'SalesOrderPlan_EXCEL'.
        ls_key-relid = 'MI'.
  
      WHEN pa_bt2.
  *      ls_key-objid = '[SAPFOODIE]2022.12 판매계획'.
        ls_key-objid = 'SalesOrderPlan_EXCEL'.
        ls_key-relid = 'MI'.
  
    ENDCASE.
  
  
  * 파일 경로 조회
  *PERFORM set_directory USING ls_key-objid.
  
    PERFORM set_directory USING ls_key-objid.
  
  * 엑셀 다운
    PERFORM download_excel_smw0 USING ls_key-objid.
  
    IF sy-subrc = 0.
    ENDIF.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form DOWNLOAD_EXCEL_SMW0
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> LS_KEY_OBJID
  *&---------------------------------------------------------------------*
  FORM download_excel_smw0  USING ls_key_objid.
  
  
  
    CALL FUNCTION 'DOWNLOAD_WEB_OBJECT'
      EXPORTING
        key         = ls_key
        destination = gv_file.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_DIRECTORY
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> LS_KEY_OBJID
  *&---------------------------------------------------------------------*
  *FORM set_directory  USING  ls_keY-objid.
  *
  *CLEAR gv_file.
  *  CREATE OBJECT objfile.
  *
  *  IF gv_file IS NOT INITIAL.
  *    gv_initial_dir = gv_file.
  *  ELSE.
  *    objfile->get_temp_directory( CHANGING     temp_dir = gv_initial_dir
  *                                 EXCEPTIONS   cntl_error           = 1
  *                                              error_no_gui         = 2
  *                                              not_supported_by_gui = 3 ).
  *  ENDIF.
  *
  *  objfile->directory_browse( EXPORTING  initial_folder = gv_initial_dir
  *                             CHANGING   selected_folder = gv_directory
  *                             EXCEPTIONS cntl_error      = 1
  *                                        error_no_gui    = 2
  *                                        not_supported_by_gui = 3 ).
  *  IF sy-subrc = 0.
  *    gv_file = gv_directory && '\' && ls_key-objid && '.xlsx'.
  *  ELSE.
  *    MESSAGE s008 DISPLAY LIKE 'E'.
  *    LEAVE LIST-PROCESSING.
  *  ENDIF.
  *
  *ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_FUNCTION_KEY
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_function_key .
  
  * SMW0
    g_function_key-icon_id   = icon_xls.
    g_function_key-icon_text = TEXT-004.
    g_function_key-text      = TEXT-004.
    sscrfields-functxt_01    = g_function_key.
  
  * OLE2
    g_function_key-icon_id   = icon_xls.
    g_function_key-icon_text = TEXT-005.
    g_function_key-text      = TEXT-005.
    sscrfields-functxt_02    = g_function_key.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_data .
  
  
    gs_layout-zebra      = 'X'.
    gs_layout-cwidth_opt = 'X'.
    gs_layout-sel_mode   = 'D'.
    gs_layout-no_toolbar = 'X'.
  
    PERFORM set_fcat USING:
          "계획번호 계획플랜트 계획 시작년월 제품코드 판매수량 수량단위
          'X' 'PLANT'   '플랜트'       'ZTC2SD2001'  'PLANT',      " 플랜트
          'X' 'SDPLNO'  '계획 번호'     'ZTC2SD2001'  'SDPLNO',     " 계획번호
          ' ' 'PLNYM'   '계획 년월'     'ZTC2SD2001'  'PLNYM',      " 계획 시작년월
          'X' 'PRODCD'  '제품코드'      'ZTC2SD2002'  'PRODCD',     " 제품코드
          ' ' 'SDPLQTY' '판매수량'      'ZTC2SD2002'  'SDPLQTY',    " 판매 수량
          ' ' 'BOXUNIT' '수량단위'      'ZTC2SD2002'  'BOXUNIT'.    " 수량 단위
  
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_file
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_file .
  
    DATA: lt_file TYPE filetable,
          lv_rc   TYPE i,
          ls_file LIKE LINE OF lt_file.
  
    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      CHANGING
        file_table = lt_file
        rc         = lv_rc.
  
    READ TABLE lt_file INTO ls_file INDEX 1.
    IF sy-subrc = 0.
  
      pa_file = ls_file.
  
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form UPLOAD_FROM_EXCEL
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM upload_from_excel .
  
  *  DATA: lt_intern TYPE TABLE OF alsmex_tabline,
  *        ls_intern TYPE alsmex_tabline.
    DATA: lv_cnt TYPE i.
  
    CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
      EXPORTING
        filename                = pa_file           " Excel 파일의 경로
        i_begin_col             = 1                 " compiler가 인식할 시작 열 번호
        i_begin_row             = 2                 " compiler가 인식할 시작 행 번호
        i_end_col               = 7                 " excel에 명시한 필드 개수
        i_end_row               = 15                " 몇건까지 할건지
      TABLES
        intern                  = gt_intern         " 펑션 수행결과 excel data를 받은 인터널 테이블
      EXCEPTIONS
        inconsistent_parameters = 1
        upload_ole              = 2
        OTHERS                  = 3.
  
  
    IF sy-subrc <> 0.
      MESSAGE i008.             " 데이터를 불러오는 중 오류가 발생했습니다.
      LEAVE LIST-PROCESSING.
    ENDIF.
  
    IF gt_intern IS INITIAL.
      MESSAGE e009.             " 데이터가 존재하지 않습니다.
    ENDIF.
  
  
  * 아래 구문 주석할거
  
  *  LOOP AT lt_intern INTO ls_intern.
  *
  *    ASSIGN COMPONENT ls_intern-COL OF STRUCTURE gt_itab TO <FS>.
  *    <FS> = ls_intern-value.
  *    AT END OF ROW.
  *      APPEND GS_ITAB TO GT_ITAB.
  *      CLEAR GS_ITAB.
  *      ENDAT.
  *
  *  ENDLOOP.
    CLEAR lv_cnt.
  
    LOOP AT gt_intern INTO gs_intern.                   " Excel Data -> ALV에 몇줄 들어가는지?
      IF gs_intern IS INITIAL.
        EXIT.
      ENDIF.
  
      IF gs_intern-col MOD 6  = 3.
        gs_intern-value = gs_intern-value(6).
      ENDIF.
  
      IF gs_intern-col MOD 6  = 1.
        gs_dataplan-plant = gs_intern-value.
        lv_cnt += 1.
      ELSEIF gs_intern-col MOD 6  = 2.
        gs_dataplan-sdplno = gs_intern-value.
        lv_cnt += 1.
      ELSEIF gs_intern-col MOD 6  = 3.
        gs_dataplan-plnym = gs_intern-value.
        lv_cnt += 1.
      ELSEIF gs_intern-col MOD 6  = 4.
        gs_dataplan-prodcd  = gs_intern-value.
        lv_cnt += 1.
      ELSEIF gs_intern-col MOD 6  = 5.
        gs_dataplan-sdplqty = gs_intern-value.
        lv_cnt += 1.
      ELSEIF gs_intern-col MOD 6  = 0.
        gs_dataplan-boxunit = gs_intern-value.
        lv_cnt += 1.
      ENDIF.
  
      IF lv_cnt MOD 6 = 0.
        APPEND gs_dataplan TO gt_dataplan.
        CLEAR gs_dataplan.
      ENDIF.
    ENDLOOP.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_data .
  
  *  IF gcl_container IS NOT BOUND.
  
  
    CREATE OBJECT gcl_container
      EXPORTING
        container_name = 'GCL_CONTAINER'.
  
  
    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.
  
  
  
    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_dataplan "gt_itab
        it_fieldcatalog = gt_fcat.
  
  
    PERFORM refresh_data.
  
  
  *   ENDIF.
  
  
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_itab
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_itab .
  
    DATA: lv_matrc    TYPE c LENGTH 2.
    DATA: lt_itab     LIKE TABLE OF gs_itab,
          ls_itab     LIKE gs_itab,
          ls_itabplan LIKE gs_dataplan,
          lv_cnt      TYPE i.
  
  
    CLEAR   gs_itab.
    REFRESH gt_itab.
  
  
    " 플랜트, 계획번호, 계획 시작 년일, 제품코드 판매수량 수량단위
  *  SELECT a~plant
  *         a~sdplno
  *         a~plcrdt
  *         b~prodcd
  *         b~sdplqty
  *         b~boxunit
  *    FROM ztc2sd2001         AS a
  *    INNER JOIN   ztc2sd2002 AS b
  *            ON a~sdplno = b~sdplno
  *    INTO CORRESPONDING FIELDS OF TABLE gt_itab
  *    WHERE a~plant = pa_plant.
  
  
  
  *
  *  SELECT b~plant
  *         a~matrc
  *         a~matrnm
  *         a~sdprice
  *         a~currency
  *
  *  FROM ztc2md2006 AS a
  *    INNER JOIN ztc2sd2002 AS b
  *    ON a~matrc = b~prodcd
  *    INner join ztc2sd2001 as c
  *    on b~sdplno = c~sdplno
  *    INTO CORRESPONDING FIELDS OF TABLE gt_itab.
  **    WHERE A~MATRC = gs_dataplan-prodcd.
  
    SELECT   a~matrc
             a~matrnm
             a~sdprice
             a~currency
    FROM ztc2md2006 AS a
    INTO CORRESPONDING FIELDS OF lS_itab
    WHERE a~matrc LIKE 'CP%'.
      ls_itab-plant = '1000'.
      lv_cnt += 1.
      READ TABLE gt_dataplan INTO ls_itabplan INDEX lv_cnt.
  *    IF ls_itabplan-prodcd <> ls_itab-matrc.            " IF문 있으면 EXCEL과 데이터가 서로 없는것만 나오게됨.
      APPEND ls_itab TO lt_itab.
  *    ENDIF.
  
  
  *        loop at gt_dataplan into ls_itabplan.
  *          if ls_itabplan-prodcd <> ls_itab-matrc.
  *            APPEND ls_itab TO LT_ITAB.
  *          ENDIF.
  *        ENDLOOP.
    ENDSELECT.
    MOVE-CORRESPONDING lt_itab TO gt_itab.
  
  
    SORT gt_itab BY sdplno matrc ASCENDING.
  
  
    IF sy-subrc NE 0.
  
      MESSAGE s001.
      LEAVE LIST-PROCESSING.
  
    ENDIF.
  
  
  
  
  
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form SET_FCAT
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM set_fcat  USING  pv_key
                        pv_field
                        pv_text
                        pv_ref_table
                        pv_ref_field.
  
    gs_fcat-key       = pv_key.
    gs_fcat-fieldname = pv_field.
    gs_fcat-coltext   = pv_text.
    gs_Fcat-ref_table = pv_ref_table.
    gs_fcat-ref_field = pv_ref_field.
  
    CASE pv_field.
      WHEN 'SDPLQTY'.
        gs_fcat-qfieldname = 'BOXUNIT'.
        gs_fcat-edit = 'X'.
  *    WHEN 'SDPRICE'.
  *      gs_fcat-cfieldname = 'CURRENCY'.
    ENDCASE.
  
  
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_data .
  
    gs_stable-col = 'X'.
    gs_stable-row = 'X'.
  
    CALL METHOD gcl_grid->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = space.
  
  ENDFORM.
  
  
  *&---------------------------------------------------------------------*
  *& Form flag_listbox
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM flag_listbox .
  **
  **  name = 'PA_FLAG'.
  **   value-key = 'A'. Value-text = '승인 대기'. APPEND value TO list.
  **   value-key = 'B'. Value-text = '승인'.    APPEND value TO list.
  **   value-key = 'C'. Value-text = '반려'.    APPEND value TO list.
  
  * CALL FUNCTION 'VRM_SET_VALUES'
  *   EXPORTING
  *     id                    = name
  *     values                = list.
  
    DATA : ls_tab    TYPE dd07v,
           lt_tab    LIKE TABLE OF ls_tab,
           lv_domain TYPE dd07l-domname.
  
    lv_domain = 'ZDC2SD_STATFLAG'.
    name = 'PA_FLAG'.
  
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
  *& Form display_data_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_data_2 .
  
    IF gcl_container_2 IS NOT BOUND.
  
      CREATE OBJECT gcl_container_2
        EXPORTING
          container_name = 'GCL_CONTAINER_2'.
  
      CREATE OBJECT gcl_grid_2
        EXPORTING
          i_parent = gcl_container_2.
  
      gs_variant = sy-dynnr.
  
      CALL METHOD gcl_grid_2->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant_2
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout_2
        CHANGING
          it_outtab       = gt_itab "gt_dataplan
          it_fieldcatalog = gt_fcat_2.
  
  
    ENDIF.
  
    PERFORM refresh_data_2.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_itab2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_itab2 .
  
  *&---------------------------------------------------------------------*
  *& 원본
  *&---------------------------------------------------------------------*
  
    CLEAR   gs_itab2.
    REFRESH gt_itab2.
  
  
    DATA: lv_domain TYPE dcobjdef-name,
          lv_value  TYPE dd07v-domvalue_l,
          lv_text   TYPE dd07v-ddtext,
          lv_tabix  TYPE sy-tabix,
          lv_check  TYPE ztc2sd2001-sdplno,
          lv_result TYPE ztc2sd2006-ttamount.
  
    lv_domain = 'ZDC2SD_STATFLAG'.
  
    DATA: BEGIN OF ls_itab3,
            checkbox,
            statext  TYPE dd07v-ddtext,
            statflag TYPE ztc2sd2001-statflag,
            sdplno   TYPE ztc2sd2001-sdplno,
            plant    TYPE ztc2sd2001-plant,
            plcrdt   TYPE ztc2sd2001-plcrdt,
            plnym    TYPE ztc2sd2001-plnym,
            resprid  TYPE ztc2sd2001-resprid,
            ttamount TYPE ztc2sd2006-ttamount,
            sdprice  TYPE ztc2md2006-sdprice,
            sdplqty  TYPE ztc2sd2002-sdplqty,
  
          END OF ls_itab3,
  
  
          lt_itab3 LIKE TABLE OF ls_itab3
          WITH NON-UNIQUE KEY checkbox statext statflag sdplno
                              plant plcrdt plnym resprid.
  
    DATA: BEGIN OF ls_itab4,
            checkbox,
            statext  TYPE dd07v-ddtext,
            statflag TYPE ztc2sd2001-statflag,
            sdplno   TYPE ztc2sd2001-sdplno,
            plant    TYPE ztc2sd2001-plant,
            plcrdt   TYPE ztc2sd2001-plcrdt,
            plnym    TYPE ztc2sd2001-plnym,
            resprid  TYPE ztc2sd2001-resprid,
            ttamount TYPE ztc2sd2006-ttamount,
            sdprice  TYPE ztc2md2006-sdprice,
            sdplqty  TYPE ztc2sd2002-sdplqty,
          END OF ls_itab4,
  
  
          lt_itab4 LIKE TABLE OF ls_itab4
          WITH NON-UNIQUE KEY checkbox statext statflag sdplno
                              plant plcrdt plnym resprid.
  
  
    SELECT a~statflag
           a~sdplno
           a~cmpnc
           a~plant
           a~plcrdt
           a~plnym
           a~resprid
           b~sdplqty
           c~sdprice
           c~currency
      FROM ztc2sd2001 AS a
      INNER JOIN ztc2sd2002 AS b
              ON a~sdplno = b~sdplno
      INNER JOIN ztc2md2006 AS c
              ON b~prodcd  = c~matrc
      INTO CORRESPONDING FIELDS OF TABLE gt_itab2
      WHERE a~statflag =  pa_flag
      AND   a~plnym    IN so_plnym.
  **      and
  **            pa_flag
  
  
    SORT gt_itab2 BY sdplno ASCENDING.
  
    MOVE-CORRESPONDING gt_itab2 TO lt_itab3.
  
    LOOP AT lt_itab3 INTO ls_itab3.
  
      lv_tabix = sy-tabix.
      lv_value = ls_itab3-statflag.
  
  
      CALL FUNCTION 'ISU_DOMVALUE_TEXT_GET'
        EXPORTING
          x_name  = lv_domain
          x_value = lv_value
        IMPORTING
          y_text  = lv_text.
  
      ls_itab3-statext  = lv_text.
      ls_itab3-ttamount = ls_itab3-sdprice * ls_itab3-sdplqty.
  *    ls_itab3-ttamount = gs_sdplno_detail-sdplqty * gs_sdplno_detail-sdprice.
  
  
      MODIFY lt_itab3 FROM ls_itab3 INDEX lv_tabix
      TRANSPORTING statext statflag."statflag.
  
      COLLECT ls_itab3 INTO lt_itab4.
  *
  *    MODIFY lt_itab3 FROM ls_itab3 INDEX lv_tabix
  *    TRANSPORTING statext ."statflag.
  
    ENDLOOP.
  
    LOOP AT lt_itab4 INTO ls_itab4.
      READ TABLE gt_itab2 INTO gs_itab2 WITH KEY sdplno = ls_itab4-sdplno.
      gs_itab2-ttamount = ls_itab4-ttamount.
      gs_itab2-waers    = gs_itab2-currency.
      gs_itab2-statext  = ls_itab4-statext.
      MODIFY TABLE gt_itab2 FROM gs_itab2.
    ENDLOOP.
  
    SORT gt_itab2 BY sdplno ASCENDING ttamount DESCENDING .
    DELETE ADJACENT DUPLICATES FROM gt_itab2 COMPARING checkbox statflag sdplno plant plcrdt plnym resprid.
  
    IF sy-subrc NE 0.
      MESSAGE s004 WITH TEXT-m00.
      LEAVE LIST-PROCESSING.
    ENDIF.
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_fcat_data_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_data_2 .
  
    gs_layout_2-zebra = 'X'.
  *  gs_layout_2-cwidth_opt = 'X'.
    gs_layout_2-sel_mode = 'D'.
    gs_layout_2-no_toolbar = 'X'.
  
    PERFORM set_fcat_2 USING:
  
          'X' 'PLANT'    '플랜트'      'ZTC2SD2001'  'PLANT' 7,
  *        'X' 'SDPLNO'  '계획 번호'    'ZTC2SD2001'  'SDPLNO' 8,
          'X' 'MATRC'    '제품 코드'    'ZTC2MD2006'  'MATRC' 7,
          ' ' 'MATRNM'   '제품 명'     'ZTC2MD2006'  'MATRNM' 17,
          ' ' 'SDPRICE'  '제품 가격'    'ZTC2MD2006'  'SDPRICE' 9,
          ' ' 'CURRENCY' '통화키'      'ZTC2MD2006'  'CURRENCY' 3.
  
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
                          pv_length.
  
  
    gs_fcat_2-key       = pv_key.
    gs_fcat_2-fieldname = pv_field.
    gs_fcat_2-coltext   = pv_text.
    gs_fcat_2-ref_table = pv_ref_table.
    gs_fcat_2-ref_field = pv_ref_field.
    gs_fcat_2-outputlen = pv_length.
  
    CASE pv_field.
      WHEN 'SDPRICE'.
        gs_fcat_2-cfieldname = 'CURRENCY'.
        GS_fCAT_2-decimals_o = 0.
    ENDCASE.
  
  
  
    APPEND gs_fcat_2 TO gt_fcat_2.
    CLEAR gs_fcat_2.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh_data_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_data_2 .
  
  
    gs_stable_2-col = 'X'.
    gs_stable_2-row = 'X'.
  
    CALL METHOD gcl_grid_2->refresh_table_display
      EXPORTING
        is_stable      = gs_stable_2
        i_soft_refresh = space.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form refresh_data_3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM refresh_data_3 .
  
    gs_stable_3-col = 'X'.
    gs_stable_3-row = 'X'.
  
    CALL METHOD gcl_grid_3->refresh_table_display
      EXPORTING
        is_stable      = gs_stable_3
        i_soft_refresh = space.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form CONVERT_TO_DISPLAY_FORMAT
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM convert_to_display_format .
  
    PERFORM data_upload.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form DATA_UPLOAD
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM data_upload .
  
  * 엑셀 데이터 넣기
    LOOP AT lt_intern INTO ls_intern.
      ASSIGN COMPONENT ls_intern-col OF STRUCTURE gs_d_excel TO <fs>.
      <fs> = ls_intern-value.
      AT END OF row.
        MOVE-CORRESPONDING gs_d_excel TO gs_dataplan.
        APPEND gs_dataplan TO gt_dataplan.
        CLEAR: gs_d_excel, gs_dataplan.
      ENDAT.
    ENDLOOP.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form CHECK_BEFORE_PROCESS
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM check_before_process .
  
  * 파일 주소 확인
    IF pa_file EQ space.
      MESSAGE i003.
      LEAVE LIST-PROCESSING.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form excel_down_ole2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM excel_down_ole2 .
  
  
  * 다운로드 양식 선택
    IF pa_bt1 = 'X'.
  
      ls_key-objid = 'SalesOrderPlan_EXCEL'.      " 파일명 제목
      ls_key-relid  = 'MI'.
  
    ENDIF.
  
  * 파일 경로 조회
    PERFORM set_directory USING ls_key-objid.
  
  * 엑셀 다운
    PERFORM download_excel_ole USING ls_key-objid.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form download_excel_ole
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> LS_KEY_OBJID
  *&---------------------------------------------------------------------*
  FORM download_excel_ole  USING p_key_objid.
  
  * OLE OBJECT 생성 & 실행
    CREATE OBJECT go_application 'Excel.Application'.
  
  * 화면 DISPLAY 설정 (1을 설정하면 DISPLAY)
    SET PROPERTY OF go_application 'Visible' = 1.
  
  * WORKBOOK 및 WORKBOOK 설정 & OPEN
    CALL METHOD OF go_application 'Workbooks' = go_wbook.
    CALL METHOD OF go_wbook 'Add'.
  
  * 최초 실행 SHEET는 첫번째
    CALL METHOD OF go_application 'Worksheets' = go_sheet
      EXPORTING
        #1 = 1.
    CALL METHOD OF go_sheet 'Activate'.
    SET PROPERTY OF go_sheet 'Name' = 'Sheet1'.
    GET PROPERTY OF go_application 'ActiveWorkbook' = go_wbook.
  
  
  * 데이터 입력, 수기로함.. 다른방법 모르겠음 [원하는 수 만큼만 사용하면됨]
    PERFORM fill_cell USING go_application 01:     01 '플랜트',
                                                   02 '계획번호',
                                                   03 '계획년월',
                                                   04 '제품코드',
                                                   05 '판매수량',
                                                   06 '수량단위'.
  
    PERFORM fill_cell_2 USING go_application 02:   01 '1000',
                                                   02 'SD22120001',
                                                   03 '20221201',
                                                   04 'CP0001',
                                                   05 '740',
                                                   06 'KAR'.
  
    PERFORM fill_cell_3 USING go_application 03:   01 '1000',
                                                   02 'SD22120001',
                                                   03 '20221201',
                                                   04 'CP0002',
                                                   05 '930',
                                                   06 'KAR'.
  
    PERFORM fill_cell_4 USING go_application 04:   01 '1000',
                                                   02 'SD22120001',
                                                   03 '20221201',
                                                   04 'CP0003',
                                                   05 '1050',
                                                   06 'KAR'.
  
    PERFORM fill_cell_5 USING go_application 05:   01 '1000',
                                                   02 'SD22120001',
                                                   03 '20221201',
                                                   04 'CP0004',
                                                   05 '990',
                                                   06 'KAR'.
  
  *  PERFORM fill_cell_6 USING go_application 06:   01 '1000',
  *                                                 02 'SD22090001',
  *                                                 03 '20220901',
  *                                                 04 'CP0005',
  *                                                 05 '100',
  *                                                 06 'KAR'.
  *
  *  PERFORM fill_cell_7 USING go_application 07:   01 '1000',
  *                                                 02 'SD22090001',
  *                                                 03 '20220901',
  *                                                 04 'CP0006',
  *                                                 05 '100',
  *                                                 06 'KAR'.
  *
  *  PERFORM fill_cell_8 USING go_application 08:   01 '1000',
  *                                                 02 'SD22090001',
  *                                                 03 '20220901',
  *                                                 04 'CP0007',
  *                                                 05 '100',
  *                                                 06 'KAR'.
  *
  *  PERFORM fill_cell_9 USING go_application 09:   01 '1000',
  *                                                 02 'SD22090001',
  *                                                 03 '20220901',
  *                                                 04 'CP0008',
  *                                                 05 '100',
  *                                                 06 'KAR'.
  
  
  * 파일명 설정
    CONCATENATE gv_directory '\' p_key_objid '.xlsx' INTO gv_path.  "//'
  
  * 실행 파일 저장
    CALL METHOD OF go_wbook 'SaveAs' EXPORTING #1 = gv_path.
  
    IF sy-subrc = 0.
      MESSAGE s000.
    ELSE.
      MESSAGE s009.
    ENDIF.
  ENDFORM.
  
  
  
  *&---------------------------------------------------------------------*
  *& Form FILL_CELL
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GO_APPLICATION
  *&      --> P_01
  *&      --> P_01
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM fill_cell  USING pv_application
                        pv_row            " 행
                        pv_col            " 열
                        pv_value.         " 데이터 값
  
    DATA: lv_ecell TYPE ole2_object.
  
    CALL METHOD OF pv_application 'Cells' = lv_ecell
    EXPORTING
      #1 = pv_row
      #2 = pv_col.
  
    SET PROPERTY OF lv_ecell 'Value' = pv_value.
  
  ENDFORM.
  
  *&---------------------------------------------------------------------*
  *& Form set_fcat_data_3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_fcat_data_3 .
  
    IF gt_fcat_3 IS INITIAL.
  
      gs_layout_3-zebra      = 'X'.
  *    gs_layout_3- cwidth_opt = 'X'.
      gs_layout_3-sel_mode   = 'A'.
      gs_layout_3-no_rowmark  = 'X'.
      gs_layout_3-no_toolbar = 'X'.
      gs_layout_3-ctab_fname = 'COLOR'.
  
  * statflag sdplno plant plcrdt plnym resprid ttamount waers
  
      PERFORM set_fcat_3 USING:
         'X' 'CHECKBOX' '선택' '' '' 5,
         'X' 'STATEXT' '상태' 'GT_ITAB2' 'STATEXT' 7,
  *       'X' 'STATFLAG' ' ' 'ZTC2SD2001'   'STATFLAG' 5,
         'X' 'PLANT'    ' ' 'ZTC2SD2001'    'PLANT'   8,
         'X' 'SDPLNO'   ' ' 'ZTC2SD2001'   'SDPLNO'  10,
         ' ' 'PLCRDT'   ' ' 'ZTC2SD2001'   'PLCRDT'  7,
         ' ' 'PLNYM'    ' ' 'ZTC2SD2001'    'PLNYM'  5,
         ' ' 'RESPRID'  ' ' 'ZTC2SD2001'  'RESPRID'  5,
         ' ' 'TTAMOUNT' ' ' 'ZTC2SD2006' 'TTAMOUNT'  10,
         ' ' 'WAERS'    ' ' 'ZTC2SD2006'    'WAERS'  5.
  
  
  
    ENDIF.
  
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
  FORM set_fcat_3  USING pv_key
                         pv_field
                         pv_text
                         pv_ref_table
                         pv_ref_field
                         pv_length.
  
    gs_fcat_3-key       = pv_key.
    gs_fcat_3-fieldname = pv_field.
    gs_fcat_3-coltext   = pv_text.
    gs_Fcat_3-ref_table = pv_ref_table.
    gs_fcat_3-ref_field = pv_ref_field.
    gs_fcat_3-outputlen = pv_length.
  
  
  
  
  
  
    CASE pv_field.
      WHEN 'TTAMOUNT'.
        gs_fcat_3-cfieldname = 'WAERS'.
      WHEN 'CHECKBOX'.
        gs_fcat_3-checkbox = 'X'.
        gs_fcat_3-edit = 'X'.
      WHEN 'SDPLNO'.
        gs_fcat_3-hotspot = 'X'.
    ENDCASE.
  
  
    APPEND gs_fcat_3 TO gt_fcat_3.
    CLEAR gs_fcat_3.
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form display_data_3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM display_data_3 .
  
    IF gcl_container_3 IS NOT BOUND.
  
      CREATE OBJECT gcl_container_3
        EXPORTING
          container_name = 'GCL_CONTAINER_3'.
  
      CREATE OBJECT gcl_grid_3
        EXPORTING
          i_parent = gcl_container_3.
  
  
  
      IF gcl_handler IS NOT BOUND.
  
        CREATE OBJECT gcl_handler.
  
      ENDIF.
  
  
      SET HANDLER: gcl_handler->hotspot_click FOR gcl_grid_3.
  
      CALL METHOD gcl_grid_3->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified.
  
  
      gs_variant_3-report = sy-repid.
  
      CALL METHOD gcl_grid_3->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant_3
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout_3
        CHANGING
          it_outtab       = gt_itab2
          it_fieldcatalog = gt_fcat_3.
  
  
  
  
  
  
  *
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form handle_data_changed
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> ER_DATA_CHANGED
  *&---------------------------------------------------------------------*
  FORM handle_data_changed  USING pcl_data_changed
                            TYPE REF TO cl_alv_changed_data_protocol.
  *
  *  DATA: ls_modi TYPE lvc_s_modi.
  *  DATA: lv_tabix TYPE sy-tabix,
  *        ls_color TYPE lvc_s_scol.
  *
  *
  *  LOOP AT pcl_data_changed->mt_mod_cells INTO ls_modi.
  *
  *    CASE ls_modi-fieldname.
  *      WHEN 'CHECKBOX'.
  *
  *        READ TABLE gt_itab2 INTO gs_itab2 INDEX ls_modi-row_id.
  *
  *      IF gs_itab2-statflag = 'A' OR gs_itab2-statflag = 'D'.
  *
  *        ls_color-fname = 'STATFLAG'.
  *        ls_color-color-col = '3'.
  *        ls_color-color-int = '1'.
  *        ls_color-color-inv = '0'.
  *
  *        APPEND ls_color TO gs_itab2-color.
  *
  *      ELSEIF gs_itab2-statflag = 'B' OR gs_itab2-statflag = 'E' OR
  *             gs_itab2-statflag = 'F' OR gs_itab2-statflag = 'G'.
  *
  *        ls_color-fname = 'STATFLAG'.
  *        ls_color-color-col = '5'.
  *        ls_color-color-int = '1'.
  *        ls_color-color-inv = '0'.
  *
  *        APPEND ls_color TO gs_itab2-color.
  *
  *      ELSEIF gs_itab2-statflag = 'C'.       " 반려
  *
  *        ls_color-fname = 'STATFLAG'.
  *        ls_color-color-col = '6'.
  *        ls_color-color-int = '1'.
  *        ls_color-color-inv = '0'.
  *
  *        APPEND ls_color TO gs_itab2-color.
  *
  *
  *      ENDIF.
  *
  *      IF sy-subrc NE 0.
  *        CONTINUE.
  *      ENDIF.
  *
  *    MODIFY gt_itab2 FROM gs_itab2 INDEX ls_modi-row_id
  *    TRANSPORTING statflag color.
  *
  *    ENDCASE.
  *
  *
  *  ENDLOOP.
  **
  *
  *
  *   PERFORM refresh_data_3.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form CHECKBOX_CLICK
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM checkbox_click .
  
    DATA: ls_modi TYPE lvc_s_modi.
    DATA: lv_tabix TYPE sy-tabix,
          ls_color TYPE lvc_s_scol.
  
    DATA : ls_itab TYPE ztc2sd2001,
           lt_itab LIKE TABLE OF ls_itab.
  
  
    DATA: lv_answer TYPE c LENGTH 1.
  
    DATA: lv_valid   TYPE char01,
          lv_refresh TYPE char01.
  
  
    CLEAR: gs_row, ls_color.
    REFRESH: gt_rows.
  *
  *  CALL METHOD gcl_grid_3->get_selected_rows
  *    IMPORTING
  *      et_index_rows = gt_rows.
  *
  
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '승인요청'
        text_question         = '승인요청을 확정하시겠습니까?'
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
        INTO CORRESPONDING FIELDS OF TABLE lt_itab
        FROM ztc2sd2001.
  
      IF gt_rows IS INITIAL.
        MESSAGE s008 WITH TEXT-m01 DISPLAY LIKE 'E'.
  *      EXIT.
  
      ENDIF.
  
  
      SORT gt_itab2 BY plant sdplno plnym plcrdt resprid statflag  .
      DELETE ADJACENT DUPLICATES FROM gt_itab2 COMPARING plant sdplno plnym plcrdt resprid statflag.
  
  *    LOOP AT gt_rows INTO gs_row.
      LOOP AT gt_itab2 INTO gs_ITAB2.
  *      READ TABLE gt_itab2 INTO gs_itab2 WITH KEY sdplno = GS_ITAB2-sdplno.
        CLEAR ls_color.
        lv_tabix = sy-tabix.
        CASE gs_itab2-checkbox.
          WHEN 'X'.
            IF gs_itab2-statext = '승인 대기'.
              CLEAR gs_itab2-color.
              gs_itab2-statext   = '승인 요청'.
              ls_color-fname     = 'STATEXT'.
              ls_color-color-col = '5'.
              ls_color-color-int = '1'.
              ls_color-color-inv = '0'.
              gs_itab2-statflag  = 'B'.
              APPEND ls_color TO gs_itab2-color.
              MODIFY gt_itab2 FROM gs_itab2 INDEX lv_tabix.
  *            TRANSPORTING STATEXT color. ".
  *            CLEAR gs_itab2.
            ELSE.
              IF sy-subrc NE 0.
                CONTINUE.
              ENDIF.
            ENDIF.
        ENDCASE.
      ENDLOOP.
  
      MOVE-CORRESPONDING gt_itab2 TO lt_itab.
      MODIFY ztc2sd2001 FROM TABLE Lt_itaB.
      CLEAR gs_itab2.
  
      PERFORM set_cell_color.
      PERFORM refresh_data_3.
  
  
  
      IF sy-dbcnt > 0.
        COMMIT WORK. " AND WAIT.
        MESSAGE s000 WITH '승인요청이 확정되었습니다.'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE s003 DISPLAY LIKE 'E'.
      ENDIF.
  
    ELSE.
      MESSAGE s000 DISPLAY LIKE 'W' WITH '취소되었습니다'.
  
  
  
  
  
    ENDIF.
  
  *  PERFORM set_cell_color.
  *  CLEAR gs_itab2.
  
  
  
  *&---------------------------------------------------------------------*
  *& 삭제보류
  *&---------------------------------------------------------------------*
  
  *  LOOP AT gt_itab2 INTO gs_itab2.
  *
  **      READ TABLE gt_itab2 INTO gs_itab2 INDEX gs_row-index.
  *        CLEAR ls_color.
  *        lv_tabix = sy-tabix.
  *
  *    CASE gs_itab2-checkbox.
  *      WHEN 'X'.
  *
  *      IF gs_itab2-statflag = 'A' OR gs_itab2-statflag = 'D'.
  *
  *        ls_color-fname = 'STATFLAG'.
  *        ls_color-color-col = '3'.
  *        ls_color-color-int = '1'.
  *        ls_color-color-inv = '0'.
  *
  *
  *        APPEND ls_color TO gs_itab2-color.
  *
  *      ELSEIF gs_itab2-statflag = 'B' OR gs_itab2-statflag = 'E' OR
  *             gs_itab2-statflag = 'F' OR gs_itab2-statflag = 'G'.
  *
  *        ls_color-fname = 'STATFLAG'.
  *        ls_color-color-col = '5'.
  *        ls_color-color-int = '1'.
  *        ls_color-color-inv = '0'.
  *
  *
  *        APPEND ls_color TO gs_itab2-color.
  *
  *      ELSEIF gs_itab2-statflag = 'C'.       " 반려
  *
  *        ls_color-fname = 'STATFLAG'.
  *        ls_color-color-col = '6'.
  *        ls_color-color-int = '1'.
  *        ls_color-color-inv = '0'.
  *
  *
  *        APPEND ls_color TO gs_itab2-color.
  *
  *
  *      ENDIF.
  
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
  
    DATA: lv_tabix TYPE sy-tabix,
          ls_color TYPE lvc_s_scol.
  
  
    LOOP AT gt_itab2 INTO gs_itab2.
  
  *      READ TABLE gt_itab2 INTO gs_itab2 INDEX gs_row-index.
      CLEAR ls_color.
      lv_tabix = sy-tabix.
  
  *    CASE gs_itab2-checkbox.
  *      WHEN 'X'.
  
      CASE gs_itab2-statext.
        WHEN '승인 대기'. "OR '주문 접수'.
          ls_color-fname = 'STATEXT'.
          ls_color-color-col = '3'.
          ls_color-color-int = '1'.
          ls_color-color-inv = '0'.
  
          APPEND ls_color TO gs_itab2-color.
  *
        WHEN '승인 요청'. "OR '주문 확정' OR '배차 확정' OR '배송 완료'.
          ls_color-fname = 'STATEXT'.
          ls_color-color-col = '5'.
          ls_color-color-int = '1'.
          ls_color-color-inv = '0'.
          APPEND ls_color TO gs_itab2-color.
  
        WHEN '반려'.
          ls_color-fname = 'STATEXT'.
          ls_color-color-col = '6'.
          ls_color-color-int = '1'.
          ls_color-color-inv = '0'.
  
          APPEND ls_color TO gs_itab2-color.
  
      ENDCASE.
  
  *      IF gs_itab2-statflag = 'A' OR gs_itab2-statflag = 'D'.
  *
  *        ls_color-fname = 'STATFLAG'.
  *        ls_color-color-col = '3'.
  *        ls_color-color-int = '1'.
  *        ls_color-color-inv = '0'.
  *
  *
  *        APPEND ls_color TO gs_itab2-color.
  *
  *      ELSEIF gs_itab2-statflag = 'B' OR gs_itab2-statflag = 'E' OR
  *             gs_itab2-statflag = 'F' OR gs_itab2-statflag = 'G'.
  *
  *        ls_color-fname = 'STATFLAG'.
  *        ls_color-color-col = '5'.
  *        ls_color-color-int = '1'.
  *        ls_color-color-inv = '0'.
  *
  *
  *        APPEND ls_color TO gs_itab2-color.
  *
  *      ELSEIF gs_itab2-statflag = 'C'.       " 반려
  *
  *        ls_color-fname = 'STATFLAG'.
  *        ls_color-color-col = '6'.
  *        ls_color-color-int = '1'.
  *        ls_color-color-inv = '0'.
  *
  *
  *        APPEND ls_color TO gs_itab2-color.
  *
  
  *      ENDIF.
  
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.
  
  
  
  *    ENDCASE.
  
      MODIFY TABLE gt_itab2 FROM gs_itab2.
  
    ENDLOOP.
  
  *  PERFORM refresh_data_3.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form add_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM add_data .
  
    DATA: lv_err.
  
    CLEAR: gs_row, gs_dataplan.
    REFRESH: gt_rows.
  
  
    CALL METHOD gcl_grid_2->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
  
    IF gt_rows IS INITIAL.
      MESSAGE s008 DISPLAY LIKE 'E'.
      EXIT.
  
    ELSE.
  
      LOOP AT gt_rows INTO gs_row .
  
        READ TABLE gt_itab INTO gs_itab INDEX gs_row-index.
  
        CLEAR lv_err.
        LOOP AT gt_dataplan INTO gs_dataplan.
  
          IF gs_itab-matrc = gs_dataplan-prodcd.
            lv_err = 'X'.
            EXIT.
          ENDIF.
  
        ENDLOOP.
  
        IF lv_err IS NOT INITIAL.
          MESSAGE s008 DISPLAY LIKE 'E'.
        ELSE.
          PERFORM create_order_number.
  
          gs_dataplan-plant = gs_itab-plant.
          gs_dataplan-sdplno = gs_itab-sdplno.
          gs_dataplan-prodcd = gs_itab-matrc.
          gs_dataplan-sdplqty = 0.
  
          APPEND gs_dataplan TO gt_dataplan.
  *        DELETE gt_itab FROM gs_itab.
        ENDIF.
  
      ENDLOOP.
  
      PERFORM refresh_data.
  
    ENDIF.
  
  
  *  IF gt_rows IS INITIAL.
  *    MESSAGE s008 DISPLAY LIKE 'E'.
  *    EXIT.
  *
  *  ELSE.
  *
  *  PERFORM create_order_number.              " 넘버 레인지에 의한 구매오더 번호 생성
  *
  *    LOOP AT gt_rows INTO gs_row.
  *
  *      READ TABLE gt_itab     INTO gs_itab     INDEX gs_row-index.
  *      READ TABLE gt_dataplan INTO gs_dataplan INDEX gs_row-index.
  *
  *
  *       IF gs_itab-matrc <> gs_dataplan-prodcd.
  *
  *         MOVE-CORRESPONDING gs_itab TO gs_dataplan.
  *         APPEND gs_dataplan TO gt_dataplan.
  *
  *       ELSE.
  *         MESSAGE s008 DISPLAY LIKE 'E'.
  *         EXIT.
  *
  *       ENDIF.
  *
  *      ENDLOOP.
  *   ENDIF.
  *
  * IF sy-subrc NE 0.
  *
  *   MESSAGE s008 DISPLAY LIKE 'E'.
  *   EXIT.
  *
  * ENDIF.
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_directory
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> LS_KEY_OBJID
  *&---------------------------------------------------------------------*
  FORM set_directory  USING ls_key_objid.
  
    CLEAR gv_file.
    CREATE OBJECT objfile.
  
    IF gv_file IS NOT INITIAL.
      gv_initial_dir = gv_file.
    ELSE.
      objfile->get_temp_directory( CHANGING     temp_dir = gv_initial_dir
                                   EXCEPTIONS   cntl_error           = 1
                                                error_no_gui         = 2
                                                not_supported_by_gui = 3 ).
    ENDIF.
  
    objfile->directory_browse( EXPORTING  initial_folder = gv_initial_dir
                               CHANGING   selected_folder = gv_directory
                               EXCEPTIONS cntl_error      = 1
                                          error_no_gui    = 2
                                          not_supported_by_gui = 3 ).
    IF sy-subrc = 0.
      gv_file = gv_directory && '\' && ls_key-objid && '.xlsx'.
    ELSE.
      MESSAGE s008 DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form FORM_DOWNLOAD
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM form_download .
    DATA: lv_filename TYPE string,
          lv_path     TYPE string,
          lv_fullpath TYPE string,
          ls_name     TYPE wwwdatatab.
  *
    DATA: ls_date TYPE sy-datum.
    ls_date = sy-datum.
    " 파일명
    ls_name-text = TEXT-t04.
    lv_filename  = ls_name-text &&'_' && ls_date && |.XLSX|.
  
    DATA : ls_wwwdata_item TYPE wwwdatatab.
    DATA : lt_mime LIKE w3mime OCCURS 100 WITH HEADER LINE.
  
    SELECT SINGLE * FROM  wwwdata
      INTO CORRESPONDING FIELDS OF ls_wwwdata_item
     WHERE objid = 'SalesOrderPlan_EXCEL'   "<-- SMW0 Object 명입니다.
       AND relid = 'MI'.
  
  
    IF sy-subrc NE 0.
      MESSAGE e000(zc203) WITH '데이터가 존재하지 않았습니다.'.
      EXIT.
    ENDIF.
  
  
    CALL FUNCTION 'WWWDATA_IMPORT'
      EXPORTING
        key               = ls_wwwdata_item
      TABLES
        mime              = lt_mime
      EXCEPTIONS
        wrong_object_type = 1
        import_error      = 2
        OTHERS            = 3.
  
  
    DATA : l_filename     TYPE string,
           l_path         TYPE string,
           l_fullpath     TYPE string,
           l_filesize(10),
           l_size         TYPE i.
  
    CALL FUNCTION 'WWWPARAMS_READ'
      EXPORTING
        relid = ls_wwwdata_item-relid
        objid = ls_wwwdata_item-objid
        name  = 'filesize'
      IMPORTING
        value = l_filesize.
  
    CALL METHOD cl_gui_frontend_services=>file_save_dialog
      EXPORTING
        window_title      = '저장'
        default_extension = 'XLS'
  *      file_filter       = 'EXCEL FILES (*.XLS)|*.XLS|EXCEL FILES (*.XLSX)|*.XLSX|'
        initial_directory = 'C:\'
        default_file_name = lv_filename
  *      default_file_name = 'ZC2SDR2001.XLSX'
      CHANGING
        filename          = lv_filename
        path              = l_path
        fullpath          = l_fullpath.
  
    l_size = l_filesize.
  
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename     = l_fullpath
        filetype     = 'BIN'
        bin_filesize = l_size
      TABLES
        data_tab     = lt_mime.
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
  
    DATA: BEGIN OF ls_value,
            statflag TYPE ztc2sd2001-statflag,
          END OF ls_value,
  
          lt_value LIKE TABLE OF ls_value.
  
    REFRESH lt_value.
  
  
  
    SELECT statflag
      INTO CORRESPONDING FIELDS OF TABLE lt_value
      FROM ztc2sd2001
      WHERE statflag BETWEEN 'A' AND 'C'.
  
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield     = 'STATFLAG'
        dynpprog     = sy-repid
        dynpnr       = sy-dynnr
        dynprofield  = 'GS_ITAB2-STATFLAG'
        window_title = '상태'
        value_org    = 'S'
  *     DISPLAY      = ' '
      TABLES
        value_tab    = lt_value.
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form fill_cell_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GO_APPLICATION
  *&      --> P_02
  *&      --> P_01
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM fill_cell_2  USING pv_application
                          pv_row            " 행
                          pv_col            " 열
                          pv_value.         " 데이터 값
  
    DATA: lv_ecell TYPE ole2_object.
  
    CALL METHOD OF pv_application 'Cells' = lv_ecell
    EXPORTING
      #1 = pv_row
      #2 = pv_col.
  
    SET PROPERTY OF lv_ecell 'Value' = pv_value.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form fill_cell_3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GO_APPLICATION
  *&      --> P_03
  *&      --> P_01
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM fill_cell_3  USING  pv_application
                        pv_row            " 행
                        pv_col            " 열
                        pv_value.         " 데이터 값
  
    DATA: lv_ecell TYPE ole2_object.
  
    CALL METHOD OF pv_application 'Cells' = lv_ecell
    EXPORTING
      #1 = pv_row
      #2 = pv_col.
  
    SET PROPERTY OF lv_ecell 'Value' = pv_value.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_input_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_input_data .
  
  *&---------------------------------------------------------------------*
  *& 시연영상 날짜에 맞춰서 아래 코드 수정해야함. 계획생성일, 계획 년월 등
  *&---------------------------------------------------------------------*
  
  
    gv_plant = '1000'. " 플랜트
  *      gv_plnym = sy-datum.          " 계획 년월
  *      gv_sonum type c length 15." 계획 번호
    gv_plcrdt = sy-datum. " 계획 생성일
    gv_resprid = sy-uname.  " 담당자 ID
  
  
    DATA: lv_data LIKE sy-datum.
  
    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = sy-datum      "-> 기준일
        days      = '00'          "-> 더하거나 뺄 일자수
        months    = '01'        "-> 더하거나 뺄 월수             " 시연영상 날짜에 맞춰서 수정 필요
        years     = '00'         "-> 더하거나 뺄 년수
        signum    = '+'         "-> 더할지 뺄지를 정하는 기호      " 시연영상 날짜에 맞춰서 수정 필요
      IMPORTING
        calc_date = lv_data. "-> 계산된 날짜 (SY-DATUM)
  
    CONCATENATE lv_data(6)'' INTO gv_plnym.
  
  
  
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
  
    DATA: lv_sdplno TYPE ztc2sd2001-sdplno,
          lv_today  TYPE ztc2sd2001-plnym.
  
    IF gv_numflag IS INITIAL.
      CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          nr_range_nr             = '01'
          object                  = 'ZC202'
        IMPORTING
          number                  = lv_sdplno
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
  
  
  *&---------------------------------------------------------------------*
  *& 시연영상 날짜에 맞춰서 아래 코드 수정해야함. 계획생성일, 계획 년월 등
  *&---------------------------------------------------------------------*
  *    lv_today =  lv_today+2(4).                 " 시연 영상 날짜에 맞춰서 바꿔주기
      CONCATENATE 'SD' '22120001' INTO lv_sdplno. "lv_today+2(4) lv_sdplno
  
      gs_itab-sdplno = lv_sdplno.
      gv_numflag     = lv_sdplno.
  
    ELSE.
      gs_itab-sdplno = gv_numflag.
  
  
  
    ENDIF.
  
    gv_sonum = gs_itab-sdplno.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form del_data
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM del_data .
  
    CLEAR gs_row.
    REFRESH gt_rows.
  
    CALL METHOD gcl_grid->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    IF gt_rows IS INITIAL.
      MESSAGE s000 WITH TEXT-m01 DISPLAY LIKE 'E'.
      EXIT.
    ELSE.
      SORT gt_rows BY index DESCENDING.
  
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_dataplan INTO gs_dataplan INDEX gs_row-index.
        MOVE-CORRESPONDING gs_dataplan TO gs_data_del.
  
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
  
  
  
        APPEND gs_data_del TO gt_data_del.
        CLEAR gs_data_del.
  
        DELETE gt_dataplan INDEX gs_row-index.
  
        PERFORM refresh_data.
  
      ENDLOOP.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form MODIFY_SCREEN
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM modify_screen .
  
    LOOP AT SCREEN.
  
  
  
      CASE 'X'.
        WHEN pa_bt1.
          CASE screen-group1.
            WHEN 'VIE'.
              screen-active = 0.
              MODIFY SCREEN.
          ENDCASE.
        WHEN pa_bt2.
          CASE screen-group1.
            WHEN 'EXE'.
              screen-active = 0.
              MODIFY SCREEN.
          ENDCASE.
      ENDCASE.
  
  
    ENDLOOP.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form MODIFY_SCREEN_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM modify_screen_2 .
  
    CASE 'X'.
      WHEN pa_bt1.
        PERFORM upload_from_excel.
        PERFORM convert_to_display_format.
        PERFORM get_itab.
        CALL SCREEN 0100.
  
      WHEN pa_bt2.
        PERFORM get_itab2.
        PERFORM set_cell_color.
        CALL SCREEN 0200.
    ENDCASE.
  
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
  
  ***********************************
    DATA: ls_read   TYPE ztc2sd2002,
          lv_tabix  TYPE sy-tabix,
          lv_sdplno TYPE ztc2SD2001-sdplno,
          ls_itab   TYPE ztc2SD2001,
          lt_itab   LIKE TABLE OF ls_itab,
          lv_udate  TYPE sy-datum,
          lv_user   TYPE sy-uname,
          lv_answer TYPE c LENGTH 1.
  
  
    DATA: ls_save TYPE ztc2sd2001,
          lt_save LIKE TABLE OF ls_save,
          lv_cnt  TYPE i.
  
  *  CALL METHOD gcl_grid->check_changed_data.
  
  
    IF gt_dataplan IS INITIAL.
      MESSAGE e009 WITH '저장할 데이터가 없습니다.'.
    ENDIF.
  
  *  IF lv_answer = 1.
  
    CALL METHOD gcl_grid->check_changed_data.
  
    READ TABLE gt_dataplan INTO gs_dataplan INDEX 1.
    lv_sdplno = gs_dataplan-sdplno.
  
  
    LOOP AT gt_dataplan INTO gs_dataplan.
      lv_tabix = sy-tabix.
      MOVE-CORRESPONDING gs_dataplan TO ls_save.
      ls_save-cmpnc = '1004'.
      ls_save-plant = gs_dataplan-plant.
      ls_save-sdplno = lv_sdplno.
      ls_save-plcrdt = sy-datum.
      ls_save-resprid = sy-uname.
      ls_save-plnym = gs_dataplan-plnym.
      ls_save-statflag = 'A'.
  *      gs_dataplan-plant = gs_itab-plant.
  *      gs_dataplan-sdplno = gs_itab-sdplno.
  *      gs_dataplan-prodcd = gs_itab-matrc.
  *      gs_dataplan-sdplqty = 0.
  
  
      APPEND ls_save TO lt_save.
  
    ENDLOOP.
  
    MODIFY ztc2sd2001 FROM TABLE lt_save.
  
    PERFORM refresh_data.
  
  ************************** 잠깐만 삭제금지, 다시 사용할수 있음.
  
  *      IF sy-dbcnt > 0.        " SELECT 구문으로 데이터베이스에서 읽어온 라인 수
  *        COMMIT WORK AND WAIT. " Update work process가 종료될때까지 기다린 후에 다음 프로세스 진행
  **        MESSAGE s000.
  *        MESSAGE s011 WITH ls_save-sdplno.
  *      ELSE.
  *        ROLLBACK WORK.
  *        MESSAGE s003 DISPLAY LIKE 'E'.
  *      ENDIF.
  ***********************
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form save_data_2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM save_data_2 .
  
    DATA: lv_tabix  TYPE sy-tabix,
          lv_sdplno TYPE ztc2sd2002-sdplno,
          ls_itab   TYPE ztc2sd2002,
          lt_itab   LIKE TABLE OF ls_itab,
          lv_udate  TYPE sy-datum,
          lv_user   TYPE sy-uname,
          lv_answer TYPE c LENGTH 1.
  
  
    DATA: ls_save TYPE ztc2sd2002,
          lt_save LIKE TABLE OF ls_save,
          lv_cnt  TYPE i.
  
  *  CALL METHOD gcl_grid->check_changed_data.
  
  
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '계획생성'
        text_question         = '판매계획을 생성하시겠습니까?'
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
  
    IF gt_dataplan IS INITIAL.
      MESSAGE e009 WITH '저장할 데이터가 없습니다.'.
    ENDIF.
  
    IF lv_answer = 1.
  
      CALL METHOD gcl_grid->check_changed_data.
  
      READ TABLE gt_dataplan INTO gs_dataplan INDEX 1.
      lv_sdplno = gs_dataplan-sdplno.
  
  
      LOOP AT gt_dataplan INTO gs_dataplan.
        lv_tabix = sy-tabix.
        MOVE-CORRESPONDING gs_dataplan TO ls_save.
        ls_save-cmpnc = '1004'.
        ls_save-plant = gs_dataplan-plant.
        ls_save-sdplno = lv_sdplno.
        ls_save-prodcd = gs_dataplan-prodcd.
        ls_save-sdplqty = gs_dataplan-sdplqty.
        ls_save-boxunit = 'KAR'.
  *        ls_save-plnym = gs_dataplan-plnym.
  *        ls_save-statflag = 'A'.
  *        gs_dataplan-plant = gs_itab-plant.
  *        gs_dataplan-sdplno = gs_itab-sdplno.
  *        gs_dataplan-prodcd = gs_itab-matrc.
  *        gs_dataplan-sdplqty = 0.
  
  
        APPEND ls_save TO lt_save.
  
      ENDLOOP.
  
      MODIFY ztc2sd2002 FROM TABLE lt_save.
  
      PERFORM refresh_data.
  
      IF sy-dbcnt > 0.        " SELECT 구문으로 데이터베이스에서 읽어온 라인 수
        COMMIT WORK AND WAIT. " Update work process가 종료될때까지 기다린 후에 다음 프로세스 진행
  *    MESSAGE s000.
        MESSAGE s011 WITH ls_save-sdplno.
      ELSE.
        ROLLBACK WORK.
        MESSAGE s003 DISPLAY LIKE 'E'.
      ENDIF.
  
    ELSEIF lv_answer = 2.
      MESSAGE s005 DISPLAY LIKE 'W' WITH '취소되었습니다'.
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form hotspot_click
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> E_ROW_ID
  *&      --> E_COLUMN_ID
  *&---------------------------------------------------------------------*
  FORM hotspot_click  USING  pv_row_id    TYPE lvc_s_row
                             pv_column_id TYPE lvc_s_col.
  
    READ TABLE gt_itab2 INTO gs_itab2 INDEX pv_row_id-index.
  
    PERFORM hotspot_itab.
  
    CALL SCREEN '0210' STARTING AT 10 5.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form hotspot_itab
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM hotspot_itab .
  
  
    CLEAR   gs_sdplno_detail.
    REFRESH gt_sdplno_detail.
  
    DATA : ls_data  LIKE gs_sdplno_detail,
           lt_data  LIKE TABLE OF gs_sdplno_detail,
           lv_tabix TYPE sy-tabix.
  
  
  *SORT gt_sdplno_detail BY prodcd DESCENDING.
  *DELETE ADJACENT DUPLICATES FROM gt_dataplan COMPARING sdplqty boxunit.
  
  
    " 판매계획 한개당 한건만 나와야함. 근데 안돼 테이블문제인가 코드문제인가
  *
  *  SELECT DISTINCT a~prodcd
  *                  b~matrnm
  *                  a~sdplqty
  *                  a~boxunit
  *                  c~itemprice
  *                  c~waers
  *                  d~resprid
  *                  d~plcrdt
  *    FROM       ztc2sd2002 AS a
  *    INNER JOIN ztc2md2006 AS b
  *            ON a~prodcd = b~matrc
  *    INNER JOIN ztc2sd2007 AS c
  *            ON a~prodcd = c~prodcd
  *    INNER JOIN ztc2sd2001 AS d
  *            ON a~sdplno = d~sdplno
  *    INTO CORRESPONDING FIELDS OF TABLE gt_sdplno_detail
  *    WHERE d~plcrdt = gs_itab2-plcrdt.
  
  
  
  *  SELECT a~prodcd
  *         c~matrnm
  *         a~sdplqty
  *         a~boxunit
  *         d~itemprice
  *         d~waers
  *         b~resprid
  *         b~plcrdt
  *    FROM       ztc2sd2002 AS a
  *    INNER JOIN ztc2sd2001 AS b
  *            ON a~sdplno = b~sdplno
  *    INNER JOIN ztc2md2006 AS c
  *            ON a~prodcd = c~matrc
  *    INNER JOIN ztc2sd2007 AS d
  *            ON c~matrc = d~prodcd
  *        INTO CORRESPONDING FIELDS OF TABLE gt_sdplno_detail.
  
  *SORT gt_sdplno_detail BY prodcd DESCENDING.
  *DELETE ADJACENT DUPLICATES FROM gt_dataplan COMPARING sdplqty boxunit.
  
    SELECT
                   a~prodcd                    "ztc2sd2002
                b~matrnm                    "ztc2md2006
                a~sdplqty                   "ztc2sd2002
                a~boxunit                   "ztc2sd2002
                b~sdprice                 "ztc2sd2007
                b~currency                     "ztc2sd2007
    FROM       ztc2sd2002 AS a
    INNER JOIN ztc2md2006 AS b
            ON a~cmpnc =  b~cmpnc
           AND a~prodcd = b~matrc
    INTO CORRESPONDING FIELDS OF TABLE gt_sdplno_detail
    WHERE a~sdplno = gs_itab2-sdplno.
  
  
  
  
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
  
  
  
  
    PERFORM set_fcat_pop USING:
  *   'X'  'PRODCD'    ''  'ZTC2SD2002'  'PRODCD',
  *   'X'  'MATRNM'    ''  'ZTC2MD2006'  'MATRNM',
  *   ' '  'SDPLQTY'   ''  'ZTC2SD2002'  'SDPLQTY',
  *   ' '  'BOXUNIT'   ''  'ZTC2SD2002'  'BOXUNIT',
  *   ' '  'ITEMPRICE' ''  'ZTC2SD2007'  'ITEMPRICE',
  *   ' '  'WAERS'     ''  'ZTC2SD2007'  'WAERS',
  *   ' '  'RESPRID'   ''  'ZTC2SD2001'  'RESPRID',
  *   ' '  'PLCRDT'    ''  'ZTC2SD2001'  'PLCRDT'.
  *
  
  
     'X'  'PRODCD'    ''  'ZTC2SD2002'  'PRODCD' 5,
     'X'  'MATRNM'    ''  'ZTC2MD2006'  'MATRNM' 20,
     ' '  'SDPLQTY'   ''  'ZTC2SD2002'  'SDPLQTY' 12,
     ' '  'BOXUNIT'   ''  'ZTC2SD2002'  'BOXUNIT' 5,
     ' '  'SDPRICE' ''  'ZTC2MD2006'  'SDPRICE'   15,
     ' '  'CURRENCY'     ''  'ZTC2MD2006'  'CURRENCY' 5.
  *   ' '  'RESPRID'   ''  'ZTC2SD2001'  'RESPRID',
  *   ' '  'PLCRDT'    ''  'ZTC2SD2001'  'PLCRDT'.
  
  
  
  
  
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
                           pv_ref_field
                           pv_length.
  
    gs_fcat_pop-key       = pv_key.
    gs_fcat_pop-fieldname = pv_field.
    gs_fcat_pop-coltext   = pv_text.
    gs_fcat_pop-ref_table = pv_ref_table.
    gs_fcat_pop-ref_field = pv_ref_field.
    gs_fcat_pop-outputlen = pv_length.
  
    CASE pv_field.
      WHEN 'SDPLQTY'.
        gs_fcat_pop-qfieldname = 'BOXUNIT'.
      WHEN 'SDPRICE'.
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
  *
  *    CREATE OBJECT gcl_container_pop
  *      EXPORTING
  *        repid     = sy-repid
  *        dynnr     = sy-dynnr
  *        side      = cl_gui_docking_container=>dock_at_left
  *        extension = 15000.
  
  
      CREATE OBJECT gcl_container_pop
        EXPORTING
          container_name = 'GCL_CONTAINER_POP'.
  
  
      CREATE OBJECT gcl_grid_pop
        EXPORTING
          i_parent = gcl_container_pop.
  
    ENDIF.
  
  *  IF gcl_handler_pop IS NOT BOUND.
  *
  *    CREATE OBJECT gcl_handler_pop.
  *
  *  ENDIF.
  
  *  SET HANDLER : gcl_handler->hotspot_click FOR gcl_grid_pop.
  
    CLEAR gs_layout_pop-cwidth_opt. " 밑에 있는 ALV화면의 자동간격 조정을 없애줌.
    gs_variant_pop-report = sy-repid.
  
  
    CALL METHOD gcl_grid_pop->set_table_for_first_display
      EXPORTING
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout_pop
      CHANGING
        it_outtab       = gt_sdplno_detail
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
  *& Form check_click
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> ER_DATA_CHANGED
  *&---------------------------------------------------------------------*
  FORM check_click  USING p_data_changed TYPE REF TO cl_alv_changed_data_protocol.
  
    DATA: ls_modi TYPE lvc_s_modi.
    DATA: lv_tabix TYPE sy-tabix,
          ls_color TYPE lvc_s_scol.
  
    DATA : ls_itab TYPE ztc2sd2001,
           lt_itab LIKE TABLE OF ls_itab.
  
  
    DATA: lv_answer TYPE c LENGTH 1.
  
    CLEAR: gs_row, ls_color.
    REFRESH: gt_rows.
  
    CALL METHOD gcl_grid_3->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
  
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '승인요청'
        text_question         = '승인요청을 확정하시겠습니까?'
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
        INTO  CORRESPONDING FIELDS OF TABLE lt_itab
        FROM ztc2sd2001.
  
      IF gt_rows IS INITIAL.
        MESSAGE s008 WITH TEXT-m01 DISPLAY LIKE 'E'.
  *      EXIT.
  
      ENDIF.
  
      LOOP AT gt_rows INTO gs_row.
  
        READ TABLE gt_itab2 INTO gs_itab2 INDEX gs_row-index.
        CLEAR ls_color.
        lv_tabix = sy-tabix.
  
        CASE gs_itab2-checkbox.
          WHEN 'X'.
  
            IF gs_itab2-statext = '승인 대기'.
  
              gs_itab2-statext   = '승인 요청'.
              ls_color-fname     = 'STATEXT'.
              ls_color-color-col = '5'.
              ls_color-color-int = '1'.
              ls_color-color-inv = '0'.
  
              APPEND ls_color TO gs_itab2-color.
  
              MODIFY gt_itab2 FROM gs_itab2 INDEX lv_tabix
              TRANSPORTING statext color. ".
  *            CLEAR gs_itab2.
  
            ELSE.
  
              IF sy-subrc NE 0.
                CONTINUE.
              ENDIF.
            ENDIF.
  
  
        ENDCASE.
  
  
      ENDLOOP.
  
      MOVE-CORRESPONDING gt_itab2 TO lt_itab.
      MODIFY ztc2sd2001 FROM TABLE lt_itab.
      CLEAR gs_itab2.
  *
  
  
      IF sy-dbcnt > 0.
        COMMIT WORK. " AND WAIT.
        MESSAGE s000 WITH '승인요청이 확정되었습니다.'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE s003 DISPLAY LIKE 'E'.
      ENDIF.
  
    ELSE.
      MESSAGE s000 DISPLAY LIKE 'W' WITH '취소되었습니다'.
  
  
  
  
  
    ENDIF.
  
  *  PERFORM set_cell_color.
  *  CLEAR gs_itab2.
    PERFORM refresh_data_3.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form fill_cell_4
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GO_APPLICATION
  *&      --> P_03
  *&      --> P_01
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM fill_cell_4  USING pv_application
                          pv_row            " 행
                          pv_col            " 열
                          pv_value.         " 데이터 값
  
    DATA: lv_ecell TYPE ole2_object.
  
    CALL METHOD OF pv_application 'Cells' = lv_ecell
    EXPORTING
      #1 = pv_row
      #2 = pv_col.
  
    SET PROPERTY OF lv_ecell 'Value' = pv_value.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form fill_cell_5
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GO_APPLICATION
  *&      --> P_05
  *&      --> P_01
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM fill_cell_5  USING pv_application
                          pv_row            " 행
                          pv_col            " 열
                          pv_value.         " 데이터 값
  
    DATA: lv_ecell TYPE ole2_object.
  
    CALL METHOD OF pv_application 'Cells' = lv_ecell
    EXPORTING
      #1 = pv_row
      #2 = pv_col.
  
    SET PROPERTY OF lv_ecell 'Value' = pv_value.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form fill_cell_6
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GO_APPLICATION
  *&      --> P_06
  *&      --> P_01
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM fill_cell_6  USING  pv_application
                           pv_row            " 행
                           pv_col            " 열
                           pv_value.         " 데이터 값
  
    DATA: lv_ecell TYPE ole2_object.
  
    CALL METHOD OF pv_application 'Cells' = lv_ecell
    EXPORTING
      #1 = pv_row
      #2 = pv_col.
  
    SET PROPERTY OF lv_ecell 'Value' = pv_value.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form fill_cell_7
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GO_APPLICATION
  *&      --> P_07
  *&      --> P_01
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM fill_cell_7  USING   pv_application
                            pv_row            " 행
                            pv_col            " 열
                            pv_value.         " 데이터 값
  
    DATA: lv_ecell TYPE ole2_object.
  
    CALL METHOD OF pv_application 'Cells' = lv_ecell
    EXPORTING
      #1 = pv_row
      #2 = pv_col.
  
    SET PROPERTY OF lv_ecell 'Value' = pv_value.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form fill_cell_8
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GO_APPLICATION
  *&      --> P_08
  *&      --> P_01
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM fill_cell_8  USING  pv_application
                            pv_row            " 행
                            pv_col            " 열
                            pv_value.         " 데이터 값
  
    DATA: lv_ecell TYPE ole2_object.
  
    CALL METHOD OF pv_application 'Cells' = lv_ecell
    EXPORTING
      #1 = pv_row
      #2 = pv_col.
  
    SET PROPERTY OF lv_ecell 'Value' = pv_value.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form fill_cell_9
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *&      --> GO_APPLICATION
  *&      --> P_09
  *&      --> P_01
  *&      --> P_
  *&---------------------------------------------------------------------*
  FORM fill_cell_9  USING   pv_application
                            pv_row            " 행
                            pv_col            " 열
                            pv_value.         " 데이터 값
  
    DATA: lv_ecell TYPE ole2_object.
  
    CALL METHOD OF pv_application 'Cells' = lv_ecell
    EXPORTING
      #1 = pv_row
      #2 = pv_col.
  
    SET PROPERTY OF lv_ecell 'Value' = pv_value.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form APPOVAL_CANCLE
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM appoval_cancle .
  
  
    DATA: ls_modi TYPE lvc_s_modi.
    DATA: lv_tabix TYPE sy-tabix,
          ls_color TYPE lvc_s_scol.
  
    DATA : ls_itab TYPE ztc2sd2001,
           lt_itab LIKE TABLE OF ls_itab.
  
  
    DATA: lv_answer TYPE c LENGTH 1.
  
    DATA: lv_valid   TYPE char01,
          lv_refresh TYPE char01.
  
  
    CLEAR: gs_row, ls_color.
    REFRESH: gt_rows.
  *
  *  CALL METHOD gcl_grid_3->get_selected_rows
  *    IMPORTING
  *      et_index_rows = gt_rows.
  *
  
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '승인요청 취소'
        text_question         = '승인요청을 취소하시겠습니까?'
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
        INTO CORRESPONDING FIELDS OF TABLE lt_itab
        FROM ztc2sd2001.
  
      IF gt_rows IS INITIAL.
        MESSAGE s008 WITH TEXT-m01 DISPLAY LIKE 'E'.
  *      EXIT.
  
      ENDIF.
  
  
      SORT gt_itab2 BY plant sdplno plnym plcrdt resprid statflag  .
      DELETE ADJACENT DUPLICATES FROM gt_itab2 COMPARING plant sdplno plnym plcrdt resprid statflag.
  
  *    LOOP AT gt_rows INTO gs_row.
      LOOP AT gt_itab2 INTO gs_ITAB2.
  *      READ TABLE gt_itab2 INTO gs_itab2 WITH KEY sdplno = GS_ITAB2-sdplno.
        CLEAR ls_color.
        lv_tabix = sy-tabix.
        CASE gs_itab2-checkbox.
          WHEN 'X'.
            IF gs_itab2-statext = '승인 요청'.
              CLEAR gs_itab2-color.
              gs_itab2-statext   = '승인 대기'.
              ls_color-fname     = 'STATEXT'.
              ls_color-color-col = '3'.
              ls_color-color-int = '1'.
              ls_color-color-inv = '0'.
              gs_itab2-statflag  = 'A'.
              APPEND ls_color TO gs_itab2-color.
              MODIFY gt_itab2 FROM gs_itab2 INDEX lv_tabix.
  *            TRANSPORTING STATEXT color. ".
  *            CLEAR gs_itab2.
            ELSE.
              IF sy-subrc NE 0.
                CONTINUE.
              ENDIF.
            ENDIF.
        ENDCASE.
      ENDLOOP.
  
      MOVE-CORRESPONDING gt_itab2 TO lt_itab.
      MODIFY ztc2sd2001 FROM TABLE Lt_itaB.
      CLEAR gs_itab2.
  
      PERFORM set_cell_color.
      PERFORM refresh_data_3.
  
  
  
      IF sy-dbcnt > 0.
        COMMIT WORK. " AND WAIT.
        MESSAGE s000 WITH '승인요청취소가 되었습니다.'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE s003 DISPLAY LIKE 'E'.
      ENDIF.
  
    ELSE.
      MESSAGE s000 DISPLAY LIKE 'W' WITH '취소되었습니다'.
  
  
  
  
  
    ENDIF.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form f4_flag
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM f4_flag .
  *
    DATA : BEGIN OF ls_flag,
             statflag TYPE ztc2sd2001-statflag,
             statext  TYPE dd07v-ddtext,
           END OF ls_flag,
  
           lt_flag LIKE TABLE OF ls_flag.
  
    ls_FLAG-statflag = 'A'.
    ls_flag-statext = TEXT-f01.
  
    APPEND ls_flag TO lt_flag.
  
    ls_flag-statflag = 'B'.
    ls_flag-statext = TEXT-f02.
  
    APPEND ls_flag TO lt_flag.
  
    ls_flag-statflag = 'C'.
    ls_flag-statext = TEXT-f03.
  
    APPEND ls_flag TO lt_flag.
  
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'STATFLAG'
        dynpprog        = sy-repid
        dynpnr          = sy-dynnr
        dynprofield     = 'PA_FLAG'
        window_title    = '상태'
        value_org       = 'S'
      TABLES
        value_tab       = lt_flag
      EXCEPTIONS
        parameter_error = 1
        no_values_found = 2
        OTHERS          = 3.
  
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.
  
  ENDFORM.