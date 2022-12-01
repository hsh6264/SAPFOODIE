*&---------------------------------------------------------------------*
*& Include          SAPMZC2SD2003_F01
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
    gs_layout-cwidth_opt = 'X'.
    gs_layout-sel_mode   = 'D'.
    gs_layout-no_toolbar = 'X'.
    gs_layout-ctab_fname = 'COLOR'.
  
    PERFORM set_fcat USING:
  *        ' '   'STATFLAG'    '주문 상태'      'ztc2sd2006'    'STATFLAG'  10,
          ' '   'STATEXT'     '주문 상태'      'GT_ITAB'       'STATEXT'  7,
          ' '   'ORDERCD'     '주문번호'       'ZTC2SD2006'    'ORDERCD'   10,
          ' '   'ORDERDATE'   '주문일자'       'ZTC2SD2006'    'ORDERDATE'   10,
          ' '   'DUEDATE'     '납기일'        'ZTC2SD2006'    'DUEDATE'   10,
          ' '   'VENDORC'     '판매처 코드'     'ZTC2SD2006'    'VENDORC'   7,
          ' '   'VENDORN'     '거래처 명'      'ZTC2SD2006'    'VENDORN'   15,
          ' '   'TTAMOUNT'    '총액'          'ZTC2SD2006'    'TTAMOUNT'  10,
          ' '   'WAERS'       '통화'          'ZTC2SD2006'    'WAERS'     4,
          ' '   'PLOC'        '거래처 주소'     'ZTC2MD2005'    'PLOC'      35.
  
  *statflag         " 상태플래그가 들어가야되는지?
  *ordercd          " 주문번호
  *orderdate        " 주문일자
  *duedate          " 납기일
  *vendorn          " 거래처 명
  *ttamount         " 총 합계
  *waers            " 통화
  *ploc             " 거래처 주소
  
  
  
  
  
  
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
  FORM set_fcat  USING  pv_key
                        pv_field
                        pv_text
                        pv_ref_table
                        pv_ref_field
                        pv_length.
  
  
    gs_fcat-key       = pv_key.
    gs_fcat-fieldname = pv_field.
    gs_fcat-coltext   = pv_text.
    gs_fcat-ref_table = pv_ref_table.
    gs_fcat-ref_field = pv_ref_field.
    gs_fcat-outputlen = pv_length.
  
  
    IF gv_delete = 'X'.
  *      CASE pv_field.
  *        WHEN 'STATFLAG'.
  *         gs_fcat-
  *      ENDCASE.
  *
  *      APPEND gs_fcat TO gt_fcat.
  *      CLEAR gs_fcat.
    ELSE.
      CASE pv_field.
        WHEN 'TTAMOUNT'.
          gs_fcat-cfieldname = 'WAERS'.
          gs_fcat-decimals_o   = 0.
      ENDCASE.
  
      APPEND gs_fcat TO gt_fcat.
      CLEAR gs_fcat.
    ENDIF.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form GET_DATA
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_data .
  * CLEAR   gs_itab.
  * REFRESH gt_itab.
  
  
  *&---------------------------------------------------------------------*
  *& 검색조건에 맞게 조회기능 구현, Fixed Value - Description 나오게, 필드 색깔넣기 변수선언
  *&---------------------------------------------------------------------*
  
    DATA: lv_domain TYPE dcobjdef-name,
          lv_value  TYPE dd07v-domvalue_l,
          lv_text   TYPE dd07v-ddtext,
          lv_tabix  TYPE sy-tabix,
          ls_color  TYPE lvc_s_scol.
  
    lv_domain = 'ZDC2SD_STATFLAG'.
  
    DATA: lt_ordercd   LIKE RANGE OF gs_itab-ordercd,
          ls_ordercd   LIKE LINE OF lt_ordercd,
          lt_orderdate LIKE RANGE OF  gs_itab-orderdate,
          ls_orderdate LIKE LINE OF lt_orderdate,
          lt_statflag  LIKE RANGE OF gs_itab-statflag,
          ls_statflag  LIKE LINE OF lt_statflag,
          lt_vendorc   LIKE RANGE OF gs_itab-vendorc,
          ls_vendorc   LIKE LINE OF lt_vendorc.
  
  
    IF gs_itab-statflag IS NOT INITIAL.
      CLEAR ls_statflag.
      ls_statflag-sign   = 'I'.
      ls_statflag-option = 'EQ'.
      ls_statflag-low    = gs_itab-statflag.
      APPEND ls_statflag TO lt_statflag.
    ENDIF.
  
    IF gs_itab-ordercd IS NOT INITIAL.
      CLEAR ls_ordercd.
      ls_ordercd-sign   = 'I'.
      ls_ordercd-option = 'EQ'.
      ls_ordercd-low    = gs_itab-ordercd.
      APPEND ls_ordercd TO lt_ordercd.
    ENDIF.
  
    IF gs_itab-orderdate IS NOT INITIAL.
      CLEAR ls_orderdate.
      ls_orderdate-sign   = 'I'.
      ls_orderdate-option = 'EQ'.
      ls_orderdate-low    = gs_itab-orderdate.
      APPEND ls_orderdate TO lt_orderdate.
    ENDIF.
  
    IF gs_itab-vendorc IS NOT INITIAL.
      CLEAR ls_vendorc.
      ls_vendorc-sign   = 'I'.
      ls_vendorc-option = 'EQ'.
      ls_vendorc-low    = gs_itab-vendorc.
      APPEND ls_vendorc TO lt_vendorc.
    ENDIF.
  
    "MANDT
    "PLANT
    "CMPNC
    "VENDORC
    "SALEYM
    "ORDERCD
    "ORDERDATE
    "DUEDATE
    "TTAMOUNT
    "WAERS
    "ODMAXWT
    "WEIGHTUNIT
    "OUTSTOREDT
    "RESPRID
    "STATFLAG
    "DELFLAG
    "DISPATCHCD
  
    SELECT a~plant
           a~cmpnc
           a~vendorc
           a~saleym
           a~statflag
           a~ordercd          " 주문번호
           a~orderdate        " 주문일자
           a~duedate          " 납기일
           b~vendorn          " 거래처 명
           a~ttamount         " 총 합계
           a~waers            " 통화
           b~ploc             " 거래처 주소
           a~odmaxwt
           a~weightunit
           a~outstoredt
           a~resprid
           a~delflag
           a~dispatchcd
      FROM       ztc2sd2006       AS a
      INNER JOIN ztc2md2005       AS b
              ON a~vendorc = b~vendorc
      INTO CORRESPONDING FIELDS OF TABLE gt_itab
      WHERE ordercd   IN lt_ordercd
        AND orderdate IN lt_orderdate
        AND statflag  IN lt_statflag
        AND ( statflag = 'D' OR statflag = 'E').
  
  
  
  
    SORT gt_itab BY ordercd ASCENDING.
  
  *  IF gs_itab
  *
  *  ENDIF.
  
  *&---------------------------------------------------------------------*
  *& Domain Fixed Value - Description 나오게
  *&---------------------------------------------------------------------*
  
    LOOP AT gt_itab INTO gs_itab.
  *    gs_itab-ttamount = gs_itab2-ordercd * .
      lv_tabix = sy-tabix.
      lv_value = gs_itab-statflag.
  *    gs_itab-ttamount = gs_itab-ttamount + ( gs_itab2-ttamount / 10 ). " 더블클릭 할수록 값이 올라감.
      CALL FUNCTION 'ISU_DOMVALUE_TEXT_GET'
        EXPORTING
          x_name  = lv_domain
          x_value = lv_value
        IMPORTING
          y_text  = lv_text.
  
      gs_itab-statext = lv_text.
  
      MODIFY gt_itab FROM gs_itab INDEX lv_tabix
      TRANSPORTING statext.
  
    ENDLOOP.
  *  CLEAR gs_itab.
  *    PERFORM refresh_data.
  
  
  *&---------------------------------------------------------------------*
  *& 필드명 색깔부여
  *&---------------------------------------------------------------------*
  
    PERFORM field_color.
  
    CLEAR gs_itab.
    PERFORM refresh_data.
  
  
  
  
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
  
  
      SET HANDLER: gcl_handler->handle_double_click FOR gcl_grid.
  
      CLEAR gs_layout-cwidth_opt. " 밑에 있는 ALV화면의 자동간격 조정을 없애줌.
  
  
      CALL METHOD gcl_grid->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout
        CHANGING
          it_outtab       = gt_itab
          it_fieldcatalog = gt_fcat.
  
  
  
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
  FORM get_data2 USING pv_ordercd.
  
    DATA: lv_tabix TYPE sy-tabix,
          ls_color TYPE lvc_s_scol.
    DATA: ls_edit TYPE lvc_s_styl,
          lt_edit TYPE lvc_t_styl.
  
    CLEAR   gs_itab2.
    REFRESH gt_itab2.
  
  
  *&---------------------------------------------------------------------*
  *& Item List 필요 필드/테이블
  *&---------------------------------------------------------------------*
  *   주문번호   제품코드    제품명    주문량       확정량       단위
  *   ORDERCD  PRODCD   MATRNM  ITEMQTY   FIXEDQTY    BOXUNIT
  *   SD2006   SD2007   MD2006  SD2007    SD2007      SD2007
  
  *   재고량    단위       단가         통화        합계금액
  *   STCKQ   UNIT     SDPRICE    CURRENCY   TTAMOUNT
  *   MM2001  MM2001   MD2006     MD2006     SD2006
  
    SELECT a~ordercd
           a~prodcd
           b~matrnm
           a~itemqty
           a~fixedqty
           a~boxunit
           c~stckq
           c~unit
           b~sdprice
           b~currency
           d~ttamount
           d~waers
      FROM       ztc2sd2007 AS a
      INNER JOIN ztc2md2006 AS b
              ON a~cmpnc   = b~cmpnc
             AND a~prodcd = b~matrc
      INNER JOIN ztc2mm2001 AS c
              ON a~plant   = c~plant
             AND a~cmpnc   = c~cmpnc
             AND a~prodcd  = c~matrc
      INNER JOIN ztc2sd2006 AS d
              ON a~plant      = d~plant
             AND a~cmpnc      = d~cmpnc
             AND a~vendorc    = d~vendorc
             AND a~saleym     = d~saleym
             AND a~ordercd    = d~ordercd
             AND a~weightunit = d~weightunit
      INTO CORRESPONDING FIELDS OF TABLE gt_itab2
      WHERE a~ordercd = gs_itab-ordercd.
  
    IF sy-subrc NE 0.
      EXIT.
    ENDIF.
  
  *  CLEAR gs_itab.
  
    CLEAR gs_itab-ttamount.
  
    LOOP AT gt_itab2 INTO gs_itab2.
      lv_tabix = sy-tabix.
      gs_itab2-ttamount = gs_itab2-itemqty * gs_itab2-sdprice .  " 총액 = 주문량 * 단가
      gs_itab2-stckq    = gs_itab2-stckq * '0.1'.
  *    gs_itab2-itemqty  = gs_itab2-itemqty / '10'.
  
  *    READ TABLE gt_itab INTO gs_itab WITH KEY ordercd = gs_itab2-ordercd.
  *      gs_itab-ttamount = gs_itab-ttamount + ( gs_itab2-ttamount / 10 ).
  *    MODIFY TABLE gt_itab FROM gs_itab.
  
  
  
      IF gs_itab-statext = '주문 접수'.
  
        MODIFY gt_itab2 FROM gs_itab2 INDEX lv_tabix
        TRANSPORTING fixedqty color ttamount. "fixedqty.
  
      ELSEIF gs_itab-statext = '주문 확정'.
  
  
      ENDIF.
  *승인대기, 승인, 반려, 주문 접수, 주문 확정, 배차 확정, 배송 완료
      IF gs_itab-statext = '주문 확정' OR gs_itab-statext = '배차 확정'
                                    OR gs_itab-statext = '승인'
                                    OR gs_itab-statext = '반려'
                                    OR gs_itab-statext = '승인 대기'
                                    OR gs_itab-statext = '배송 완료'.
        CLEAR ls_edit.
        REFRESH lt_edit.
        ls_edit-fieldname = 'FIXEDQTY'.
        ls_edit-style = cl_gui_alv_grid=>mc_style_disabled.
        INSERT ls_edit INTO TABLE lt_edit.
  
      ENDIF.
  
      INSERT LINES OF lt_edit INTO TABLE gs_itab2-style.
  
      MODIFY gt_itab2 FROM gs_itab2 INDEX lv_tabix
      TRANSPORTING fixedqty color style itemqty ttamount stckq.
  
    ENDLOOP.
  *  PERFORM refresh_data.
    PERFORM refresh_data_2.
  *  PERFORM modif_data.
  
  
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
  
  
  *&---------------------------------------------------------------------*
  *& Item List 필요 필드/테이블
  *&---------------------------------------------------------------------*
  *   주문번호   제품코드    제품명    주문량       확정량       단위
  *   ORDERCD  PRODCD   MATRNM  ITEMQTY   FIXEDQTY    BOXUNIT
  *   SD2006   SD2007   MD2006  SD2007    SD2007      SD2007
  
  *   재고량    단위       단가         통화        합계금액
  *   STCKQ   UNIT     SDPRICE    CURRENCY   TTAMOUNT
  *   MM2001  MM2001   MD2006     MD2006     SD2006
  
    DATA : lv_tabix TYPE sy-tabix,
           ls_color TYPE lvc_s_scol.
  
  
    gs_layout_2-stylefname = 'STYLE'.
    gs_layout_2-zebra      = 'X'.
    gs_layout_2-cwidth_opt = 'X'.
    gs_layout_2-sel_mode   = 'D'.
    gs_layout_2-no_toolbar = 'X'.
    gs_layout_2-ctab_fname = 'COLOR'.
  
    REFRESH gt_fcat_2.
  
    PERFORM set_fcat_2 USING:
          'X'   'ORDERCD'     '주문번호'         'ZTC2SD2007'    'ORDERCD'   10,
          'X'   'PRODCD'      '제품코드'         'ZTC2SD2007'    'PRODCD'    7,
          ' '   'MATRNM'      '제품명'          'ZTC2MD2006'    'MATRNM'    20,
          ' '   'ITEMQTY'     '주문량'          'ZTC2SD2007'    'ITEMQTY'   5,
          ' '   'FIXEDQTY'    '확정 수량'        'ZTC2SD2007'    'FIXEDQTY'  7,
          ' '   'STCKQ'       '재고량'           'ZTC2MM2001'    'STCKQ'     10,
          ' '   'BOXUNIT'     '단위(BOX)'      'ZTC2SD2007'    'BOXUNIT'   10,
  *        ' '   'UNIT'        '단위'            'ZTC2MM2001'    'UNIT'       5,
          ' '   'SDPRICE'     '단가'            'ZTC2MD2006'    'SDPRICE'    10,
          ' '   'CURRENCY'    '통화'            'ZTC2MD2006'    'CURRENCY'   5,
          ' '   'TTAMOUNT'    '총액'            'ZTC2SD2006'    'TTAMOUNT'   10,
          ' '   'WAERS'       '통화키'           'ZTC2SD2006'    'WAERS'      5.
  
  
  
  
  
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
  *&---------------------------------------------------------------------*
  FORM set_fcat_2  USING pv_key
                         pv_field
                         pv_text
                         pv_ref_table
                         pv_ref_field
                         pv_length.
  
    CLEAR  gs_fcat_2.
  
    gs_fcat_2-key       = pv_key.
    gs_fcat_2-fieldname = pv_field.
    gs_fcat_2-coltext   = pv_text.
    gs_fcat_2-ref_table = pv_ref_table.
    gs_fcat_2-ref_field = pv_ref_field.
    gs_fcat_2-outputlen = pv_length.
  
    " 수정 버튼 클릭 시 'FXIEDQTY'만 EDIT 가능
    CASE pv_field.
      WHEN 'SDPRICE'.
        gs_fcat_2-cfieldname = 'CURRENCY'.
      WHEN 'FIXEDQTY'.
  
        gs_fcat_2-edit  = 'X'.
        gs_fcat_2-qfieldname = 'BOXUNIT'.
      WHEN 'STCKQ'.
        gs_fcat_2-qfieldname = 'BOXUNIT'.
      WHEN 'TTAMOUNT'.
        gs_Fcat_2-cfieldname = 'WAERS'.
        gs_Fcat_2-decimals_o = 0.
    ENDCASE.
  
    APPEND gs_fcat_2 TO gt_fcat_2.
  
  
  
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
  
  
    IF gcl_container_2 IS NOT BOUND.
      CLEAR gv_edit.
      CREATE OBJECT gcl_container_2
        EXPORTING
          container_name = 'GCL_CONTAINER_2'.
  
      CREATE OBJECT gcl_grid_2
        EXPORTING
          i_parent = gcl_container_2.
  
      gs_variant_2-report  = sy-repid.
  
  
      CLEAR gs_layout_2-cwidth_opt. " 밑에 있는 ALV화면의 자동간격 조정을 없애줌.
  
      CALL METHOD gcl_grid_2->set_table_for_first_display
        EXPORTING
          is_variant      = gs_variant_2
          i_save          = 'A'
          i_default       = 'X'
          is_layout       = gs_layout_2
        CHANGING
          it_outtab       = gt_itab2
          it_fieldcatalog = gt_fcat_2.
  
  
  
  
  
  
    ENDIF.
  
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
        i_soft_refresh = space.   " === ' '.
  
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
  
  **&---------------------------------------------------------------------*
  **& ITAB의 내용 ---> ALV : Grid의 메소드 중 refresh_table_display
  **& ALV의 내용 ---> ITAB : Grid의 메소드 중 check_changed_data
  **&---------------------------------------------------------------------*
  *
    DATA: ls_save TYPE ztc2sd2006,
          lt_save LIKE TABLE OF ls_save.
  
    CALL METHOD gcl_grid->check_changed_data.
  
  
  
  
    MOVE-CORRESPONDING gs_itab TO ls_save.
  
    MODIFY ztc2sd2006 FROM TABLE lt_save.
  
    IF sy-dbcnt > 0.        " SELECT 구문으로 데이터베이스에서 읽어온 라인 수
      COMMIT WORK AND WAIT. " Update work process가 종료될때까지 기다린 후에 다음 프로세스 진행
      MESSAGE s002.
    ELSE.
      ROLLBACK WORK.
      MESSAGE s003 DISPLAY LIKE 'E'.
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
  FORM handle_double_click  USING    pv_row    TYPE lvc_s_row
                                     pv_column TYPE lvc_s_col.
  
  
    READ TABLE gt_itab INTO gs_itab INDEX pv_row-index.
  
    IF sy-subrc NE 0.
      EXIT.
    ENDIF.
  
  
    CASE pv_column.
      WHEN 'ORDERCD'.
        PERFORM get_data2 USING gs_itab-ordercd.      " Item List CRUD
      WHEN OTHERS.
  
    ENDCASE.
  
  
  
  
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
        i_soft_refresh = space.   " === ' '.
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form get_data3
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM get_data3 .
  
  *&---------------------------------------------------------------------*
  *& 이거 필요없음 안쓰는 데이터
  *&
  *&---------------------------------------------------------------------*
  
  
  *    CLEAR   gs_itab.
  *    REFRESH gt_itab.
  *
  *    SELECT a~statflag
  *           a~ordercd          " 주문번호
  *           a~orderdate        " 주문일자
  *           a~duedate          " 납기일
  *           b~vendorn          " 거래처 명
  *           a~ttamount         " 총 합계
  *           a~waers            " 통화
  *           b~ploc             " 거래처 주소
  *      FROM       ztc2sd2006       AS a
  *      INNER JOIN ztc2md2005       AS b
  *        ON a~vendorc = b~vendorc
  *      INTO CORRESPONDING FIELDS OF TABLE gt_itab
  *      WHERE a~vendorc = gs_itab-vendorc.
  
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form set_vendorc
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM set_vendorc .
  
  *&---------------------------------------------------------------------*
  *& 거래처명 보이게 하는 SQL
  *&---------------------------------------------------------------------*
  
    SELECT SINGLE vendorn
      INTO gv_name
      FROM ztc2md2005
      WHERE vendorc = gs_itab-vendorc.
  
  *    PERFORM refresh_data.
  
  
  
  ENDFORM.
  
  *&---------------------------------------------------------------------*
  *& Form CONFIRM_DATA
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM confirm_data .
  
    DATA : lv_tabix TYPE sy-tabix,
           ls_color TYPE lvc_s_scol.
  
    DATA : ls_itab TYPE ztc2sd2006,
           lt_itab LIKE TABLE OF ls_itab.
  
    DATA: lv_input TYPE i.
  
  
  
    DATA : lv_answer TYPE c LENGTH 1.
  
    CLEAR : gs_row, ls_color.
    REFRESH gt_rows.
  
    CALL METHOD gcl_grid->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '주문확정'
        text_question         = '주문을 확정하시겠습니까?'
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
       FROM ztc2sd2006.
  
      IF gt_rows IS INITIAL.
        MESSAGE s000 WITH TEXT-m01 DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.
  *    SORT gt_rows BY index DESCENDING.
  
  
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_itab INTO gs_itab INDEX gs_row-index.
  
        lv_tabix = sy-tabix.
  
  
        IF gs_itab-statflag = 'D' AND gs_itab-statext = '주문 접수'.
          gs_itab-statext   = '주문 확정'.
          gs_itab-statflag  = 'E'.
          gs_itab-resprid   = sy-uname.
  *                APPEND gs_itab TO gt_itab.
          MODIFY gt_itab FROM gs_itab INDEX lv_tabix
          TRANSPORTING statflag statext resprid. "color.
  
        ELSEIF gs_itab-statflag = 'E' AND gs_itab-statext = '주문 확정'.
           MESSAGE S003 DISPLAY LIKE 'E'.
        ENDIF.
  
      ENDLOOP.
  
      MOVE-CORRESPONDING gt_itab TO lt_itab.
      MODIFY ztc2sd2006 FROM TABLE lt_itab.
      CLEAR gs_itab.
  *     ROLLBACK WORK.
  
  
      IF sy-dbcnt > 0.
        COMMIT WORK. " AND WAIT.
        MESSAGE s000 WITH '주문이 확정되었습니다.'.
  *      PERFORM refresh_data_2.
      ELSE.
        ROLLBACK WORK.
        MESSAGE s003 DISPLAY LIKE 'E'.
      ENDIF.
  
    ELSE.
      MESSAGE s000 DISPLAY LIKE 'W' WITH '취소되었습니다'.
    ENDIF.
  
    PERFORM field_color.
  
    CLEAR gs_itab.
  
  *&---------------------------------------------------------------------*
  *& 주문확정 누른 동시에 INPUT창 (EDIT MODE) 막힘.
  *&---------------------------------------------------------------------*
  
    lv_input = 0.
  
    CALL METHOD gcl_grid_2->set_ready_for_input
      EXPORTING
        i_ready_for_input = lv_input.
  
  
    PERFORM refresh_data.
  *  PERFORM refresh_data_2.
  
  ENDFORM.
  
  *&---------------------------------------------------------------------*
  *& Form save_data2
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM save_data2 .
  
    DATA: ls_save TYPE ztc2sd2007,
          lt_save LIKE TABLE OF ls_save.
    DATA: lv_tabix TYPE sy-tabix.
    DATA: lv_tabix2 TYPE sy-tabix.
  
    CALL METHOD gcl_grid_2->check_changed_data.
  
  
    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE lt_save
      FROM ztc2sd2007.
  
  
    LOOP AT gt_itab2 INTO gs_itab2.
      lv_tabix = sy-tabix.
      READ TABLE lt_save INTO ls_save
      WITH KEY ordercd = gs_itab2-ordercd
               prodcd   = gs_itab2-prodcd.
      "fixedqty =
  
  
  
      IF sy-subrc = 0.
        lv_tabix2 = sy-tabix.
        ls_save-fixedqty = gs_itab2-fixedqty.
  *      MODIFY lt_save FROM ls_save INDEX lv_tabix
  *      TRANSPORTING fixedqty.
  
      ENDIF.
  
  
  
      MODIFY TABLE lt_save FROM ls_save "INDEX lv_tabix
      TRANSPORTING fixedqty.
  
  
    ENDLOOP.
  
    MOVE-CORRESPONDING gs_itab2 TO ls_save.
    MODIFY ztc2sd2007 FROM TABLE lt_save.
  
  *  PERFORM refresh_data_2.
  *  CLEAR GS_ITAB2.
  
  
    IF sy-dbcnt > 0.        " SELECT 구문으로 데이터베이스에서 읽어온 라인 수
      COMMIT WORK AND WAIT. " Update work process가 종료될때까지 기다린 후에 다음 프로세스 진행
      MESSAGE s002.
    ELSE.
      ROLLBACK WORK.
      MESSAGE s003 DISPLAY LIKE 'E'.
    ENDIF.
  * IF GS_ITAB2-fixedqty <= gs_itab2-stckq.
  *    ELSEIF gs_itab2-fixedqty > gs_itab2-stckq.
  *    MESSAGE s003 DISPLAY LIKE 'E'.
  *    ENDIF.
  
  *
  *  PERFORM refresh_data_2.
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form CONCORDER_DATA
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM concorder_data .
    DATA : lv_tabix TYPE sy-tabix,
           ls_color TYPE lvc_s_scol.
  
    DATA : ls_itab TYPE ztc2sd2006,
           lt_itab LIKE TABLE OF ls_itab.
  
  
  
    DATA : lv_answer TYPE c LENGTH 1.
  
    CLEAR : gs_row, ls_color.
    REFRESH gt_rows.
  
    CALL METHOD gcl_grid->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '주문취소'
        text_question         = '주문을 취소하시겠습니까?'
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
       FROM ztc2sd2006.
  
      IF gt_rows IS INITIAL.
        MESSAGE s000 WITH TEXT-m01 DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.
  *    SORT gt_rows BY index DESCENDING.
  
  
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_itab INTO gs_itab INDEX gs_row-index.
  
        lv_tabix = sy-tabix.
  
  
  
        IF gs_itab-statflag = 'E' AND gs_itab-statext = '주문 확정'.
          gs_itab-statext   = '주문 접수'.
          gs_itab-statflag  = 'D'.
  
  *                APPEND gs_itab TO gt_itab.
          MODIFY gt_itab FROM gs_itab INDEX lv_tabix
          TRANSPORTING statflag statext. "color.
        ELSE.
  
        ENDIF.
  
      ENDLOOP.
  
      MOVE-CORRESPONDING gt_itab TO lt_itab.
      MODIFY ztc2sd2006 FROM TABLE lt_itab.
      CLEAR gs_itab.
  *     ROLLBACK WORK.
  
  
  
  
      IF sy-dbcnt > 0.
        COMMIT WORK AND WAIT.
        MESSAGE s000 WITH '주문이 취소되었습니다.'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE s003 DISPLAY LIKE 'E'.
      ENDIF.
  
    ELSE.
      MESSAGE s000 DISPLAY LIKE 'W' WITH '취소되었습니다'.
    ENDIF.
  
  
  
    CLEAR gs_itab.
  
  
    PERFORM refresh_data.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form CANCORDER_DATA
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM cancorder_data .
    DATA : lv_tabix TYPE sy-tabix,
           ls_color TYPE lvc_s_scol.
  
    DATA : ls_itab TYPE ztc2sd2006,
           lt_itab LIKE TABLE OF ls_itab.
  
  
  
    DATA : lv_answer TYPE c LENGTH 1.
  
    CLEAR : gs_row, ls_color.
    REFRESH gt_rows.
  
    CALL METHOD gcl_grid->get_selected_rows
      IMPORTING
        et_index_rows = gt_rows.
  
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = '주문취소'
        text_question         = '주문을 취소하시겠습니까?'
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
       FROM ztc2sd2006.
  
      IF gt_rows IS INITIAL.
        MESSAGE s000 WITH TEXT-m01 DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.
  *    SORT gt_rows BY index DESCENDING.
  
  
      LOOP AT gt_rows INTO gs_row.
        READ TABLE gt_itab INTO gs_itab INDEX gs_row-index.
  
        lv_tabix = sy-tabix.
  
  
  
        IF gs_itab-statflag = 'E' AND gs_itab-statext = '주문 확정'.
          gs_itab-statext   = '주문 접수'.
          gs_itab-statflag  = 'D'.
  
  *                APPEND gs_itab TO gt_itab.
          MODIFY gt_itab FROM gs_itab INDEX lv_tabix
          TRANSPORTING statflag statext. "color.
        ELSE.
  
        ENDIF.
  
      ENDLOOP.
  
      MOVE-CORRESPONDING gt_itab TO lt_itab.
      MODIFY ztc2sd2006 FROM TABLE lt_itab.
      CLEAR gs_itab.
  *     ROLLBACK WORK.
  
  
  
  
      IF sy-dbcnt > 0.
        COMMIT WORK AND WAIT.
        MESSAGE s000 WITH '주문이 취소되었습니다.'.
      ELSE.
        ROLLBACK WORK.
        MESSAGE s003 DISPLAY LIKE 'E'.
      ENDIF.
  
    ELSE.
      MESSAGE s000 DISPLAY LIKE 'W' WITH '취소되었습니다'.
    ENDIF.
  *
    PERFORM field_color.
  
    CLEAR gs_itab.
  
  
    PERFORM refresh_data.
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form FIELD_COLOR
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM field_color .
  
    DATA: lv_tabix TYPE sy-tabix,
          ls_color TYPE lvc_s_scol.
  
  
    LOOP AT gt_itab INTO gs_itab.
      lv_tabix = sy-tabix.
      CLEAR gs_itab-color.
  
      IF gs_itab-ordercd IS NOT INITIAL.
        ls_color-fname = 'ORDERCD'.
        ls_color-color-col = '4'.
        ls_color-color-int = '1'.
        ls_color-color-inv = '1'.
        APPEND ls_color TO gs_itab-color.
      ENDIF.
  
      CASE gs_itab-statext.
        WHEN '주문 접수'.
  *     gs_itab-statext = '주문 접수'.
          ls_color-fname = 'STATEXT'.
          ls_color-color-col = '3'.
          ls_color-color-int = '1'.
          ls_color-color-inv = '0'.
          APPEND ls_color TO gs_itab-color.
  *     MODIFY gt_itab FROM gs_itab INDEX lv_tabix
  *     TRANSPORTING Color.
  
  
        WHEN '주문 확정'.
  *     gs_itab-statext = '주문 확정'.
          ls_color-fname = 'STATEXT'.
          ls_color-color-col = '5'.
          ls_color-color-int = '0'.
          ls_color-color-inv = '0'.
          APPEND ls_color TO gs_itab-color.
  *    ENDCASE.
  
  ** 승인대기, 승인, 반려, 주문 접수, 주문 확정, 배차 확정, 배송 완료
        WHEN '승인대기'.
  *     gs_itab-statext = '승인대기'.
          ls_color-fname = 'STATEXT'.
          ls_color-color-col = '5'.
          ls_color-color-int = '0'.
          ls_color-color-inv = '0'.
          APPEND ls_color TO gs_itab-color.
  
        WHEN '승인'.
  *     gs_itab-statext = '승인'.
          ls_color-fname = 'STATEXT'.
          ls_color-color-col = '5'.
          ls_color-color-int = '0'.
          ls_color-color-inv = '0'.
          APPEND ls_color TO gs_itab-color.
  
        WHEN '배차 확정'.
  *     gs_itab-statext = '배차 확정'.
          ls_color-fname = 'STATEXT'.
          ls_color-color-col = '5'.
          ls_color-color-int = '0'.
          ls_color-color-inv = '0'.
          APPEND ls_color TO gs_itab-color.
  
        WHEN '배송 완료'.
  *     gs_itab-statext = '배송 완료'.
          ls_color-fname = 'STATEXT'.
          ls_color-color-col = '5'.
          ls_color-color-int = '0'.
          ls_color-color-inv = '0'.
          APPEND ls_color TO gs_itab-color.
      ENDCASE.
  
      MODIFY gt_itab FROM gs_itab INDEX lv_tabix
      TRANSPORTING statflag statext color.
  
  
    ENDLOOP.
  
  
  
  
  ENDFORM.
  *&---------------------------------------------------------------------*
  *& Form f4_statflag
  *&---------------------------------------------------------------------*
  *& text
  *&---------------------------------------------------------------------*
  *& -->  p1        text
  *& <--  p2        text
  *&---------------------------------------------------------------------*
  FORM f4_statflag .
  
    DATA: BEGIN OF ls_value,
            statflag TYPE ztc2sd2006-statflag,
            statext  TYPE dd07v-ddtext,
          END OF ls_value,
  
          lt_value LIKE TABLE OF ls_value.
  
    REFRESH lt_value.
  
  
  
    SELECT statflag
      INTO CORRESPONDING FIELDS OF TABLE lt_value
      FROM ztc2sd2006
      WHERE statflag  BETWEEN 'D' AND 'E'.
  
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield    = 'STATEXT'
        dynpprog    = sy-repid
        dynpnr      = sy-dynnr
        dynprofield = 'GS_INPUT-STATEXT'
       window_title = '상태 정보'
        value_org   = 'S'
  *     DISPLAY     = ' '
      TABLES
        value_tab   = lt_value.
  
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
  
  DATA : BEGIN OF ls_flag,
             statflag TYPE ztc2sd2006-statflag,
             statext  TYPE dd07v-ddtext,
           END OF ls_flag,
  
           lt_flag LIKE TABLE OF ls_flag.
  
    ls_FLAG-statflag = 'D'.
    ls_flag-statext = TEXT-f01.
  
    APPEND ls_flag TO lt_flag.
  
    ls_flag-statflag = 'E'.
    ls_flag-statext = TEXT-f02.
  
    APPEND ls_flag TO lt_flag.
  
  *  ls_flag-statflag = 'C'.
  *  ls_flag-statext = TEXT-f03.
  *
  *  APPEND ls_flag TO lt_flag.
  
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield        = 'STATFLAG'
        dynpprog        = sy-repid
        dynpnr          = sy-dynnr
        dynprofield     = 'GS_ITAB-STATFLAG'
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