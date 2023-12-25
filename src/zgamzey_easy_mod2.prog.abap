*&---------------------------------------------------------------------*
*& Report ZGAMZEY_EASY_MOD2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_easy_mod2.

DATA:gv_num TYPE i.

gv_num = 1.

WRITE:'İkiye bölünebilen sayılar:'.
DO 100 TIMES.
  IF  gv_num MOD 2 EQ 0.
    WRITE:gv_num,','.
  ENDIF.
  gv_num = gv_num + 1.
ENDDO.

gv_num = 1.
WRITE:/,'Üçe bölünebilen sayılar:'.
DO 100 TIMES.
  IF  gv_num MOD 3 EQ 0.
    WRITE:gv_num,','.
  ENDIF.
  gv_num = gv_num + 1.
ENDDO.

gv_num = 1.
WRITE:/,'Beşe bölünebilen sayılar:'.
DO 100 TIMES.
  IF  gv_num MOD 5 EQ 0.
    WRITE:gv_num,','.
  ENDIF.
  gv_num = gv_num + 1.
ENDDO.
