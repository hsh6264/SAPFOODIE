*&---------------------------------------------------------------------*
*& Include ZC2MMR2003_TOP                           - Report ZC2MMR2003
*&---------------------------------------------------------------------
PROGRAM sapmzc2mm2001 MESSAGE-ID zc202.

TYPE-POOLS: vrm.

CLASS : lcl_event_handler DEFINITION DEFERRED.

TABLES : ztc2mm2004, ztc2mm2005, ztc2md2005, ztc2md2006.

*TYPES : it_col TYPE lvc_t_scol.

*Input값 필터를 위한 internal table
DATA : BEGIN OF gs_execute,
         purcornb TYPE ztc2mm2004-purcornb,
         statflag TYPE ztc2mm2004-statflag,
         vendorc  TYPE ztc2mm2004-vendorc,
         spras    TYPE i,
       END OF gs_execute,

       gt_execute LIKE TABLE OF gs_execute.

DATA : BEGIN OF gs_data,
         plant    TYPE ztc2mm2004-plant,
         cmpnc    TYPE ztc2mm2004-cmpnc,
         status   TYPE c LENGTH 4,
         emaili   LIKE icon-name, "icon 삽입
         statflag TYPE ztc2mm2004-statflag,
         purcornb TYPE ztc2mm2004-purcornb,
         orpddt   TYPE ztc2mm2004-orpddt,
         vendorc  TYPE ztc2mm2004-vendorc,
         instrdt  TYPE ztc2mm2004-instrdt,
         instrdd  TYPE ztc2mm2005-instrdd,
         respr    TYPE ztc2md2005-respr,
         email    TYPE ztc2md2005-email,
         stckq    TYPE ztc2mm2001-stckq,
         color    TYPE lvc_t_scol, "셀 색깔 추가
       END OF gs_data,

       gt_data LIKE TABLE OF gs_data WITH KEY purcornb.

* hotspot popup 데이터
DATA : BEGIN OF gs_data2,
         matrtype TYPE ztc2md2006-matrtype,
         matrc    TYPE ztc2md2006-matrc,
         matrnm   TYPE ztc2md2006-matrnm,
         purcp    TYPE ztc2mm2005-purcp,
         unit     TYPE ztc2mm2005-unit,
         mmprice  TYPE ztc2md2006-mmprice,
         currency TYPE ztc2mm2004-currency,
         purctp   TYPE ztc2mm2004-purctp,
         purcornb TYPE ztc2mm2004-purcornb,
         vendorc   TYPE ztc2mm2005-vendorc,
         purcym   TYPE ztc2mm2007-purcym,
       END OF gs_data2,

       gt_data2 LIKE TABLE OF gs_data2.

* 입고처리 popup 데이터
DATA :  BEGIN OF gs_data3.
          INCLUDE STRUCTURE ztc2mm2004.
DATA:     "purcornb  TYPE ztc2mm2004-purcornb,
        "orpddt    TYPE ztc2mm2004-orpddt,
        "vendorc   TYPE ztc2mm2004-vendorc,
          matrc       TYPE ztc2mm2005-matrc,
          matrnm      TYPE ztc2md2006-matrnm,
          "instrdt   TYPE ztc2mm2004-instrdt,
          "resprid   TYPE ztc2mm2004-resprid,
          purcp       TYPE ztc2mm2005-purcp,
          instq       TYPE ztc2mm2005-instq,
          falutyq     TYPE ztc2mm2005-falutyq,
          faultyr     TYPE ztc2mm2005-faultyr,
          warehscd    TYPE ztc2mm2005-warehscd,
          faultyp(10),
          unit        TYPE ztc2mm2005-unit,
          stckq       TYPE ztc2mm2001-stckq,
        END OF gs_data3,

        gt_data3 LIKE TABLE OF gs_data3.

* ALV
DATA : gcl_container TYPE REF TO cl_gui_custom_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gcl_handler   TYPE REF TO lcl_event_handler,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant,
       gs_stable     TYPE lvc_s_stbl.


* ALV 2 (이메일)
DATA : gcl_container_2 TYPE REF TO cl_gui_custom_container,
       gcl_edit_2      TYPE REF TO cl_gui_textedit,
       gs_layout_2     TYPE lvc_s_layo,
       gs_fcat_2       TYPE lvc_s_fcat,
       gt_fcat_2       TYPE lvc_t_fcat,
       gs_variant_2    TYPE disvariant,
       gs_stable_2     TYPE lvc_s_stbl.

* Popup ALV
DATA : gcl_container_pop TYPE REF TO cl_gui_custom_container,
       gcl_grid_pop      TYPE REF TO cl_gui_alv_grid,
       gs_fcat_pop       TYPE lvc_s_fcat,
       gt_fcat_pop       TYPE lvc_t_fcat,
       gs_layout_pop     TYPE lvc_s_layo,
       gs_variant_pop    TYPE disvariant,
       gs_stable_pop     TYPE lvc_s_stbl.

* 입고처리 Popup ALV
DATA : gcl_container_pop_2 TYPE REF TO cl_gui_custom_container,
       gcl_grid_pop_2      TYPE REF TO cl_gui_alv_grid,
       gs_fcat_pop_2       TYPE lvc_s_fcat,
       gt_fcat_pop_2       TYPE lvc_t_fcat,
       gs_layout_pop_2     TYPE lvc_s_layo,
       gs_variant_pop_2    TYPE disvariant,
       gs_stable_pop_2     TYPE lvc_s_stbl.


DATA : gv_okcode TYPE sy-ucomm,
       gt_rows   TYPE lvc_t_row,
       gs_row    TYPE lvc_s_row.

"-------------------------------------------------------------------
DATA : gv_flag,
       gv_input TYPE ztc2md2005-vendorn.

DATA : gs_add TYPE ztc2mm2001,
       gt_add LIKE TABLE OF gs_add.

DATA : gs_purc TYPE ztc2mm2005,
       gt_purc LIKE TABLE OF gs_purc.

DATA : gs_purcp TYPE ztc2mm2007,
       gt_purcp LIKE TABLE OF gs_purcp.S