*&---------------------------------------------------------------------*
*& Report ZGY_AF_DRIVER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_af_driver.

DATA:gs_outputparams TYPE  sfpoutputparams,
     gv_name         TYPE  fpname,
     gv_funcname     TYPE  funcname,
     gs_docparams    TYPE  sfpdocparams,
     gv_barcode      TYPE  char200,
     gs_formoutput   TYPE  fpformoutput.

START-OF-SELECTION.

  gv_name = 'ZGY_EGT_FORM'.
  gv_barcode = '123456789'.

  gs_outputparams-nodialog = abap_true.
  gs_outputparams-preview  = abap_true.
  gs_outputparams-dest     = 'LP01'.

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = gs_outputparams
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = gv_name
    IMPORTING
      e_funcname = gv_funcname.

*  '/1BCDWB/SM00000448'

  CALL FUNCTION gv_funcname
    EXPORTING
      /1bcdwb/docparams  = gs_docparams
      iv_barcode         = gv_barcode
*     IV_HEADER_T1       =
    IMPORTING
      /1bcdwb/formoutput = gs_formoutput
    EXCEPTIONS
      usage_error        = 1
      system_error       = 2
      internal_error     = 3
      OTHERS             = 4.

  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.
