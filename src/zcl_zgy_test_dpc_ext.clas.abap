class ZCL_ZGY_TEST_DPC_EXT definition
  public
  inheriting from ZCL_ZGY_TEST_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~DELETE_STREAM
    redefinition .
protected section.

  methods ORDERHEADERSET_CREATE_ENTITY
    redefinition .
  methods ORDERHEADERSET_DELETE_ENTITY
    redefinition .
  methods ORDERHEADERSET_GET_ENTITY
    redefinition .
  methods ORDERHEADERSET_GET_ENTITYSET
    redefinition .
  methods ORDERHEADERSET_UPDATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGY_TEST_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.

    DATA: ls_deep   TYPE zcl_zgy_test_mpc_ext=>ts_deep_entity,
          ls_header TYPE zgy_t_0005,
          lt_item   TYPE TABLE OF zgy_t_0006.

    CASE iv_entity_set_name.
      WHEN 'OrderHeaderSet'.
        TRY.
            io_data_provider->read_entry_data(
              IMPORTING
                es_data = ls_deep
            ).
          CATCH /iwbep/cx_mgw_tech_exception.
        ENDTRY.

        IF ls_deep IS NOT INITIAL.

          ls_header = CORRESPONDING #( ls_deep ).
          lt_item   = CORRESPONDING #( ls_deep-orderheadertoitemnav ).

          MODIFY zgy_t_0005 FROM ls_header.
          MODIFY zgy_t_0006 FROM TABLE lt_item.

          copy_data_to_ref(
            EXPORTING
              is_data = ls_deep
            CHANGING
              cr_data = er_deep_entity
          ).

        ENDIF.
    ENDCASE.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.

    DATA: ls_entity TYPE zcl_zgy_test_mpc=>ts_files.

    DATA: ls_file TYPE zgy_t_0007.

    ls_file-filename = iv_slug.
    ls_file-value    = is_media_resource-value.
    ls_file-mimetype = is_media_resource-mime_type.
    ls_file-cdate    = sy-datum.
    ls_file-ctime    = sy-uzeit.

    INSERT zgy_t_0007 FROM ls_file.

    ls_entity-filename = iv_slug.

    copy_data_to_ref(
      EXPORTING
        is_data = ls_entity
      CHANGING
        cr_data = er_entity
    ).

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~delete_stream.

    DATA: ls_key_tab  TYPE /iwbep/s_mgw_name_value_pair,
          lv_filename TYPE char100.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'Filename'.
    IF sy-subrc EQ 0.
      lv_filename = ls_key_tab-value.

      DELETE FROM zgy_t_0007 WHERE filename EQ lv_filename.
    ENDIF.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.
    DATA: lv_num1      TYPE i,
          lv_num2      TYPE i,
          lv_result    TYPE i,
          ls_parameter TYPE /iwbep/s_mgw_name_value_pair,
          ls_entity    TYPE zcl_zgy_test_mpc=>ts_sumnumbers.

    CASE iv_action_name.
      WHEN 'SumNumbersFunc'.
        READ TABLE it_parameter INTO ls_parameter WITH KEY name = 'Number1'.
        IF sy-subrc EQ 0.
          lv_num1 = ls_parameter-value.
        ENDIF.

        READ TABLE it_parameter INTO ls_parameter WITH KEY name = 'Number2'.
        IF sy-subrc EQ 0.
          lv_num2 = ls_parameter-value.
        ENDIF.

        IF lv_num1 IS NOT INITIAL AND lv_num2 IS NOT INITIAL.
          lv_result = lv_num1 + lv_num2.

          ls_entity-return = lv_result.

          copy_data_to_ref(
          EXPORTING
            is_data = ls_entity
          CHANGING
            cr_data = er_data ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_expanded_entityset.

    DATA: lt_deep   TYPE TABLE OF zgy_s_0007,
          ls_deep   TYPE zgy_s_0007,
          lt_header TYPE TABLE OF zgy_s_0005,
          ls_header TYPE zgy_s_0005,
          lt_item   TYPE TABLE OF zgy_s_0006,
          ls_item   TYPE zgy_s_0006.

    CASE iv_entity_set_name.
      WHEN 'OrderHeaderSet'.
        SELECT * UP TO 10 ROWS
          FROM vbak INTO CORRESPONDING FIELDS OF TABLE @lt_header.

        IF sy-subrc EQ 0.
          SELECT *
            FROM vbap FOR ALL ENTRIES IN @lt_header
            WHERE vbeln EQ @lt_header-vbeln
            INTO CORRESPONDING FIELDS OF TABLE @lt_item.
        ENDIF.

        LOOP AT lt_header INTO ls_header.
          CLEAR:ls_deep.
          MOVE-CORRESPONDING ls_header TO ls_deep.

          LOOP AT lt_item INTO ls_item WHERE vbeln = ls_header-vbeln.
            APPEND ls_item TO ls_deep-orderheadertoitemnav.
          ENDLOOP.

          APPEND ls_deep TO lt_deep.
        ENDLOOP.

        copy_data_to_ref(
          EXPORTING
            is_data = lt_deep
          CHANGING
            cr_data = er_entityset
        ).
    ENDCASE.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.

    DATA: ls_stream   TYPE ty_s_media_resource,
          lv_filename TYPE char100,
          ls_key_tab  TYPE /iwbep/s_mgw_name_value_pair.

*    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'Filename'.
    READ TABLE it_key_tab INTO ls_key_tab INDEX 1.
    IF sy-subrc EQ 0.

      lv_filename = ls_key_tab-value.

      SELECT SINGLE *
        FROM zgy_t_0007
        WHERE filename EQ @lv_filename
        INTO @DATA(ls_0007).

      IF sy-subrc EQ 0.
        ls_stream-mime_type = ls_0007-mimetype.
        ls_stream-value     = ls_0007-value.

        copy_data_to_ref(
          EXPORTING
            is_data = ls_stream
          CHANGING
            cr_data = er_stream
        ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~update_stream.

    DATA: ls_key_tab TYPE /iwbep/s_mgw_name_value_pair,
          ls_file    TYPE zgy_t_0007.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'Filename'.
    IF sy-subrc EQ 0.
      ls_file-filename  = ls_key_tab-value.
      ls_file-value     = is_media_resource-value.
      ls_file-mimetype  = is_media_resource-mime_type.
      ls_file-cdate     = sy-datum.
      ls_file-ctime     = sy-uzeit.

      MODIFY zgy_t_0007 FROM ls_file.

    ENDIF.
  ENDMETHOD.


  METHOD orderheaderset_create_entity.

    DATA: ls_data TYPE zcl_zgy_test_mpc=>ts_orderheader,
          ls_0004 TYPE zgy_t_0004.
    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data  = ls_data
        ).

        IF ls_data IS NOT INITIAL.
          MOVE-CORRESPONDING ls_data TO ls_0004.
          INSERT zgy_t_0004 FROM ls_0004.

          IF sy-subrc EQ 0.
            er_entity = ls_data.
          ENDIF.
        ENDIF.
   CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.
  ENDMETHOD.


  METHOD orderheaderset_delete_entity.
    DATA: ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'OrderNo'.
    IF sy-subrc EQ 0.
      DATA(lv_vbeln) = ls_key_tab-value.

      DELETE FROM zgy_t_0004 WHERE vbeln = lv_vbeln.
    ENDIF.
  ENDMETHOD.


METHOD orderheaderset_get_entity.

  DATA: ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.

  READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'OrderNo'.
  IF sy-subrc EQ 0.
    DATA(lv_vbeln) = ls_key_tab-value.

    SELECT SINGLE *
      FROM vbak
      INTO @DATA(ls_vbak)
      WHERE vbeln EQ @lv_vbeln.

    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING ls_vbak TO er_entity.
    ENDIF.
  ENDIF.

ENDMETHOD.


  METHOD orderheaderset_get_entityset.


*    DATA: ls_entityset LIKE LINE OF et_entityset.
    DATA: ls_entityset TYPE zcl_zgy_test_mpc=>ts_orderheader.

    DATA: lt_filter        TYPE /iwbep/t_mgw_select_option,
          ls_filter        TYPE /iwbep/s_mgw_select_option,
          ls_select_option TYPE /iwbep/s_cod_select_option.

*    DATA: lt_vbeln_r TYPE sd_vbeln_ranges,
*          ls_vbeln_r TYPE sdsls_vbeln_range.
    DATA: lt_vbeln_r TYPE RANGE OF vbeln,
          ls_vbeln_r LIKE LINE OF lt_vbeln_r,
          lt_auart_r TYPE RANGE OF auart,
          ls_auart_r LIKE LINE OF lt_auart_r.

    lt_filter = io_tech_request_context->get_filter( )->get_filter_select_options( ).

    LOOP AT lt_filter INTO ls_filter.
      CASE ls_filter-property.
        WHEN 'VBELN'.
          LOOP AT ls_filter-select_options INTO ls_select_option .
            CLEAR:ls_vbeln_r.
            MOVE-CORRESPONDING ls_select_option TO ls_vbeln_r.
            APPEND ls_vbeln_r TO lt_vbeln_r.
          ENDLOOP.
        WHEN 'AUART'.
          LOOP AT ls_filter-select_options INTO ls_select_option .
            CLEAR:ls_auart_r.
            MOVE-CORRESPONDING ls_select_option TO ls_auart_r.
            APPEND ls_auart_r TO lt_auart_r.
          ENDLOOP.
      ENDCASE.
    ENDLOOP.

    SELECT
    auart,
    erdat,
    erzet,
    vbeln
    "UP TO @is_paging-top ROWS
    FROM vbak
    ORDER BY vbeln
    INTO TABLE @DATA(lt_vbak)
*    WHERE vbeln IN @lt_vbeln_r
*    AND   auart IN @lt_auart_r
    OFFSET @is_paging-skip UP TO @is_paging-top ROWS .

    IF sy-subrc EQ 0.
      LOOP AT lt_vbak ASSIGNING FIELD-SYMBOL(<lfs_vbak>).
*        ls_entityset-auart = <lfs_vbak>-auart.
*        ls_entityset-erdat = <lfs_vbak>-erdat.
*        ls_entityset-erzet = <lfs_vbak>-erzet.
*        ls_entityset-vbeln = <lfs_vbak>-vbeln.
        MOVE-CORRESPONDING <lfs_vbak> TO ls_entityset.
        APPEND ls_entityset TO et_entityset.
      ENDLOOP.
    ENDIF.


    DATA(lt_orderby) = io_tech_request_context->get_orderby( ).
    DATA : lt_order TYPE /iwbep/t_mgw_sorting_order,
           ls_order TYPE /iwbep/s_mgw_sorting_order.

    LOOP AT lt_orderby INTO DATA(ls_orderby).
      MOVE-CORRESPONDING ls_orderby TO ls_order.
      APPEND ls_order TO lt_order.
    ENDLOOP.

    /iwbep/cl_mgw_data_util=>orderby(
      EXPORTING
        it_order = lt_order    " the sorting order
      CHANGING
        ct_data  = et_entityset
    ).


*    DATA(lr_msg_cont) = /iwbep/cl_mgw_msg_container=>get_mgw_msg_container( ).
*
*    DATA: lt_errors TYPE bapiret2_t,
*          ls_error  TYPE bapiret2.
*
*    ls_error-type = 'E'.
*    ls_error-message = 'Deneme hata'.
*    APPEND ls_error TO lt_errors.
*
*    lr_msg_cont->add_messages_from_bapi(
*       EXPORTING
*          it_bapi_messages = lt_errors
*    ).
*
*    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
*      EXPORTING
*        message_container = lr_msg_cont.

  ENDMETHOD.


  METHOD orderheaderset_update_entity.

    DATA: ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.
    DATA: ls_data TYPE zcl_zgy_test_mpc=>ts_orderheader.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'OrderNo'.
    IF sy-subrc EQ 0.
      DATA(lv_vbeln) = ls_key_tab-value.
    ENDIF.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_data
    ).

    IF lv_vbeln IS NOT INITIAL AND ls_data IS NOT INITIAL.
      UPDATE zgy_t_0004 SET auart = ls_data-auart
                            erdat = ls_data-erdat
                            erzet = ls_data-erzet WHERE vbeln = lv_vbeln.
    ENDIF.

    IF sy-subrc EQ 0.
      er_entity = ls_data.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
