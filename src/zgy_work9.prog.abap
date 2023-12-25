*&---------------------------------------------------------------------*
*& Report ZGY_WORK5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_work9.

INCLUDE:
 zgy_work9_top,
 zgy_work9_lcl,
 zgy_work9_form,
 zgy_work9_mdl.

INITIALIZATION.
  gs_variant_tmp-report  = sy-repid.

  CALL FUNCTION 'LVC_VARIANT_DEFAULT_GET'
    EXPORTING
      i_save        = 'A'
    CHANGING
      cs_variant    = gs_variant_tmp
    EXCEPTIONS
      wrong_input   = 1
      not_found     = 2
      program_error = 3
      OTHERS        = 4.
  IF sy-subrc EQ 0.
    p_vari = gs_variant_tmp-variant.
  ENDIF.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_vari.
  CALL FUNCTION 'LVC_VARIANT_F4'
    EXPORTING
      is_variant = gs_variant_tmp
*     IT_DEFAULT_FIELDCAT       =
      i_save     = 'A'
    IMPORTING
*     E_EXIT     =
      es_variant = gs_variant_tmp.
  IF sy-subrc EQ 0.
    p_vari = gs_variant_tmp-variant.
  ENDIF.


START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->call_screen( ).
