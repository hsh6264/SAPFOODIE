*&---------------------------------------------------------------------*
*& Include ZC2MMR2002_TOP                           - Report ZC2MMR2002
*&---------------------------------------------------------------------*
REPORT zc2mmr2002 MESSAGE-ID zc202.

TABLES : ztc2mm2002, ztc2md2006, ztc2mm2001, ztc2pp2004, ztc2pp2005, ztc2mm2003.

CLASS lcl_event_handler DEFINITION DEFERRED.

DATA : gv_ddate    TYPE sy-datum,
       gv_charge   TYPE sy-uname,
       gv_plant    TYPE char10,
       gv_yymm     TYPE char6,
       gv_purcplnb TYPE c LENGTH 20,
       gv_numflag  TYPE c LENGTH 20.
*       gv_plnb         type ztc2mm2003-purcplnb.

* 0100 Screen.
*Left
DATA : BEGIN OF gs_data,
         cmpnc    TYPE ztc2mm2001-cmpnc,
         plnym    TYPE ztc2pp2004-plnym,
         plant    TYPE ztc2mm2001-plant,
         matrc    TYPE ztc2md2006-matrc,
         matrnm   TYPE ztc2md2006-matrnm,
         ppquan   TYPE ztc2pp2005-ppquan,
         stckq    TYPE ztc2mm2001-stckq,
         unit     TYPE ztc2mm2001-unit,
         purcp    TYPE ztc2mm2003-purcp,
         warehscd TYPE ztc2md2006-warehscd,
         purcplnb TYPE ztc2mm2002-purcplnb,
         rqqty    TYPE ztc2pp2002-rqqty,
         saveq    TYPE ztc2md2006-saveq,
         vendorc  TYPE ztc2md2006-vendorc,
       END OF gs_data,
       gt_data LIKE TABLE OF gs_data.

DATA: gs_data_del3 TYPE ztc2mm2003,
      gt_data_del3 LIKE TABLE OF gs_data_del3.
*Right
DATA: BEGIN OF gs_item.
        INCLUDE STRUCTURE ztc2mm2003.
DATA:   plnym    TYPE ztc2pp2004-plnym,
        matrnm   TYPE ztc2md2006-matrnm,
        stckq    TYPE ztc2mm2001-stckq,
        ppquan   TYPE ztc2pp2005-ppquan,
        unit     TYPE ztc2mm2001-unit,  "ztc2mm2003-uint
        warehscd TYPE ztc2md2006-warehscd,
        rqqty    TYPE ztc2pp2002-rqqty,
        saveq    TYPE ztc2md2006-saveq,
        purctp   TYPE ztc2mm2002-purctp,
        currency TYPE ztc2mm2002-currency,
        mmprice  TYPE ztc2md2006-mmprice,
        versn    TYPE ztc2pp2002-versn,
      END OF gs_item,
      gt_item LIKE TABLE OF gs_item.

DATA : gs_mitem LIKE ztc2mm2003,
       gt_mitem LIKE TABLE OF gs_mitem.

*Left ALV
DATA : gcl_container TYPE REF TO cl_gui_custom_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant,
       gs_stable     TYPE lvc_s_stbl.

*Right ALV
DATA : gcl_container2 TYPE REF TO cl_gui_custom_container,
       gcl_grid2      TYPE REF TO cl_gui_alv_grid,
       gs_layout2     TYPE lvc_s_layo,
       gs_fcat2       TYPE lvc_s_fcat,
       gt_fcat2       TYPE lvc_t_fcat,
       gs_variant2    TYPE disvariant,
       gs_stable2     TYPE lvc_s_stbl.

DATA : gv_okcode  TYPE sy-ucomm,
       gv_okcode2 TYPE sy-ucomm.

DATA : gs_row  TYPE lvc_s_row,
       gt_rows TYPE lvc_t_row.

DATA : gs_data_del LIKE gs_data,
       gt_data_del LIKE TABLE OF gs_data_del.

DATA: gs_header LIKE ztc2mm2002,
      gt_header LIKE TABLE OF gs_header.


*0101 Screen

DATA : BEGIN OF gs_s2header.
         INCLUDE STRUCTURE ztc2mm2002.
DATA :   color  TYPE lvc_t_scol,
         status TYPE c LENGTH 4,
       END OF gs_s2header,
       gt_s2header LIKE TABLE OF gs_s2header.

DATA : gs_data_del2 TYPE ztc2mm2002,
       gt_data_del2 LIKE TABLE OF gs_data_del2.

DATA: BEGIN OF gs_pitem,
        cmpnc    TYPE ztc2mm2003-cmpnc,
        plant    TYPE ztc2mm2003-plant,
        purcplnb TYPE ztc2mm2003-purcplnb,
        matrc    TYPE ztc2mm2003-matrc,
        purcp    TYPE ztc2mm2003-purcp,
        uint     TYPE ztc2mm2003-uint,
        matrnm   TYPE ztc2md2006-matrnm,
        warehscd TYPE ztc2md2006-warehscd,
        vendorc  TYPE ztc2md2006-vendorc,
        delflag  TYPE ztc2mm2003-delflag,
      END OF gs_pitem,
      gt_pitem LIKE TABLE OF gs_pitem WITH NON-UNIQUE KEY purcplnb.

*Header ALV
DATA : gcl_container_hd TYPE REF TO cl_gui_custom_container,
       gcl_grid_hd      TYPE REF TO cl_gui_alv_grid,
       gcl_handler      TYPE REF TO lcl_event_handler,
       gs_layout_hd     TYPE lvc_s_layo,
       gs_fcat_hd       TYPE lvc_s_fcat,
       gt_fcat_hd       TYPE lvc_t_fcat,
       gs_variant_hd    TYPE disvariant,
       gs_stable_hd     TYPE lvc_s_stbl.

*Item List ALV
DATA : gcl_container_pl TYPE REF TO cl_gui_custom_container,
       gcl_grid_pl      TYPE REF TO cl_gui_alv_grid,
       gs_layout_pl     TYPE lvc_s_layo,
       gs_fcat_pl       TYPE lvc_s_fcat,
       gt_fcat_pl       TYPE lvc_t_fcat,
       gs_variant_pl    TYPE disvariant,
       gs_stable_pl     TYPE lvc_s_stbl.

*Edit ALV
DATA : gcl_container_ed TYPE REF TO cl_gui_custom_container,
       gcl_grid_ed      TYPE REF TO cl_gui_alv_grid,
       gs_layout_ed     TYPE lvc_s_layo,
       gs_fcat_ed       TYPE lvc_s_fcat,
       gt_fcat_ed       TYPE lvc_t_fcat,
       gs_variant_ed    TYPE disvariant,
       gs_stable_ed     TYPE lvc_s_stbl.