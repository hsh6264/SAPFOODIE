*&---------------------------------------------------------------------*
*& Include ZC2R20001_AUTOCAR_TOP                    - Module Pool      ZC2R20001_AUTOCAR
*&---------------------------------------------------------------------*
PROGRAM ZC2R20001_AUTOCAR MESSAGE-ID ZC202.
CLASS lcl_event_handler DEFINITION DEFERRED.
tables: ZTC2SD2006, ZTC2SD2003, ZTC2SD2004, ZTC2MD2005, ZTC2MD2004.

data ok_code type sy-ucomm.
data: go_container1 type ref to cl_gui_custom_container,
      go_container2 type ref to cl_gui_custom_container,
      go_container3 type ref to cl_gui_custom_container,
      go_container4 type ref to cl_gui_custom_container,
      go_grid1      type ref to cl_gui_alv_grid,
      go_grid2      type ref to cl_gui_alv_grid,
      go_grid3      type ref to cl_gui_alv_grid,
      go_grid4      type ref to cl_gui_alv_grid,
      gs_fcat1      type lvc_s_fcat,
      gs_fcat2      type lvc_s_fcat,
      gs_fcat3      type lvc_s_fcat,
      gs_fcat4      type lvc_s_fcat,
      gs_layo1      type lvc_s_layo,
      gs_layo2      type lvc_s_layo,
      gs_layo3      type lvc_s_layo,
      gs_layo4      type lvc_s_layo,
      gt_fcat1      type lvc_t_fcat,
      gt_fcat2      type lvc_t_fcat,
      gt_fcat3      type lvc_t_fcat,
      gt_fcat4      type lvc_t_fcat,
      GV_FLAG,
      GV_BCNT TYPE i.

DATA: BEGIN OF GS_DATA1,
      PLOC       TYPE ZTC2MD2005-ploc,
      ORDERCD    TYPE ZTC2SD2006-ORDERCD,
      VENDORC    TYPE ZTC2SD2006-VENDORC,
      SALEYM     TYPE ZTC2SD2006-SALEYM,
      OUTSTOREDT TYPE ZTC2SD2006-OUTSTOREDT,
      ODMAXWT    TYPE ZTC2SD2006-ODMAXWT,
      WEIGHTUNIT TYPE ZTC2SD2006-WEIGHTUNIT,
      RESPRID    TYPE ZTC2SD2006-RESPRID,
      areacd     type ZTC2MD2005-areacd,
  DUEDATE    TYPE ztc2sd2006-duedate,
      END   OF GS_DATA1.

DATA: BEGIN OF GS_DATA2,
      PLANT      TYPE ZTC2SD2004-plant,
      CMPNC      TYPE ZTC2SD2004-cmpnc,
      DISPATCHCD TYPE ZTC2SD2004-dispatchcd,
      CARCODE    TYPE ZTC2SD2004-carcode,
      CARNUM     TYPE ZTC2SD2003-carnum,
      CURRMAXWT  TYPE ZTC2SD2004-currmaxwt,
      allmaxwt   type ztc2sd2003-maxwt,
      WEIGHTUNIT TYPE ZTC2SD2004-weightunit,
      AREACD     TYPE ZTC2SD2003-areacd,
      CARDRIVE   TYPE ZTC2SD2003-cardrive,
      END   OF GS_dATA2.

DATA: GT_DATA1   LIKE TABLE OF GS_dATA1,
      GT_dATA2   LIKE TABLE OF GS_dATA2,
      gs_data3   type ZTC2SD2003,
      gt_Data3   like table of gs_Data3 WITH KEY CARCODE ,
      GV_CARLEFT type i,
      GS_DATAALV1 LIKE GS_DATA1,
      GT_DATAALV1 LIKE TABLE OF GS_dATAALV1 with key ordercd,
      GT_DATALOOP1 LIKE TABLE OF GS_DATAALV1,
      GS_DATALOOP1 LIKE GS_dATAALV1,
      Gv_maxwt like gs_data3-maxwt,
      GV_AREALEFT TYPE I,
      GO_HANDLER  TYPE REF TO lcl_event_handleR.

data: BEGIN OF GS_DATA4,"배차의 이력을 저장하는 테이블
      ORDERCD    TYPE ZTC2SD2006-ORDERCD,
      DISPATCHCD TYPE ZTC2SD2004-dispatchcd,
      PLOC       TYPE ZTC2MD2005-ploc,
      VENDORC    TYPE ZTC2SD2006-VENDORC,
      SALEYM     TYPE ZTC2SD2006-SALEYM,
      OUTSTOREDT TYPE ZTC2SD2006-OUTSTOREDT,
      ODMAXWT    TYPE ZTC2SD2006-ODMAXWT,
      WEIGHTUNIT TYPE ZTC2SD2006-WEIGHTUNIT,
      RESPRID    TYPE ZTC2SD2006-RESPRID,
      areacd     type ZTC2MD2005-areacd,
      END   OF GS_DATA4,
      gt_Data4 like table of gs_Data4 with key ordercd,
      gs_data5 like gs_data4,
      gt_Data5 like table of gs_data4 with key ordercd,
      gs_row  TYPE lvc_s_row,
      gt_rows TYPE lvc_t_row,
      GV_OUPDA,
      gv_flag_110,
      GV_100FLAG,
      GV_FLAGCHECK_SCREEN.

DATA: GS_COMMITDATA1 TYPE ZTC2SD2006,
      GT_COMMITDATA1 LIKE TABLE OF GS_COMMITDATA1,
      GS_COMMITDATA2 TYPE ZTC2SD2004,
      GT_COMMITDATA2 LIKE TABLE OF GS_COMMITDATA2.



DATA: GV_EMPLYGD TYPE ZTC2MD2004-emplygd,
      gv_agian.

DATA:   GV_CBCNT TYPE C LENGTH 5,
        GV_CCCNT TYPE C LENGTH 5.