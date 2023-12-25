*&---------------------------------------------------------------------*
*& Report ZGY_0008
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_0008.

DATA:gv_num TYPE i.

START-OF-SELECTION.
  DO 101 TIMES.
    IF gv_num MOD 2 EQ 0.
      WRITE:/,|Çift sayı:|,gv_num.
    ELSE.
      WRITE:|Tek sayı:|,gv_num.
    ENDIF.
    gv_num = gv_num + 1.
  ENDDO.
