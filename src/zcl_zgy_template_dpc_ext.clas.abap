class ZCL_ZGY_TEMPLATE_DPC_EXT definition
  public
  inheriting from ZCL_ZGY_TEMPLATE_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_EXPANDED_ENTITYSET
    redefinition .
protected section.

  methods HEDIYESET_CREATE_ENTITY
    redefinition .
  methods HEDIYESET_DELETE_ENTITY
    redefinition .
  methods HEDIYESET_GET_ENTITY
    redefinition .
  methods HEDIYESET_GET_ENTITYSET
    redefinition .
  methods HEDIYESET_UPDATE_ENTITY
    redefinition .
  methods POHEADERSET_CREATE_ENTITY
    redefinition .
  methods POHEADERSET_DELETE_ENTITY
    redefinition .
  methods POHEADERSET_GET_ENTITY
    redefinition .
  methods POHEADERSET_GET_ENTITYSET
    redefinition .
  methods POHEADERSET_UPDATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGY_TEMPLATE_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.

    DATA:ls_deep   TYPE zcl_zgy_template_mpc_ext=>ts_deep_entity,
         ls_header TYPE zgy_t_0013,
         lt_item   TYPE TABLE OF zgy_t_0011.

    CASE iv_entity_set_name.
      WHEN 'POHeaderSet'.
        TRY.
            io_data_provider->read_entry_data(
              IMPORTING
                es_data = ls_deep ).
          CATCH /iwbep/cx_mgw_tech_exception.    "
        ENDTRY.

        IF ls_deep IS NOT INITIAL.

          ls_header = CORRESPONDING #( ls_deep ).
          lt_item   = CORRESPONDING #( ls_deep-poheadertoitemnav ).

          MODIFY zgy_t_0013 FROM ls_header.
          MODIFY zgy_t_0011 FROM TABLE lt_item.

          copy_data_to_ref(
            EXPORTING
              is_data = ls_deep
            CHANGING
              cr_data = er_deep_entity ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_expanded_entityset.
    DATA:lt_deep   TYPE TABLE OF zgy_s_0012,
         ls_deep   TYPE zgy_s_0012,
         lt_header TYPE TABLE OF zgy_s_0013,
         ls_header TYPE zgy_s_0013,
         lt_item   TYPE TABLE OF zgy_s_0011,
         ls_item   TYPE zgy_s_0011.

    CASE iv_entity_set_name.
      WHEN 'POHeaderSet'.
        SELECT * UP TO 10 ROWS FROM ekko
          INTO CORRESPONDING FIELDS OF TABLE @lt_header.

        IF sy-subrc EQ 0.
          SELECT * FROM ekpo
            FOR ALL ENTRIES IN @lt_header
            WHERE ebeln EQ @lt_header-ebeln
            INTO CORRESPONDING FIELDS OF TABLE @lt_item.
        ENDIF.

        LOOP AT lt_header INTO ls_header.
          CLEAR:ls_deep.
          MOVE-CORRESPONDING ls_header TO ls_deep.

          LOOP AT lt_item INTO ls_item WHERE ebeln = ls_header-ebeln.
            APPEND ls_item TO ls_deep-poheadertoitemnav.
          ENDLOOP.

          APPEND ls_deep TO lt_deep.
        ENDLOOP.

        copy_data_to_ref(
          EXPORTING
            is_data = lt_deep
          CHANGING
            cr_data = er_entityset ).
    ENDCASE.

*    CASE iv_entity_set_name.
*      WHEN 'POHeaderSet'.
*        SELECT *  FROM zgy_t_0013
*          INTO CORRESPONDING FIELDS OF TABLE @lt_header.
*
*        IF sy-subrc EQ 0.
*          SELECT * FROM zgy_t_0011
*            FOR ALL ENTRIES IN @lt_header
*            WHERE ebeln EQ @lt_header-ebeln
*            INTO CORRESPONDING FIELDS OF TABLE @lt_item.
*        ENDIF.
*
*        LOOP AT lt_header INTO ls_header.
*          CLEAR:ls_deep.
*          MOVE-CORRESPONDING ls_header TO ls_deep.
*
*          LOOP AT lt_item INTO ls_item WHERE ebeln = ls_header-ebeln.
*            APPEND ls_item TO ls_deep-poheadertoitemnav.
*          ENDLOOP.
*
*          APPEND ls_deep TO lt_deep.
*        ENDLOOP.
*
*        copy_data_to_ref(
*          EXPORTING
*            is_data = lt_deep
*          CHANGING
*            cr_data = er_entityset ).
*    ENDCASE.
  ENDMETHOD.


  METHOD hediyeset_create_entity.
    TRY.
        DATA:ls_entity TYPE zcl_zgy_template_mpc=>ts_hediye,
             ls_0010   TYPE zgy_t_0010.

        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_entity
        ).

        IF ls_entity IS NOT INITIAL.
          MOVE-CORRESPONDING ls_entity TO ls_0010.
          INSERT zgy_t_0010 FROM ls_0010.

          IF sy-subrc EQ 0.
            er_entity = ls_entity.
          ENDIF.
        ENDIF.
      CATCH /iwbep/cx_mgw_tech_exception.    "
    ENDTRY.
  ENDMETHOD.


  METHOD hediyeset_delete_entity.
    DATA:ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'HediyeAd'.
    IF sy-subrc EQ 0.
      DATA(lv_ad) = ls_key_tab-value.
    ENDIF.

    DELETE FROM zgy_t_0010 WHERE hediye_ad EQ lv_ad.

  ENDMETHOD.


  METHOD hediyeset_get_entity.
    DATA:ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'HediyeAd'.
    IF sy-subrc EQ 0.
      DATA(lv_ad) = ls_key_tab-value.
    ENDIF.

    SELECT SINGLE * FROM zgy_t_0010
      INTO @DATA(ls_0010)
      WHERE hediye_ad EQ @lv_ad.

    IF sy-subrc EQ 0.
      MOVE-CORRESPONDING ls_0010 TO er_entity.
    ENDIF.
  ENDMETHOD.


  METHOD hediyeset_get_entityset.
    DATA:ls_entityset TYPE zcl_zgy_template_mpc=>ts_hediye.

    SELECT * FROM zgy_t_0010
      INTO TABLE @DATA(lt_0010).

    LOOP AT lt_0010 ASSIGNING FIELD-SYMBOL(<lfs_0010>).
      MOVE-CORRESPONDING <lfs_0010> TO ls_entityset.
      APPEND ls_entityset TO et_entityset.
    ENDLOOP.
  ENDMETHOD.


  METHOD hediyeset_update_entity.
    DATA:ls_key_tab TYPE /iwbep/s_mgw_name_value_pair,
         ls_entity  TYPE zcl_zgy_template_mpc=>ts_hediye.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'HediyeAd'.
    IF sy-subrc EQ 0.
      DATA(lv_ad) = ls_key_tab-value.
    ENDIF.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_entity
    ).

    IF ls_entity IS NOT INITIAL AND lv_ad IS NOT INITIAL.
      UPDATE zgy_t_0010 SET hediye_ad      = ls_entity-hediye_ad
                            hediye_renk    = ls_entity-hediye_renk
                            hediye_alan    = ls_entity-hediye_alan
                            hediye_verilen = ls_entity-hediye_verilen WHERE hediye_ad EQ lv_ad.
    ENDIF.

*    IF ls_entity IS NOT INITIAL AND lv_ad IS NOT INITIAL.
*      DATA:ls_0010 TYPE zgy_t_0010.
*      MOVE-CORRESPONDING ls_entity TO ls_0010.
*      MODIFY zgy_t_0010 FROM ls_entity.
*    ENDIF.

    IF sy-subrc EQ 0.
      er_entity = ls_entity.
    ENDIF.

  ENDMETHOD.


  METHOD poheaderset_create_entity.
    TRY.
        DATA:ls_entity TYPE zcl_zgy_template_mpc=>ts_poheader,
             ls_0013   TYPE zgy_t_0013.

        io_data_provider->read_entry_data(
          IMPORTING
            es_data  = ls_entity ).

        IF ls_entity IS NOT INITIAL.
          MOVE-CORRESPONDING ls_entity TO ls_0013.
          INSERT zgy_t_0013 FROM ls_0013.

          IF sy-subrc EQ 0.
            er_entity = ls_entity.
          ENDIF.
        ENDIF.
      CATCH /iwbep/cx_mgw_tech_exception.    "
    ENDTRY.
  ENDMETHOD.


  METHOD poheaderset_delete_entity.
    DATA:ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'Ebeln'.
    IF sy-subrc EQ 0.
      DATA(lv_ebeln) = ls_key_tab-value.

      DELETE FROM zgy_t_0013 WHERE ebeln EQ lv_ebeln.
    ENDIF.
  ENDMETHOD.


  METHOD poheaderset_get_entity.
    DATA:ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.
    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'Ebeln'.
    IF sy-subrc EQ 0.
      DATA(lv_ebeln) = ls_key_tab-value.

      SELECT SINGLE * FROM ekko INTO @DATA(ls_ekko)
        WHERE ebeln EQ @lv_ebeln.

      IF sy-subrc EQ 0.
        MOVE-CORRESPONDING ls_ekko TO er_entity.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD poheaderset_get_entityset.
    DATA:ls_entityset TYPE zcl_zgy_template_mpc=>ts_poheader.

    SELECT
      ebeln,
      bukrs,
      aedat,
      ernam FROM ekko INTO TABLE @DATA(lt_ekko).

    LOOP AT lt_ekko ASSIGNING FIELD-SYMBOL(<lfs_ekko>).
      MOVE-CORRESPONDING <lfs_ekko> TO ls_entityset.
      APPEND ls_entityset TO et_entityset.
    ENDLOOP.
  ENDMETHOD.


  METHOD poheaderset_update_entity.
    DATA:ls_entity  TYPE zcl_zgy_template_mpc=>ts_poheader,
         ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.
    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'Ebeln'.
    IF sy-subrc EQ 0.
      DATA(lv_ebeln) = ls_key_tab-value.

      io_data_provider->read_entry_data(
        IMPORTING
          es_data = ls_entity ).

      IF lv_ebeln IS NOT INITIAL AND ls_entity IS NOT INITIAL.
        UPDATE zgy_t_0013 SET ebeln = ls_entity-ebeln
                              bukrs = ls_entity-bukrs
                              aedat = ls_entity-aedat
                              ernam = ls_entity-ernam WHERE ebeln EQ lv_ebeln.
      ENDIF.

      IF sy-subrc EQ 0.
        er_entity = ls_entity.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
