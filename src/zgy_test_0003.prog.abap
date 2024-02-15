*&---------------------------------------------------------------------*
*& Report ZGY_TEST_0003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_test_0003.

TABLES:vbak,vbap.

"smartform
DATA:gs_header TYPE zgy_s_0029,
     gt_items  TYPE zgy_tt_0030.

"smartform verileri
DATA:gv_fm_name   TYPE rs38l_fnam,
     gs_controls  TYPE ssfctrlop,
     gs_output_op TYPE ssfcompop.

SELECT-OPTIONS:so_vbeln FOR vbak-vbeln.

START-OF-SELECTION.

  SELECT SINGLE
     vbeln,
     erdat,
     ernam,
     audat,
     auart,
     vkorg,
     vtweg
     FROM vbak
     WHERE vbeln IN @so_vbeln
     INTO @gs_header.

  IF gs_header IS NOT INITIAL.
    SELECT
    vbeln,
    posnr,
    matnr,
    netwr,
    waerk,
    werks
    FROM vbap                                       "internal table olsaydı -> for all entries in
    WHERE vbeln EQ @gs_header-vbeln
    INTO CORRESPONDING FIELDS OF TABLE @gt_items.
  ENDIF.

  gs_controls-no_dialog = abap_true.
  gs_controls-preview   = abap_true.
  gs_output_op-tddest   = 'LP01'.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZGY_SF_0007'
    IMPORTING
      fm_name            = gv_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  CALL FUNCTION gv_fm_name
    EXPORTING
      control_parameters = gs_controls
      output_options     = gs_output_op
      user_settings      = ' '
      it_items           = gt_items
      is_header          = gs_header
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
