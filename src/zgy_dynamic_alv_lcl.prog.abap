*&---------------------------------------------------------------------*
*& Include          ZGY_WORK10_LCL
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
    SELECT *
      FROM zgy_dbt_dynamic
      INTO TABLE gt_alv.

    "il kodları sıralansın ve aynı olup tekrar eden il kodları silinsin
    gt_ilkodu = gt_alv.
    "küçükten büyüğe il koduna göre sırala
    SORT gt_ilkodu BY il_kodu.
    "tekrar eden il_kodu kolonlarını siler
    DELETE ADJACENT DUPLICATES FROM gt_ilkodu COMPARING il_kodu.
*    BREAK gamzey.
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

    "dinamik ilkodu kolonunun pozisyonunu malzeme 1den başladığı
    "için 2 den başlatıp loop içinde artıracağız.
    DATA:lv_count     TYPE int4 VALUE 2,
         lv_fieldname TYPE string.

    CLEAR:   gs_fcat.
    gs_fcat-col_pos   = 1.
    gs_fcat-fieldname = 'MALZEME'.
    gs_fcat-scrtext_l = 'Malzeme'.
    gs_fcat-scrtext_m = 'Malzeme'.
    gs_fcat-scrtext_s = 'Malzeme'.

    IF gs_fcat-fieldname = 'MALZEME'.
      gs_fcat-datatype  = 'CHAR'.
      gs_fcat-intlen    = 40.
    ELSE.
      gs_fcat-datatype  = 'CHAR'.
      gs_fcat-intlen    = 10.
    ENDIF.

    APPEND gs_fcat TO gt_fcat.

    LOOP AT gt_ilkodu INTO DATA(ls_ilkodu).

      CLEAR:gs_fcat.
      gs_fcat-col_pos   = lv_count.
      gs_fcat-fieldname = |IL_KODU| && ls_ilkodu-il_kodu .
      gs_fcat-scrtext_l = |IL_KODU| && ls_ilkodu-il_kodu .
      gs_fcat-scrtext_m = |IL_KODU| && ls_ilkodu-il_kodu .
      gs_fcat-scrtext_s = |IL_KODU| && ls_ilkodu-il_kodu .

      IF gs_fcat-fieldname = 'MALZEME'.
        gs_fcat-datatype  = 'CHAR'.
        gs_fcat-intlen    = 40.
      ELSE.
        gs_fcat-datatype  = 'CHAR'.
        gs_fcat-intlen    = 10.
      ENDIF.
      APPEND gs_fcat TO gt_fcat.

      lv_count = lv_count + 1.
      CLEAR:ls_ilkodu-il_kodu.

    ENDLOOP.

    CALL METHOD cl_alv_table_create=>create_dynamic_table
      EXPORTING
        it_fieldcatalog = gt_fcat  " Field Catalog
      IMPORTING
        ep_table        = go_dynamic.   " Pointer to Dynamic Data Table

    ASSIGN go_dynamic->* TO <dyn_table>.

    CREATE DATA gs_dynamic LIKE LINE OF <dyn_table>.
    ASSIGN gs_dynamic->* TO <gfs_s_table>.


*    "birinci yöntem
*    gt_malzeme = gt_alv.
*    SORT gt_malzeme BY malzeme.
*    DELETE ADJACENT DUPLICATES FROM gt_malzeme COMPARING malzeme.
*
*    "en dıştaki loop ta malzemeler uniqe olarak tutuluyor.
*    LOOP AT gt_malzeme INTO DATA(ls_malzeme).
*
*      APPEND INITIAL LINE TO <dyn_table> ASSIGNING <gfs_s_table>.
*
*      IF <gfs_s_table> IS ASSIGNED.
*        ASSIGN COMPONENT 'MALZEME' OF STRUCTURE <gfs_s_table> TO <gfs>.
*        IF <gfs> IS ASSIGNED.
*          <gfs> = ls_malzeme-malzeme.
*        ENDIF.
*      ENDIF.
*
*      LOOP AT gt_alv INTO DATA(ls_alv) WHERE malzeme = ls_malzeme-malzeme.
*        lv_fieldname = |IL_KODU| && ls_alv-il_kodu.
*        IF <gfs_s_table> IS ASSIGNED.
*          ASSIGN COMPONENT lv_fieldname OF STRUCTURE <gfs_s_table> TO <gfs>.
*          IF <gfs> IS ASSIGNED.
*            <gfs> = ls_alv-fiyat.
*            CONDENSE <gfs>.
*          ENDIF.
*        ENDIF.
*      ENDLOOP.
**      APPEND <gfs_s_table> TO <dyn_table>.
**      CLEAR:<gfs_s_table>.
*    ENDLOOP.

*    "dahaa modern ikinci yöntem yine ilk loop da malzemeler uniqe şekilde tutuluyor ikinci loopta ilkodu altına fiyat eklenecektir
    LOOP AT gt_alv INTO DATA(ls_alv) GROUP BY ( malzeme = ls_alv-malzeme
                                                index   = GROUP INDEX
                                                size    = GROUP SIZE ) ASCENDING ASSIGNING FIELD-SYMBOL(<lfs_group>).

      APPEND INITIAL LINE TO <dyn_table> ASSIGNING <gfs_s_table>.

      IF <gfs_s_table> IS ASSIGNED.
        ASSIGN COMPONENT 'MALZEME' OF STRUCTURE <gfs_s_table> TO <gfs>.
        IF <gfs> IS ASSIGNED.
          <gfs> = <lfs_group>-malzeme.
        ENDIF.
      ENDIF.

      LOOP AT GROUP <lfs_group> ASSIGNING FIELD-SYMBOL(<lfs_s_group>).
        lv_fieldname = |IL_KODU| && <lfs_s_group>-il_kodu.
        IF <gfs_s_table> IS ASSIGNED.
          ASSIGN COMPONENT lv_fieldname OF STRUCTURE <gfs_s_table> TO <gfs>.
          IF <gfs> IS ASSIGNED.
            <gfs> = <lfs_s_group>-fiyat.
            CONDENSE <gfs>.
          ENDIF.
        ENDIF.
      ENDLOOP.
**      APPEND <gfs_s_table> TO <dyn_table>.
**      CLEAR:<gfs_s_table>.
    ENDLOOP.


  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra      = abap_true.
    gs_layout-cwidth_opt = abap_true.
    gs_layout-col_opt    = abap_true.
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
          it_outtab       = <dyn_table> " Output Table
          it_fieldcatalog = gt_fcat.  " Field Catalog

    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
