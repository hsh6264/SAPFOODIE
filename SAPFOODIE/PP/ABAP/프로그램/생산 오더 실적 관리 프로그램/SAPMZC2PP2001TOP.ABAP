*&---------------------------------------------------------------------*
*& Include SAPMZC2PP2001_TOP                        - Module Pool      SAPMZC2PP2001
*&---------------------------------------------------------------------*
PROGRAM sapmzc2pp2001 MESSAGE-ID zc202.
TYPE-POOLS: icon.
TABLES : ztc2pp2006.

CLASS lcl_event_handler DEFINITION DEFERRED.

DATA : BEGIN OF gs_ordernum,
         ponum TYPE ztc2pp2006-ponum,
       END OF gs_ordernum,
       gt_ordernum LIKE TABLE OF gs_ordernum.

"header data
DATA : BEGIN OF gs_header_data.
         INCLUDE STRUCTURE ztc2pp2006.
DATA :   statext TYPE dd07v-ddtext,
         color   TYPE lvc_t_scol,
         icon    TYPE icon-id,
       END OF gs_header_data,
       gt_header_data LIKE TABLE OF gs_header_data.


"item data
DATA : BEGIN OF gs_item,
         ponum     TYPE ztc2pp2007-ponum,
         mkits     TYPE ztc2pp2007-mkits,
         matrnm    TYPE ztc2md2006-matrnm,
         wcid      TYPE ztc2md2006-wcid,
         poquan    TYPE ztc2pp2007-poquan,
         pmquan    TYPE ztc2pp2007-pmquan,
         faltq     TYPE ztc2pp2007-faltq,
         unit      TYPE ztc2pp2007-unit,
         frate(10),
         falrsn    TYPE ztc2pp2007-falrsn,
       END OF gs_item,
       gt_item LIKE TABLE OF gs_item.

" selected header 격납
DATA : gs_selected_row  TYPE lvc_s_row,
       gt_selected_rows TYPE lvc_t_row.

* header ALV
DATA : gcl_container TYPE REF TO cl_gui_custom_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gcl_handler   TYPE REF TO lcl_event_handler,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant,
       gs_stable     TYPE lvc_s_stbl.

*item ALV
DATA : gcl_container2 TYPE REF TO cl_gui_custom_container,
       gcl_grid2      TYPE REF TO cl_gui_alv_grid,
       gs_fcat2       TYPE lvc_s_fcat,
       gt_fcat2       TYPE lvc_t_fcat,
       gs_layout2     TYPE lvc_s_layo,
       gs_variant2    TYPE disvariant,
       gs_stable2     TYPE lvc_s_stbl.

DATA : gv_okcode TYPE sy-ucomm.