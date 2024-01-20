*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_ADVANCED4_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.

DATA:go_alv_grid  TYPE REF TO cl_gui_alv_grid,
     go_container TYPE REF TO cl_gui_custom_container,
     gt_fcat      TYPE lvc_t_fcat,
     gs_fcat      TYPE lvc_s_fcat,
     gs_layout    TYPE lvc_s_layo.

TABLES:ztree_t,zastok_t.
DATA:gt_tree  TYPE TABLE OF ztree_t,
     gt_astok TYPE TABLE OF zastok_t.

"c deki array gibi bir kullanım abap'ta structure yapısı içinde eşleşme yapılır.
TYPES: BEGIN OF gty_miktar,
         ana_malzeme TYPE matnr,
         miktar      TYPE labst,
       END OF gty_miktar.
DATA:gt_miktar TYPE TABLE OF gty_miktar,
     gs_miktar TYPE gty_miktar.


"dinamik
FIELD-SYMBOLS:<dyn_itab>      TYPE STANDARD TABLE, "table
              <dyn_structure>,                      "structure
              <fs>.                                 "field symbol
