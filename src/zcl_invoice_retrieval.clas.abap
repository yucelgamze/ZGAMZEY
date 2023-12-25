CLASS zcl_invoice_retrieval DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: ty_table_of_zgy_so_invoice_ite TYPE STANDARD TABLE OF zgy_so_invoice_item WITH DEFAULT KEY.
*ABAPDoc KULLANIMI:
    "! <p class="shorttext synchronized">Read items from DB</p>
    "! Method reads invoice items from database
    "! @parameter lt_result | <p class="shorttext synchronized">Table of invoice items</p>
    "!
    METHODS get_items_from_db
      RETURNING
        VALUE(lt_result) TYPE ty_table_of_zgy_so_invoice_ite.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_invoice_retrieval IMPLEMENTATION.

  METHOD get_items_from_db.

*    TYPES: BEGIN OF helper_type,
*             company_name   TYPE snwd_bpa-company_name,
*             gross_amount   TYPE snwd_so_inv_item-gross_amount,
*             currency_code  TYPE snwd_so_inv_item-currency_code,
*             payment_status TYPE snwd_so_inv_head-payment_status,
*           END OF helper_type.

*    DATA: lt_result TYPE STANDARD TABLE OF zgy_so_invoice_item.

    SELECT
       snwd_bpa~company_name,
       snwd_so_inv_item~gross_amount,
       snwd_so_inv_item~currency_code,
       snwd_so_inv_head~payment_status
     FROM
      snwd_so_inv_item
      JOIN snwd_so_inv_head ON snwd_so_inv_item~parent_key = snwd_so_inv_head~node_key
      JOIN snwd_bpa ON snwd_so_inv_head~buyer_guid = snwd_bpa~node_key
     WHERE
      snwd_so_inv_item~currency_code = 'USD'
     ORDER BY  snwd_bpa~company_name
     INTO TABLE @lt_result.

    LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<lfs_result>).
      CASE <lfs_result>-payment_status.
        WHEN 'P'.
          <lfs_result>-payment_status = abap_true.
        WHEN OTHERS.
          <lfs_result>-payment_status = abap_false.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
