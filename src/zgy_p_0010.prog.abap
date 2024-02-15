*&---------------------------------------------------------------------*
*& Report ZGY_P_0010
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_p_0010.

DATA:gv_fm_name TYPE rs38l_fnam,
     gs_control TYPE ssfctrlop,
     gs_output  TYPE ssfcompop.

START-OF-SELECTION.

  gs_control-no_dialog = abap_true.
  gs_control-preview   = abap_true.
  gs_output-tddest     = 'LP01'.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZGY_SF_0004'
    IMPORTING
      fm_name            = gv_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.


*CALL FUNCTION '/1BCDWB/SF00000308'
  CALL FUNCTION gv_fm_name
    EXPORTING
      control_parameters = gs_control
      output_options     = gs_output
      user_settings      = ' '
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
