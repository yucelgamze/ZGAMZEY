*&---------------------------------------------------------------------*
*& Report ZGY_NS_0022
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0022.

*DATA:gv_col TYPE char10.
*
*gv_col = '0000001234'.
*
*WRITE gv_col.
*
*CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*  EXPORTING
*    input  = gv_col
*  IMPORTING
*    output = gv_col.
*
*WRITE / gv_col.

*--------------------------------------------------------------------*
DATA(lv_col) = '0000001234'.
WRITE lv_col.
WRITE:/ |{ lv_col ALPHA = OUT }|.

DATA:gv_col TYPE char10.
gv_col = '1234'.
WRITE / gv_col.
WRITE:/ |{ gv_col ALPHA = IN }|.
