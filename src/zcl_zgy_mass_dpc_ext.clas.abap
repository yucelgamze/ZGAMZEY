class ZCL_ZGY_MASS_DPC_EXT definition
  public
  inheriting from ZCL_ZGY_MASS_DPC
  create public .

public section.
protected section.

  methods MASSDATASET_CREATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGY_MASS_DPC_EXT IMPLEMENTATION.


  METHOD massdataset_create_entity.
**TRY.
*CALL METHOD SUPER->MASSDATASET_CREATE_ENTITY
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
             orderid(10)  TYPE c,
             customer(10) TYPE c,
             amount(10)   TYPE c,
           END OF gty_json.

    DATA: json_tab TYPE TABLE OF gty_json.

    DATA: ls_entity TYPE zcl_zgy_mass_mpc=>ts_massdata,
          itab      TYPE TABLE OF zgy_orders,
          gs_orders TYPE zgy_orders.

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
        data             = json_tab ).

    LOOP AT json_tab ASSIGNING FIELD-SYMBOL(<lfs_json_line>).
      MOVE-CORRESPONDING <lfs_json_line> TO gs_orders.
      APPEND gs_orders TO itab.
    ENDLOOP.

    INSERT zgy_orders FROM TABLE itab.

*    REPLACE ALL OCCURRENCES OF '#' IN lv_json WITH  ''.
*
*    cl_fdt_json=>json_to_data(
*      EXPORTING
*        iv_json = lv_json
*      CHANGING
*        ca_data = json_tab
*    ).

    BREAK-POINT.

*      CATCH /iwbep/cx_mgw_tech_exception.    "
  ENDMETHOD.
ENDCLASS.
