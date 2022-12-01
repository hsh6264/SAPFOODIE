*&---------------------------------------------------------------------*
*& Include ZC2PPR2002_TOP                           - Report ZC2PPR2002
*&---------------------------------------------------------------------*
REPORT zc2ppr2002 MESSAGE-ID zc202.

TABLES: ztc2pp2006.

DATA : cdate    TYPE sy-datum,
       createid TYPE sy-uname,
       gv_ponum TYPE ztc2pp2006-ponum.

"ALV에 뿌려질 mkit i-tab
DATA: BEGIN OF gs_mkit,
       cmpnc    TYPE ztc2md2006-cmpnc   ,
       matrc    TYPE ztc2md2006-matrc   ,
       matrnm   TYPE ztc2md2006-matrnm  ,
       wcid     TYPE ztc2md2006-wcid    ,
       warehscd TYPE ztc2md2006-warehscd,
       saveq    TYPE ztc2md2006-saveq   ,
       stckq    TYPE ztc2mm2001-stckq   ,
       unit     TYPE ztc2md2006-unit    ,
       color    TYPE lvc_t_scol,
      END OF gs_mkit,
      gt_mkit LIKE TABLE OF gs_mkit.

"ALV에 뿌려질 item i-tab
      DATA: BEGIN OF gs_item,
        cmpnc   TYPE ztc2pp2007-cmpnc,
        plant   TYPE ztc2pp2007-plant,
        matrc   TYPE ztc2md2006-matrc,
        ponum   TYPE ztc2pp2007-ponum,
        matrnm  TYPE ztc2md2006-matrnm,
        poquan  TYPE ztc2pp2007-poquan,
        unit    TYPE ztc2md2006-unit,
        wcid    TYPE ztc2md2006-wcid,
        postat  TYPE ztc2pp2007-postat ,
        warehscd TYPE ztc2md2006-warehscd, "ALV에서 보여줄 필요 없음. 아마도?
      END OF gs_item,
      gt_item LIKE TABLE OF gs_item.

" Delete 담을 i-tab
      DATA: BEGIN OF gs_item_del,
        cmpnc   TYPE ztc2pp2007-cmpnc,
        plant   TYPE ztc2pp2007-plant,
        matrc   TYPE ztc2md2006-matrc,
        ponum   TYPE ztc2pp2007-ponum,
        matrnm  TYPE ztc2md2006-matrnm,
        poquan  TYPE ztc2pp2007-poquan,
        unit    TYPE ztc2md2006-unit,
        wcid    TYPE ztc2md2006-wcid,
        postat  TYPE ztc2pp2007-postat ,
        warehscd TYPE ztc2md2006-warehscd, "ALV에서 보여줄 필요 없음. 아마도?
      END OF gs_item_del,
      gt_item_del LIKE TABLE OF gs_item_del.

*"Header담을 I-tab
*       DATA: BEGIN OF gs_header.
*              INCLUDE STRUCTURE ztc2pp2006.
*       DATA: END OF gs_header,
*             gt_header LIKE TABLE OF gs_header.
*
*"Item 담을 I-tab
*       DATA: BEGIN OF gs_poitem.
*              INCLUDE STRUCTURE ztc2pp2007.
*       DATA: END OF gs_poitem,
*             gt_poitem LIKE TABLE OF gs_poitem.


"mkit ALV
DATA: gcl_container_mkit TYPE REF TO cl_gui_custom_container,
      gcl_grid_mkit      TYPE REF TO cl_gui_alv_grid,
      gs_fcat_mkit       TYPE lvc_s_fcat,
      gt_fcat_mkit       TYPE lvc_t_fcat,
      gs_layout_mkit     TYPE lvc_s_layo,
      gs_variant_mkit    TYPE disvariant,
      gs_stable_mkit     TYPE lvc_s_stbl.

"Item ALV
DATA: gcl_container_item TYPE REF TO cl_gui_custom_container,
      gcl_grid_item      TYPE REF TO cl_gui_alv_grid,
      gs_fcat_item       TYPE lvc_s_fcat,
      gt_fcat_item       TYPE lvc_t_fcat,
      gs_layout_item     TYPE lvc_s_layo,
      gs_variant_item    TYPE disvariant,
      gs_stable_item     TYPE lvc_s_stbl.

DATA : gv_okcode TYPE sy-ucomm.

DATA : gs_row  TYPE lvc_s_row,
       gt_rows TYPE lvc_t_row.

DEFINE _clear.
  CLEAR &1.
  DEFINE &2.
END-OF-DEFINITION.