*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_WORK1_LCL
*&---------------------------------------------------------------------*
CLASS local DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      get_data2,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      pbo_0101,
      pai_0101 IMPORTING iv_ucomm TYPE sy-ucomm,
      pai_0102 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fieldcat,
      set_layout,
      display_alv,
      save_personal,
      update_personal,
      delete_personal,
      call_func IMPORTING iv_personal_id TYPE zpers_id_de
                EXPORTING ev_found       TYPE char1
                          ev_maas        TYPE zpers_maas_de,
      total_salary.
ENDCLASS.

CLASS local IMPLEMENTATION.
  METHOD get_data.

    SELECT
      t1~personal_id,
      t1~personal_ad,
      t1~personal_soyad,
      t2~departman_ad,
      t1~maas
      FROM zpersonal_t AS t1
      LEFT JOIN zdepartman_t AS t2
      ON t1~departman_id EQ t2~departman_id
      INTO CORRESPONDING FIELDS OF TABLE @gt_pers.

  ENDMETHOD.

  METHOD get_data2.
    SELECT
      t1~personal_id,
      t1~personal_ad,
      t1~personal_soyad,
      t2~departman_ad,
      t1~maas
      FROM zpersonal_t AS t1
      LEFT JOIN zdepartman_t AS t2
      ON t1~departman_id EQ t2~departman_id
      WHERE maas GE @gv_maas
      INTO CORRESPONDING FIELDS OF TABLE @gt_pers.
  ENDMETHOD.

  METHOD save_personal.

    IF gv_personal_id     IS NOT INITIAL AND
       gv_personal_ad     IS NOT INITIAL AND
       gv_personal_soyad  IS NOT INITIAL AND
       gv_departman_id    IS NOT INITIAL AND
       gv_maas            IS NOT INITIAL .

      go_local->call_func(
        EXPORTING
          iv_personal_id = gv_personal_id
        IMPORTING
          ev_found       = gv_found
          ev_maas        = gv_maas
      ).
      IF gv_found EQ 'X'.
        MESSAGE i002 DISPLAY LIKE 'E'.
      ELSE.
        DATA:ls_pers TYPE zpersonal_t.
        ls_pers-personal_id    = gv_personal_id.
        ls_pers-personal_ad    = gv_personal_ad.
        ls_pers-personal_soyad = gv_personal_soyad.
        ls_pers-departman_id   = gv_departman_id.
        ls_pers-maas           = gv_maas.

        INSERT zpersonal_t FROM ls_pers.
        IF sy-subrc EQ 0.
          MESSAGE i001 DISPLAY LIKE 'S'.
        ELSE.
          MESSAGE i002 DISPLAY LIKE 'E'.
        ENDIF.
      ENDIF.
    ELSE.
      MESSAGE i000 DISPLAY LIKE 'W'.
    ENDIF.
  ENDMETHOD.

  METHOD update_personal.

    IF gv_personal_id     IS NOT INITIAL AND
       gv_personal_ad     IS NOT INITIAL AND
       gv_personal_soyad  IS NOT INITIAL .

      go_local->call_func(
        EXPORTING
          iv_personal_id = gv_personal_id
        IMPORTING
          ev_found       = gv_found
          ev_maas        = gv_maas
      ).
      IF gv_found EQ 'X'.
        UPDATE zpersonal_t SET personal_ad    = gv_personal_ad
                      personal_soyad = gv_personal_soyad
                      WHERE personal_id EQ gv_personal_id.
        IF sy-subrc EQ 0.
          MESSAGE i003 DISPLAY LIKE 'S'.
        ELSE.
          MESSAGE i004 DISPLAY LIKE 'E'.
        ENDIF.

      ELSE.
        MESSAGE i004 DISPLAY LIKE 'E'.
      ENDIF.
    ELSE.
      MESSAGE i000 DISPLAY LIKE 'W'.
    ENDIF.

  ENDMETHOD.

  METHOD delete_personal.
    IF gv_personal_id IS NOT INITIAL.

      go_local->call_func(
        EXPORTING
          iv_personal_id = gv_personal_id
        IMPORTING
          ev_found       = gv_found
          ev_maas        = gv_maas
      ).
      IF gv_found EQ 'X'.
        DELETE FROM zpersonal_t WHERE personal_id EQ gv_personal_id.
        IF sy-subrc EQ 0.
          MESSAGE i006 DISPLAY LIKE 'S'.
        ELSE.
          MESSAGE i007 DISPLAY LIKE 'E'.
        ENDIF.
      ELSE.
        MESSAGE i007 DISPLAY LIKE 'E'.
      ENDIF.

    ELSE.
      MESSAGE i005 DISPLAY LIKE 'W'.
    ENDIF.
  ENDMETHOD.

  METHOD call_func.
    CALL FUNCTION 'ZPERS_FM'
      EXPORTING
        iv_personal_id = iv_personal_id
      IMPORTING
        ev_found       = ev_found
        ev_maas        = ev_maas.

  ENDMETHOD.

  METHOD total_salary.

    CLEAR gv_total_maas.
    LOOP AT gt_pers INTO gs_pers.
      gv_total_maas = gv_total_maas + gs_pers-maas.
    ENDLOOP.

  ENDMETHOD.

  METHOD call_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS '0100'.
    SET TITLEBAR '0100'.

  ENDMETHOD.
  METHOD pbo_0101.
    LOOP AT SCREEN.
      CASE abap_true.
        WHEN pselect.
          IF screen-group1 EQ 'X'.
            screen-active = 0.
            MODIFY SCREEN.
          ENDIF.
        WHEN pinsert.
          IF screen-group2 EQ 'X'.
            screen-active = 0.
            MODIFY SCREEN.
          ENDIF.
        WHEN pupdate.
          IF screen-group3 EQ 'X'.
            screen-active = 0.
            MODIFY SCREEN.
          ENDIF.
        WHEN pdelete.
          IF screen-group4 EQ 'X'.
            screen-active = 0.
            MODIFY SCREEN.
          ENDIF.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&TAB1'.
        tb_id-activetab = '&TAB1'.
      WHEN '&TAB2'.
        tb_id-activetab = '&TAB2'.
    ENDCASE.
  ENDMETHOD.

  METHOD pai_0101.
    CASE iv_ucomm.
      WHEN '&OP'.
        IF pselect EQ abap_true.
          go_local->get_data2( ).
          CALL METHOD go_alv_grid->refresh_table_display.
        ELSEIF pinsert EQ abap_true.
          go_local->save_personal( ).
          go_local->get_data( ).
          CALL METHOD go_alv_grid->refresh_table_display.
        ELSEIF pupdate EQ abap_true.
          go_local->update_personal( ).
          go_local->get_data( ).
          CALL METHOD go_alv_grid->refresh_table_display.
        ELSEIF pdelete EQ abap_true.
          go_local->delete_personal( ).
          go_local->get_data( ).
          CALL METHOD go_alv_grid->refresh_table_display.
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD pai_0102.
    CASE iv_ucomm.
      WHEN '&CALCULATE'.
        go_local->get_data( ).
        go_local->total_salary( ).
    ENDCASE.
  ENDMETHOD.

  METHOD set_fieldcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZPERSONAL_DEPARTMAN_S'
      CHANGING
        ct_fieldcat      = gt_fieldcat.
  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra = abap_true.
    gs_layout-col_opt = abap_true.
    gs_layout-cwidth_opt = abap_true.
  ENDMETHOD.

  METHOD display_alv.
    IF go_alv_grid IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.  " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid
        EXPORTING
*         i_parent = cl_gui_container=>screen0  " Parent Container
          i_parent = go_container. " Parent Container
      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout " Layout
        CHANGING
          it_outtab       = gt_pers  " Output Table
          it_fieldcatalog = gt_fieldcat.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
