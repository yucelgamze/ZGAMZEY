*&---------------------------------------------------------------------*
*& Include          ZPP_002_ISEMRI_CLS
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      print_adobe,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fcat,
      set_layout,
      display_alv.
ENDCLASS.

CLASS lcl_class IMPLEMENTATION.

  METHOD get_data.
  ENDMETHOD.

  METHOD print_adobe.

    CLEAR:gs_data,fm_name.

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
      APPEND gs_data TO gt_data.
    ENDLOOP.

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

      LOOP AT lt_table ASSIGNING FIELD-SYMBOL(<lfs_table>) GROUP BY ( aufnr = <lfs_table>-aufnr
                                                                     ltxa1 = <lfs_table>-ltxa1 )
       ASCENDING ASSIGNING FIELD-SYMBOL(<lfs_head>).

        gs_table = CORRESPONDING #( <lfs_head> ).
        LOOP AT GROUP <lfs_head> ASSIGNING FIELD-SYMBOL(<lfs_body>) WHERE ltxa1 = <lfs_head>-ltxa1.

          gs_table-table = VALUE #( ( maktx       = <lfs_body>-maktx
*                                    DESCRIPTION = <lfs_body>-
*                                    COLOR        = <lfs_body>-
                                    bdmng       = <lfs_body>-bdmng
                                    meins       = <lfs_body>-meins ) ).
        ENDLOOP.
        APPEND gs_table TO gt_table.
      ENDLOOP.


    ENDIF.

    IF sy-subrc IS INITIAL.

      fp_outputparams-device   = 'PRINTER'.
      fp_outputparams-nodialog = abap_true.
      fp_outputparams-preview  = abap_true.
      fp_outputparams-dest     = 'LP01'.

      CALL FUNCTION 'FP_JOB_OPEN'
        CHANGING
          ie_outputparams = fp_outputparams
        EXCEPTIONS
          cancel          = 1
          usage_error     = 2
          system_error    = 3
          internal_error  = 4
          OTHERS          = 5.

      CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
        EXPORTING
          i_name     = 'ZPP_002_AF_ISEMRI2'
        IMPORTING
          e_funcname = fm_name.

*      CALL FUNCTION '/1BCDWB/SM00000007'
      CALL FUNCTION fm_name
        EXPORTING
          /1bcdwb/docparams = fp_docparams
          is_data           = gs_data
          it_table          = gt_table
*         it_data           = gt_data
* IMPORTING
*         /1BCDWB/FORMOUTPUT       =
        EXCEPTIONS
          usage_error       = 1
          system_error      = 2
          internal_error    = 3
          OTHERS            = 4.

      CALL FUNCTION 'FP_JOB_CLOSE'
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.

    ENDIF.
  ENDMETHOD.

  METHOD call_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS '0100'.
    SET TITLEBAR '0100'.
  ENDMETHOD.

  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
*    WHEN '&ADOBEFORM'.
*      go_local->print_adobe( ).
    ENDCASE.
  ENDMETHOD.

  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZPP_002_TT_ISEMRI'
      CHANGING
        ct_fieldcat      = gt_fcat.
  ENDMETHOD.

  METHOD set_layout.
    gs_layout = VALUE #( zebra      = abap_true
                         cwidth_opt = abap_true
                         col_opt    = abap_true
                         sel_mode   = 'A').
  ENDMETHOD.

  METHOD display_alv.
    IF go_alv_grid IS INITIAL.

      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.
      CREATE OBJECT go_alv_grid
        EXPORTING
          i_parent = go_container.  " Parent Container
*          i_parent = cl_gui_container=>screen0.  " Parent Container
      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_table   " Output Table
          it_fieldcatalog = gt_fcat.   " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
