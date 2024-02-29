class ZCL_ZGY_REST_0001_DPC_EXT definition
  public
  inheriting from ZCL_ZGY_REST_0001_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~DELETE_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_STREAM
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
  methods HEADERSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGY_REST_0001_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.
    DATA:ls_deep_entity TYPE zcl_zgy_rest_0001_mpc_ext=>ts_deep_entity,
         ls_header      TYPE zgy_t_0005,
         lt_item        TYPE TABLE OF zgy_t_0006.
    CASE iv_entity_set_name.
      WHEN 'OrderHeaderSet'.
        TRY.
            io_data_provider->read_entry_data(
              IMPORTING
                es_data = ls_deep_entity
            ).
          CATCH /iwbep/cx_mgw_tech_exception.    "
        ENDTRY.
        IF ls_deep_entity IS NOT INITIAL.
          ls_header = CORRESPONDING #( ls_deep_entity ).
          lt_item   = CORRESPONDING #( ls_deep_entity-orderheadertoitemnav ).
          MODIFY zgy_t_0005 FROM ls_header.
          MODIFY zgy_t_0006 FROM TABLE lt_item.
          copy_data_to_ref(
            EXPORTING
              is_data = ls_deep_entity
            CHANGING
              cr_data = er_deep_entity
          ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.
    DATA:ls_files TYPE zcl_zgy_rest_0001_mpc=>ts_files,
         ls_0007  TYPE zgy_t_0007.
    ls_0007 = VALUE #( BASE ls_0007
                        filename = iv_slug
                        value    = is_media_resource-value
                        mimetype = is_media_resource-mime_type
                        cdate    = sy-datum
                        ctime    = sy-uzeit ).
    INSERT zgy_t_0007 FROM ls_0007.
    ls_files-filename = iv_slug.
    copy_data_to_ref(
      EXPORTING
        is_data = ls_files
      CHANGING
        cr_data = er_entity
    ).
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~delete_stream.
    DATA:ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'Filename'.
    IF sy-subrc IS INITIAL.
      DATA(lv_filename) = ls_key_tab-value.
      DELETE FROM zgy_t_0007 WHERE filename = lv_filename.
    ENDIF.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.
    DATA:ls_paramater TYPE /iwbep/s_mgw_name_value_pair,
         ls_sumfunc   TYPE zcl_zgy_rest_0001_mpc=>ts_sumfunc,
         lv_num1      TYPE i,
         lv_num2       TYPE i,
         lv_result    TYPE i.
    CASE iv_action_name.
      WHEN 'SumFunction'.
        READ TABLE it_parameter INTO ls_paramater WITH KEY name = 'Number1'.
        IF sy-subrc IS INITIAL.
          lv_num1 = ls_paramater-value.
        ENDIF.
        READ TABLE it_parameter INTO ls_paramater WITH KEY name = 'Number2'.
        IF sy-subrc IS INITIAL.
          lv_num2 = ls_paramater-value.
        ENDIF.
        IF lv_num1 IS NOT INITIAL AND lv_num2 IS NOT INITIAL.
          lv_result = lv_num1 + lv_num2.

          ls_sumfunc-return = lv_result.

          copy_data_to_ref(
          EXPORTING
          is_data = ls_sumfunc
          CHANGING
          cr_data = er_data ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_expanded_entityset.
    DATA:lt_deep   TYPE TABLE OF zgy_s_0007,
         ls_deep   TYPE zgy_s_0007,
         lt_header TYPE TABLE OF zgy_s_0005,
         lt_item   TYPE TABLE OF zgy_s_0006.

    CASE iv_entity_set_name.
      WHEN 'OrderHeaderSet'.
        SELECT * UP TO 10 ROWS
        FROM vbak
        INTO CORRESPONDING FIELDS OF TABLE @lt_header.
        IF sy-subrc IS INITIAL.
          SELECT *
          FROM vbap
          FOR ALL ENTRIES IN @lt_header
          WHERE vbeln = @lt_header-vbeln
          INTO CORRESPONDING FIELDS OF TABLE @lt_item.
        ENDIF.

        LOOP AT lt_header INTO DATA(ls_header).
          CLEAR:ls_deep.
          ls_deep = CORRESPONDING #( ls_header ).
          LOOP AT lt_item INTO DATA(ls_item) WHERE vbeln = ls_header-vbeln.
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

    DATA:ls_stream  TYPE ty_s_media_resource,
         ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'Filename'.
    IF sy-subrc IS INITIAL.
      DATA(lv_filename) = ls_key_tab-value.
      SELECT SINGLE * FROM zgy_t_0007
      WHERE filename = @lv_filename
      INTO @DATA(ls_0007).
      IF sy-subrc IS INITIAL.
        ls_stream = CORRESPONDING #( ls_0007 ).
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
    DATA:ls_key_tab TYPE /iwbep/s_mgw_name_value_pair,
         ls_0007    TYPE zgy_t_0007.

    READ TABLE it_key_tab INTO ls_key_tab INDEX 1.
    IF sy-subrc IS INITIAL.
      ls_0007 = VALUE #( BASE ls_0007
                         filename = ls_key_tab-value
                         value    = is_media_resource-value
                         mimetype = is_media_resource-mime_type
                         cdate    = sy-datum
                         ctime    = sy-uzeit ).
      MODIFY zgy_t_0007 FROM ls_0007.
    ENDIF.
  ENDMETHOD.


  METHOD headerset_get_entityset.

*--------------------------------FILTER------------------------------------*
    DATA:lt_filter         TYPE /iwbep/t_mgw_select_option,
         ls_filter         TYPE /iwbep/s_mgw_select_option,
         ls_select_options TYPE /iwbep/s_cod_select_option.
*    DATA:lt_vbeln_r TYPE sd_vbeln_ranges,
*         ls_vbeln_r TYPE sdsls_vbeln_range.   "se11 den range tt bulunarak ya da type range of ile tanımlama yapılabilir
    DATA:lt_vbeln_r TYPE RANGE OF vbeln,
         ls_vbeln_r LIKE LINE OF lt_vbeln_r,
         lt_auart_r TYPE RANGE OF auart,
         ls_auart_r LIKE LINE OF lt_auart_r.
    lt_filter = io_tech_request_context->get_filter( )->get_filter_select_options( ).

    LOOP AT lt_filter INTO ls_filter.
      CASE ls_filter-property.
        WHEN 'VBELN'.
          LOOP AT ls_filter-select_options INTO ls_select_options.
            CLEAR:ls_vbeln_r.
            ls_vbeln_r = CORRESPONDING #( ls_select_options ).
            APPEND ls_vbeln_r TO lt_vbeln_r.
          ENDLOOP.
        WHEN 'AUART'.
          LOOP AT ls_filter-select_options INTO ls_select_options.
            CLEAR:ls_auart_r.
            ls_auart_r = CORRESPONDING #( ls_select_options ).
            APPEND ls_auart_r TO lt_auart_r.
          ENDLOOP.
      ENDCASE.
    ENDLOOP.
*--------------------------------FILTER------------------------------------*
    DATA:ls_entityset TYPE zcl_zgy_rest_0001_mpc=>ts_header.

    SELECT * "UP TO @is_paging-top ROWS
      FROM vbak
      ORDER BY vbeln
      INTO TABLE @DATA(lt_tab)
*      WHERE vbeln IN @lt_vbeln_r
*      AND   auart IN @lt_auart_r
      OFFSET @is_paging-skip UP TO @is_paging-top ROWS.

    LOOP AT lt_tab ASSIGNING FIELD-SYMBOL(<lfs_tab>).
      ls_entityset = CORRESPONDING #( <lfs_tab> ).
      APPEND ls_entityset TO et_entityset.
    ENDLOOP.

*--------------------------------ORDERBY------------------------------------*
    DATA(lt_orderby) = io_tech_request_context->get_orderby( ).
    DATA:lt_order TYPE /iwbep/t_mgw_sorting_order.
    lt_order = CORRESPONDING #( lt_orderby ).
    /iwbep/cl_mgw_data_util=>orderby(
      EXPORTING
        it_order = lt_order    " the sorting order
      CHANGING
        ct_data  = et_entityset
    ).
*--------------------------------ORDERBY------------------------------------*

**------------------------------HATA MESAJI--------------------------------------*
*    DATA(lr_msg_cont) = /iwbep/cl_mgw_msg_container=>get_mgw_msg_container( ).
*    DATA: lt_errors TYPE bapiret2_t,
*          ls_error  TYPE bapiret2.
*
*    ls_error-type    = 'E'.
*    ls_error-message = 'Deneme Hata'.
*    APPEND ls_error TO lt_errors.
*
*    lr_msg_cont->add_messages_from_bapi(
*       EXPORTING
*          it_bapi_messages = lt_errors
*          ).
*    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
*      EXPORTING
*        message_container = lr_msg_cont.
**------------------------------HATA MESAJI--------------------------------------*
  ENDMETHOD.


  METHOD orderheaderset_create_entity.
    DATA:ls_entity TYPE zcl_zgy_rest_0001_mpc=>ts_orderheader,
         ls_0004   TYPE zgy_t_0004.
    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_entity ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.
    IF ls_entity IS NOT INITIAL.
      ls_0004 = CORRESPONDING #( ls_entity ).
      INSERT zgy_t_0004 FROM ls_0004.
*      MODIFY zgy_t_0004 FROM ls_0004.
      IF sy-subrc IS INITIAL.
        er_entity = ls_entity.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD orderheaderset_delete_entity.
    DATA:ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'OrderNo'.
    IF sy-subrc IS INITIAL.
      DATA(lv_vbeln) = ls_key_tab-value.
      DELETE FROM zgy_t_0004 WHERE vbeln = lv_vbeln.
    ENDIF.
  ENDMETHOD.


  METHOD orderheaderset_get_entity.
    DATA:ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'OrderNo'.
    IF sy-subrc IS INITIAL.
      DATA(lv_vbeln) = ls_key_tab-value.

      SELECT SINGLE *
      FROM vbak
      WHERE vbeln = @lv_vbeln
      INTO @DATA(ls_tab).
      IF sy-subrc IS INITIAL.
        er_entity = CORRESPONDING #( ls_tab ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD orderheaderset_get_entityset.

    DATA:ls_entityset TYPE zcl_zgy_rest_0001_mpc=>ts_orderheader.

    SELECT * UP TO 10 ROWS FROM vbak
      INTO TABLE @DATA(lt_tab).

    LOOP AT lt_tab ASSIGNING FIELD-SYMBOL(<lfs_tab>).
      ls_entityset = CORRESPONDING #( <lfs_tab> ).
      APPEND ls_entityset TO et_entityset.
    ENDLOOP.
  ENDMETHOD.


  METHOD orderheaderset_update_entity.
    DATA:ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.
    DATA:ls_entity TYPE zcl_zgy_rest_0001_mpc=>ts_orderheader.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'OrderNo'.
    IF sy-subrc IS INITIAL.
      DATA(lv_vbeln) = ls_key_tab-value.
    ENDIF.
    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_entity ).
      CATCH /iwbep/cx_mgw_tech_exception.
    ENDTRY.

    IF lv_vbeln IS NOT INITIAL AND ls_entity IS NOT INITIAL.
      UPDATE zgy_t_0004 SET erdat = ls_entity-erdat
                            erzet = ls_entity-erzet
                            auart = ls_entity-auart    WHERE vbeln = lv_vbeln.
      IF sy-subrc IS INITIAL.
        er_entity = ls_entity.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
