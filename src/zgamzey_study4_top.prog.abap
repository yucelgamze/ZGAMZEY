*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_STUDY4_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.

TYPES:BEGIN OF gty_kazanan,
        gv_num1 TYPE int4,
        gv_num2 TYPE int4,
        gv_num3 TYPE int4,
        gv_num4 TYPE int4,
        gv_num5 TYPE int4,
        gv_num6 TYPE int4,
      END OF gty_kazanan.

TYPES:BEGIN OF gty_oynayan,
        gv_num1 TYPE int4,
        gv_num2 TYPE int4,
        gv_num3 TYPE int4,
        gv_num4 TYPE int4,
        gv_num5 TYPE int4,
        gv_num6 TYPE int4,
      END OF gty_oynayan.

DATA:gt_kazanan TYPE TABLE OF int4,
     gs_kazanan TYPE gty_kazanan,
     gt_oynayan TYPE TABLE OF gty_oynayan,
     gs_oynayan TYPE gty_oynayan,
     gv_bakiye  TYPE int4,
     gv_ekle    TYPE int4.

gv_bakiye = 500.
