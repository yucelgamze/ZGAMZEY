*&---------------------------------------------------------------------*
*& Report ZGY_0007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_0007.

DATA:i TYPE i,
     j TYPE i.

START-OF-SELECTION.

  DO 5 TIMES.
    WRITE:|*|.
    DO i TIMES.
      WRITE:|*|.
    ENDDO.
    WRITE:/.
    i = i + 1.
  ENDDO.
*i=5
  j = i - 2.

  DO i - 1 TIMES.
    WRITE:|*|.
    DO j TIMES.
      WRITE:|*|.
    ENDDO.
    WRITE:/.
    j = j - 1.
  ENDDO.
