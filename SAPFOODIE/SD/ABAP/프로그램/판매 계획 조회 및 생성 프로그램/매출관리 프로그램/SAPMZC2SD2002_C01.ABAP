*&---------------------------------------------------------------------*
*& Include          SAPMZC2SD2002_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.
    PUBLIC SECTION.
    METHODS:
      hotspot_click for EVENT hotspot_click of cl_gui_alv_grid
        IMPORTING
          e_row_id
          e_column_id,
      hotspot_click_2 for EVENT hotspot_click of cl_gui_alv_grid
        IMPORTING
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
  
     METHOD hotspot_click_2.
      PERFORM hotspot_click_2 USING e_row_id e_column_id.
    ENDMETHOD.
  
  ENDCLASS.