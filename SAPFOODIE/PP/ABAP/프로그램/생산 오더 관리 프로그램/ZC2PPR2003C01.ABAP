*&---------------------------------------------------------------------*
*& Include          ZC2PPR2003_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.
    PUBLIC SECTION.
      METHODS:
        handle_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
          IMPORTING
            e_column_id
            es_row_no,
  
        handle_changed_finished FOR EVENT data_changed_finished OF cl_gui_alv_grid
          IMPORTING
            e_modified
            et_good_cells,
        handle_db_click FOR EVENT double_click OF cl_gui_alv_grid
          IMPORTING
            e_row
            e_column.
  ENDCLASS.
  *&---------------------------------------------------------------------*
  *& Class (Implementation) lcl_event_handler
  *&---------------------------------------------------------------------*
  *&
  *&---------------------------------------------------------------------*
  CLASS lcl_event_handler IMPLEMENTATION.
  
    METHOD handle_hotspot_click.
      PERFORM handle_hotspot_click USING e_column_id es_row_no.
    ENDMETHOD.
  
    METHOD handle_changed_finished.
      PERFORM handle_changed_finished USING e_modified et_good_cells.
    ENDMETHOD.
    METHOD handle_db_click.
      PERFORM handle_db_click USING e_row e_column.
    ENDMETHOD.
  ENDCLASS.