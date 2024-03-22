*&---------------------------------------------------------------------*
*& Report ZGY_OOP_0001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_oop_0001.

CLASS lcl_class DEFINITION DEFERRED.
DATA:go_local TYPE REF TO lcl_class.

PARAMETERS:p_num1 TYPE i,
           p_num2 TYPE i.

CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      topla,
      cıkar.
    DATA:gv_toplam TYPE i,
         gv_fark   TYPE i.
ENDCLASS.

CLASS lcl_class IMPLEMENTATION.

  METHOD topla.
    gv_toplam = p_num1 + p_num2.
    WRITE:|Toplam:|,gv_toplam.
  ENDMETHOD.

  METHOD cikar.
    gv_fark = p_num1 - p_num2.
    WRITE:/,|Fark:|,gv_fark.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  go_local = NEW lcl_class( ).
  go_local->topla( ).
  go_local->cikar( ).
