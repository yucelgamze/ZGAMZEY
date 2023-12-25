class ZCL_ZGY_TABLET_V1_DPC_EXT definition
  public
  inheriting from ZCL_ZGY_TABLET_V1_DPC
  create public .

public section.
protected section.

  methods TABLETDATASET_CREATE_ENTITY
    redefinition .
  methods TABLETDATASET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGY_TABLET_V1_DPC_EXT IMPLEMENTATION.


  METHOD tabletdataset_create_entity.
**TRY.
*CALL METHOD SUPER->TABLETDATASET_CREATE_ENTITY
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

    TYPES: BEGIN OF gty_json,
             departman(100)       TYPE c,
             is_emri_no(10)       TYPE c,
             operasyon_adi(100)   TYPE c,
             siparis_tipi(50)     TYPE c,
             model_adi(100)       TYPE c,
             renk_adi(50)         TYPE c,
             beden(10)            TYPE c,
             baslama_saati        TYPE tims,
             standart_sure        TYPE tims,
             toplam_standart_sure TYPE tims,
             miktar(10)           TYPE c,
             demet_no(10)         TYPE c,
           END OF gty_json.

    DATA: json_tab TYPE TABLE OF gty_json.

    DATA: ls_entity TYPE zcl_zgy_tablet_v1_mpc=>ts_tabletdata,
          itab      TYPE TABLE OF zgy_t_0002,
          gs_tablet TYPE zgy_t_0002.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_entity
    ).

    DATA(lo_http) = NEW cl_http_utility( ).
    DATA(lv_json) = lo_http->decode_base64( encoded = ls_entity-value ).

    /ui2/cl_json=>deserialize(
      EXPORTING
        json             = lv_json
        pretty_name      = /ui2/cl_json=>pretty_mode-camel_case
      CHANGING
        data             = json_tab
    ).

    LOOP AT json_tab ASSIGNING FIELD-SYMBOL(<lfs_json_line>).
      MOVE-CORRESPONDING <lfs_json_line> TO gs_tablet.
      APPEND gs_tablet TO itab.
    ENDLOOP.

    INSERT zgy_t_0002 FROM TABLE itab.

*    BREAK-POINT.

  ENDMETHOD.


  METHOD tabletdataset_get_entityset.

    DATA: ls_entityset TYPE zcl_zgy_tablet_v1_mpc=>ts_tabletdata.

    SELECT * FROM zgy_t_0002
      INTO TABLE @DATA(lt_0002).

    IF sy-subrc EQ 0.

      LOOP AT lt_0002 ASSIGNING FIELD-SYMBOL(<lfs_0002>).
        MOVE-CORRESPONDING <lfs_0002> TO ls_entityset.

        APPEND ls_entityset TO et_entityset.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
