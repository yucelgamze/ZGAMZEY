*&---------------------------------------------------------------------*
*& Include          ZGY_DALV_LCL
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
    SELECT
      malzeme,
      il_kodu,
      fiyat
      FROM zgy_t_0001
      INTO CORRESPONDING FIELDS OF TABLE @gt_alv.
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
    DATA:lv_count TYPE int4 VALUE 2,
         lv_field TYPE string.

    CLEAR gs_fcat.
    gs_fcat =  VALUE #( col_pos   = 1
                        datatype  = 'CHAR'
                        intlen    = 40
                        fieldname = 'MALZEME'
                        scrtext_s = 'Malzeme'
                        scrtext_m = 'Malzeme'
                        scrtext_l = 'Malzeme').

    APPEND gs_fcat TO gt_fcat.

    LOOP AT gt_alv INTO gs_alv GROUP BY ( il_kodu = gs_alv-il_kodu ) ASCENDING ASSIGNING FIELD-SYMBOL(<lfs_il_kodu>).
      IF <lfs_il_kodu> IS ASSIGNED.
        CLEAR gs_fcat.
        gs_fcat = VALUE #(
                          col_pos   = lv_count
                          datatype  = 'CHAR'
                          intlen    = 10
                          fieldname = |IL_KODU| && <lfs_il_kodu>-il_kodu
                          scrtext_s = |IL_KODU| && <lfs_il_kodu>-il_kodu
                          scrtext_m = |IL_KODU| && <lfs_il_kodu>-il_kodu
                          scrtext_l = |IL_KODU| && <lfs_il_kodu>-il_kodu ).

        APPEND gs_fcat TO gt_fcat.
        lv_count = lv_count + 1.
      ENDIF.
    ENDLOOP.

    CALL METHOD cl_alv_table_create=>create_dynamic_table
      EXPORTING
        it_fieldcatalog = gt_fcat   " Field Catalog
      IMPORTING
        ep_table        = go_t_dynamic. " Pointer to Dynamic Data Table
    ASSIGN go_t_dynamic->* TO <dyn_table>.

    CREATE DATA go_s_dynamic LIKE LINE OF <dyn_table>.
    ASSIGN go_s_dynamic->* TO <gfs_s_table>.

    LOOP AT gt_alv INTO DATA(ls_alv) GROUP BY ( malzeme = ls_alv-malzeme
                                                index   = GROUP INDEX
                                                size    = GROUP SIZE )
      ASCENDING ASSIGNING FIELD-SYMBOL(<lfs_group>).

      APPEND INITIAL LINE TO <dyn_table> ASSIGNING <gfs_s_table>.

      IF <gfs_s_table> IS ASSIGNED.
        ASSIGN COMPONENT 'MALZEME' OF STRUCTURE <gfs_s_table> TO <gfs>.
        IF <gfs> IS ASSIGNED.
          <gfs> = <lfs_group>-malzeme.
        ENDIF.
      ENDIF.

      LOOP AT GROUP <lfs_group> ASSIGNING FIELD-SYMBOL(<lfs_s_group>).

        lv_field = |IL_KODU| && <lfs_s_group>-il_kodu.

        IF <gfs_s_table> IS ASSIGNED.
          ASSIGN COMPONENT lv_field OF STRUCTURE <gfs_s_table> TO <gfs>.
          IF <gfs> IS ASSIGNED.
            <gfs> = <lfs_s_group>-fiyat.
            CONDENSE <gfs>.
          ENDIF.
        ENDIF.
      ENDLOOP.

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
          container_name = 'CC_ALV'.  " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid
        EXPORTING
          i_parent = go_container.  " Parent Container
      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout  " Layout
        CHANGING
          it_outtab       = <dyn_table>   " Output Table
          it_fieldcatalog = gt_fcat.    " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
