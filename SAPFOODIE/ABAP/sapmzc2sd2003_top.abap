
*& Include          SAPMZC2SD2003_TOP
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& CLASS 선언
*&---------------------------------------------------------------------*

CLASS lcl_event_handler DEFINITION DEFERRED.


    *&---------------------------------------------------------------------*
    *& TABLES
    *&---------------------------------------------------------------------*
    TABLES: ztc2sd2006, ztc2sd2007, ztc2md2006, ztc2mm2001, ztc2md2005, sscrfields.
    
    
    
    *&---------------------------------------------------------------------*
    *& Header List Data
    *&---------------------------------------------------------------------*
    
    *DATA: BEGIN OF gs_itab,
    *        plant     TYPE ztc2sd2006-plant,
    *        cmpnc     TYPE ztc2sd2006-cmpnc,
    *        vendorc   TYPE ztc2sd2006-vendorc,
    *        saleym    TYPE ztc2sd2006-saleym,
    *        statflag  TYPE ztc2sd2006-statflag,
    *        ordercd   TYPE ztc2sd2006-ordercd,
    *        orderdate TYPE ztc2sd2006-orderdate,
    *        duedate   TYPE ztc2sd2006-duedate,
    *        vendorn   TYPE ztc2md2005-vendorn,
    *        ttamount  TYPE ztc2sd2006-ttamount,
    *        waers     TYPE ztc2sd2006-waers,
    *        ploc      TYPE ztc2md2005-ploc,
    *       color      TYPE lvc_t_scol.
    *
    *DATA: statext TYPE dd07v-ddtext,
    *      END OF gs_itab,
    *
    *
    *      gt_itab LIKE TABLE OF gs_itab,
    *
    *      gv_name(20).  " 거래처명 띄우기 위해 변수 선언
    *
    *DATA: gt_datarange LIKE RANGE OF gs_itab.
    
    DATA: BEGIN OF gs_itab.
            INCLUDE STRUCTURE ztc2sd2006.
    DATA:   vendorn TYPE ztc2md2005-vendorn,
            ploc    TYPE ztc2md2005-ploc,
            color   TYPE lvc_t_scol.
    
    DATA: statext TYPE dd07v-ddtext,
          END OF gs_itab,
    
          gt_itab     LIKE TABLE OF gs_itab,
    
          gv_name(20).  " 거래처명 띄우기 위해 변수 선언
    
    DATA: gt_datarange LIKE RANGE OF gs_itab.
    
    *아이콘
    *주문번호	ordercd
    *주문일  orderdate
    *납기일  ??????????????
    *거래처명	vendorn(ztc2md2005)
    *총 금액
    *통화
    *주소
    
    
    
    
    *&---------------------------------------------------------------------*
    *& Item List Data
    *&---------------------------------------------------------------------*
    
    *&---------------------------------------------------------------------*
    *& Item List 필요 필드/테이블
    *&---------------------------------------------------------------------*
    *   주문번호   제품코드    제품명    주문량       확정량       단위
    *   ORDERCD  PRODCD   MATRNM  ITEMQTY   FIXEDQTY    BOXUNIT
    *   SD2006   SD2007   MD2006  SD2007    SD2007      SD2007
    
    *   재고량    단위       단가         통화        합계금액
    *   STCKQ   UNIT     SDPRICE    CURRENCY   TTAMOUNT
    *   MM2001  MM2001   MD2006     MD2006     SD2006
    
    DATA: BEGIN OF gs_itab2,
            ordercd  TYPE ztc2sd2007-ordercd,
            prodcd   TYPE ztc2sd2007-prodcd,
            matrnm   TYPE ztc2md2006-matrnm,
            itemqty  TYPE ztc2sd2007-itemqty,
            fixedqty TYPE ztc2sd2007-fixedqty,
            boxunit  TYPE ztc2sd2007-boxunit,
            stckq    TYPE ztc2mm2001-stckq,
            unit     TYPE ztc2mm2001-unit,
            sdprice  TYPE ztc2md2006-sdprice,
            currency TYPE ztc2md2006-currency,
            ttamount TYPE ztc2sd2006-ttamount,
            waers    TYPE ztc2sd2006-waers,
            color    TYPE lvc_t_scol,
            style    TYPE lvc_t_styl.
    
    DATA: celltab TYPE lvc_t_styl,
          END OF gs_itab2,
    
          gt_itab2 LIKE TABLE OF gs_itab2 WITH KEY ordercd prodcd.
    
    
    
    
    *&---------------------------------------------------------------------*
    *& Item List Data
    *&---------------------------------------------------------------------*
    
    
    *DATA: BEGIN OF gs_itab3,
    *        ordercd      TYPE ztc2sd2007-ordercd,
    *        prodcd       TYPE ztc2sd2007-prodcd,
    *        matrnm       TYPE ztc2md2006-matrnm,
    *        itemqty      TYPE ztc2sd2007-itemqty,
    *        fixedqty     TYPE ztc2sd2007-fixedqty,
    *        boxunit      TYPE ztc2sd2007-boxunit,
    *        stckq        TYPE ztc2mm2001-stckq,
    *        unit         TYPE ztc2mm2001-unit,
    *        sdprice      TYPE ztc2md2006-sdprice,
    *        currency     TYPE ztc2md2006-currency,
    *        ttamount     TYPE ztc2sd2006-ttamount.
    *
    *DATA: celltab TYPE lvc_t_styl,
    *            END OF gs_itab3,
    *
    *    gt_itab3 LIKE TABLE OF gs_itab3.
    
    
    
    
    
    
    *&---------------------------------------------------------------------*
    *& ALV DATA
    *&---------------------------------------------------------------------*
    
    
    DATA: gcl_container TYPE REF TO cl_gui_custom_container,
          gcl_grid      TYPE REF TO cl_gui_alv_grid,
          gcl_handler   TYPE REF TO lcl_event_handler,
          gs_fcat       TYPE        lvc_s_fcat,
          gt_fcat       TYPE        lvc_t_fcat,
          gs_layout     TYPE        lvc_s_layo,
          gs_variant    TYPE        disvariant,
          gs_stable     TYPE        lvc_s_stbl.
    
    
    *&---------------------------------------------------------------------*
    *& ALV DATA 2
    *&---------------------------------------------------------------------*
    
    DATA: gcl_container_2 TYPE REF TO cl_gui_custom_container,
          gcl_grid_2      TYPE REF TO cl_gui_alv_grid,
          gs_fcat_2       TYPE        lvc_s_fcat,
          gt_fcat_2       TYPE        lvc_t_fcat,
          gs_layout_2     TYPE        lvc_s_layo,
          gs_variant_2    TYPE        disvariant,
          gs_stable_2     TYPE        lvc_s_stbl.
    
    
    
    
    *&---------------------------------------------------------------------*
    *& 나머지 변수 선언
    *&---------------------------------------------------------------------*
    DATA: gv_okcode TYPE sy-ucomm.
    
    *
    DATA: gv_edit   TYPE string.    " 수정버튼
    DATA: gv_delete TYPE string.  " 삭제버튼
    
    * 행 선택 변수 선언
    DATA : gs_row  TYPE lvc_s_row,
           gt_rows TYPE lvc_t_row.
    
    * INPUT값 필터 DATA
    
    DATA: BEGIN OF gs_input,
            statflag TYPE ztc2sd2006-statflag,
            vendorc  TYPE ztc2sd2006-vendorc,
            spras    TYPE i,
            statext TYPE dd07v-ddtext,
          END OF gs_input,
    
          gt_input LIKE TABLE OF gs_input.