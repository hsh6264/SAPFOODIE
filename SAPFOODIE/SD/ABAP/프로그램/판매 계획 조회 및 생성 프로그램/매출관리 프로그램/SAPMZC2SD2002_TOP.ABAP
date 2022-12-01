*&---------------------------------------------------------------------*
*& Include SAPMZC2SD2002_TOP                        - Module Pool      SAPMZC2SD2002
*&---------------------------------------------------------------------*
PROGRAM sapmzc2sd2002 MESSAGE-ID zc222.

CLASS : lcl_event_handler DEFINITION DEFERRED.

TABLES : ztc2sd2008, ztc2sd2006, ztc2sd2007, ztc2md2006.


* Input값 필터를 위한 internal table
DATA : BEGIN OF gs_search,
          vendorc TYPE ztc2sd2008-vendorc,
          saleym  TYPE ztc2sd2008-saleym,
       END OF gs_search,
       gt_search LIKE TABLE OF gs_search.

* ALV 첫번째 : 마감테이블 데이터 internal table
DATA : BEGIN OF gs_data,
    mandt    TYPE ztc2sd2008-mandt,
    cmpnc    TYPE ztc2sd2008-cmpnc,
    plant    TYPE ztc2sd2008-plant,
    vendorc  TYPE ztc2sd2008-vendorc,
    saleym   TYPE ztc2sd2008-saleym,
    saletp   TYPE ztc2sd2008-saletp,
    waers    TYPE ztc2sd2008-waers,
    resprid  TYPE ztc2sd2008-resprid,
    salefdt  TYPE ztc2sd2008-salefdt,
    statflag TYPE ztc2sd2008-statflag,
    color    TYPE lvc_t_scol,
  END OF gs_data,
  gt_data LIKE TABLE OF gs_data.

* 행 선택 변수 선언
 DATA : gs_row  TYPE lvc_s_row,
        gt_rows TYPE lvc_t_row.

* ALV 두번째 : 고객주문테이블 데이터 internal table
DATA : BEGIN OF gs_data_2,
  mandt       TYPE ztc2sd2006-mandt,
  plant       TYPE ztc2sd2006-plant,
  cmpnc       TYPE ztc2sd2006-cmpnc,
  vendorc     TYPE ztc2sd2006-vendorc,
  saleym      TYPE ztc2sd2006-saleym,
  ordercd     TYPE ztc2sd2006-ordercd,
  orderdate   TYPE ztc2sd2006-orderdate,
  duedate     TYPE ztc2sd2006-duedate,
  ttamount    TYPE ztc2sd2006-ttamount,
  waers       TYPE ztc2sd2006-waers,
  odmaxwt     TYPE ztc2sd2006-odmaxwt,
  weightunit  TYPE ztc2sd2006-weightunit,
  outstoredt  TYPE ztc2sd2006-outstoredt,
  resprid     TYPE ztc2sd2006-resprid,
  statflag    TYPE ztc2sd2006-statflag,
  delflag     TYPE ztc2sd2006-delflag,
  dispatchcd  TYPE ztc2sd2006-dispatchcd,
  color       TYPE lvc_t_scol,
  END OF gs_data_2,
  gt_data_2 LIKE TABLE OF gs_data_2.

* popup : 고객주문아이템 데이터
DATA: BEGIN OF gs_data_3,
      ordercd   TYPE ztc2sd2007-ordercd,
      prodcd    TYPE ztc2sd2007-prodcd,
      matrnm    TYPE ztc2md2006-matrnm,
      itemqty   TYPE ztc2sd2007-itemqty,
      boxunit   TYPE ztc2sd2007-boxunit,
      itemprice TYPE ztc2sd2007-itemprice,
      waers     TYPE ztc2sd2007-waers,
      END OF gs_data_3,

   gt_data_3 LIKE TABLE OF gs_data_3.

DATA : gcl_container TYPE REF TO cl_gui_custom_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gcl_handler   TYPE REF TO lcl_event_handler,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant,
       gs_stable     TYPE lvc_s_stbl,
       gs_sort       TYPE lvc_s_sort,
       gt_sort       TYPE lvc_t_sort.

DATA : gcl_container_2 TYPE REF TO cl_gui_custom_container,
       gcl_grid_2      TYPE REF TO cl_gui_alv_grid,
       gcl_handler_2   TYPE REF TO lcl_event_handler,
       gs_fcat_2       TYPE lvc_s_fcat,
       gt_fcat_2       TYPE lvc_t_fcat,
       gs_layout_2     TYPE lvc_s_layo,
       gs_variant_2    TYPE disvariant,
       gs_stable_2     TYPE lvc_s_stbl.


DATA : gcl_container_pop TYPE REF TO cl_gui_custom_container,
       gcl_grid_pop      TYPE REF TO cl_gui_alv_grid,
       gs_fcat_pop       TYPE lvc_s_fcat,
       gt_fcat_pop       TYPE lvc_t_fcat,
       gs_layout_pop     TYPE lvc_s_layo,
       gs_variant_pop    TYPE disvariant,
       gs_stable_pop     TYPE lvc_s_stbl.

DATA : gv_okcode TYPE sy-ucomm.