*&---------------------------------------------------------------------*
*& Include          ZGY_P_0009_LCL
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

    DATA:lt_agr_users TYPE TABLE OF agr_users.

    IF so_bname IS INITIAL.

      so_bname = VALUE #( sign   = 'I'
                          option = 'EQ'
                          low    = sy-uname  ).

      APPEND so_bname TO so_bname[].
    ENDIF.

    SELECT bname
    FROM usr02
    WHERE bname IN @so_bname
    INTO CORRESPONDING FIELDS OF TABLE @gt_alv.

    SORT gt_alv BY bname.

    LOOP AT gt_alv ASSIGNING FIELD-SYMBOL(<lfs_alv>).

      CLEAR:lt_agr_users.
      CALL FUNCTION 'CKEXUTIL_USER_TO_ROLE'
        EXPORTING
          i_uname      = <lfs_alv>-bname
        TABLES
          et_agr_users = lt_agr_users.

      LOOP AT lt_agr_users ASSIGNING FIELD-SYMBOL(<lfs_agr_user>) WHERE from_dat GE p_start
                                                                  AND   to_dat   LE p_fin.
        <lfs_alv> = VALUE #( BASE gs_alv
                             bname    = <lfs_agr_user>-uname
                             agr_name = <lfs_agr_user>-agr_name
                             from_dat = <lfs_agr_user>-from_dat
                             to_dat   = <lfs_agr_user>-to_dat ).
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
    gs_fcat = VALUE #( col_pos   = 1
                       datatype  = 'CHAR'
                       intlen    = 12
                       fieldname = 'BNAME'
                       scrtext_l = 'Kullanıcı Adı'
                       scrtext_m = 'Kullanıcı Adı'
                       scrtext_s = 'Kullanıcı Adı').
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat = VALUE #( col_pos   = 2
                       datatype  = 'CHAR'
                       intlen    = 30
                       fieldname = 'AGR_NAME'
                       scrtext_l = 'Rol'
                       scrtext_m = 'Rol'
                       scrtext_s = 'Rol').
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat = VALUE #( col_pos   = 3
                       ref_table = 'AGR_USERS'
                       ref_field = 'FROM_DAT'
                       fieldname = 'FROM_DAT'
                       scrtext_l = 'Başlangıç Tarihi'
                       scrtext_m = 'Başlangıç Tarihi'
                       scrtext_s = 'Başlangıç T.').
    APPEND gs_fcat TO gt_fcat.

    CLEAR:gs_fcat.
    gs_fcat = VALUE #( col_pos   = 4
                       ref_table = 'AGR_USERS'
                       ref_field = 'TO_DAT'
                       fieldname = 'TO_DAT'
                       scrtext_l = 'Bitiş Tarihi'
                       scrtext_m = 'Bitiş Tarihi'
                       scrtext_s = 'Bitiş T.').
    APPEND gs_fcat TO gt_fcat.
*    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
*      EXPORTING
*        i_structure_name = 'MARA'
*      CHANGING
*        ct_fieldcat      = gt_fcat.
  ENDMETHOD.
  METHOD set_layout.
    gs_layout = VALUE #(  cwidth_opt = abap_true
                          col_opt    = abap_true
                          zebra      = abap_true  ).
  ENDMETHOD.
  METHOD display_alv.
    IF go_alv_grid IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.  " Name of the Screen CustCtrl Name to Link Container To
      CREATE OBJECT go_alv_grid
        EXPORTING
          i_parent = go_container.   " Parent Container
      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout   " Layout
        CHANGING
          it_outtab       = gt_alv   " Output Table
          it_fieldcatalog = gt_fcat.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
