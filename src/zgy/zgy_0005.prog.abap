*&---------------------------------------------------------------------*
*& Report ZGY_0005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_0005.

PARAMETERS:p_num TYPE i.

DATA:gv_result TYPE i VALUE 1,
     index     TYPE i VALUE 1.

DO p_num TIMES.
  gv_result = gv_result * index.
  index = index + 1.
ENDDO.

IF p_num EQ 0.
  WRITE:1.
ELSE.
  WRITE:gv_result.
ENDIF.
