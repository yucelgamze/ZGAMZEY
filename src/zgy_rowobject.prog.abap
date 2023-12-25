*&---------------------------------------------------------------------*
*& Report ZGY_ROWOBJECT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_rowobject.

SELECT * FROM spfli INTO TABLE @DATA(lt_spfli).

LOOP AT lt_spfli REFERENCE INTO DATA(lo_spfli).
  WRITE: / lo_spfli->cityfrom.
ENDLOOP.
