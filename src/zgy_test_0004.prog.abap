*&---------------------------------------------------------------------*
*& Report ZGY_TEST_0004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_test_0004.
*TABLES:scarr.
*
*DATA:gv_fmname TYPE  rs38l_fnam.
*
*DATA:gs_control TYPE  ssfctrlop,
*     gs_output  TYPE  ssfcompop.
*
*DATA:gt_table TYPE zgy_tt_0004.
*
*SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
*SELECT-OPTIONS:so_pb FOR scarr-currcode.
*SELECTION-SCREEN END OF BLOCK a.
*SELECTION-SCREEN BEGIN OF BLOCK b WITH FRAME TITLE TEXT-001.
*PARAMETERS:p_cond    TYPE char1,
*           p_barc TYPE char200.
*SELECTION-SCREEN END OF BLOCK b.
*
*START-OF-SELECTION.
*
*  gs_control-no_dialog = abap_true.
*  gs_control-preview   = abap_true.
*  gs_output-tddest     = 'LP01'.
*
*  SELECT * FROM scarr
*  WHERE currcode IN @so_pb
*  INTO TABLE @gt_table.
*
*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      formname           = 'ZGY_SF_TEST'
*    IMPORTING
*      fm_name            = gv_fmname
*    EXCEPTIONS
*      no_form            = 1
*      no_function_module = 2
*      OTHERS             = 3.
*
*  CALL FUNCTION gv_fmname
*    EXPORTING
*      control_parameters = gs_control
*      output_options     = gs_output
*      user_settings      = ' '
*      it_table           = gt_table
*      iv_cond            = p_cond
*      iv_barcode         = p_barc
*    EXCEPTIONS
*      formatting_error   = 1
*      internal_error     = 2
*      send_error         = 3
*      user_canceled      = 4
*      OTHERS             = 5.


PARAMETERS:p_aufnr TYPE aufnr.

TYPES:BEGIN OF gty_table,
        maktx TYPE maktx,
        bdmng TYPE bdmng,
        meins TYPE meins,
      END OF gty_table.

TYPES:BEGIN OF gty_main,
        aufnr TYPE aufnr,
        ltxa1 TYPE ltxa1,
        table TYPE TABLE OF gty_table WITH DEFAULT KEY,
      END OF gty_main.

DATA:gt_table TYPE TABLE OF gty_main,
     gs_table TYPE gty_main.

TYPES:BEGIN OF gty_data,
        aufnr TYPE aufnr,
        maktx TYPE maktx,
        erdat TYPE erdat,
      END OF gty_data.

DATA:gs_data TYPE gty_data,
     gt_data TYPE TABLE OF gty_data.

START-OF-SELECTION.

  SELECT
  caufv~aufnr,
  caufv~plnbez,
  mara~satnr,
  makt~maktx,
  caufv~erdat
  FROM caufv
  LEFT JOIN mara ON caufv~plnbez EQ mara~matnr
  LEFT JOIN makt ON mara~matnr   EQ makt~matnr
  WHERE aufnr = @p_aufnr
  INTO TABLE @DATA(lt_data).

  LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<lfs_data>).
    <lfs_data>-maktx = | { <lfs_data>-satnr }-{ <lfs_data>-maktx } |.
    gs_data = CORRESPONDING #( <lfs_data> ).
  ENDLOOP.

  gt_data = CORRESPONDING #( lt_data ).

  IF sy-subrc IS INITIAL.

    SELECT
    caufv~aufnr,
    afvc~ltxa1,
    resb~matnr,
    makt~maktx,
    resb~bdmng,
    resb~meins
    FROM caufv
    LEFT JOIN afvc ON caufv~werks  EQ afvc~werks  AND caufv~aufpl EQ afvc~aufpl
    LEFT JOIN resb ON caufv~werks  EQ resb~werks  AND caufv~aufpl EQ resb~aufpl AND resb~xloek = @space
    LEFT JOIN makt ON resb~matnr   EQ makt~matnr
    INTO TABLE @DATA(lt_table)
    FOR ALL ENTRIES IN @lt_data
    WHERE caufv~aufnr = @lt_data-aufnr.

    LOOP AT lt_table ASSIGNING FIELD-SYMBOL(<lfs_table>).
      gs_table = CORRESPONDING #( <lfs_table> ).
      gs_table-table = CORRESPONDING #( lt_table ).
      APPEND gs_table TO gt_table.
    ENDLOOP.

  ENDIF.
