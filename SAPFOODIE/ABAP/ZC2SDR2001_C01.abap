*&---------------------------------------------------------------------*
*& Include          ZC2SDR2001_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.

    PUBLIC SECTION.
  
       METHODS:
        hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid " 두번째 ALV에서 판매계획번호 핫스팟 클릭 시
        IMPORTING                                                " 상세 제품 데이터 나오기
          e_row_id
          e_column_id.
  
  
  
  ENDCLASS.
  *&---------------------------------------------------------------------*
  *& Class (Implementation) lcl_event_handler
  *&---------------------------------------------------------------------*
  *&
  *&---------------------------------------------------------------------*
  CLASS lcl_event_handler IMPLEMENTATION.
  
    METHOD hotspot_click.
  
      PERFORM hotspot_click USING e_row_id e_column_id.
  
    ENDMETHOD.
  
  
  
  
  ENDCLASS.