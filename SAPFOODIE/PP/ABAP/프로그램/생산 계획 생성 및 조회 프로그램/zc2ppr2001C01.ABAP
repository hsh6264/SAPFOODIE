*&---------------------------------------------------------------------*
*& Include          ZC2PPR2001_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.
    PUBLIC SECTION.
   METHODS:
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
  
     METHOD handle_db_click.
      PERFORM handle_db_click USING e_row e_column.
    ENDMETHOD.
  
  
  ENDCLASS.