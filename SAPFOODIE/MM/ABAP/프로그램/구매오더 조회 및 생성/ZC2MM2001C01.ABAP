*&---------------------------------------------------------------------*
*& Include          ZC2MMR2001_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.
    PUBLIC SECTION.
      CLASS-METHODS : hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
          e_row_id
          e_column_id.
  
      CLASS-METHODS : handle_changed_finished FOR EVENT data_changed_finished OF cl_gui_alv_grid
        IMPORTING
          e_modified
          et_good_cells.
  
      CLASS-METHODS : handle_changed_finished2 FOR EVENT data_changed_finished OF cl_gui_alv_grid
        IMPORTING
          e_modified
          et_good_cells.
  
      CLASS-METHODS : hotspot_click2 FOR EVENT hotspot_click OF cl_gui_alv_grid
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
    METHOD : hotspot_click.
  
      PERFORM : hotspot_click USING e_row_id e_column_id.
  
    ENDMETHOD.
  
    METHOD handle_changed_finished.
      PERFORM handle_changed_finished USING e_modified et_good_cells.
  
    ENDMETHOD.
  
    METHOD handle_changed_finished2.
      PERFORM handle_changed_finished2 USING e_modified et_good_cells.
  
    ENDMETHOD.
  
    METHOD hotspot_click2.
      PERFORM hotspot_click2 USING e_row_id e_column_id.
  
    ENDMETHOD.
  
  ENDCLASS.