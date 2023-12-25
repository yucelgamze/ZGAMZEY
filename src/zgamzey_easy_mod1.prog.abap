*&---------------------------------------------------------------------*
*& Report ZGAMZEY_EASY_MOD1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_easy_mod1.

DATA: gv_num TYPE i.

gv_num = 0.

DO 100 TIMES.
  IF gv_num MOD 2 EQ 0.
    WRITE:/,'Çift sayı:',gv_num.
  ELSE.
    WRITE:/,'Tek sayı:',gv_num.
  ENDIF.
  gv_num = gv_num + 1.
ENDDO.
