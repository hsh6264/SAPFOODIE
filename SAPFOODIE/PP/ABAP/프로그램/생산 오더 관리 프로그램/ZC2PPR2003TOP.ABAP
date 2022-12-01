*&---------------------------------------------------------------------*
*& Include ZC2PPR2003_TOP                           - Report ZC2PPR2003
*&---------------------------------------------------------------------*
REPORT zc2ppr2003 MESSAGE-ID zc202.

TABLES : ztc2pp2006.

CLASS lcl_event_handler DEFINITION DEFERRED.

TYPE-POOLS: vrm.

DATA: name  TYPE vrm_id,
      list  TYPE vrm_values,
      value LIKE LINE OF list.

DATA : gv_save, gv_close.

DATA : gv_err(1).

"생산 오더 헤더 테이블
DATA : BEGIN OF gs_odlist.
         INCLUDE STRUCTURE ztc2pp2006.
DATA :   statext TYPE dd07v-ddtext,
         color   TYPE lvc_t_scol,
         chg(1),
       END OF gs_odlist,
       gt_odlist LIKE TABLE OF gs_odlist.

"생산 오더 아이템 테이블
DATA: BEGIN OF gs_item,
        ponum    TYPE ztc2pp2006-ponum,   " 생산오더번호
        strtdt   TYPE ztc2pp2006-strtdt,  " 생산시작일
        enddt    TYPE ztc2pp2006-enddt,   " 생산종료일
        createid TYPE ztc2pp2006-createid, " 등록자
        updateid TYPE ztc2pp2006-updateid, " 수정자
        postart  TYPE ztc2pp2006-postart, " 생산오더 시작일 (약간의 계획)
        mkits    TYPE ztc2pp2007-mkits,   " 자재코드
        matrnm   TYPE ztc2md2006-matrnm,  " 자재명
        poquan   TYPE ztc2pp2007-poquan,  " 생산오더수량
        unit     TYPE ztc2pp2007-unit,    " 단위
        wcid     TYPE ztc2md2006-wcid,    " 작업장 코드
        warehsnm TYPE ztc2md2007-warehsnm, " 창고명
        chg(1),                           " changed 데이터
        lack(1),
      END OF gs_item,
      gt_item LIKE TABLE OF gs_item.

 "생산 오더 수량에 따른 재고 확인 테이블
  DATA : BEGIN OF gs_stock_item,
           cmpnc    TYPE ztc2pp2002-cmpnc,
           mkits    TYPE ztc2pp2002-mkits,
           matrc    TYPE ztc2pp2002-matrc,
           versn    TYPE ztc2pp2002-versn,
           rqqty    TYPE ztc2pp2002-rqqty,
           stckq    TYPE ztc2mm2001-stckq,
           unit     TYPE ztc2mm2001-unit,
           matrnm   TYPE ztc2md2006-matrnm,
           color    TYPE lvc_t_scol,
           err(1),
         END OF gs_stock_item,
         gt_stock_item LIKE TABLE OF gs_stock_item.

"Header ALV
DATA: gcl_container_1 TYPE REF TO cl_gui_docking_container,
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
      gcl_handler2    TYPE REF TO lcl_event_handler,
      gs_fcat_2       TYPE lvc_s_fcat,
      gt_fcat_2       TYPE lvc_t_fcat,
      gs_layout_2     TYPE lvc_s_layo,
      gs_variant_2    TYPE disvariant,
      gs_stable_2     TYPE lvc_s_stbl.

"Item의 재고 수량 ALV
DATA: gcl_container_3 TYPE REF TO cl_gui_custom_container,
      gcl_grid_3      TYPE REF TO cl_gui_alv_grid,
      gs_fcat_3       TYPE lvc_s_fcat,
      gt_fcat_3       TYPE lvc_t_fcat,
      gs_layout_3     TYPE lvc_s_layo,
      gs_variant_3    TYPE disvariant,
      gs_stable_3     TYPE lvc_s_stbl.


DATA : gv_okcode TYPE sy-ucomm.
DATA : gv_okcode_detail TYPE sy-ucomm.

" SCREEN 0110 layout 선언 변수
DATA : gv_cmpnc  TYPE ztc2pp2006-cmpnc,
       gv_plant  TYPE ztc2pp2006-plant,
       gv_odnum  TYPE ztc2pp2006-ponum,
       gv_odstar TYPE ztc2pp2006-strtdt,
       gv_odend  TYPE ztc2pp2006-enddt,
       gv_mrg    TYPE ztc2pp2006-createid,
       gv_postat TYPE ztc2pp2006-postat.

"선택된 header 데이터 rows
DATA : gs_row  TYPE lvc_s_row,
       gt_rows TYPE lvc_t_row.

" 버튼 클릭시 상태 격납 변수
DATA : gv_stat TYPE dd07v-domvalue_l.

" edit display 모드 제어
DATA : gv_input TYPE i.

DATA : gv_overr(1).

"부족 수량 자재코드 격납.
 DATA : BEGIN OF gs_matrnm,
          matrnm   TYPE ztc2md2006-matrnm,
        END OF gs_matrnm,
        gt_matrnm LIKE TABLE OF gs_matrnm.