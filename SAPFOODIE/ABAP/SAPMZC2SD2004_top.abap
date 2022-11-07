*&---------------------------------------------------------------------*
*& Include          SAPMZC2SD2004_TOP
*&---------------------------------------------------------------------*
tables ztc2sd2006.
CLASS lcl_event_handler DEFINITION DEFERRED.
data: go_container1 type ref to cl_gui_custom_container,
      go_container2 type ref to cl_gui_custom_container,
      go_grid1      type ref to cl_gui_alv_grid,
      go_grid2      type ref to cl_gui_alv_grid,
      gs_fcat1      type lvc_s_fcat,
      gs_fcat2      type lvc_s_fcat,
      gs_layo1      type lvc_s_layo,
      gs_layo2      type lvc_s_layo,
      gt_fcat1      type lvc_t_fcat,
      gt_fcat2      type lvc_t_fcat,
      GO_HANDLER  TYPE REF TO lcl_event_handleR,
      GV_STATFLAG TYPE C LENGTH 10,
      GV_VENDORN  TYPE C LENGTH 10,
      GV_DATEUP   TYPE ZTC2SD2006-ORDERDATE.

data: BEGIN OF gs_Data1,
SHOT       TYPE C LENGTH 8,
PLANT      type ZTC2SD2006-plant,
CMPNC      type ZTC2SD2006-cmpnc,
VENDORC    type ZTC2SD2006-vendorc,
SALEYM     type ZTC2SD2006-saleym,
ORDERCD    type ZTC2SD2006-ordercd,
ORDERDATE  type ztc2sd2006-ORDErdate,
DUEDATE    type ZTC2SD2006-DUEDATE,
TTAMOUNT   type ztc2sd2006-ttamount,
WAERS      type ZTC2SD2006-waers,
ODMAXWT    type ZTC2SD2006-ODMAXWT,
WEIGHTUNIT type ZTC2SD2006-WEIGHTUNIT,
OUTSTOREDT type ZTC2SD2006-OUTSTOREDT,
RESPRID    type ztc2sd2006-RESPRID,
STATFLAG   type ZTC2SD2006-STATFLAG,
DELFLAG    type ZTC2SD2006-delflag,
DISPATCHCD type ZTC2SD2006-DISPATCHCD,
VENDORN    type ztc2md2005-vendorn,
      end of gs_Data1,

   gt_Data1 like table of gs_Data1.

data: begin of gs_data2,
PLANT      type ztc2sd2007-plant,
CMPNC      type ztc2sd2007-cmpnc,
VENDORC    type ztc2sd2007-vendorc,
SALEYM     type ztc2sd2007-saleym,
ORDERCD    type ztc2sd2007-ordercd,
PRODCD     type ztc2sd2007-prodcd,
BOXUNIT    type ztc2sd2007-boxunit,
BOXEA      TYPE I,
ITEMPRICE  type ztc2sd2007-itemprice,
WAERS      type ztc2sd2007-waers,
ITEMWEIGHT type ztc2sd2007-itemweight,
SOITEMPRICE type ztc2sd2007-itemprice,
WEIGHTUNIT type ztc2sd2007-weightunit,
STATFLAG   type ztc2sd2007-statflag,
ITEMQTY    type ztc2sd2007-itemqty,
FIXEDQTY   type ztc2sd2007-fixedqty,
MATrNM     type ztc2md2006-matrnm,
  end of gs_Data2,
  gt_Data2 like table of gs_data2 with NON-UNIQUE KEY prodcd,
  ok_code  type sy-ucomm.

DATA: GS_DATASTATTX TYPE ztc2sd2009,
      GT_DATASTATTX LIKE TABLE OF GS_DATASTATTX.