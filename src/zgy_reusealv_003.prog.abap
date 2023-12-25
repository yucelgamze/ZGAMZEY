*&---------------------------------------------------------------------*
*& Report ZGY_REUSEALV_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_reusealv_003.

INCLUDE zgy_reusealv_003_top.
*INCLUDE zgy_reusealv_002_top.
INCLUDE zgy_reusealv_003_frm.
*INCLUDE zgy_reusealv_002_frm.

INITIALIZATION.

  gs_variant_get-report = sy-repid.
  CALL FUNCTION 'REUSE_ALV_VARIANT_DEFAULT_GET'
* EXPORTING
*   I_SAVE              = ' '
    CHANGING
      cs_variant    = gs_variant_get
    EXCEPTIONS
      wrong_input   = 1
      not_found     = 2
      program_error = 3
      OTHERS        = 4.
  IF sy-subrc EQ 0.
    p_varian = gs_variant_get-variant.
  ENDIF.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_varian.

  gs_variant_get-report = sy-repid.
  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant    = gs_variant_get
*     I_TABNAME_HEADER          =
*     I_TABNAME_ITEM            =
*     IT_DEFAULT_FIELDCAT       =
*     I_SAVE        = ' '
*     I_DISPLAY_VIA_GRID        = ' '
    IMPORTING
      e_exit        = gv_exit
      es_variant    = gs_variant_get
    EXCEPTIONS
      not_found     = 1
      program_error = 2
      OTHERS        = 3.
  IF sy-subrc EQ 0.
    IF gv_exit IS INITIAL.
      p_varian = gs_variant_get-variant.
    ENDIF.
  ENDIF.


START-OF-SELECTION.

  PERFORM get_data.
  PERFORM set_fcat.
  PERFORM set_layout.
  PERFORM display_alv.
