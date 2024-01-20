*&---------------------------------------------------------------------*
*& Report ZGAMZEY_EASY_DO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_easy_do.

DATA:
  gv_satır TYPE i,
  gv_sutun TYPE i.

gv_satır = 5.
gv_sutun = 1.

DO gv_satır TIMES.
  DO gv_sutun TIMES.
    WRITE : '*'.
  ENDDO.
  gv_sutun = gv_sutun + 1.
  WRITE: /.
ENDDO.

gv_satır = 4.

DO  4 TIMES.
  Do gv_satır TIMES.
    WRITE: '*'.
  ENDDO.
gv_satır = gv_satır - 1.
WRITE: / .
ENDDO.
