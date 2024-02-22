*&---------------------------------------------------------------------*
*& Report ZGY_SF_XXX
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_sf_xxx.

DATA:gv_fmname  TYPE rs38l_fnam,
     gs_control TYPE ssfctrlop,
     gs_output  TYPE ssfcompop.

DATA:gt_table TYPE zgy_tt_0005.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
PARAMETERS:p_cond TYPE char1,
           p_bar  TYPE char200.
SELECTION-SCREEN END OF BLOCK a.

START-OF-SELECTION.

  gs_control-no_dialog  = abap_true.
  gs_control-preview    = abap_true.
  gs_output-tddest      = 'LP01'.

  SELECT * FROM scarr
  INTO TABLE @gt_table.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZGY_SF_0010'
    IMPORTING
      fm_name            = gv_fmname
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.


  CALL FUNCTION '/1BCDWB/SF00000324'
    EXPORTING
      control_parameters = gs_control
      output_options     = gs_output
      user_settings      = ' '
      it_table           = gt_table
      iv_condition       = p_cond
      iv_barcode         = p_bar
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.





*
**  CALL FUNCTION '/1BCDWB/SF00000314'
*  CALL FUNCTION gv_fmname
*    EXPORTING
*      control_parameters = gs_control
*      output_options     = gs_output
*      user_settings      = ' '
*    EXCEPTIONS
*      formatting_error   = 1
*      internal_error     = 2
*      send_error         = 3
*      user_canceled      = 4
*      OTHERS             = 5.
