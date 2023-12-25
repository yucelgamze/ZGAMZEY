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

    DATA:lt_users TYPE TABLE OF agr_users,
         ls_alv   TYPE gty_alv.

    IF so_bname IS INITIAL.

      so_bname = VALUE #( sign   = 'I'
                          option = 'EQ'
                          low    = sy-uname  ).

      APPEND so_bname TO so_bname[].
    ENDIF.


    SELECT
    bname
    FROM usr02
    WHERE bname IN @so_bname
    INTO TABLE @DATA(lt_alv).

    LOOP AT lt_alv ASSIGNING FIELD-SYMBOL(<gfs_alv>).

      CLEAR:lt_users.

      CALL FUNCTION 'CKEXUTIL_USER_TO_ROLE'
        EXPORTING
          i_uname      = <gfs_alv>-bname
        TABLES
          et_agr_users = lt_users.

      LOOP AT lt_users ASSIGNING FIELD-SYMBOL(<gfs_users>) WHERE from_dat GE p_start AND
                                                                 to_dat   LE p_end.
        ls_alv-bname    = <gfs_users>-uname. "kullanıcı adı
        ls_alv-agr_name = <gfs_users>-agr_name. "rol
        ls_alv-from_dat = <gfs_users>-from_dat.
        ls_alv-to_dat   = <gfs_users>-to_dat.

        APPEND ls_alv TO gt_alv.
      ENDLOOP.
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

  METHOD set_fcat.
    CLEAR:gs_fcat.
    gs_fcat-ref_table = 'USR02'.
    gs_fcat-ref_field = 'BNAME'.
    gs_fcat-fieldname = 'BNAME'.
    gs_fcat-scrtext_l = 'Kullanıcı Adı'.
    gs_fcat-scrtext_m = 'Kullanıcı Adı'.
    gs_fcat-scrtext_s = 'Kullanıcı Adı'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-ref_table = 'AGR_USERS'.
    gs_fcat-ref_field = 'AGR_NAME'.
    gs_fcat-fieldname = 'AGR_NAME'.
    gs_fcat-scrtext_l = 'Rol'.
    gs_fcat-scrtext_m = 'Rol'.
    gs_fcat-scrtext_s = 'Rol'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-ref_table = 'AGR_USERS'.
    gs_fcat-ref_field = 'FROM_DAT'.
    gs_fcat-fieldname = 'FROM_DAT'.
    gs_fcat-scrtext_l = 'Başlangıç Tarihi'.
    gs_fcat-scrtext_m = 'Başlangıç Tarihi'.
    gs_fcat-scrtext_s = 'Başlangıç Tarihi'.
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat-ref_table = 'AGR_USERS'.
    gs_fcat-ref_field = 'TO_DAT'.
    gs_fcat-fieldname = 'TO_DAT'.
    gs_fcat-scrtext_l = 'Bitiş Tarihi'.
    gs_fcat-scrtext_m = 'Bitiş Tarihi'.
    gs_fcat-scrtext_s = 'Bitiş Tarihi'.
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
