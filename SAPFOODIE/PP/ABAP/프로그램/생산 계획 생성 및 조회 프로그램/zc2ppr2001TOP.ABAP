*&---------------------------------------------------------------------*
*& Include ZC2PPR2001_TOP                           - Report ZC2PPR2001
*&---------------------------------------------------------------------*
REPORT zc2ppr2001 MESSAGE-ID zc202.

TABLES: ztc2pp2004.
CLASS lcl_event_handler DEFINITION DEFERRED.

DATA : cdate  TYPE sy-datum,
       createid TYPE sy-uname,
       gv_plnym TYPE ztc2pp2005-ppnum.

DATA: BEGIN OF gs_mkit.
      INCLUDE STRUCTURE ztc2md2006.
DATA: prodcd  TYPE ztc2sd2002-prodcd,
      sdplqty TYPE ztc2sd2002-sdplqty,
      ppquan  TYPE ztc2pp2005-ppquan,
      END OF gs_mkit,
      gt_mkit   LIKE TABLE OF gs_mkit.

DATA : BEGIN OF gs_header.
      INCLUDE STRUCTURE ztc2pp2004.
DATA : statext TYPE dd07v-ddtext,
       color    TYPE lvc_t_scol,
      END OF gs_header,
       gt_header LIKE TABLE OF gs_header.

DATA: gs_ppitem TYPE ztc2pp2005,
      gt_ppitem LIKE TABLE OF gs_ppitem.


DATA: BEGIN OF gs_item,
        cmpnc   TYPE ztc2pp2005-cmpnc,
        plant   TYPE ztc2pp2005-plant,
        mkits   TYPE ztc2pp2005-mkits,
        ppnum   TYPE ztc2pp2004-ppnum,
        matrnm  TYPE ztc2md2006-matrnm,
        sdplqty TYPE ztc2sd2002-sdplqty,
        ppquan  TYPE ztc2pp2005-ppquan,
        unit    TYPE ztc2md2006-unit,
        wcid    TYPE ztc2md2006-wcid,
      END OF gs_item,
      gt_item LIKE TABLE OF gs_item.

DATA: BEGIN OF gs_list,
        cmpnc   TYPE ztc2pp2005-cmpnc,
        plant   TYPE ztc2pp2005-plant,
        matrc   TYPE ztc2md2006-matrc,
        ppnum   TYPE ztc2pp2004-ppnum,
        matrnm  TYPE ztc2md2006-matrnm,
        sdplqty TYPE ztc2sd2002-sdplqty,
        ppquan  TYPE ztc2pp2005-ppquan,
        unit    TYPE ztc2md2006-unit,
        wcid    TYPE ztc2md2006-wcid,
      END OF gs_list,
      gt_list LIKE TABLE OF gs_list.


"mkit ALV
DATA: gcl_container_mkit TYPE REF TO cl_gui_custom_container,
      gcl_grid_mkit      TYPE REF TO cl_gui_alv_grid,
      gs_fcat_mkit       TYPE lvc_s_fcat,
      gt_fcat_mkit       TYPE lvc_t_fcat,
      gs_layout_mkit     TYPE lvc_s_layo,
      gs_variant_mkit    TYPE disvariant,
      gs_stable_mkit     TYPE lvc_s_stbl.

"SD LIST ALV
DATA: gcl_container_sd TYPE REF TO cl_gui_custom_container,
      gcl_grid_sd      TYPE REF TO cl_gui_alv_grid,
      gs_fcat_sd       TYPE lvc_s_fcat,
      gt_fcat_sd       TYPE lvc_t_fcat,
      gs_layout_sd     TYPE lvc_s_layo,
      gs_variant_sd    TYPE disvariant,
      gs_stable_sd     TYPE lvc_s_stbl.


"Header ALV
DATA: gcl_container_1 TYPE REF TO cl_gui_custom_container,
      gcl_grid_1      TYPE REF TO cl_gui_alv_grid,
      gcl_handler     TYPE REF TO lcl_event_handler,
      gs_fcat_1       TYPE lvc_s_fcat,
      gt_fcat_1       TYPE lvc_t_fcat,
      gs_layout_1     TYPE lvc_s_layo,
      gs_variant_1    TYPE disvariant,
      gs_stable_1     TYPE lvc_s_stbl.

"Item ALV
DATA: gcl_container_2 TYPE REF TO cl_gui_custom_container,
      gcl_grid_2      TYPE REF TO cl_gui_alv_grid,
      gs_fcat_2       TYPE lvc_s_fcat,
      gt_fcat_2       TYPE lvc_t_fcat,
      gs_layout_2     TYPE lvc_s_layo,
      gs_variant_2    TYPE disvariant,
      gs_stable_2     TYPE lvc_s_stbl.

DATA : gv_okcode TYPE sy-ucomm.

DATA : gs_row  TYPE lvc_s_row,
       gt_rows TYPE lvc_t_row.

DATA : gs_click  TYPE lvc_s_row,
       gt_click TYPE lvc_t_row.


DATA: BEGIN OF gs_list_del,
        cmpnc   TYPE ztc2pp2005-cmpnc,
        plant   TYPE ztc2pp2005-plant,
        matrc   TYPE ztc2md2006-matrc,
        ppnum   TYPE ztc2pp2004-ppnum,
        matrnm  TYPE ztc2md2006-matrnm,
        sdplqty TYPE ztc2sd2002-sdplqty,
        ppquan  TYPE ztc2pp2005-ppquan,
        unit    TYPE ztc2md2006-unit,
      END OF gs_list_del,
      gt_list_del LIKE TABLE OF gs_list_del.

DATA: BEGIN OF gs_item_del,
        cmpnc   TYPE ztc2pp2005-cmpnc,
        plant   TYPE ztc2pp2005-plant,
        mkits   TYPE ztc2pp2005-mkits,
        ppnum   TYPE ztc2pp2004-ppnum,
        matrnm  TYPE ztc2md2006-matrnm,
        sdplqty TYPE ztc2sd2002-sdplqty,
        ppquan  TYPE ztc2pp2005-ppquan,
        unit    TYPE ztc2md2006-unit,
      END OF gs_item_del,
      gt_item_del LIKE TABLE OF gs_item_del.

DEFINE _clear.
  CLEAR &1.
  DEFINE &2.
END-OF-DEFINITION.