*&---------------------------------------------------------------------*
*& Include          ZGY_P_0017_LCL
*&---------------------------------------------------------------------*

CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    DATA:header_rows_count TYPE i,
         max_rows          TYPE i.
    METHODS:constructor.
    METHODS:
      upload CHANGING ct_data TYPE ANY TABLE,
      upload_xls,
      call_func,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      set_fcat,
      set_layout,
      display_alv.
  PRIVATE SECTION.
    DATA:lv_tot_components TYPE i.
    METHODS:
      do_upload
        IMPORTING
          iv_begin TYPE i
          iv_end   TYPE i
        EXPORTING
          rv_empty TYPE flag
        CHANGING
          ct_data  TYPE STANDARD TABLE.
ENDCLASS.

CLASS lcl_class IMPLEMENTATION.

  METHOD constructor.
*    max_rows = 9999.
    max_rows = 11368.
  ENDMETHOD.

  METHOD upload.
    DATA:lo_struct TYPE REF TO cl_abap_structdescr,
         lo_table  TYPE REF TO cl_abap_tabledescr,
         lt_comp   TYPE cl_abap_structdescr=>component_table.

    lo_table  ?= cl_abap_structdescr=>describe_by_data( ct_data ).
    lo_struct ?= lo_table->get_table_line_type( ).
    lt_comp    = lo_struct->get_components( ).

    lv_tot_components = lines( lt_comp ).

    DATA:lv_empty TYPE flag,
         lv_begin TYPE i,
         lv_end   TYPE i.

    lv_begin = header_rows_count + 1.
    lv_end   = max_rows.

    WHILE lv_empty IS INITIAL.
      do_upload(
        EXPORTING
          iv_begin = lv_begin
          iv_end   = lv_end
        IMPORTING
          rv_empty = lv_empty
        CHANGING
          ct_data  = ct_data
      ).
      lv_begin = lv_end + 1.
      lv_end   = lv_begin + max_rows.
    ENDWHILE.
  ENDMETHOD.

  METHOD do_upload.
    DATA:ls_data     TYPE alsmex_tabline,
         lv_tot_rows TYPE i,
         lv_packet   TYPE i.
    FIELD-SYMBOLS:<struc> TYPE any,
                  <field> TYPE any.
    CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
      EXPORTING
        filename                = p_file
        i_begin_col             = 1
        i_begin_row             = iv_begin
        i_end_col               = lv_tot_components
        i_end_row               = iv_end
      TABLES
        intern                  = gt_data
      EXCEPTIONS
        inconsistent_parameters = 1
        upload_ole              = 2
        OTHERS                  = 3.

    IF sy-subrc <> 0.
      rv_empty = 'X'.
      EXIT.
    ENDIF.

    LOOP AT gt_data INTO ls_data.
      AT NEW row.
        APPEND INITIAL LINE TO ct_data ASSIGNING <struc>.
      ENDAT.

      ASSIGN COMPONENT ls_data-col OF STRUCTURE <struc> TO <field>.
      IF sy-subrc IS INITIAL.
        <field> = ls_data-value.
      ENDIF.

      AT END OF row.
        IF <struc> IS NOT INITIAL.
          lv_tot_rows = lv_tot_rows + 1.
        ENDIF.
      ENDAT.
    ENDLOOP.

    lv_packet = iv_end - iv_begin.
    IF lv_tot_rows LT lv_packet.
      rv_empty = 'X'.
    ENDIF.

  ENDMETHOD.

  METHOD upload_xls.

    DATA:lt_raw TYPE truxs_t_text_data.
    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
        i_line_header        = abap_true
        i_tab_raw_data       = lt_raw
        i_filename           = p_file
      TABLES
        i_tab_converted_data = gt_xls
      EXCEPTIONS
        conversion_failed    = 1
        OTHERS               = 2.

  ENDMETHOD.
  METHOD call_func.

    DATA:lt_xls TYPE TABLE OF gty_xls.
    DATA:lv_partner         TYPE bu_partner,
         lv_contractaccount TYPE vkont_kk,
         lv_partn_cat       TYPE bu_type,
         ls_000000          TYPE zvkt_s_bp001,
         lv_mobtel          TYPE ad_tlnmbr,
         lt_msg             TYPE TABLE OF zvkt_s_bpmsg,
         ls_msg             TYPE zvkt_s_bpmsg,
         lt_mobile          TYPE zvkt_tt_telnum,
         ls_mobile          TYPE ad_tlnmbr,
         lt_telno           TYPE TABLE OF zvkt_t_telno,
         ls_telno           TYPE zvkt_t_telno.
    lt_xls = gt_xls.
*    SORT lt_xls BY partner.
*    DELETE ADJACENT DUPLICATES FROM lt_xls COMPARING partner.


    LOOP AT lt_xls ASSIGNING FIELD-SYMBOL(<lfs_xls>).

      CLEAR:ls_000000,
            ls_msg,
            gs_alv,
            lv_contractaccount,
            lv_partner
            .

*      lv_partner   = <lfs_xls>-partner.
      lv_partn_cat = <lfs_xls>-type.

      ls_000000 = CORRESPONDING #( <lfs_xls> ).

      ls_000000 = VALUE #( BASE ls_000000
                            langu    = 'T'
                            lastname = |LASTNAME|                "CHECK_FIELDS DA MUHATAP KİŞİYSE SOYAD KONTORLÜ !
                            bpext  = <lfs_xls>-bpext ).

      CASE ls_000000-type.
        WHEN 1.
          ls_000000-stcd2 = <lfs_xls>-taxnumxl.
        WHEN 2.
          ls_000000-stcd2 = <lfs_xls>-stcd2.
      ENDCASE.

      ls_000000-type = '2'.

*      CONDENSE ls_000000-region NO-GAPS.

*      SHIFT ls_000000-region RIGHT DELETING TRAILING space.
*      TRANSLATE ls_000000-region USING '0'.

      ls_000000-bpext = |{ ls_000000-bpext ALPHA = IN }|.

      lv_partn_cat = '2' .

      CALL FUNCTION 'Z_VKT_BP_CREATE_BUPA'
        EXPORTING
          i_partn_cat        = lv_partn_cat
          i_role_000000      = ls_000000
        IMPORTING
          ev_partner         = lv_partner
          ev_contractaccount = lv_contractaccount
        TABLES
          te_messages        = lt_msg.

*      IF sy-subrc IS INITIAL.
*        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
*      ENDIF.

*      READ TABLE lt_tab INTO DATA(ls_tab) WITH KEY vkont = ls_000000-bpext BINARY SEARCH.
*
*      LOOP AT lt_tab INTO DATA(ls_tab) WHERE vkont = ls_000000-bpext .
*        gs_alv = VALUE #( BASE gs_alv
*                 partner = ls_tab-gpart
*                 vkont   = ls_tab-vkont ).
*        APPEND gs_alv TO gt_alv.
*      ENDLOOP.

      gs_alv-partner = lv_partner.
      gs_alv-vkont = ls_000000-bpext.
      APPEND gs_alv TO gt_alv.

      LOOP AT gt_alv ASSIGNING FIELD-SYMBOL(<lfs_alv>) WHERE partner = lv_partner AND vkont = ls_000000-bpext.
        LOOP AT  lt_msg INTO ls_msg .
          <lfs_alv> = VALUE #( BASE gs_alv
                                type    = lv_partn_cat
                                message = ls_msg-message
                                cname   = sy-uname
                                cdatum  = sy-datum
                                ctime   = sy-uzeit ).
        ENDLOOP.
      ENDLOOP.

    ENDLOOP.



*    SELECT
*    vkont,
*    gpart
*    FROM fkkvkp
*    INNER JOIN @lt_xls AS lt ON lt~bpext = fkkvkp~vkont
*    GROUP BY vkont, gpart
*    ORDER BY vkont
*    INTO TABLE @DATA(lt_tab).       "sözleşme hesabı ve muhatap itab


    MODIFY zfica_t0008 FROM TABLE gt_alv.  "log itab

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
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZFICA_T0008'
      CHANGING
        ct_fieldcat      = gt_fcat.
  ENDMETHOD.
  METHOD set_layout.
    gs_layout = VALUE #( zebra      = abap_true
                         cwidth_opt = abap_true
                         col_opt    = abap_true ).
  ENDMETHOD.
  METHOD display_alv.
    IF go_alv_grid IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.
      CREATE OBJECT go_alv_grid
        EXPORTING
          i_parent = cl_gui_container=>screen0.
*          i_parent = go_container.
      CALL METHOD go_alv_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout
        CHANGING
          it_outtab       = gt_alv               " DEĞİŞECEK !!!!!!!!!!
          it_fieldcatalog = gt_fcat.
    ELSE.
      CALL METHOD go_alv_grid->refresh_table_display( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
