*&---------------------------------------------------------------------*
*& Include          ZC2MMR2002_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module SET_FACT_LAYOUT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_fact_layout OUTPUT.
  IF gt_fcat IS INITIAL.
     PERFORM set_fcat_layout.
  ENDIF.
ENDMODULE.

MODULE display_screen OUTPUT.
     PERFORM display_screen..
ENDMODULE.

MODULE set_fact_layout2 OUTPUT.
  IF gt_fcat2 IS INITIAL.
     PERFORM set_fcat_layout2.
  ENDIF.
ENDMODULE.

MODULE display_screen2 OUTPUT.
     PERFORM display_screen2.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
 SET PF-STATUS 'S0100'.
 SET TITLEBAR 'T0100'.
ENDMODULE.

MODULE status_0101 OUTPUT.
 SET PF-STATUS 'S0101'.
 SET TITLEBAR 'T0101'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_FCAT_LAYOUT_HD OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_fcat_layout_hd OUTPUT.
  IF gt_fcat_hd IS INITIAL.
     PERFORM set_fcat_layout_hd.
  ENDIF.
ENDMODULE.
MODULE display_screen_hd OUTPUT.
     PERFORM display_screen_hd.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_FCAT_LAYOUT_PL OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module SET_FCAT_LAYOUT_ED OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_fcat_layout_ed OUTPUT.
  IF gt_fcat_ed IS INITIAL.
     PERFORM set_fcat_layout_ed.
  ENDIF.
ENDMODULE.