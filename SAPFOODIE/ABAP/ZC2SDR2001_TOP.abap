*&---------------------------------------------------------------------*
*& Include ZC2SDR2001_TOP                           - Report ZC2SDR2001
*&---------------------------------------------------------------------*
REPORT zc2sdr2001 MESSAGE-ID zc202.

CLASS: lcl_event_handler DEFINITION DEFERRED.

TYPE-POOLS : vrm, sol, ole2.
INCLUDE <icon>.

TABLES: sscrfields, ztc2sd2001, ztc2sd2002.

DATA: gv_okcode      TYPE sy-ucomm,
      g_function_key TYPE smp_dyntxt. " function key data 선언

*  넘버 레인지 중복 방지용.
DATA : gv_numflag TYPE c LENGTH 20.


* SCREEN 100 INPUT창  DATA 선언
DATA: gv_plant   TYPE c LENGTH 8, " 플랜트
      gv_plnym   TYPE c LENGTH 6,          " 계획 년월
      gv_sonum   TYPE c LENGTH 15, " 계획 번호
      gv_plcrdt  TYPE sy-datum, " 계획 생성일
      gv_resprid TYPE sy-uname.  " 담당자 ID

* Delete Data 선언
DATA : gs_data_del TYPE ztc2sd2001,
       gt_data_del LIKE TABLE OF gs_data_del.




* List Box Data
DATA: name  TYPE vrm_id,
      list  TYPE vrm_values,
      value LIKE LINE OF list.



* EXCEL DOWN: DIRECTORY, SMW0
DATA: gv_directory   TYPE string,
      gv_initial_dir TYPE string,
      gv_file        LIKE rlgrap-filename,
      objfile        TYPE REF TO cl_gui_frontend_services.

* EXCEL DOWN: OLE
DATA: ls_key LIKE wwwdatatab.
DATA: go_application TYPE ole2_object,
      go_books       TYPE ole2_object,
      go_wbook       TYPE ole2_object,
      go_book        TYPE ole2_object,
      go_sheets      TYPE ole2_object,
      go_sheet       TYPE ole2_object,
      go_cells       TYPE ole2_object,
      go_cell        TYPE ole2_object,
      go_range       TYPE ole2_object,
      go_font        TYPE ole2_object,
      go_row         TYPE ole2_object,
      gv_path        TYPE string,
      gv_num         TYPE i.



* EXCEL UPLOAD
DATA: lt_intern TYPE TABLE OF alsmex_tabline,
      ls_intern TYPE          alsmex_tabline,
      lv_type,
      lv_nrow   TYPE REF TO   i.
FIELD-SYMBOLS <fs> TYPE any.

*  데이터 저장
DATA: lt_row TYPE lvc_t_roid,
      ls_row TYPE lvc_s_roid.

*  데이터 저장
DATA : gs_row  TYPE lvc_s_row,
       gt_rows TYPE lvc_t_row.


* EXCEL Data 담을 인터널 테이블
DATA: gt_intern TYPE TABLE OF alsmex_tabline,
      gs_intern TYPE alsmex_tabline.




*&---------------------------------------------------------------------*
*& 판매계획 Header List Data
*&---------------------------------------------------------------------*

*생산계획         - 상태, 플랜트, 생산계획번호, 계획년월, 등록자ID, 생성일자, 수정자ID 수정일자, 승인요청일, 반려사유
*판매계획 모든 필드 - 플랜트, 회사코드, 판매계획번호, 계획 년월, 계획 생성일, 계획 수정일, 승인 완료일, 담당자 ID,
*               수정자ID, 반려사유, 상태플래그, 삭제플래그,



DATA: BEGIN OF gs_itab,
        plant    TYPE ztc2sd2001-plant,
        sdplno   TYPE ztc2sd2001-sdplno,
        matrc    TYPE ztc2md2006-matrc,
        matrnm   TYPE ztc2md2006-matrnm,
        sdprice  TYPE ztc2md2006-sdprice,
        currency TYPE ztc2md2006-currency,
      END OF gs_itab,

      gt_itab LIKE TABLE OF gs_itab.



" 플랜트 계획번호 계획시작년월 제품코드 판매 수량 수량단위
* Excel Download Data?
DATA: BEGIN OF gs_d_excel,
        plant   TYPE ztc2sd2001-plant,
        sdplno  TYPE ztc2sd2001-sdplno,
        plnym   TYPE ztc2sd2001-plnym,
        prodcd  TYPE ztc2sd2002-prodcd,
        sdplqty TYPE ztc2sd2002-sdplqty,
        boxunit TYPE ztc2sd2002-boxunit,
      END OF gs_d_excel,

      gt_d_excel LIKE TABLE OF gs_d_Excel.


DATA: BEGIN OF gs_dataplan,
        plant   TYPE ztc2sd2001-plant,
        sdplno  TYPE ztc2sd2001-sdplno,
        plnym   TYPE ztc2sd2001-plnym,
        prodcd  TYPE ztc2sd2002-prodcd,
        sdplqty TYPE ztc2sd2002-sdplqty,
        boxunit TYPE ztc2sd2002-boxunit,
      END OF gs_dataplan,
      gt_dataplan LIKE TABLE OF gs_dataplan.







*&---------------------------------------------------------------------*
*& 판매계획 Item List Data
*&---------------------------------------------------------------------*

* SD2002 - 플랜트, 회사코드, 판매계획번호, 제품코드, 판매계획 수량, 출고단위, 삭제플래그
* 추가 필드: 승인상태 플랜트 계획번호 계획 생성일 계획 시작 년월 담당자명 판매총액 승인일자
*DATA: gs_itab2 TYPE ztc2sd2001,
*      gt_itab2 LIKE TABLE OF gs_itab2.


"승인상태 계획번호 플랜트 계획생성일 계획시작년월 담당자명 판매총액 승인일자

*DATA: BEGIN OF gs_itab2.
*        INCLUDE STRUCTURE ztc2sd2001.
*DATA: ttamount TYPE ztc2sd2006-ttamount,
*      waers    TYPE ztc2sd2006-waers,
*      END OF gs_itab2,
*
*      gt_itab2 LIKE TABLE OF gs_itab2.

DATA: BEGIN OF gs_itab2,
        checkbox,
        statflag TYPE ztc2sd2001-statflag,
        sdplno   TYPE ztc2sd2001-sdplno,
        cmpnc    TYPE ztc2sd2001-cmpnc,
        plant    TYPE ztc2sd2001-plant,
        plcrdt   TYPE ztc2sd2001-plcrdt,
        plnym    TYPE ztc2sd2001-plnym,
        resprid  TYPE ztc2sd2001-resprid,
        ttamount TYPE ztc2sd2006-ttamount,
        waers    TYPE ztc2sd2006-waers,
        sdprice  TYPE ztc2md2006-sdprice,
        currency TYPE ztc2md2006-currency,
        sdplqty  TYPE ztc2sd2002-sdplqty,
        color    TYPE lvc_t_scol,
        stlye    TYPE lvc_t_styl,
        celltab  TYPE lvc_t_styl,
        statext  TYPE dd07v-ddtext,
      END OF gs_itab2,


      gt_itab2 LIKE TABLE OF gs_itab2 WITH NON-UNIQUE KEY statflag sdplno plant plcrdt plnym resprid.


*&---------------------------------------------------------------------*
*& HOTSPOT_DATA
*&------------------------------------------------------------------

*제품코드
*자재명
*구매 수량
*박스 단위
*판매 단가
*통화키
*담당자 ID
*계획 생성일


DATA: BEGIN OF gs_sdplno_detail,
*        prodcd    TYPE ztc2sd2002-prodcd,
*        matrnm    TYPE ztc2md2006-matrnm,
*        sdplqty   TYPE ztc2sd2002-sdplqty,
*        boxunit   TYPE ztc2sd2002-boxunit,
*        itemprice TYPE ztc2sd2007-itemprice,
*        waers     TYPE ztc2sd2007-waers,
*        resprid   TYPE ztc2sd2001-resprid,
*        plcrdt    TYPE ztc2sd2001-plcrdt,

        prodcd    TYPE ztc2sd2002-prodcd,          " 제품코드
        matrnm    TYPE ztc2md2006-matrnm,          " 제품명
        sdplqty   TYPE ztc2sd2002-sdplqty,         " 판매계획 수량
        boxunit   TYPE ztc2sd2002-boxunit,         " 수량 단위
        sdprice TYPE ztc2md2006-sdprice,       " 제품 가격
        currency     TYPE ztc2md2006-currency,       " 화폐단위


      END OF gs_sdplno_detail,

      gt_sdplno_detail LIKE TABLE OF gs_sdplno_detail.










*&---------------------------------------------------------------------*
*& ALV Data
*&---------------------------------------------------------------------*

DATA: gcl_container TYPE REF TO cl_gui_custom_container,
      gcl_grid      TYPE REF TO cl_gui_alv_grid,
      gs_fcat       TYPE        lvc_s_fcat,
      gt_fcat       TYPE        lvc_t_fcat,
      gs_layout     TYPE        lvc_s_layo,
      gs_stable     TYPE        lvc_s_stbl,
      gs_variant    TYPE        disvariant.




*&---------------------------------------------------------------------*
*& ALV Data 2
*&---------------------------------------------------------------------*

DATA: gcl_container_2 TYPE REF TO cl_gui_custom_container,
      gcl_grid_2      TYPE REF TO cl_gui_alv_grid,
      gs_fcat_2       TYPE        lvc_s_fcat,
      gt_fcat_2       TYPE        lvc_t_fcat,
      gs_layout_2     TYPE        lvc_s_layo,
      gs_stable_2     TYPE        lvc_s_stbl,
      gs_variant_2    TYPE        disvariant.



*&---------------------------------------------------------------------*
*& ALV Data 3
*&---------------------------------------------------------------------*

DATA: gcl_container_3 TYPE REF TO cl_gui_custom_container,
      gcl_grid_3      TYPE REF TO cl_gui_alv_grid,
      gcl_handler     TYPE REF TO lcl_event_handler,
      gs_fcat_3       TYPE        lvc_s_fcat,
      gt_fcat_3       TYPE        lvc_t_fcat,
      gs_layout_3     TYPE        lvc_s_layo,
      gs_stable_3     TYPE        lvc_s_stbl,
      gs_variant_3    TYPE        disvariant.




*&---------------------------------------------------------------------*
*& HOTSPOT ALV DATA
*&---------------------------------------------------------------------*

DATA : gcl_container_pop TYPE REF TO cl_gui_custom_container, " 오더 조회 창 핫스팟 클릭시 출력 화면용
       gcl_grid_pop      TYPE REF TO cl_gui_alv_grid,
       gcl_handler_pop   TYPE REF TO lcl_event_handler,
       gs_layout_pop     TYPE lvc_s_layo,
       gs_fcat_pop       TYPE lvc_s_fcat,
       gt_fcat_pop       TYPE lvc_t_fcat,
       gs_variant_pop    TYPE disvariant,
       gs_stable_pop     TYPE lvc_s_stbl.