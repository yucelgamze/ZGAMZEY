*&---------------------------------------------------------------------*
*& Report ZGY_TEST_0004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_test_0004.
TABLES:scarr.

DATA:gv_fmname TYPE  rs38l_fnam.

DATA:gs_control TYPE  ssfctrlop,
     gs_output  TYPE  ssfcompop.

DATA:gt_table TYPE zgy_tt_0004.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
SELECT-OPTIONS:so_pb FOR scarr-currcode.
SELECTION-SCREEN END OF BLOCK a.
SELECTION-SCREEN BEGIN OF BLOCK b WITH FRAME TITLE TEXT-001.
PARAMETERS:p_cond    TYPE char1,
           p_barc TYPE char200.
SELECTION-SCREEN END OF BLOCK b.

START-OF-SELECTION.

  gs_control-no_dialog = abap_true.
  gs_control-preview   = abap_true.
  gs_output-tddest     = 'LP01'.

  SELECT * FROM scarr
  WHERE currcode IN @so_pb
  INTO TABLE @gt_table.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZGY_SF_TEST'
    IMPORTING
      fm_name            = gv_fmname
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  CALL FUNCTION gv_fmname
    EXPORTING
      control_parameters = gs_control
      output_options     = gs_output
      user_settings      = ' '
      it_table           = gt_table
      iv_cond            = p_cond
      iv_barcode         = p_barc
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
