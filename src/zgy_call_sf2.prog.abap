*&---------------------------------------------------------------------*
*& Report ZGY_CALL_SF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_call_sf2.

TABLES:scarr.

DATA:gv_fm_name   TYPE rs38l_fnam,
     gs_controls  TYPE ssfctrlop,
     gs_output_op TYPE ssfcompop.

DATA: gt_scarr TYPE TABLE OF scarr.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
SELECT-OPTIONS: so_pb FOR scarr-currcode.
SELECTION-SCREEN END OF BLOCK a.

SELECTION-SCREEN BEGIN OF BLOCK b WITH FRAME TITLE TEXT-001.
PARAMETERS: p_active TYPE char1.
SELECTION-SCREEN END OF BLOCK b.

START-OF-SELECTION.

  SELECT *
    FROM scarr
    WHERE currcode IN @so_pb
    INTO TABLE @gt_scarr.

  gs_controls-no_dialog = abap_true.
  gs_controls-preview   = abap_true.
  gs_output_op-tddest   = 'LP01'.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname = 'ZGY_SF2'
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


  CALL FUNCTION gv_fm_name
    EXPORTING
      control_parameters = gs_controls
      output_options     = gs_output_op
      user_settings      = ' '
      it_scarr           = gt_scarr
      iv_active          = p_active
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
