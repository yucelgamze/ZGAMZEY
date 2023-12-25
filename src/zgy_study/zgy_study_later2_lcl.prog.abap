*&---------------------------------------------------------------------*
*& Include          ZVKT_R_OOALV_CLS
*&---------------------------------------------------------------------*

CLASS lcl_report DEFINITION.
  PUBLIC SECTION.
    METHODS:
      screen_output,
      start_of_selection,
      get_data,
      get_report,
      print,
      smartform,
      adobeform,
      adobeform2,
      zpl,
      add_message IMPORTING iv_msg_type TYPE bapi_mtype
                            iv_msg_numb TYPE syst_msgno
                            iv_msg_id   TYPE syst_msgid
                            iv_par1     TYPE syst_msgv
                            iv_par2     TYPE syst_msgv
                            iv_par3     TYPE syst_msgv
                            iv_par4     TYPE syst_msgv
                  CHANGING  ct_return   TYPE bapirettab,
      prepare_alv,
      display_alv CHANGING cs_alvgird TYPE REF TO cl_gui_alv_grid
                           cs_layout  TYPE lvc_s_layo
                           cs_variant TYPE disvariant
                           ct_output  TYPE ANY TABLE
                           ct_fielcat TYPE lvc_t_fcat
                           ct_sort    TYPE lvc_t_sort
                           ct_exclude TYPE ui_functions,
      refresh_alv CHANGING cs_alvgird TYPE REF TO cl_gui_alv_grid,
      refresh_alv_2.

  PROTECTED SECTION.
    "ALV Tanımlamaları
    DATA: lv_cc            TYPE scrfname VALUE 'CC',
          lo_container     TYPE REF TO cl_gui_custom_container,
          lo_alvgrid       TYPE REF TO cl_gui_alv_grid,
          lt_fc            TYPE lvc_t_fcat,
          ls_layout        TYPE lvc_s_layo,
          ls_variant       TYPE disvariant,
          ls_stable        TYPE lvc_s_stbl,
          lt_exclude       TYPE ui_functions,
          lt_sort          TYPE lvc_t_sort,
          lt_selected_rows TYPE lvc_t_row,
          ls_selected_rows TYPE lvc_s_row,
          lv_lines         TYPE i.

  PRIVATE SECTION.
    METHODS:
      handle_data_changed  FOR EVENT data_changed   OF cl_gui_alv_grid IMPORTING er_data_changed,
      handle_hotspot_click FOR EVENT hotspot_click  OF cl_gui_alv_grid IMPORTING e_row_id
                                                                                   e_column_id
                                                                                   es_row_no,
      handle_toolbar       FOR EVENT toolbar        OF cl_gui_alv_grid IMPORTING e_object
                                                                                   e_interactive,
      handle_user_command  FOR EVENT user_command   OF cl_gui_alv_grid IMPORTING e_ucomm,
      clear_all,
      clear_alv,
      create_container    IMPORTING iv_cont_name TYPE scrfname
                          CHANGING  cs_container TYPE REF TO cl_gui_custom_container
                                    cs_alv_grid  TYPE REF TO cl_gui_alv_grid,
      create_container2   CHANGING  cs_alv_grid    TYPE REF TO cl_gui_alv_grid,
      create_layout       IMPORTING iv_title  TYPE lvc_title
                          EXPORTING es_layout TYPE lvc_s_layo,
      create_variant      IMPORTING iv_handle  TYPE slis_handl
                          EXPORTING es_variant TYPE disvariant,
      create_fcat         EXPORTING et_fc          TYPE lvc_t_fcat,
      modify_fcat         IMPORTING iv_field TYPE lvc_fname
                                    iv_text  TYPE string
                          CHANGING  ct_fc    TYPE lvc_t_fcat,
      modify_fcat_edit    IMPORTING iv_field TYPE lvc_fname
                          CHANGING  ct_fc    TYPE lvc_t_fcat,
      modify_fcat_no_out  IMPORTING iv_field TYPE lvc_fname
                          CHANGING  ct_fc    TYPE lvc_t_fcat,
      modify_fcat_hotspot IMPORTING iv_field TYPE lvc_fname
                          CHANGING  ct_fc    TYPE lvc_t_fcat,
      modify_fcat_chkbox  IMPORTING iv_field TYPE lvc_fname
                          CHANGING  ct_fc    TYPE lvc_t_fcat,
      modify_fcat_color   IMPORTING iv_field TYPE lvc_fname
                                    iv_color TYPE lvc_emphsz
                          CHANGING  ct_fc    TYPE lvc_t_fcat,
      exclude             IMPORTING iv_statu   TYPE char1
                          EXPORTING et_exclude TYPE ui_functions,
      sort_filter         IMPORTING iv_field       TYPE lvc_fname
                                    it_fc          TYPE lvc_t_fcat
                          CHANGING  ct_sort_filter TYPE lvc_t_sort,
      event_receiver      CHANGING cs_alvgird      TYPE REF TO cl_gui_alv_grid,
      get_tabname         IMPORTING iv_tabname     TYPE tabname.
ENDCLASS. "lcl_report DEFINITION

*----------------------------------------------------------------------*
* CLASS gcl_report IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_report IMPLEMENTATION.
  METHOD handle_data_changed.
*    DATA: ls_mod_cell  TYPE lvc_s_modi.
*    LOOP AT er_data_changed->mt_mod_cells INTO ls_mod_cell.
*      READ TABLE gt_output ASSIGNING FIELD-SYMBOL(<lfs_output>) INDEX ls_mod_cell-row_id.
*      IF sy-subrc = 0.
*        ASSIGN COMPONENT ls_mod_cell-fieldname OF STRUCTURE <lfs_output> TO FIELD-SYMBOL(<lfs_value>).
*        IF <lfs_value> IS ASSIGNED.
*          TRY .
*              <lfs_value> = ls_mod_cell-value.
*              IF  ls_mod_cell-fieldname EQ 'OMENG_S' AND
*                  <lfs_value> GT <lfs_output>-omeng.
*                MESSAGE i009(zsd_order) WITH <lfs_value> <lfs_output>-omeng DISPLAY LIKE 'E'.
*                <lfs_value>       = <lfs_output>-omeng.
*                EXIT.
*              ENDIF.
*              UNASSIGN <lfs_value>.
*            CATCH cx_root INTO DATA(lo_root).
*          ENDTRY.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.
  ENDMETHOD. "handle_data_changed

  METHOD handle_hotspot_click.
*    DATA: lv_tknum TYPE tknum.
*
*    CLEAR: lv_tknum.
*
*    CASE e_column_id.
*      WHEN 'TKNUM'.
***        READ TABLE gt_output INTO gs_output INDEX e_row_id.
***        IF sy-subrc EQ 0.
***
***        ENDIF.
*        lv_tknum =  VALUE #( gt_output[ e_row_id ]-tknum OPTIONAL ).
*        SET PARAMETER ID: 'TNR' FIELD lv_tknum.
*        CALL TRANSACTION 'VT03N' AND SKIP FIRST SCREEN.
*    ENDCASE.
  ENDMETHOD. "handle_hotspot_click

  METHOD handle_toolbar.
*    DATA: ls_toolbar  TYPE stb_button.
*    CLEAR ls_toolbar.
*
*    IF gv_tabname EQ gc_output.
*      MOVE   3          TO ls_toolbar-butn_type.
*      APPEND ls_toolbar TO e_object->mt_toolbar.
*
*      CLEAR ls_toolbar.
*      MOVE 'INS'            TO ls_toolbar-function.
*      MOVE icon_insert_row  TO ls_toolbar-icon.
*      MOVE TEXT-034         TO ls_toolbar-quickinfo.
*      MOVE TEXT-034         TO ls_toolbar-text.
*      MOVE ' '              TO ls_toolbar-disabled.
*      APPEND ls_toolbar     TO e_object->mt_toolbar.
*
*      CLEAR ls_toolbar.
*      MOVE 'DEL'            TO ls_toolbar-function.
*      MOVE icon_delete_row  TO ls_toolbar-icon.
*      MOVE  TEXT-035        TO ls_toolbar-quickinfo.
*      MOVE  TEXT-035        TO ls_toolbar-text.
*      MOVE ' '              TO ls_toolbar-disabled.
*      APPEND ls_toolbar     TO e_object->mt_toolbar.
*    ENDIF.
  ENDMETHOD. "handle_toolbar

  METHOD handle_user_command.
*    WAIT UP TO 1 SECONDS.
*    CASE e_ucomm.
*      WHEN 'INS'.
*        "Sat#r Ekle
*        me->add_order_get_data( ).
*      WHEN 'DEL'.
*        "Sat#r Sil
*        CLEAR:  lt_selected_rows,
*                ls_selected_rows,
*                lv_lines.
*
*        CALL METHOD lo_alvgrid->get_selected_rows
*          IMPORTING
*            et_index_rows = lt_selected_rows.
*
*        lv_lines = lines( lt_selected_rows ).
*        IF lv_lines EQ 0.
*          MESSAGE e010(zsd_order).
*        ENDIF.
*
*        LOOP AT lt_selected_rows INTO ls_selected_rows.
*          DELETE gt_output INDEX ls_selected_rows-index.
*        ENDLOOP.
*        me->refresh_alv_2( ).
*    ENDCASE.
  ENDMETHOD. "handle_user_command
  METHOD screen_output.
*    LOOP AT SCREEN.
*      IF p_r01 EQ abap_true.
*        CASE screen-group1.
*          WHEN 'M' OR 'M1'.
*            screen-active = 1.
*          WHEN 'M2'.
*            screen-active = 0.
*        ENDCASE.
*      ELSEIF p_r02 EQ abap_true.
*        CASE screen-group1.
*          WHEN 'M' OR 'M2'.
*            screen-active = 1.
*          WHEN 'M1'.
*            screen-active = 0.
*        ENDCASE.
*      ENDIF.
*      MODIFY SCREEN.
*    ENDLOOP.
  ENDMETHOD. "screen_output

  METHOD clear_all.
    CLEAR:    gv_tabname,
              gv_error,
              gs_return,
              gs_output.

    REFRESH:  gt_output,
              gt_return.
  ENDMETHOD."clear_all

  METHOD start_of_selection.
    me->clear_all( ).
    me->get_report( ).
  ENDMETHOD. "start_of_selection

  METHOD get_data.
    me->clear_all( ).

    SELECT *
      FROM vbak
      INTO TABLE @gt_output
      WHERE vbeln IN @s_vbeln
        AND ernam IN @s_ernam
        AND erdat IN @s_erdat.
  ENDMETHOD. "get_data

  METHOD get_report.
    me->get_data( ).

    IF gt_output IS NOT INITIAL.
      CALL SCREEN 0100.
    ELSE.
      MESSAGE s001(zbulent) DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.
  ENDMETHOD. "get_report

  METHOD print.
    DATA: lt_vbak TYPE vbak_t,
          lt_vbap TYPE vbap_t.

    DATA: lv_fm_name         TYPE rs38l_fnam,
          lv_fp_docparams    TYPE sfpdocparams,
          lv_fp_outputparams TYPE sfpoutputparams.


    REFRESH: lt_vbak,
             lt_vbap,
             lt_selected_rows.

    CLEAR: ls_selected_rows,
           lv_lines.

    CLEAR: lv_fm_name,
           lv_fp_docparams,
           lv_fp_outputparams.


    CALL METHOD lo_alvgrid->get_selected_rows
      IMPORTING
        et_index_rows = lt_selected_rows.

    DESCRIBE TABLE lt_selected_rows LINES lv_lines.

    CHECK: lv_lines GT 0 AND gt_output IS NOT INITIAL.

    LOOP AT lt_selected_rows INTO ls_selected_rows.
      READ TABLE gt_output INTO DATA(ls_out) INDEX ls_selected_rows-index.
      IF sy-subrc EQ 0.
        APPEND INITIAL LINE TO lt_vbak ASSIGNING FIELD-SYMBOL(<lfs_vbak>).
        <lfs_vbak> = CORRESPONDING #( BASE ( <lfs_vbak> ) ls_out ).
      ENDIF.
    ENDLOOP.

    CHECK lt_vbak IS NOT INITIAL.

    SELECT *
      FROM vbap AS vp
      INTO TABLE @lt_vbap
      FOR ALL ENTRIES IN @lt_vbak
      WHERE vp~vbeln EQ @lt_vbak-vbeln.


    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = lv_fp_outputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        i_name     = 'ZEGT_AF_ADOBE'
      IMPORTING
        e_funcname = lv_fm_name.

    CALL FUNCTION lv_fm_name
      EXPORTING
        /1bcdwb/docparams = lv_fp_docparams
        it_vbak           = lt_vbak
        it_vbap           = lt_vbap
*   IMPORTING
*       /1BCDWB/FORMOUTPUT       =
      EXCEPTIONS
        usage_error       = 1
        system_error      = 2
        internal_error    = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    CALL FUNCTION 'FP_JOB_CLOSE'
*   IMPORTING
*     E_RESULT             =
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.



  ENDMETHOD. "print

  METHOD smartform.
    DATA: lt_vbak TYPE vbak_t,
          ls_vbak TYPE vbak,
          lt_vbap TYPE zegt_s_0006_t.

    DATA : lv_formname TYPE tdsfname,
           lv_fm_name  TYPE rs38l_fnam.

    REFRESH: lt_vbak,
             lt_vbap,
             lt_selected_rows.

    CLEAR: ls_vbak.

    CLEAR: ls_selected_rows,
           lv_lines.

    CLEAR: lv_formname,
           lv_fm_name.

    CALL METHOD lo_alvgrid->get_selected_rows
      IMPORTING
        et_index_rows = lt_selected_rows.

    DESCRIBE TABLE lt_selected_rows LINES lv_lines.

    IF lv_lines NE 1.
      MESSAGE s011(zbulent) DISPLAY LIKE 'E'.
      EXIT.
    ELSE.

      LOOP AT lt_selected_rows INTO ls_selected_rows.
        READ TABLE gt_output INTO DATA(ls_out) INDEX ls_selected_rows-index.
        IF sy-subrc EQ 0.
          ls_vbak = CORRESPONDING #( BASE ( ls_vbak ) ls_out ).
        ENDIF.
      ENDLOOP.

      SELECT  vp~vbeln,
              vp~posnr,
              vp~matnr,
              mk~maktx,
              vp~netwr,
              vp~waerk
        FROM vbap AS vp
        LEFT OUTER JOIN makt AS mk ON vp~matnr EQ mk~matnr
                                  AND mk~spras EQ 'T'
        INTO TABLE @lt_vbap
        WHERE vp~vbeln EQ @ls_vbak-vbeln.

      CHECK ls_vbak IS NOT INITIAL AND lt_vbap IS NOT INITIAL.

      CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
        EXPORTING
          formname           = 'ZEGT_SF_0005' "Kullanılacak smartforms adı
        IMPORTING
          fm_name            = lv_fm_name
        EXCEPTIONS
          no_form            = 1
          no_function_module = 2
          OTHERS             = 3.


      CALL FUNCTION lv_fm_name
        EXPORTING
*         archive_index    = toa_dara
*         archive_parameters = arc_params
*         control_parameters = ls_control_param
*         mail_recipient   = ls_recipient
*         mail_sender      = ls_sender
*         output_options   = ls_composer_param
*         user_settings    = ' '
          is_vbak          = ls_vbak
          it_vbap          = lt_vbap
        EXCEPTIONS
          formatting_error = 1
          internal_error   = 2
          send_error       = 3
          user_canceled    = 4
          OTHERS           = 5.

    ENDIF.

  ENDMETHOD. "smartform

  METHOD adobeform.
    DATA: lt_vbak TYPE zgy_tt_0002,
          ls_vbak TYPE vbak,
          lt_vbap TYPE zgy_tt_0001.

    DATA: lv_fm_name         TYPE rs38l_fnam,
          lv_fp_docparams    TYPE sfpdocparams,
          lv_fp_outputparams TYPE sfpoutputparams.


    REFRESH: lt_vbak,
             lt_vbap,
             lt_selected_rows.

    CLEAR: ls_vbak.

    CLEAR: ls_selected_rows,
           lv_lines.

    CLEAR: lv_fm_name,
           lv_fp_docparams,
           lv_fp_outputparams.


    CALL METHOD lo_alvgrid->get_selected_rows
      IMPORTING
        et_index_rows = lt_selected_rows.

    DESCRIBE TABLE lt_selected_rows LINES lv_lines.

    IF lv_lines NE 1.
      MESSAGE |Lütfen bir satır seçiniz!| TYPE 'I' DISPLAY LIKE 'E'.
      EXIT.
    ELSE.

      CHECK: lv_lines GT 0 AND gt_output IS NOT INITIAL.

      LOOP AT lt_selected_rows INTO ls_selected_rows.
        READ TABLE gt_output INTO DATA(ls_out) INDEX ls_selected_rows-index.
        IF sy-subrc EQ 0.
          ls_vbak = CORRESPONDING #( BASE ( ls_vbak ) ls_out ).
        ENDIF.
      ENDLOOP.

      SELECT  vp~vbeln,
              vp~posnr,
              vp~matnr,
              mk~maktx,
              vp~netwr,
              vp~waerk
        FROM vbap AS vp
        LEFT OUTER JOIN makt AS mk ON vp~matnr EQ mk~matnr
                                  AND mk~spras EQ 'T'
        INTO TABLE @lt_vbap
        WHERE vp~vbeln EQ @ls_vbak-vbeln.

      CHECK ls_vbak IS NOT INITIAL AND lt_vbap IS NOT INITIAL.


      CALL FUNCTION 'FP_JOB_OPEN'
        CHANGING
          ie_outputparams = lv_fp_outputparams
        EXCEPTIONS
          cancel          = 1
          usage_error     = 2
          system_error    = 3
          internal_error  = 4
          OTHERS          = 5.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
        EXPORTING
          i_name     = 'ZGY_AF_0002'
        IMPORTING
          e_funcname = lv_fm_name.

      CALL FUNCTION lv_fm_name
        EXPORTING
          /1bcdwb/docparams = lv_fp_docparams
          is_vbak           = ls_vbak
          it_vbap           = lt_vbap
*   IMPORTING
*         /1BCDWB/FORMOUTPUT       =
        EXCEPTIONS
          usage_error       = 1
          system_error      = 2
          internal_error    = 3.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      CALL FUNCTION 'FP_JOB_CLOSE'
*   IMPORTING
*     E_RESULT             =
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    ENDIF.



  ENDMETHOD. "ADOBEFORM

  METHOD adobeform2.
    DATA: lt_vbak TYPE zgy_tt_0003.

    DATA: lv_fm_name         TYPE rs38l_fnam,
          lv_fp_docparams    TYPE sfpdocparams,
          lv_fp_outputparams TYPE sfpoutputparams.


    REFRESH: lt_vbak,
             lt_selected_rows.

    CLEAR: ls_selected_rows,
           lv_lines.

    CLEAR: lv_fm_name,
           lv_fp_docparams,
           lv_fp_outputparams.


    CALL METHOD lo_alvgrid->get_selected_rows
      IMPORTING
        et_index_rows = lt_selected_rows.

    DESCRIBE TABLE lt_selected_rows LINES lv_lines.

    IF lv_lines EQ 0.
      MESSAGE s006(zbulent) DISPLAY LIKE 'E'.
      EXIT.
    ELSE.

      CHECK: lv_lines GT 0 AND gt_output IS NOT INITIAL.

      LOOP AT lt_selected_rows INTO ls_selected_rows.
        READ TABLE gt_output INTO DATA(ls_out) INDEX ls_selected_rows-index.
        IF sy-subrc EQ 0.
          APPEND INITIAL LINE TO lt_vbak ASSIGNING FIELD-SYMBOL(<lfs_vbak>).
          <lfs_vbak> = CORRESPONDING #( BASE ( <lfs_vbak> ) ls_out ).
        ENDIF.
      ENDLOOP.

      CHECK lt_vbak IS NOT INITIAL.


      CALL FUNCTION 'FP_JOB_OPEN'
        CHANGING
          ie_outputparams = lv_fp_outputparams
        EXCEPTIONS
          cancel          = 1
          usage_error     = 2
          system_error    = 3
          internal_error  = 4
          OTHERS          = 5.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
        EXPORTING
          i_name     = 'ZGY_AF_0003'
        IMPORTING
          e_funcname = lv_fm_name.

      CALL FUNCTION lv_fm_name
        EXPORTING
          /1bcdwb/docparams = lv_fp_docparams
          it_vbak           = lt_vbak
*   IMPORTING
*         /1BCDWB/FORMOUTPUT       =
        EXCEPTIONS
          usage_error       = 1
          system_error      = 2
          internal_error    = 3.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.

      CALL FUNCTION 'FP_JOB_CLOSE'
*   IMPORTING
*     E_RESULT             =
        EXCEPTIONS
          usage_error    = 1
          system_error   = 2
          internal_error = 3
          OTHERS         = 4.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ENDIF.
    ENDIF.



  ENDMETHOD. "ADOBEFORM2

  METHOD zpl.
    DATA: ls_vbak TYPE vbak.

    DATA: lo_zpl     TYPE REF TO zcl_zpl,
          lv_success TYPE char1,
          lv_message TYPE char255.

    DATA : lv_tddest TYPE  rspopname.

    REFRESH: lt_selected_rows.

    CLEAR: ls_vbak.

    CLEAR: ls_selected_rows,
           lv_lines.

    CLEAR: lv_success,
           lv_message.

    CLEAR: lv_tddest.


    CALL METHOD lo_alvgrid->get_selected_rows
      IMPORTING
        et_index_rows = lt_selected_rows.

    DESCRIBE TABLE lt_selected_rows LINES lv_lines.

    IF lv_lines NE 1.
      MESSAGE s011(zbulent) DISPLAY LIKE 'E'.
      EXIT.
    ELSE.

      CHECK: lv_lines GT 0 AND gt_output IS NOT INITIAL.

      LOOP AT lt_selected_rows INTO ls_selected_rows.
        READ TABLE gt_output INTO DATA(ls_out) INDEX ls_selected_rows-index.
        IF sy-subrc EQ 0.
          ls_vbak = CORRESPONDING #( BASE ( ls_vbak ) ls_out ).
        ENDIF.
      ENDLOOP.

      CHECK ls_vbak IS NOT INITIAL.

      lo_zpl = NEW zcl_zpl( ).

      lo_zpl->device( IMPORTING ev_device = lv_tddest ).

      lo_zpl->print_sales_order( EXPORTING iv_device  = lv_tddest
                                           is_vbak    = ls_vbak
                                 IMPORTING ev_success = lv_success
                                           ev_message = lv_message ).

    ENDIF.

  ENDMETHOD. "ZPL

*  METHOD zpl.
*    DATA: lt_vbak TYPE vbak_t,
*          ls_vbak TYPE vbak,
*          lt_vbap TYPE zegt_s_0006_t.
*
*    DATA: lo_zpl     TYPE REF TO zcl_zpl_labels,
*          lv_success TYPE char1,
*          lv_message TYPE char255.
*
*    DATA : lt_fields TYPE TABLE OF sval,
*           ls_fields LIKE LINE OF lt_fields,
*           lv_tddest TYPE  rspopname.
*
*    REFRESH: lt_vbak,
*             lt_vbap,
*             lt_selected_rows.
*
*    CLEAR: ls_vbak.
*
*    CLEAR: ls_selected_rows,
*           lv_lines.
*
*    CLEAR: lv_success,
*           lv_message.
*
*    CLEAR: lt_fields,
*           ls_fields,
*           lv_tddest.
*
*
*    CALL METHOD lo_alvgrid->get_selected_rows
*      IMPORTING
*        et_index_rows = lt_selected_rows.
*
*    DESCRIBE TABLE lt_selected_rows LINES lv_lines.
*
*    IF lv_lines NE 1.
*      MESSAGE s011(zbulent) DISPLAY LIKE 'E'.
*      EXIT.
*    ELSE.
*
*      CHECK: lv_lines GT 0 AND gt_output IS NOT INITIAL.
*
*      LOOP AT lt_selected_rows INTO ls_selected_rows.
*        READ TABLE gt_output INTO DATA(ls_out) INDEX ls_selected_rows-index.
*        IF sy-subrc EQ 0.
*          ls_vbak = CORRESPONDING #( BASE ( ls_vbak ) ls_out ).
*        ENDIF.
*      ENDLOOP.
*
*      SELECT  vp~vbeln,
*              vp~posnr,
*              vp~matnr,
*              mk~maktx,
*              vp~netwr,
*              vp~waerk
*        FROM vbap AS vp
*        LEFT OUTER JOIN makt AS mk ON vp~matnr EQ mk~matnr
*                                  AND mk~spras EQ 'T'
*        INTO TABLE @lt_vbap
*        WHERE vp~vbeln EQ @ls_vbak-vbeln.
*
*      CHECK ls_vbak IS NOT INITIAL AND lt_vbap IS NOT INITIAL.
*
*      "yazıcı seçme işlemi
*      APPEND INITIAL LINE TO lt_fields ASSIGNING FIELD-SYMBOL(<lfs_fields>).
*      <lfs_fields>-tabname   = 'TSP03' .
*      <lfs_fields>-fieldname = 'PADEST' .
*      <lfs_fields>-field_obl = 'X' .
*
*      IF <lfs_fields> IS ASSIGNED.
*        UNASSIGN <lfs_fields>.
*      ENDIF.
*
*      CALL FUNCTION 'POPUP_GET_VALUES'
*        EXPORTING
*          popup_title     = 'Yazıcı seçiniz'
*          start_column    = '5'
*          start_row       = '5'
*        TABLES
*          fields          = lt_fields[]
*        EXCEPTIONS
*          error_in_fields = 1
*          OTHERS          = 2.
*      IF sy-subrc EQ 0.
*        read table lt_fields into ls_fields with key fieldname = 'PADEST'.
*        IF sy-subrc EQ 0.
*          lv_tddest = ls_fields-value.
*        ENDIF.
*      ENDIF.
*
*
*      lo_zpl = NEW zcl_zpl_labels( ).
*
*      lo_zpl->print_sales_order( EXPORTING iv_device  = lv_tddest
*                                           is_vbak    = ls_vbak
*                                 IMPORTING ev_success = lv_success
*                                           ev_message = lv_message ).
*
*    ENDIF.
*
*  ENDMETHOD. "ZPL

  METHOD add_message.
    DATA: ls_return TYPE bapiret2.
    CLEAR:  ls_return.
    CALL FUNCTION 'FS_BAPI_BAPIRET2_FILL'
      EXPORTING
        type   = iv_msg_type
        cl     = iv_msg_id
        number = iv_msg_numb
        par1   = iv_par1
        par2   = iv_par2
        par3   = iv_par3
        par4   = iv_par4
      IMPORTING
        return = ls_return.
    APPEND ls_return TO ct_return.
  ENDMETHOD. "add_message

  METHOD clear_alv.
    CLEAR:  lo_container,
            lo_alvgrid,
            ls_layout,
            ls_variant.
    REFRESH: lt_exclude.
    "lt_fc.

    FREE: lo_container,
          lo_alvgrid.

  ENDMETHOD. "clear_alv

  METHOD prepare_alv.
    IF lo_alvgrid IS INITIAL.
      me->get_tabname( iv_tabname = gc_output ).
      me->create_container( EXPORTING iv_cont_name = lv_cc
                            CHANGING  cs_container = lo_container
                                      cs_alv_grid  = lo_alvgrid ).
*      me->create_container2( CHANGING  cs_alv_grid  = lo_alvgrid ).
      me->create_layout(  EXPORTING iv_title       = TEXT-000
                          IMPORTING es_layout      = ls_layout ).
      me->create_variant( EXPORTING iv_handle      = 'A'
                          IMPORTING es_variant     = ls_variant ).
      me->create_fcat(    IMPORTING et_fc          = lt_fc ).
      me->exclude(        EXPORTING iv_statu       = abap_false
                          IMPORTING et_exclude     = lt_exclude ).
      me->event_receiver( CHANGING  cs_alvgird     = lo_alvgrid ).
      me->sort_filter(    EXPORTING iv_field       = 'VBELN'
                                    it_fc          = lt_fc
                           CHANGING ct_sort_filter = lt_sort ).
      me->display_alv(    CHANGING  cs_alvgird     = lo_alvgrid
                                    cs_layout      = ls_layout
                                    cs_variant     = ls_variant
                                    ct_output      = gt_output
                                    ct_fielcat     = lt_fc
                                    ct_sort        = lt_sort
                                    ct_exclude     = lt_exclude ).
    ELSE .
      me->refresh_alv( CHANGING  cs_alvgird = lo_alvgrid ).
    ENDIF.
  ENDMETHOD. "prepare_alv

  METHOD create_container.
*    CREATE OBJECT co_alv_grid
*      EXPORTING
*        i_parent = cl_gui_custom_container=>screen0.

    CREATE OBJECT cs_container
      EXPORTING
        container_name = iv_cont_name.

    CREATE OBJECT cs_alv_grid
      EXPORTING
        i_parent = cs_container.

  ENDMETHOD. "create_container

  METHOD create_container2.
    CREATE OBJECT cs_alv_grid
      EXPORTING
        i_parent = cl_gui_custom_container=>screen0.
  ENDMETHOD. "create_container2

  METHOD create_layout.
    es_layout-zebra       = abap_true.
    es_layout-smalltitle  = abap_true.
    es_layout-cwidth_opt  = abap_true.
    es_layout-sel_mode    = 'D'.
    es_layout-grid_title  = iv_title.
    es_layout-info_fname  = 'COLOR'."Style
  ENDMETHOD. "create_layout

  METHOD create_variant.
    es_variant-handle = iv_handle.
    es_variant-report = sy-repid.
  ENDMETHOD. "create_variant

  METHOD create_fcat.
    DATA: lv_text TYPE string,
          ls_fcat TYPE lvc_s_fcat.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = gv_tabname
      CHANGING
        ct_fieldcat            = et_fc
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc EQ 0.
      "field catalog ekranda göstermeme i#lemi
*      me->modify_fcat_no_out( EXPORTING iv_field = 'SELECT' CHANGING  ct_fc    = et_fc ).

      "field catalog hotspot
*      me->modify_fcat_hotspot( EXPORTING iv_field = 'TKNUM' CHANGING  ct_fc    = et_fc ).

      "field catalog tan#m de#i#tirme i#lemi
*      lv_text = TEXT-003.
*      me->modify_fcat( EXPORTING iv_field ='EDATU'
*                                 iv_text  = lv_text
*                       CHANGING  ct_fc    = et_fc ).
      "field catalog edite açma i#lemi
*      me->modify_fcat_edit( EXPORTING iv_field = 'DURUM' CHANGING  ct_fc    = et_fc ).
      "field catalog checkbox olarak gösterme i#lemi
*      me->modify_fcat_chkbox( EXPORTING iv_field = 'DURUM' CHANGING  ct_fc    = et_fc ).
      "field catalog hücre renklendirme
*      me->modify_fcat_color( EXPORTING  iv_field = 'ZTERM'
*                                        iv_color = 'C500'
*                             CHANGING   ct_fc    =  et_fc ).

    ENDIF.
  ENDMETHOD. "create_fcat
  METHOD modify_fcat.
    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
    IF sy-subrc EQ 0.
      <lfs_fc>-scrtext_s = iv_text.
      <lfs_fc>-scrtext_m = iv_text.
      <lfs_fc>-scrtext_l = iv_text.
      <lfs_fc>-reptext   = iv_text.
      <lfs_fc>-coltext   = iv_text.
      <lfs_fc>-col_opt   = abap_true.
    ENDIF.
  ENDMETHOD. "modify_fcat

  METHOD modify_fcat_edit.
    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
    IF sy-subrc EQ 0.
      <lfs_fc>-edit = abap_true.
    ENDIF.
  ENDMETHOD. "modify_fcat_edit

  METHOD modify_fcat_no_out.
    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
    IF sy-subrc EQ 0.
      <lfs_fc>-no_out = abap_true.
    ENDIF.
  ENDMETHOD. "modify_fcat_no_out

  METHOD modify_fcat_hotspot.
    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
    IF sy-subrc EQ 0.
      <lfs_fc>-hotspot = abap_true.
    ENDIF.
  ENDMETHOD. "modify_fcat_no_out

  METHOD modify_fcat_chkbox.
    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
    IF sy-subrc EQ 0.
      <lfs_fc>-checkbox = abap_true.
    ENDIF.
  ENDMETHOD. "modify_fcat_chkbox

  METHOD modify_fcat_color.
    READ TABLE ct_fc ASSIGNING FIELD-SYMBOL(<lfs_fc>) WITH KEY fieldname = iv_field.
    IF sy-subrc EQ 0.
      <lfs_fc>-emphasize = iv_color.
    ENDIF.
  ENDMETHOD. "modify_fcat_color

  METHOD exclude.
    REFRESH: et_exclude.

    IF iv_statu IS INITIAL.
      APPEND: cl_gui_alv_grid=>mc_fc_loc_insert_row         TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_delete_row         TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_move_row           TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_move_row           TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_cut                TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_copy_row           TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_copy               TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_paste              TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_paste_new_row      TO et_exclude,
              cl_gui_alv_grid=>mc_fc_loc_undo               TO et_exclude.
    ENDIF.
    APPEND: cl_gui_alv_grid=>mc_fc_loc_append_row           TO et_exclude,
            cl_gui_alv_grid=>mc_fc_views                    TO et_exclude,
            cl_gui_alv_grid=>mc_fc_view_crystal             TO et_exclude,
            cl_gui_alv_grid=>mc_fc_view_excel               TO et_exclude,
            cl_gui_alv_grid=>mc_fc_view_grid                TO et_exclude,
            cl_gui_alv_grid=>mc_fc_view_lotus               TO et_exclude,
            cl_gui_alv_grid=>mc_fc_col_invisible            TO et_exclude,
            cl_gui_alv_grid=>mc_fc_print                    TO et_exclude,
            cl_gui_alv_grid=>mc_fc_graph                    TO et_exclude,
            cl_gui_alv_grid=>mc_fc_info                     TO et_exclude.
  ENDMETHOD. "exclude

  METHOD sort_filter.
    REFRESH: ct_sort_filter.
    READ TABLE it_fc INTO DATA(ls_fc) WITH KEY fieldname = iv_field.
    IF sy-subrc EQ 0.
      ct_sort_filter = VALUE #( ( fieldname = ls_fc-fieldname spos = ls_fc-col_pos up = 'X') ).
    ENDIF.
  ENDMETHOD.  "sort_filter

  METHOD event_receiver.
    SET HANDLER me->handle_data_changed  FOR cs_alvgird.
    SET HANDLER me->handle_hotspot_click FOR cs_alvgird.
    SET HANDLER me->handle_toolbar       FOR cs_alvgird.
    SET HANDLER me->handle_user_command  FOR cs_alvgird.
  ENDMETHOD. "event_receiver

  METHOD display_alv.
    CALL METHOD cs_alvgird->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.

    CALL METHOD cs_alvgird->set_table_for_first_display
      EXPORTING
        is_layout            = cs_layout
        is_variant           = cs_variant
        i_save               = 'A'
        it_toolbar_excluding = ct_exclude
      CHANGING
        it_outtab            = ct_output
        it_fieldcatalog      = ct_fielcat
        it_sort              = lt_sort.

  ENDMETHOD. "display_alv

  METHOD refresh_alv.
    CLEAR: ls_stable.
    ls_stable-row = 'X'.
    ls_stable-col = 'X'.

    CALL METHOD cs_alvgird->refresh_table_display
      EXPORTING
        i_soft_refresh = ''
        is_stable      = ls_stable.
  ENDMETHOD. "refresh_alv

  METHOD refresh_alv_2.
    CLEAR: ls_stable.
    ls_stable-row = 'X'.
    ls_stable-col = 'X'.

    CALL METHOD lo_alvgrid->refresh_table_display
      EXPORTING
        i_soft_refresh = ''
        is_stable      = ls_stable.
  ENDMETHOD. "refresh_alv_2

  METHOD get_tabname.
    gv_tabname = iv_tabname.
  ENDMETHOD. "get_tabname

ENDCLASS. "lcl_report IMPLEMENTATION
