class ZCL_ZGY_PO_DETAILS_DPC_EXT definition
  public
  inheriting from ZCL_ZGY_PO_DETAILS_DPC
  create public .

public section.
protected section.

  methods PO_HEADERSET_GET_ENTITYSET
    redefinition .
  methods PO_ITEMSSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGY_PO_DETAILS_DPC_EXT IMPLEMENTATION.


  METHOD po_headerset_get_entityset.

    DATA:ls_entityset TYPE zcl_zgy_po_details_mpc=>ts_po_header.

    DATA:ls_filter_so TYPE /iwbep/s_mgw_select_option,
         lt_so        TYPE /iwbep/t_cod_select_options.
    DATA:lv_ebeln TYPE ebeln.

    READ TABLE it_filter_select_options INTO ls_filter_so WITH KEY property = 'PoNumber'.
    IF sy-subrc EQ 0.
      lt_so = ls_filter_so-select_options[].

      READ TABLE lt_so INTO DATA(ls_so) INDEX 1.
      IF sy-subrc EQ 0.
        lv_ebeln = ls_so-low.
      ENDIF.

      CALL FUNCTION 'BAPI_PO_GETDETAIL'
        EXPORTING
          purchaseorder = lv_ebeln
        IMPORTING
          po_header     = ls_entityset.

      APPEND ls_entityset TO et_entityset.
      CLEAR:ls_entityset.
    ENDIF.


*    DATA:ls_entityset TYPE zcl_zgy_po_details_mpc=>ts_po_header.
*    DATA:lt_filter_so TYPE /iwbep/t_mgw_select_option.
*    DATA:ls_filter_so TYPE /iwbep/s_mgw_select_option,
*         lt_so        TYPE /iwbep/t_cod_select_options.
*
*    DATA:lt_ebeln_r TYPE RANGE OF ebeln,
*         ls_ebeln_r LIKE LINE OF lt_ebeln_r.
*
*    lt_filter_so = io_tech_request_context->get_filter( )->get_filter_select_options( ).
*
*    LOOP AT lt_filter_so INTO ls_filter_so.

*      CASE ls_filter_so-property.
*        WHEN 'EBELN'.

*          LOOP AT ls_filter_so-select_options INTO ls_so.

*            CLEAR:ls_ebeln_r.
*            MOVE-CORRESPONDING ls_so TO ls_ebeln_r.
*            APPEND ls_ebeln_r TO lt_ebeln_r.

*          ENDLOOP.
*      ENDCASE.
*    ENDLOOP.

  ENDMETHOD.


  METHOD po_itemsset_get_entityset.
    DATA:ls_entityset TYPE zcl_zgy_po_details_mpc=>ts_po_items.

    DATA:ls_filter_so TYPE /iwbep/s_mgw_select_option,
         lt_so        TYPE /iwbep/t_cod_select_options.
    DATA:lv_ebeln TYPE ebeln.

    READ TABLE it_filter_select_options INTO ls_filter_so WITH KEY property = 'PoNumber'.
    IF sy-subrc EQ 0.
      lt_so = ls_filter_so-select_options[].

      READ TABLE lt_so INTO DATA(ls_so) INDEX 1.
      IF sy-subrc EQ 0.
        lv_ebeln = ls_so-low.
      ENDIF.

      CALL FUNCTION 'BAPI_PO_GETDETAIL'
        EXPORTING
          purchaseorder = lv_ebeln
*         ITEMS         = 'X'
*  IMPORTING
*         PO_HEADER     =
        TABLES
          po_items      = et_entityset.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
