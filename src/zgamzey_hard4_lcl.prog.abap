*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_HARD4_LCL
*&---------------------------------------------------------------------*
CLASS local DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      call_func_f4_filename,
      download_excel,
      convert_excel,
      add_excel,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fieldcat,
      set_layout,
      display_alv.
ENDCLASS.

CLASS local IMPLEMENTATION.
  METHOD get_data.
    SELECT
      t1~envanter_ad,
      t2~adet,
      t2~cname,
      t2~cdate,
      t2~ctime
      FROM zenvanter_t AS t1
      INNER JOIN zenvanter_l_t AS t2
      ON t1~envanter_id EQ t2~envanter_id
      INTO TABLE @gt_env.
  ENDMETHOD.

  METHOD call_func_f4_filename.
    CALL FUNCTION 'F4_FILENAME'
      EXPORTING
        field_name = 'P_FILE'
      IMPORTING
        file_name  = p_file.

  ENDMETHOD.

  METHOD download_excel.
    "sscrfields ile butona gömülü metot.
    "Örnek excel butonuna tıklandığında, başlığında Envanter ID ve Adet yazan bir exceli bilgisayara indirecek.

    CALL METHOD cl_gui_frontend_services=>directory_browse
      CHANGING
        selected_folder = gv_folder.  " Folder Selected By User

    CONCATENATE gv_folder
                '\'
                sy-datum
                '-'
                sy-uzeit
                '.xls'
    INTO gv_filename.

    gs_header-line = 'ENVANTER ID'.
    APPEND gs_header TO gt_header.
    gs_header-line = 'ADET'.
    APPEND gs_header TO gt_header.

    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename              = gv_filename
        filetype              = 'ASC'
        write_field_separator = 'X'
      TABLES
        data_tab              = gt_itab
        fieldnames            = gt_header. "başlıkları doldurulan it
  ENDMETHOD.

  METHOD convert_excel.
    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
        i_line_header        = 'X'                      "başlıkları satır olarak almasın
        i_tab_raw_data       = gt_raw_data
        i_filename           = p_file
      TABLES
        i_tab_converted_data = gt_itab.
  ENDMETHOD.

  METHOD add_excel.
    DATA:lt_elist TYPE TABLE OF zenvanter_l_t,
         ls_elist TYPE zenvanter_l_t.

    SELECT
      t1~envanter_id,
      t2~adet
      FROM zenvanter_t AS t1
      LEFT JOIN zenvanter_l_t AS t2
      ON t1~envanter_id EQ t2~envanter_id
      FOR ALL ENTRIES IN @gt_itab
      WHERE t1~envanter_id EQ @gt_itab-envanter_id
      INTO TABLE @DATA(lt_mevcut).

    "excel'den girilen envanter_id (@gt_itab-envanter_id) envanter kodları tablosunda (t1) var mı

    ls_elist-cname = sy-uname.
    ls_elist-cdate = sy-datum.
    ls_elist-ctime = sy-uzeit.

    "Envanter ID doğruysa Envanter Listesi tablosunda önceden bu Envanter ID li kayıt var mı.
    "Eğer varsa tablosa var olan satırın adedini arttırılsın. Eğer yoksa yeni kayıt eklensin

    LOOP AT lt_mevcut INTO DATA(ls_mevcut).

      READ TABLE gt_itab INTO gs_itab WITH KEY envanter_id = ls_mevcut-envanter_id.

      IF ls_mevcut-adet IS NOT INITIAL.
        ls_elist-adet = ls_mevcut-adet + gs_itab-adet.
      ELSE.
        ls_elist-adet = gs_itab-adet.
      ENDIF.
      ls_elist-envanter_id = gs_itab-envanter_id.
      APPEND ls_elist TO lt_elist.
    ENDLOOP.
    MODIFY zenvanter_l_t FROM TABLE @lt_elist.

  ENDMETHOD.

  METHOD call_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS '0100'.
    SET TITLEBAR '0100'.
     go_local->get_data( ).
  ENDMETHOD.

  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
    ENDCASE.
  ENDMETHOD.

  METHOD set_fieldcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZENVANTERLIST_S'
      CHANGING
        ct_fieldcat      = gt_fieldcat.
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
          it_outtab       = gt_env " Output Table
          it_fieldcatalog = gt_fieldcat.  " Field Catalog
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
