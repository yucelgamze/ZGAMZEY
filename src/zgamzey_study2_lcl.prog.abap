*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_STUDY2_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fcat,
      set_layout,
      display_alv.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.
    DATA:ls_alv TYPE gty_alv.

    SELECT
      bkpf~bukrs,
      bkpf~belnr,
      bkpf~gjahr,
      bseg~koart,
      bseg~kunnr,
      bseg~lifnr,
      kna1~name1,
      kna1~name2,
      lfa1~name1 AS lname1,
      lfa1~name2 AS lname2,
      bseg~pswsl,
      bseg~wrbtr,
      bseg~shkzg,
      bseg~h_bldat
      FROM bkpf
      LEFT JOIN bseg
      ON bkpf~bukrs EQ bseg~bukrs AND
         bkpf~belnr EQ bseg~belnr AND
         bkpf~gjahr EQ bseg~gjahr
      LEFT JOIN kna1
      ON bseg~kunnr EQ kna1~kunnr
       LEFT JOIN lfa1
      ON bseg~lifnr EQ lfa1~lifnr
      WHERE bkpf~bukrs EQ @p_burks AND
            bkpf~belnr IN @so_belnr AND
            bseg~pswsl IN @so_pswsl AND
           ( bseg~koart EQ 'D' OR bseg~koart EQ 'K' )
      INTO TABLE @DATA(gt_list).

    LOOP AT gt_list ASSIGNING FIELD-SYMBOL(<gfs_list>).

      gs_alv-bukrs   = <gfs_list>-bukrs.
      gs_alv-belnr   = <gfs_list>-belnr.
      gs_alv-gjahr   = <gfs_list>-gjahr.
      gs_alv-pswsl   = <gfs_list>-pswsl.
      gs_alv-h_bldat = <gfs_list>-h_bldat.

      IF <gfs_list>-koart EQ 'D'.
        gs_alv-kunnr = <gfs_list>-kunnr.
        gs_alv-name1 = <gfs_list>-name1 && | | && <gfs_list>-name2.
      ELSEIF <gfs_list>-koart EQ 'K'.
        gs_alv-kunnr = <gfs_list>-lifnr.
        gs_alv-name1 = <gfs_list>-lname1 && | | && <gfs_list>-lname2.
      ENDIF.

      IF <gfs_list>-shkzg EQ 'S'.
        gs_alv-wrbtr   =  - <gfs_list>-wrbtr.
      ELSEIF <gfs_list>-shkzg EQ 'H'.
        gs_alv-wrbtr   = <gfs_list>-wrbtr.
      ENDIF.

      APPEND gs_alv TO gt_alv.

    ENDLOOP.

*    LOOP AT gt_list INTO DATA(ls_list).
*      gs_alv-bukrs   = ls_list-bukrs.
*      gs_alv-belnr   = ls_list-belnr.
*      gs_alv-gjahr   = ls_list-gjahr.
*
*      IF ls_list-koart EQ 'D'.
*        gs_alv-kunnr = ls_list-kunnr.
*        gs_alv-name1 = ls_list-name1 && | | && ls_list-name2.
*      ELSEIF ls_list-koart EQ 'K'.
*        gs_alv-kunnr = ls_list-lifnr.
*        gs_alv-name1 = ls_list-lname1 && | | && ls_list-lname2.
*      ENDIF.
*
*      gs_alv-pswsl   = ls_list-pswsl.
*
*      IF ls_list-shkzg EQ 'S'.
*        gs_alv-wrbtr   =  - ls_list-wrbtr.
*      ELSEIF ls_list-shkzg EQ 'H'.
*        gs_alv-wrbtr   = ls_list-wrbtr.
*      ENDIF.
*
*      gs_alv-h_bldat = ls_list-h_bldat.
*
*      APPEND gs_alv TO gt_alv.
*    ENDLOOP.

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
    ENDCASE.
  ENDMETHOD.

  METHOD set_fcat.

    CLEAR:gs_fcat.
    gs_fcat-ref_table = 'BKPF'.
    gs_fcat-ref_field = 'BUKRS'.
    gs_fcat-fieldname = 'BUKRS'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-ref_table = 'BKPF'.
    gs_fcat-ref_field = 'BELNR'.
    gs_fcat-fieldname = 'BELNR'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-ref_table = 'BKPF'.
    gs_fcat-ref_field = 'GJAHR'.
    gs_fcat-fieldname = 'GJAHR'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-datatype  = 'CHAR10'.
    gs_fcat-fieldname = 'KUNNR'.
    gs_fcat-scrtext_l = 'KUNNR/LIFNR'.
    gs_fcat-scrtext_m = 'KUNNR/LIFNR'.
    gs_fcat-scrtext_s = 'KUNNR/LIFNR'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-datatype  = 'CHAR70'.
    gs_fcat-fieldname = 'NAME1'.
    gs_fcat-scrtext_l = 'NAME1'.
    gs_fcat-scrtext_m = 'NAME1'.
    gs_fcat-scrtext_s = 'NAME1'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-ref_table = 'BSEG'.
    gs_fcat-ref_field = 'PSWSL'.
    gs_fcat-fieldname = 'PSWSL'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-ref_table = 'BSEG'.
    gs_fcat-ref_field = 'WRBTR'.
    gs_fcat-fieldname = 'WRBTR'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-ref_table = 'BSEG'.
    gs_fcat-ref_field = 'H_BLDAT'.
    gs_fcat-fieldname = 'H_BLDAT'.
    APPEND gs_fcat TO gt_fcat.

  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt = abap_true.
  ENDMETHOD.

  METHOD display_alv.
    IF go_alv_grid IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.   " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid
        EXPORTING
*         i_parent = cl_gui_container=>screen0.
          i_parent = go_container.   " Parent Container
      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_alv " Output Table
          it_fieldcatalog = gt_fcat.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
