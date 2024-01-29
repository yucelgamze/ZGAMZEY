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

    SELECT DISTINCT
     mara~matnr,
     makt~maktx,
     mara~matkl,
     t023t~wgbez60,
     mara~mtart,
     mard~labst AS stok,
     mara~meins,
     marc~mabst AS minstok,
     mara~meins AS meins2,
     marc~eisbe AS azstok,
     mara~meins AS meins3,
     eban~menge AS asat,
     mara~meins AS meins4,
     ( eket~menge ) - ( eket~wemng ) AS asas,
     mara~meins AS meins5,
     marc~mabst AS talep,
     mara~meins AS meins6,
     eban~banfn AS satno,
     eban~bnfpo AS satkalem,
     '@0A@'     AS durum
     FROM mara
     LEFT JOIN t023t ON mara~matkl EQ t023t~matkl
     LEFT JOIN makt  ON mara~matnr EQ makt~matnr
     LEFT JOIN marc  ON mara~matnr EQ marc~matnr
     LEFT JOIN eban  ON mara~matnr EQ eban~matnr
     LEFT JOIN mard  ON mara~matnr EQ mard~matnr
     LEFT JOIN ekpo  ON mara~matnr EQ ekpo~matnr
     LEFT JOIN eket  ON ekpo~ebeln EQ eket~ebeln AND ekpo~ebelp EQ eket~ebelp
     WHERE mara~matnr IN @so_matnr AND
           mara~matkl IN @so_matkl AND
           mara~mtart IN @so_mtart AND
           mard~werks IN @so_werks AND marc~werks IN @so_werks

      AND mard~lgort EQ '1001'          AND mard~lvorm EQ @space
      "AND marc~eisbe GT 0
      AND marc~lvorm EQ @space
      AND marc~mmsta EQ @( VALUE #( ) ) AND marc~beskz EQ 'F'
      AND eban~loekz EQ @space          AND eban~statu <> 'E'
      AND eban~ebeln EQ @space          AND eban~ebelp EQ @space
      AND ekpo~loekz EQ @space          AND ekpo~elikz EQ @space

     AND makt~spras EQ 'T'
     INTO CORRESPONDING FIELDS OF TABLE @gt_alv.


    SORT gt_alv BY matnr.
    DELETE ADJACENT DUPLICATES FROM gt_alv COMPARING matnr.


    LOOP AT gt_alv ASSIGNING FIELD-SYMBOL(<lfs_alv>).
      IF ( <lfs_alv>-asas + <lfs_alv>-asat + <lfs_alv>-stok ) < <lfs_alv>-minstok.
        <lfs_alv>-talep = ( <lfs_alv>-azstok - ( <lfs_alv>-asas + <lfs_alv>-asat + <lfs_alv>-stok ) ).

*        <lfs_alv>-satol = abap_true.
        IF <lfs_alv>-satol EQ abap_true.
          go_local->bapi( ).
          go_local->get_data( ).
          CALL METHOD go_alv_grid->refresh_table_display( ).
        ENDIF.
      ELSE.
        ROLLBACK WORK.
        MESSAGE |SAT, SAS ve Stok miktarları toplamı Min stok seviyesi altında olmayan malzemelere SAT açılamaz| TYPE 'I' DISPLAY LIKE 'E'.
      ENDIF.
    ENDLOOP.


*    DATA:lt_index_rows TYPE lvc_t_row.
*
*    CALL METHOD go_alv_grid->get_selected_rows
*      IMPORTING
*        et_index_rows = lt_index_rows.  " Indexes of Selected Rows
*
*    IF lt_index_rows IS INITIAL.
*      MESSAGE |satır verisi seçin!| TYPE 'I' DISPLAY LIKE 'W'.
*    ELSE.
*      LOOP AT lt_index_rows INTO DATA(ls_index_rows).
*        READ TABLE gt_alv INTO gs_alv INDEX ls_index_rows-index.
*      ENDLOOP.

  ENDMETHOD.
  METHOD bapi.
    DATA:lt_items  TYPE TABLE OF bapiebanc,
         ls_items  LIKE LINE OF lt_items,
         lt_return TYPE TABLE OF bapireturn,
         ls_return LIKE LINE OF lt_return,
         lv_werks  TYPE werks_d,
         ls_so     TYPE selopt.
    LOOP AT so_werks INTO ls_so.
      lv_werks = ls_so-low.
    ENDLOOP.

    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<lfs_items>).
      READ TABLE gt_alv INTO gs_alv WITH KEY satol = abap_true.
      IF sy-subrc IS INITIAL.

        <lfs_items> = VALUE #( doc_type   = 'ZSAT'
                               material   = gs_alv-matnr
                               plant      = lv_werks
                               store_loc  = '1001'
                               quantity   = gs_alv-talep
                               unit       = gs_alv-meins
                               deliv_date = sy-datum
                               rel_date   = sy-datum ).
      ENDIF.
    ENDLOOP.

    CALL FUNCTION 'BAPI_REQUISITION_CREATE'
      EXPORTING
        automatic_source  = 'X'
      TABLES
        requisition_items = lt_items
        return            = lt_return.

    IF ls_return-type EQ 'S'.

      DATA:lt_itemsget TYPE TABLE OF bapieban,
           ls_itemsget LIKE LINE OF  lt_itemsget.

      lt_itemsget = CORRESPONDING #( lt_items ).

      CALL FUNCTION 'BAPI_REQUISITION_GETDETAIL'
*        EXPORTING
*          number            =
        TABLES
          requisition_items = lt_itemsget.

      LOOP AT gt_alv ASSIGNING FIELD-SYMBOL(<lfs_alv>).
        READ TABLE lt_itemsget INTO ls_itemsget WITH KEY material = <lfs_alv>-matnr.
        <lfs_alv>-satno    = ls_itemsget-preq_no.
        <lfs_alv>-satkalem = ls_itemsget-preq_item.
        <lfs_alv>-durum    = '@08@'.
      ENDLOOP.
    ELSE.
      <lfs_alv>-durum    = '@0A@'.
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
*                        ref_table  = 'MARC'
*                        ref_field  = 'MABST'
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
                        fieldname  = 'ASAS'
                        scrtext_s  = 'Açık SAS'
                        scrtext_m  = 'Açık SAS'
                        scrtext_l  = 'Açık SAT Miktarı').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 15
*                        ref_table  = 'MARA'
*                        ref_field  = 'MEINS'
                        fieldname  = 'MEINS5'
                        scrtext_s  = 'Ölçü Birim'
                        scrtext_m  = 'Ölçü Birimi'
                        scrtext_l  = 'Ölçü Birimi').
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos    = 16       "EDITABLE OLACAK!
                        edit        = abap_true
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
                        edit       = abap_true
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
                        icon       = abap_true
                        fieldname  = 'DURUM'
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
