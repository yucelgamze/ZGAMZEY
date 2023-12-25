*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_ADVANCED4_LCL
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

    DATA:lv_max_adet TYPE labst,
         lv_miktar   TYPE labst.

    SELECT
    db_t1~ana_malzeme,
    db_t1~alt_malzeme,
    db_t1~alt_malzeme_miktar
    FROM ztree_t AS db_t1
    INTO TABLE @DATA(lt_tree).

    SELECT
    db_t2~alt_malzeme,
    db_t2~stok_miktari
    FROM zastok_t AS db_t2
    INTO TABLE @DATA(lt_astok).

    LOOP AT lt_tree INTO DATA(ls_tree) GROUP BY ls_tree-ana_malzeme.

      LOOP AT GROUP ls_tree INTO DATA(ls_tree2).

        READ TABLE lt_astok INTO DATA(ls_astok) WITH KEY alt_malzeme = ls_tree2-alt_malzeme.

       lv_max_adet = floor( ls_astok-stok_miktari / ls_tree-alt_malzeme_miktar ).

      ENDLOOP.

  "hesaplanan üretilebilecek miktarın bir types structure'ında tutarak aşağıdaki loop da okuma yapılır

      gs_miktar-ana_malzeme = ls_tree-ana_malzeme.
      gs_miktar-miktar = lv_max_adet.
      APPEND gs_miktar TO gt_miktar.

      CLEAR:gs_miktar.

      CLEAR lv_max_adet.

    ENDLOOP.

    SORT lt_astok ASCENDING BY alt_malzeme.

    LOOP AT lt_tree ASSIGNING FIELD-SYMBOL(<fs_wa>) GROUP BY <fs_wa>-ana_malzeme.
      READ TABLE gt_miktar INTO gs_miktar WITH KEY ana_malzeme = <fs_wa>-ana_malzeme.
      IF sy-subrc EQ 0.
        lv_miktar = gs_miktar-miktar.
        ASSIGN COMPONENT 'ANA_MALZEME' OF STRUCTURE <dyn_structure> TO <fs>.
        <fs> = <fs_wa>-ana_malzeme.

        ASSIGN COMPONENT 'URETILEBILECEK_MIKTAR' OF STRUCTURE <dyn_structure> TO <fs> .
        <fs> = lv_miktar.

        CLEAR:ls_astok, gs_miktar.

        LOOP AT lt_astok INTO ls_astok.

          IF ls_astok-alt_malzeme IS NOT INITIAL.
            READ TABLE lt_tree INTO ls_tree WITH KEY alt_malzeme = ls_astok-alt_malzeme
                                                     ana_malzeme = <fs_wa>-ana_malzeme.
*                                                     ana_malzeme = ls_tree-ana_malzeme.  """ !!
            "BINARY SEARCH.

            IF sy-subrc EQ 0.
              ASSIGN COMPONENT ls_astok-alt_malzeme OF STRUCTURE <dyn_structure> TO <fs>.
              <fs> = lv_miktar * ls_tree-alt_malzeme_miktar.
            ELSE.
              ASSIGN COMPONENT ls_astok-alt_malzeme OF STRUCTURE <dyn_structure> TO <fs>.
              <fs> = 0.
            ENDIF.

          ELSE.

            EXIT.
          ENDIF.

        ENDLOOP.

        CLEAR : lv_miktar.
      ENDIF.

      APPEND <dyn_structure> TO <dyn_itab>.
      CLEAR <dyn_structure>.
    ENDLOOP.


*    SELECT
*    db_t1~ana_malzeme,
*    db_t1~alt_malzeme_miktar,
*    db_t2~alt_malzeme,
*    db_t2~stok_miktari
*    FROM ztree_t AS db_t1
*    LEFT JOIN zastok_t AS db_t2
*    on db_t1~alt_malzeme eq db_t2~alt_malzeme
*    INTO TABLE @DATA(gt_alv).
*
*
*     LOOP AT gt_alv ASSIGNING FIELD-SYMBOL(<fs_wa>) GROUP BY <fs_wa>-ana_malzeme.
*      ASSIGN COMPONENT 'ANA_MALZEME' OF STRUCTURE <dyn_structure> TO <fs>.
*      <fs> = <fs_wa>-ana_malzeme.
*      LOOP AT GROUP <fs_wa> ASSIGNING FIELD-SYMBOL(<fs_wa2>).
*        DATA(lv_num) =  floor( <fs_wa2>-stok_miktari / <fs_wa2>-alt_malzeme_miktar ).
*        IF lv_max_adet <= lv_num.
*          lv_num = lv_max_adet.
*        ENDIF.
*      ENDLOOP.
*      ASSIGN COMPONENT 'URETILEBILECEK_MIKTAR' OF STRUCTURE <dyn_structure> TO <fs>.
*      <fs> = lv_num.
*
*      LOOP AT gt_alv ASSIGNING FIELD-SYMBOL(<fs_wa3>).
*        READ TABLE gt_alv INTO <fs_wa> WITH KEY ana_malzeme = <fs_wa3>-ana_malzeme
*                                                     alt_malzeme = <fs_wa3>-alt_malzeme.
*        IF sy-subrc EQ 0.
*          ASSIGN COMPONENT <fs_wa3>-alt_malzeme OF STRUCTURE <dyn_structure> TO <fs>.
*          <fs> = lv_num * <fs_wa3>-alt_malzeme_miktar.
*        ELSE.
*          ASSIGN COMPONENT <fs_wa3>-alt_malzeme OF STRUCTURE <dyn_structure> TO <fs>.
*          <fs> = 0.
*        ENDIF.
*      ENDLOOP.
*      APPEND <dyn_structure> TO <dyn_itab>.
*      CLEAR <dyn_structure>.
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

    "stok tablosundan alt malzeme kolonları seçilir.
    SELECT
      t~alt_malzeme
      FROM zastok_t AS t
      INTO TABLE @DATA(lt_alt).

    CLEAR gs_fcat.
    gs_fcat-ref_table = 'ZTREE_T'.
    gs_fcat-ref_field = 'ANA_MALZEME'.
    gs_fcat-fieldname = 'ANA_MALZEME'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR gs_fcat.
    gs_fcat-ref_table = 'MARD'.
    gs_fcat-ref_field = 'LABST'.
*    gs_fcat-ref_table   = 'MARA'.
*    gs_fcat-ref_field   = 'MEINS'.
    gs_fcat-fieldname   = 'URETILEBILECEK_MIKTAR'.
    gs_fcat-scrtext_l   = 'Üretilebilecek Miktar'.
    gs_fcat-scrtext_m   = 'Üretilebilecek Miktar'.
    gs_fcat-scrtext_s   = 'Üretilebilecek Miktar'.
    gs_fcat-seltext     = 'Üretilebilecek Miktar'.
    gs_fcat-reptext     = 'Üretilebilecek Miktar'.
    APPEND gs_fcat TO gt_fcat.


    LOOP AT lt_alt ASSIGNING FIELD-SYMBOL(<fs_alt>).
      CLEAR:gs_fcat.
      gs_fcat-fieldname   = <fs_alt>-alt_malzeme.
      gs_fcat-scrtext_l   = <fs_alt>-alt_malzeme.
      gs_fcat-scrtext_m   = <fs_alt>-alt_malzeme.
      gs_fcat-scrtext_s   = <fs_alt>-alt_malzeme.
      gs_fcat-seltext     = <fs_alt>-alt_malzeme.
      gs_fcat-reptext     = <fs_alt>-alt_malzeme.
      APPEND gs_fcat TO gt_fcat.
    ENDLOOP.
    "dinamik internal table
    DATA:new_table TYPE REF TO data,
         new_line  TYPE REF TO data.

    CALL METHOD cl_alv_table_create=>create_dynamic_table
      EXPORTING
        it_fieldcatalog = gt_fcat   " Field Catalog
      IMPORTING
        ep_table        = new_table. " Pointer to Dynamic Data Table

    ASSIGN new_table->* TO <dyn_itab>.

    CREATE DATA new_line LIKE LINE OF <dyn_itab>.
    ASSIGN new_line->* TO <dyn_structure>.
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
          it_outtab       = <dyn_itab> " Output Table
          it_fieldcatalog = gt_fcat.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
