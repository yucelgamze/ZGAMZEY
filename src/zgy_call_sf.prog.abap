*&---------------------------------------------------------------------*
*& Report ZGY_CALL_SF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_call_sf.

DATA:gv_fm_name   TYPE rs38l_fnam,
     gs_controls  TYPE ssfctrlop,
     gs_output_op TYPE ssfcompop.

START-OF-SELECTION.

  gs_controls-no_dialog = abap_true.
  gs_controls-preview   = abap_true.
  gs_output_op-tddest   = 'LP01'.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname = 'ZGY_SMARTFORMS'
*     VARIANT  = ' '
*     DIRECT_CALL              = ' '
    IMPORTING
      fm_name  = gv_fm_name
* EXCEPTIONS
*     NO_FORM  = 1
*     NO_FUNCTION_MODULE       = 2
*     OTHERS   = 3
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

*CALL FUNCTION '/1BCDWB/SF00000268'

  CALL FUNCTION gv_fm_name
    EXPORTING
*     ARCHIVE_INDEX      =
*     ARCHIVE_INDEX_TAB  =
*     ARCHIVE_PARAMETERS =
      control_parameters = gs_controls
*     MAIL_APPL_OBJ      =
*     MAIL_RECIPIENT     =
*     MAIL_SENDER        =
      output_options     = gs_output_op
      user_settings      = ' '
* IMPORTING
*     DOCUMENT_OUTPUT_INFO       =
*     JOB_OUTPUT_INFO    =
*     JOB_OUTPUT_OPTIONS =
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
