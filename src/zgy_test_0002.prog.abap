*&---------------------------------------------------------------------*
*& Report ZGY_TEST_0002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_test_0002.
TABLES:vbak.

DATA:gv_fm_name   TYPE rs38l_fnam,
     gs_controls  TYPE ssfctrlop,
     gs_output_op TYPE ssfcompop.

DATA:gt_table TYPE zgy_tt_0024,
     gs_table TYPE zgy_s_0024.

DATA:ls_data TYPE zgy_s_0026.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
SELECT-OPTIONS: so_vbeln FOR vbak-vbeln.
SELECTION-SCREEN END OF BLOCK a.
*    DATA:lt_index_rows TYPE lvc_t_row.
*    CALL METHOD go_alv_grid->get_selected_rows
*      IMPORTING
*        et_index_rows = lt_index_rows.   " Indexes of Selected Rows
*
*    IF lt_index_rows IS INITIAL.
*      MESSAGE i001 DISPLAY LIKE 'W'.
*    ELSE.
*      LOOP AT lt_index_rows INTO DATA(ls_index_row).
*        READ TABLE gt_alv ASSIGNING FIELD-SYMBOL(<lfs_alv>) INDEX ls_index_row-index.
*        IF sy-subrc IS INITIAL.
*          DATA(lv_vbeln) = <lfs_alv>-vbeln.
*        ENDIF.
*      ENDLOOP.
*    ENDIF.

START-OF-SELECTION.

  SELECT
  vbak~vbeln  AS siparis,
  vbap~posnr  AS kalem,
  vbap~arktx  AS urun_ack,
  vbap~matnr  AS urun_kod,
  vbap~kwmeng AS miktar,
  vbap~vrkme  AS satıs_obr,
  vbap~netwr  AS birim_fiyat,
  vbap~netwr  AS tutar,
  vbap~waerk  AS para_br
  FROM vbak
  LEFT JOIN vbap ON vbap~vbeln EQ vbak~vbeln
*    WHERE vbak~vbeln EQ @lv_vbeln
    WHERE vbak~vbeln IN @so_vbeln
  INTO CORRESPONDING FIELDS OF TABLE @gt_table.

  LOOP AT gt_table ASSIGNING FIELD-SYMBOL(<lfs_table>).
    <lfs_table>-no = sy-tabix.
  ENDLOOP.

  SELECT SINGLE vbeln, bukrs_vf, auart
  FROM vbak
*    WHERE vbeln EQ @lv_vbeln
    WHERE vbak~vbeln IN @so_vbeln
  INTO CORRESPONDING FIELDS OF @ls_data .

  IF sy-subrc IS INITIAL.

    IF ls_data-bukrs_vf EQ '1000'.
      ls_data-logo = 'ZGY_1000'.
    ELSEIF ls_data-bukrs_vf EQ 'ZV99'.
      ls_data-logo = 'ZGY_ZV99'.
    ELSE.
      ls_data-logo = 'VLOGO'.
    ENDIF.

    IF ls_data-auart EQ 'ZTAZ'.
      ls_data-baslik = 'X'.               "Proforma Fatura’
      ls_data-tarih  = 'X'.
      ls_data-no     = 'X'.
    ELSEIF ls_data-auart EQ 'ZSN1'.
      ls_data-baslik = ' '.                "Teklif Belgesi’
      ls_data-tarih  = ' '.
      ls_data-no     = ' '.
    ENDIF.

  ENDIF.

  gs_controls-no_dialog = abap_true.
  gs_controls-preview   = abap_true.
  gs_output_op-tddest   = 'LP01'.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZGY_SF_0002'
    IMPORTING
      fm_name            = gv_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

*CALL FUNCTION '/1BCDWB/SF00000304'

  CALL FUNCTION gv_fm_name
    EXPORTING
      control_parameters = gs_controls
      output_options     = gs_output_op
      user_settings      = ' '
      is_data            = ls_data
      it_table           = gt_table
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.
