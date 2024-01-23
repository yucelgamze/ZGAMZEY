*&---------------------------------------------------------------------*
*& Include          ZGY_P_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      bapi,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fcat,
      set_layout,
      display_alv.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.

    SELECT *  FROM mara
      WHERE matnr IN @so_matnr
    INTO CORRESPONDING FIELDS OF TABLE @gt_alv.

  ENDMETHOD.
  METHOD bapi.

    DATA:lt_items TYPE TABLE OF bapiebanc,
         ls_items LIKE LINE OF lt_items,
         lv_werks TYPE bapiebanc-plant.

    DATA:ls_selopt TYPE selopt.

    LOOP AT so_werks INTO ls_selopt.
      lv_werks = ls_selopt-low.
    ENDLOOP.

*    DATA(lv_werks) = VALUE rsdsselopt_t( FOR ls_selopt IN so_werks
*    ( sign = if_fsbp_const_range=>sign_include
*      option = if_fsbp_const_range=>option_equal
*      low = ls_selopt-low ) ).

    CALL FUNCTION 'BAPI_REQUISITION_CREATE'
      EXPORTING
        automatic_source  = 'X'
      TABLES
        requisition_items = lt_items.

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
    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 1
                        ref_table  = 'MARA'
                        ref_field  = 'MATNR'
                        fieldname  = 'MATNR'
                        scrtext_s  = 'Malzeme'
                        scrtext_m  = 'Malzeme'
                        scrtext_l  = 'Malzeme').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 2
                        ref_table  = 'MAKT'
                        ref_field  = 'MAKTX'
                        fieldname  = 'MAKTX'
                        scrtext_s  = 'Malz.Tanım'
                        scrtext_m  = 'Malzeme Tanım'
                        scrtext_l  = 'Malzeme Tanımı').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 3
                        ref_table  = 'MARA'
                        ref_field  = 'MATKL'
                        fieldname  = 'MATKL'
                        scrtext_s  = 'Mal Grubu'
                        scrtext_m  = 'Mal Grubu'
                        scrtext_l  = 'Mal Grubu').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 4
                        ref_table  = 'T023'
                        ref_field  = 'WGBEZ60'
                        fieldname  = 'WGBEZ60'
                        scrtext_s  = 'Mal Gr. T'
                        scrtext_m  = 'Mal Gr. Tanım'
                        scrtext_l  = 'Mal Grubu Tanımı').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 5
                        ref_table  = 'MARA'
                        ref_field  = 'MTART'
                        fieldname  = 'MTART'
                        scrtext_s  = 'Malz. Tür'
                        scrtext_m  = 'Malzeme Türü'
                        scrtext_l  = 'Malzeme Türü').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 6
                        ref_table  = 'MARC'
                        ref_field  = 'MABST'
                        fieldname  = 'STOK'
                        scrtext_s  = 'Stok Mik.'
                        scrtext_m  = 'Stok Miktar'
                        scrtext_l  = 'Stok Miktar').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 7
                        ref_table  = 'MARA'
                        ref_field  = 'MEINS'
                        fieldname  = 'MEINS'
                        scrtext_s  = 'Ölçü Birim'
                        scrtext_m  = 'Ölçü Birimi'
                        scrtext_l  = 'Ölçü Birimi').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 8
                        ref_table  = 'MARC'
                        ref_field  = 'MABST'
                        fieldname  = 'MINSTOK'
                        scrtext_s  = 'Min. Stok'
                        scrtext_m  = 'Min. Stok'
                        scrtext_l  = 'Min. Stok Seviyesi').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 9
                        ref_table  = 'MARA'
                        ref_field  = 'MEINS'
                        fieldname  = 'MEINS2'
                        scrtext_s  = 'Ölçü Birim'
                        scrtext_m  = 'Ölçü Birimi'
                        scrtext_l  = 'Ölçü Birimi').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 10
                        ref_table  = 'MARC'
                        ref_field  = 'MABST'
                        fieldname  = 'AZSTOK'
                        scrtext_s  = 'Azami Stok'
                        scrtext_m  = 'Azami Stok'
                        scrtext_l  = 'Azami Stok Seviyesi').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 11
                        ref_table  = 'MARA'
                        ref_field  = 'MEINS'
                        fieldname  = 'MEINS3'
                        scrtext_s  = 'Ölçü Birim'
                        scrtext_m  = 'Ölçü Birimi'
                        scrtext_l  = 'Ölçü Birimi').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 12
                        ref_table  = 'MARC'
                        ref_field  = 'MABST'
                        fieldname  = 'ASAT'
                        scrtext_s  = 'Açık SAT'
                        scrtext_m  = 'Açık SAT'
                        scrtext_l  = 'Açık SAT Miktarı').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 13
                        ref_table  = 'MARA'
                        ref_field  = 'MEINS'
                        fieldname  = 'MEINS4'
                        scrtext_s  = 'Ölçü Birim'
                        scrtext_m  = 'Ölçü Birimi'
                        scrtext_l  = 'Ölçü Birimi').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 14
                        ref_table  = 'MARC'
                        ref_field  = 'MABST'
                        fieldname  = 'ASASA'
                        scrtext_s  = 'Açık SAS'
                        scrtext_m  = 'Açık SAS'
                        scrtext_l  = 'Açık SAT Miktarı').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 15
                        ref_table  = 'MARA'
                        ref_field  = 'MEINS'
                        fieldname  = 'MEINS5'
                        scrtext_s  = 'Ölçü Birim'
                        scrtext_m  = 'Ölçü Birimi'
                        scrtext_l  = 'Ölçü Birimi').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 16       "EDITABLE OLACAK!
                        ref_table  = 'MARC'
                        ref_field  = 'MABST'
                        fieldname  = 'TALEP'
                        scrtext_s  = 'Talep Mik.'
                        scrtext_m  = 'Talep Miktarı'
                        scrtext_l  = 'Talep Miktarı').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 17
                        ref_table  = 'MARA'
                        ref_field  = 'MEINS'
                        fieldname  = 'MEINS6'
                        scrtext_s  = 'Ölçü Birim'
                        scrtext_m  = 'Ölçü Birimi'
                        scrtext_l  = 'Ölçü Birimi').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 18
                        checkbox   = abap_true
                        fieldname  = 'SATOL'
                        scrtext_s  = 'SAT Ol.'
                        scrtext_m  = 'SAT Oluştur'
                        scrtext_l  = 'SAT Oluştur').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 19
                        ref_table  = 'EBAN'
                        ref_field  = 'BANFN'
                        fieldname  = 'SATNO'
                        scrtext_s  = 'SAT No'
                        scrtext_m  = 'SAT No'
                        scrtext_l  = 'SAT No').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 20
                        ref_table  = 'EBAN'
                        ref_field  = 'BNFPO'
                        fieldname  = 'SATKALEM'
                        scrtext_s  = 'SAT Kalem'
                        scrtext_m  = 'SAT Kalemi'
                        scrtext_l  = 'SAT Kalemi').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 21
                        fieldname  = 'BANFN'
                        scrtext_s  = 'Durum'
                        scrtext_m  = 'Durum'
                        scrtext_l  = 'Durum').
    APPEND gs_fcat TO gt_fcat.
*    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
*      EXPORTING
*        i_structure_name = ''
*      CHANGING
*        ct_fieldcat      = gt_fcat.
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
          i_parent = go_container.  " Parent Container
      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_alv   " Output Table
          it_fieldcatalog = gt_fcat.   " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
