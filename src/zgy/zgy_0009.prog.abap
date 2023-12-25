*&---------------------------------------------------------------------*
*& Report ZGY_0009
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_0009.

DATA:gv_num TYPE i.

START-OF-SELECTION.

  CLEAR:gv_num.
  WRITE:|2'ye tam bölünebilen sayılar:|.
  DO 101 TIMES.
    IF gv_num MOD 2 EQ 0.
      WRITE:gv_num,|,|.
    ENDIF.
    gv_num = gv_num + 1.
  ENDDO.

  CLEAR:gv_num.
  WRITE:/,|3'e tam bölünebilen sayılar:|.
  DO 101 TIMES.
    IF gv_num MOD 3 EQ 0.
      WRITE:gv_num,|,|.
    ENDIF.
    gv_num = gv_num + 1.

  ENDDO.

  CLEAR:gv_num.
  WRITE:/,|5'e tam bölünebilen sayılar:|.
  DO 101 TIMES.
    IF gv_num MOD 5 EQ 0.
      WRITE:gv_num,|,|.
    ENDIF.
    gv_num = gv_num + 1.
  ENDDO.
