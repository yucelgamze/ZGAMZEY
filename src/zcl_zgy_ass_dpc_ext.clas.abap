class ZCL_ZGY_ASS_DPC_EXT definition
  public
  inheriting from ZCL_ZGY_ASS_DPC
  create public .

public section.
protected section.

  methods PO_HEADERSET_GET_ENTITY
    redefinition .
  methods PO_HEADERSET_GET_ENTITYSET
    redefinition .
  methods PO_ITEMSSET_GET_ENTITY
    redefinition .
  methods PO_ITEMSSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGY_ASS_DPC_EXT IMPLEMENTATION.


  METHOD po_headerset_get_entity.

    DATA:ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'PoNumber'.
    IF sy-subrc EQ 0.
      DATA(lv_po) = ls_key_tab-value.
    ENDIF.

*    SELECT SINGLE * FROM ekko INTO @DATA(ls_ekko)
*      WHERE ebeln EQ @lv_po.
*
*    IF sy-subrc EQ 0.
*      MOVE-CORRESPONDING ls_ekko TO er_entity.
*    ENDIF.

    CALL FUNCTION 'BAPI_PO_GETDETAIL'
      EXPORTING
        purchaseorder = lv_po
      IMPORTING
        po_header     = er_entity.
*     TABLES
*       PO_HEADER_TEXTS                  =
*       PO_ITEMS                         =


  ENDMETHOD.


  METHOD po_headerset_get_entityset.

    DATA:ls_entityset TYPE zcl_zgy_ass_mpc=>ts_po_header.
*
*    SELECT
*      ebeln,
*      bukrs,
*      bsart,
*      ernam,
*      lifnr
*      FROM ekko INTO TABLE @DATA(lt_ekko).
*
*    LOOP AT lt_ekko ASSIGNING FIELD-SYMBOL(<lfs_ekko>).
*      MOVE-CORRESPONDING <lfs_ekko> TO ls_entityset.
*      APPEND ls_entityset TO et_entityset.
*    ENDLOOP.

    DATA:ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'PoNumber'.
    IF sy-subrc EQ 0.
      DATA(lv_po) = ls_key_tab-value.
    ENDIF.

    CALL FUNCTION 'BAPI_PO_GETDETAIL'
      EXPORTING
        purchaseorder = lv_po
      IMPORTING
        po_header     = ls_entityset.
*     TABLES
*       PO_HEADER_TEXTS                  =
*       PO_ITEMS                         =

    APPEND ls_entityset TO et_entityset.

  ENDMETHOD.


  METHOD po_itemsset_get_entity.

*    DATA:ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.
*
*    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'PoNumber'.
*    IF sy-subrc EQ 0.
*      DATA(lv_po) = ls_key_tab-value.
*    ENDIF.

  ENDMETHOD.


  METHOD po_itemsset_get_entityset.

    DATA:ls_key_tab TYPE /iwbep/s_mgw_name_value_pair.

    READ TABLE it_key_tab INTO ls_key_tab WITH KEY name = 'PoNumber'.
    IF sy-subrc EQ 0.
      DATA(lv_po) = ls_key_tab-value.
    ENDIF.

    CALL FUNCTION 'BAPI_PO_GETDETAIL'
      EXPORTING
        purchaseorder = lv_po
        items         = 'X'
*     IMPORTING
*       PO_HEADER     =
      TABLES
        po_items      = et_entityset.

  ENDMETHOD.
ENDCLASS.
