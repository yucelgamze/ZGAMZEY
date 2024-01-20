*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_ADVANCED1_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fieldcat,
      set_layout,
      display_alv.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.
    "ortak keylere sahip olan db_t3 üzerinden join
    SELECT
      db_t3~il_kodu,
      db_t1~il_tanım,
      db_t2~ilce_tanım
      FROM zil_listesi_t AS db_t1
      LEFT JOIN zil_ilce_esi_t AS db_t3
      ON db_t3~il_kodu EQ db_t1~il_kodu
      LEFT JOIN zilce_listesi_t AS db_t2
      ON db_t3~ilce_kodu EQ db_t2~ilce_kodu
      INTO  TABLE @DATA(gt_table).

    DATA(lv_sayac) = 1.

    LOOP AT gt_table ASSIGNING FIELD-SYMBOL(<fs_wa>) GROUP BY <fs_wa>-il_kodu.

      ASSIGN COMPONENT 'IL_KODU' OF STRUCTURE <dyn_wa> TO <fs>.
      <fs> = <fs_wa>-il_kodu.
      ASSIGN COMPONENT 'IL_TANIM' OF STRUCTURE <dyn_wa> TO <fs>.
      <fs> = <fs_wa>-il_tanim.
      lv_sayac = 1.

      LOOP AT GROUP <fs_wa> ASSIGNING FIELD-SYMBOL(<fs_wa_2>).

        DATA(dyn_column) = 'ILCE_TANIM' && lv_sayac.
        ASSIGN COMPONENT dyn_column OF STRUCTURE <dyn_wa> TO <fs>.
        <fs> = <fs_wa_2>-ilce_tanim.
        lv_sayac = lv_sayac + 1.
      ENDLOOP.

      APPEND <dyn_wa> TO <dyn_table>.
      CLEAR <dyn_wa>.

    ENDLOOP.

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

  METHOD set_fieldcat.

    DATA(dyn_ilce) = 1.

    SELECT
    il_kodu, COUNT(*) AS ilce_sayı
      FROM zil_ilce_esi_t
      INTO TABLE @DATA(lt_ilce_sayı)
      GROUP BY il_kodu.

    LOOP AT lt_ilce_sayi INTO DATA(ls_ilce_sayi).
      dyn_ilce = ls_ilce_sayi-ilce_sayi.
    ENDLOOP.

    CLEAR gs_fieldcat.

*    APPEND INITIAL LINE TO gt_fieldcat ASSIGNING FIELD-SYMBOL(<fs_fieldcat>).
*    <fs_fieldcat>-fieldname = 'IL_KODU'.
*    <fs_fieldcat>-ref_table = 'GTY_DYNAMIC'.
*    <fs_fieldcat>-datatype = 'CHAR'.

    gs_fieldcat-fieldname = 'IL_KODU'.
    gs_fieldcat-ref_table = 'ZIL_LISTESI_T'.
    gs_fieldcat-ref_field = 'IL_KODU'.
    APPEND gs_fieldcat TO gt_fieldcat.

    gs_fieldcat-fieldname = 'IL_TANIM'.
    gs_fieldcat-ref_table = 'ZIL_LISTESI_T'.
    gs_fieldcat-ref_field = 'IL_TANIM'.
    APPEND gs_fieldcat TO gt_fieldcat.

    DATA(lv_sayac) = 1.
    DO  dyn_ilce TIMES.
      CLEAR gs_fieldcat.
      gs_fieldcat-fieldname = 'ILCE_TANIM' && lv_sayac.
      gs_fieldcat-datatype  = 'ZILCE_KODU'.

      "tablodan referans verildiğinde dinamik özelliğini bozuyor
*      gs_fieldcat-ref_field = 'ILCE_TANIM'.
      gs_fieldcat-scrtext_l = 'İLÇE TANIMI' && | | && lv_sayac.
      gs_fieldcat-scrtext_m = 'İLÇE TANIMI' && | | && lv_sayac.
      gs_fieldcat-scrtext_s = 'İLÇE TANIMI' && | | && lv_sayac.
      gs_fieldcat-seltext = gs_fieldcat-reptext = 'İLÇE TANIMI' && | | && lv_sayac.

      APPEND gs_fieldcat TO gt_fieldcat.
      CLEAR gs_fieldcat.
      lv_sayac = lv_sayac + 1.
    ENDDO.


    "dinamik internal table
    DATA:new_table TYPE REF TO data,
         new_line  TYPE REF TO data.

    CALL METHOD cl_alv_table_create=>create_dynamic_table
      EXPORTING
        it_fieldcatalog = gt_fieldcat   " Field Catalog
      IMPORTING
        ep_table        = new_table. " Pointer to Dynamic Data Table

    ASSIGN new_table->* TO <dyn_table>.

    CREATE DATA new_line LIKE LINE OF <dyn_table>.
    ASSIGN new_line->* TO <dyn_wa>.

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
          it_outtab       = <dyn_table> " Output Table
          it_fieldcatalog = gt_fieldcat.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
