*&---------------------------------------------------------------------*
*& Include          ZC2R20001_JUNGCHUC01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class LCL_EVENT_HANDLER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.
    PUBLIC SECTION.
    methods: handle_double_click
    for event double_click of cl_Gui_alv_grid
    IMPORTING
      e_row
      e_column
      .
  ENDCLASS.
  *&---------------------------------------------------------------------*
  *& Class (Implementation) LCL_EVENT_HANDLER
  *&---------------------------------------------------------------------*
  *&
  *&---------------------------------------------------------------------*
  CLASS lcl_event_handler IMPLEMENTATION.
    method: handle_double_click.
      perform handle_double_click using e_row e_column.
    ENDMETHOD.
  ENDCLASS.