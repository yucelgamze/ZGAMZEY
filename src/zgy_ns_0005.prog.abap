*&---------------------------------------------------------------------*
*& Report ZGY_NS_0005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0005.

CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      topla IMPORTING iv_num1  TYPE i
                      iv_num2  TYPE i
            EXPORTING ev_sonuc TYPE i,

      topla_v2 IMPORTING iv_num1         TYPE i
                         iv_num2         TYPE i
               RETURNING VALUE(rv_sonuc) TYPE i.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD topla.
    ev_sonuc = iv_num1 + iv_num2.
  ENDMETHOD.
  METHOD topla_v2.
    rv_sonuc = iv_num1 + iv_num2.
  ENDMETHOD.
ENDCLASS.

DATA:go_local TYPE REF TO lcl_class.

DATA:gv_num1  TYPE i,
     gv_num2  TYPE i,
     gv_sonuc TYPE i.

START-OF-SELECTION.

  go_local = NEW lcl_class( ).

  gv_num1 = 24.
  gv_num2 = 20.

*  go_local->topla(
*    EXPORTING
*      iv_num1  = gv_num1
*      iv_num2  = gv_num2
*    IMPORTING
*      ev_sonuc = gv_sonuc
*  ).

*  go_local->topla(
*    EXPORTING
*      iv_num1  = gv_num1
*      iv_num2  = gv_num2
*    IMPORTING
*      ev_sonuc = DATA(lv_sonuc)
*  ).

*go_local->topla_v2(
*  EXPORTING
*    iv_num1  = gv_num1
*    iv_num2  = gv_num2
*  RECEIVING
*    rv_sonuc = DATA(lv_sonuc)
*).

  DATA(lv_sonuc) = go_local->topla_v2(
                       iv_num1  = gv_num1
                       iv_num2  = gv_num2
                   ).
  WRITE:/ 'Sonuç:', lv_sonuc.
