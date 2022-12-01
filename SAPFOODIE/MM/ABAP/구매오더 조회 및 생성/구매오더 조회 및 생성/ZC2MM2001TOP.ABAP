*&---------------------------------------------------------------------*
*& Include ZC2MMR2001_TOP                           - Report ZC2MMR2001
*&---------------------------------------------------------------------*
REPORT zc2mmr2001 MESSAGE-ID zc202.

TABLES : ztc2mm2004, ztc2mm2005, ztc2md2005.

TYPE-POOLS: vrm.

DATA : gv_numflag TYPE c LENGTH 20.                         " 넘버 레인지 중복 방지용.

DATA : gv_plant    TYPE c LENGTH 8,                          " 인풋 박스에 데이터 기입용.
       gv_orpddt   TYPE sy-datum,
       gv_vencor   TYPE c LENGTH 3,
       gv_resprid  TYPE sy-uname,
       gv_purcym   TYPE c LENGTH 20,
       gv_instrdt  TYPE sy-datum,
       gv_purcornb TYPE c LENGTH 15,
       gv_year     TYPE sy-datum,
       gv_year2     TYPE sy-datum.

DATA : BEGIN OF gs_status_flag,
         statflag TYPE ztc2mm2004-statflag,
       END OF gs_status_flag,

       gt_status_flag LIKE TABLE OF gs_status_flag.


DATA : gs_header TYPE ztc2mm2004,                            "구매헤더
       gt_header LIKE TABLE OF gs_header.

DATA : BEGIN OF gs_item.                                     " 주문할 아이템 리스트
         INCLUDE STRUCTURE ztc2mm2005.
DATA :   celltab  TYPE lvc_t_styl,
         mmprice  TYPE ztc2md2006-mmprice,
         purctp   TYPE ztc2mm2004-purctp,
         currency TYPE ztc2md2006-currency,
         instrdt  TYPE ztc2mm2004-instrdt,
       END OF gs_item,
       gt_item LIKE TABLE OF gs_item.

DATA : BEGIN OF gs_jego.                                     " 구매 가능 아이템 리스트(ALL)
         INCLUDE STRUCTURE ztc2mm2001.
DATA :   vendorc  TYPE ztc2md2006-vendorc,
         matrnm   TYPE ztc2md2006-matrnm,
         mmprice  TYPE ztc2md2006-mmprice,
         currency TYPE ztc2md2006-currency,
       END OF gs_jego.
DATA : gt_jego    LIKE TABLE OF gs_jego.

DATA : BEGIN OF gs_gumeheader,
         status   TYPE c LENGTH 4,                        "오더 조회화면 용
         statflag TYPE ztc2mm2004-statflag,
         purcornb TYPE ztc2mm2004-purcornb,
         vendorc  TYPE ztc2mm2004-vendorc,
         matrtype TYPE ztc2md2006-matrtype,
         orpddt   TYPE ztc2mm2004-orpddt,
         warehscd TYPE ztc2md2006-warehscd,
         resprid  TYPE ztc2mm2004-resprid,
         purcfdt  TYPE ztc2mm2007-purcfdt,
         delflag  TYPE ztc2mm2004-delflag,
         cmpnc    TYPE ztc2mm2004-cmpnc,
         plant    TYPE ztc2mm2004-plant,
         purcym   TYPE ztc2mm2004-purcym,
         instrdt  TYPE ztc2mm2004-instrdt,
         retnr    TYPE ztc2mm2004-retnr,
         purcp    TYPE ztc2mm2005-purcp,
         purctp   TYPE ztc2mm2004-purctp,
         currency TYPE ztc2mm2004-currency,
         instrdd  TYPE ztc2mm2004-instrdd,
         color    TYPE lvc_t_scol,
       END OF gs_gumeheader,
       gt_gumeheader LIKE TABLE OF gs_gumeheader.

DATA : BEGIN OF gs_gume_sebu,                                "셀탭이 스트럭쳐에 존재하면 콜렉트가 불가함.
         purcornb TYPE ztc2mm2004-purcornb,
         matrc    TYPE ztc2mm2005-matrc,
         purcp    TYPE ztc2mm2005-purcp,
         unit     TYPE ztc2mm2005-unit,
         matrnm   TYPE ztc2md2006-matrnm,
         warehscd TYPE ztc2mm2005-warehscd,
         resprid  TYPE ztc2mm2004-resprid,
         orpddt   TYPE ztc2mm2004-orpddt,
         instrdt  TYPE ztc2mm2004-instrdt,
         celltab  TYPE lvc_t_styl,
       END OF gs_gume_sebu,
       gt_gume_sebu LIKE TABLE OF gs_gume_sebu.

DATA : BEGIN OF gs_gume_sebu2,                              "그래서 셀텝을 빼고 다른 방법으로 인풋을 막았어용
         purcornb TYPE ztc2mm2004-purcornb,
         matrc    TYPE ztc2mm2005-matrc,
         purcp    TYPE ztc2mm2005-purcp,
         unit     TYPE ztc2mm2005-unit,
         matrnm   TYPE ztc2md2006-matrnm,
         warehscd TYPE ztc2mm2005-warehscd,
         resprid  TYPE ztc2mm2004-resprid,
         orpddt   TYPE ztc2mm2004-orpddt,
         instrdt  TYPE ztc2mm2004-instrdt,
         purcym   TYPE ztc2mm2004-purcym,
         mmprice  TYPE ztc2md2006-mmprice,
         purctp   TYPE ztc2mm2004-purctp,
         currency TYPE ztc2md2006-currency,
         money    TYPE dmbtr,
       END OF gs_gume_sebu2,
       gt_gume_sebu2 LIKE TABLE OF gs_gume_sebu2.




DATA : gcl_container TYPE REF TO cl_gui_custom_container,  " 오더 조회 라디오 버튼 클릭시
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gs_layout     TYPE lvc_s_layo,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_variant    TYPE disvariant,
       gs_stable     TYPE lvc_s_stbl.

DATA : gcl_container_2 TYPE REF TO cl_gui_custom_container, " 오더 생성 화면 좌측 컨테이너
       gcl_grid_2      TYPE REF TO cl_gui_alv_grid,
       gs_layout_2     TYPE lvc_s_layo,
       gs_fcat_2       TYPE lvc_s_fcat,
       gt_fcat_2       TYPE lvc_t_fcat,
       gs_variant_2    TYPE disvariant,
       gs_stable_2     TYPE lvc_s_stbl.

DATA : gcl_container_3 TYPE REF TO cl_gui_custom_container, " 오더 생성 화면 우측 컨테이너
       gcl_grid_3      TYPE REF TO cl_gui_alv_grid,
       gs_layout_3     TYPE lvc_s_layo,
       gs_fcat_3       TYPE lvc_s_fcat,
       gt_fcat_3       TYPE lvc_t_fcat,
       gs_variant_3    TYPE disvariant,
       gs_stable_3     TYPE lvc_s_stbl.

DATA : gcl_container_pop TYPE REF TO cl_gui_custom_container, " 오더 조회 창 핫스팟 클릭시 출력 화면용
       gcl_grid_pop      TYPE REF TO cl_gui_alv_grid,
       gs_layout_pop     TYPE lvc_s_layo,
       gs_fcat_pop       TYPE lvc_s_fcat,
       gt_fcat_pop       TYPE lvc_t_fcat,
       gs_variant_pop    TYPE disvariant,
       gs_stable_pop     TYPE lvc_s_stbl.

DATA : gcl_container_pop_2 TYPE REF TO cl_gui_custom_container, " 승인완료 상세조회 핫스팟 클릭시 출력 화면용
       gcl_grid_pop_2      TYPE REF TO cl_gui_alv_grid,
       gs_layout_pop_2     TYPE lvc_s_layo,
       gs_fcat_pop_2       TYPE lvc_s_fcat,
       gt_fcat_pop_2       TYPE lvc_t_fcat,
       gs_variant_pop_2    TYPE disvariant,
       gs_stable_pop_2     TYPE lvc_s_stbl.

DATA : gcl_container_4 TYPE REF TO cl_gui_custom_container, " 승인완료 조회창
       gcl_grid_4      TYPE REF TO cl_gui_alv_grid,
       gs_layout_4     TYPE lvc_s_layo,
       gs_fcat_4       TYPE lvc_s_fcat,
       gt_fcat_4       TYPE lvc_t_fcat,
       gs_variant_4    TYPE disvariant,
       gs_stable_4     TYPE lvc_s_stbl.

DATA : gs_row  TYPE lvc_s_row,
       gt_rows TYPE lvc_t_row.

DATA : gs_data_del   TYPE ztc2mm2005,                         " 데이터 딜리트용
       gt_data_del   LIKE TABLE OF gs_data_del,
       gs_data_del_2 TYPE ztc2mm2004,
       gt_data_del_2 LIKE TABLE OF gs_data_del_2,
       gs_data_del_3 TYPE ztc2mm2004,
       gt_data_del_3 LIKE TABLE OF gs_data_del_3.



DATA : gv_okcode  TYPE sy-ucomm,                              "각 화면별 ok code.
       gv_okcode2 TYPE sy-ucomm,
       gv_okcode3 TYPE sy-ucomm,
       gv_okcode4 TYPE sy-ucomm,
       gv_okcode5 TYPE sy-ucomm.

DATA: gv_flag,
      gv_input TYPE ztc2md2005-vendorn.