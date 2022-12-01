*&---------------------------------------------------------------------*
*& Include          SAPMZC2MM2001_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.
    PUBLIC SECTION.
      METHODS:
        handle_hotspot FOR EVENT hotspot_click OF cl_gui_alv_grid
          IMPORTING
            e_row_id
            e_column_id.
  
      METHODS: handle_changed_finished FOR EVENT data_changed_finished OF cl_gui_alv_grid
        IMPORTING
          e_modified
          et_good_cells.
  
  ENDCLASS.
  *&---------------------------------------------------------------------*
  *& Class (Implementation) lcl_event_handler
  *&---------------------------------------------------------------------*
  *&
  *&---------------------------------------------------------------------*
  CLASS lcl_event_handler IMPLEMENTATION.
  
    METHOD handle_hotspot.
      PERFORM handle_hotspot USING e_row_id e_column_id.
    ENDMETHOD.
  
    METHOD handle_changed_finished.
      PERFORM handle_changed_finished USING e_modified et_good_cells.
  
    ENDMETHOD.
  
  ENDCLASS.