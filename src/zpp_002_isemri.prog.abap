*&---------------------------------------------------------------------*
*& Report ZGY_ALV_TEMPLATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpp_002_isemri.
INCLUDE:zpp_002_isemri_top,
        zpp_002_isemri_cls,
        zpp_002_isemri_mdl.

START-OF-SELECTION.

  go_local = NEW lcl_class( ).

  go_local->print_adobe( ).
*  go_local->call_screen( ).
