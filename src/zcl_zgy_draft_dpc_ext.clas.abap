class ZCL_ZGY_DRAFT_DPC_EXT definition
  public
  inheriting from ZCL_ZGY_DRAFT_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_STREAM
    redefinition .
protected section.

  methods BELGESTRSET_CREATE_ENTITY
    redefinition .
  methods BELGESTRSET_GET_ENTITY
    redefinition .
  methods HEADERSET_CREATE_ENTITY
    redefinition .
  methods HEADERSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGY_DRAFT_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
**  EXPORTING
**    iv_action_name          =
**    it_parameter            =
**    io_tech_request_context =
**  IMPORTING
**    er_data                 =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    DATA:lv_number TYPE i.
    DATA:ls_entity TYPE zcl_zgy_draft_mpc=>ts_return.

    CASE iv_action_name.
      WHEN 'DemoFuncImport'.

        READ TABLE it_parameter INTO DATA(ls_parameter) WITH KEY name = 'Number'.

        IF sy-subrc EQ 0.
          lv_number = ls_parameter-value.
        ENDIF.

        CASE lv_number MOD 2.
          WHEN 0.
            ls_entity-message = 'Çift'.
          WHEN 1.
            ls_entity-message = 'Tek'.
        ENDCASE.

        copy_data_to_ref( EXPORTING is_data = ls_entity
                          CHANGING cr_data = er_data ).

    ENDCASE.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_expanded_entityset.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET
**  EXPORTING
**    iv_entity_name           =
**    iv_entity_set_name       =
**    iv_source_name           =
**    it_filter_select_options =
**    it_order                 =
**    is_paging                =
**    it_navigation_path       =
**    it_key_tab               =
**    iv_filter_string         =
**    iv_search_string         =
**    io_expand                =
**    io_tech_request_context  =
**  IMPORTING
**    er_entityset             =
**    et_expanded_clauses      =
**    et_expanded_tech_clauses =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    DATA:lt_deep TYPE TABLE OF zgy_s_deep,
         ls_deep TYPE zgy_s_deep,
         ls_item TYPE zgy_s_item,
         lt_item TYPE TABLE OF zgy_s_item.

    CASE iv_entity_set_name.

      WHEN 'Header2Set'.
        SELECT * FROM bkpf UP TO 2 ROWS
        INTO CORRESPONDING FIELDS OF TABLE lt_deep.

        LOOP AT lt_deep INTO ls_deep.
          SELECT * FROM bseg INTO CORRESPONDING FIELDS OF TABLE lt_item
          WHERE bukrs EQ ls_deep-bukrs
          AND   belnr EQ ls_deep-belnr
          AND   gjahr EQ ls_deep-gjahr.

          ls_deep-headertoitemnavigation = lt_item.
          MODIFY lt_deep FROM ls_deep.
        ENDLOOP.

        copy_data_to_ref( EXPORTING is_data = ls_deep
                          CHANGING  cr_data = er_entityset ).
    ENDCASE.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
**  EXPORTING
**    iv_entity_name          =
**    iv_entity_set_name      =
**    iv_source_name          =
**    it_key_tab              =
**    it_navigation_path      =
**    io_tech_request_context =
**  IMPORTING
**    er_stream               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    DATA:ls_stream TYPE ty_s_media_resource,
         ls_upload TYPE zfile.

    READ TABLE it_key_tab ASSIGNING FIELD-SYMBOL(<fs_key>) INDEX 1.

    DATA:lv_filename TYPE char30.
    lv_filename = <fs_key>-value.

    SELECT SINGLE * FROM zfile INTO ls_upload WHERE filename = lv_filename.

    IF ls_upload IS NOT INITIAL.
      ls_stream-value = ls_upload-value.
      ls_stream-mime_type = ls_upload-mimetype.

      copy_data_to_ref( EXPORTING is_data = ls_stream
                        CHANGING  cr_data = er_stream ).
    ENDIF.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~update_stream.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_MGW_APPL_SRV_RUNTIME~UPDATE_STREAM
*  EXPORTING
**    iv_entity_name          =
**    iv_entity_set_name      =
**    iv_source_name          =
*    IS_MEDIA_RESOURCE       =
**    it_key_tab              =
**    it_navigation_path      =
**    io_tech_request_context =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    DATA:lw_file TYPE zfile.
    READ TABLE it_key_tab ASSIGNING FIELD-SYMBOL(<fs_key>) INDEX 1.

    lw_file-filename = <fs_key>-value.
    lw_file-value    = is_media_resource-value.
    lw_file-mimetype = is_media_resource-mime_type.
    lw_file-sydate   = sy-datum.
    lw_file-sytime   = sy-uzeit.

    MODIFY zfile FROM lw_file.
  ENDMETHOD.


  method BELGESTRSET_CREATE_ENTITY.
**TRY.
*CALL METHOD SUPER->BELGESTRSET_CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  endmethod.


  METHOD belgestrset_get_entity.
**TRY.
*CALL METHOD SUPER->BELGESTRSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    DATA:lv_bukrs TYPE bukrs,
         lv_belnr TYPE belnr_d,
         lv_gjahr TYPE gjahr.

    LOOP AT it_key_tab INTO DATA(ls_key_tab).

      CASE ls_key_tab-name.
        WHEN 'Bukrs'.
          lv_bukrs = ls_key_tab-value.
        WHEN 'Belnr'.
          lv_belnr = ls_key_tab-value.
        WHEN 'Gjahr'.
          lv_gjahr = ls_key_tab-value.
        WHEN OTHERS.
      ENDCASE.

    ENDLOOP.

    IF sy-subrc IS INITIAL.
      SELECT SINGLE * INTO CORRESPONDING FIELDS OF @er_entity
        FROM zgy_t_draft
        WHERE bukrs EQ @lv_bukrs
        AND   belnr EQ @lv_belnr
        AND   gjahr EQ @lv_gjahr.
    ENDIF.
  ENDMETHOD.


  METHOD headerset_create_entity.
**TRY.
*CALL METHOD SUPER->HEADERSET_CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data                      =  er_entity
    ).
*      CATCH /iwbep/cx_mgw_tech_exception.    "
  ENDMETHOD.


  METHOD headerset_get_entityset.
**TRY.
*CALL METHOD SUPER->HEADERSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    DATA: ls_entity LIKE LINE OF  et_entityset.

    ls_entity-bukrs = '1001'.
    ls_entity-belnr = '1000000000'.
    ls_entity-gjahr = '2020'.
    APPEND ls_entity TO et_entityset.

*    DATA:ls_entityset TYPE zcl_zgy_draft_mpc=>ts_header.
*
*    "filter / order / key
*    DATA(lt_filter) = io_tech_request_context->get_filter( )->get_filter_select_options( ).
*
*    SELECT * INTO TABLE @DATA(lt_data)
*      FROM zgy_t_draft.
*
*    MOVE-CORRESPONDING lt_data TO et_entityset.

  ENDMETHOD.
ENDCLASS.
