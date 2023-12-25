*&---------------------------------------------------------------------*
*& Report ZGY_NS_0019
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0019.

*DATA:gv_output TYPE string.
*
**CONCATENATE 'Hello' 'World' INTO gv_output.
*CONCATENATE 'Hello' 'World' INTO gv_output SEPARATED BY space.
*WRITE gv_output.

*DATA(lv_output) = |pazartesi| & | | & |kulak çekme partisi|.

DATA(lv_string) = |bugün|.
DATA(lv_output) = |{ lv_string }| & | | & |pazartesi| & | | & |kulak çekme partisi|.

WRITE:/ lv_output.
