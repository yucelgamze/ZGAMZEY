*&---------------------------------------------------------------------*
*& Report ZGY_0006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_0006.

DATA:index     TYPE i.

START-OF-SELECTION.

  DO 5 TIMES.
    WRITE:|*|.

    DO index TIMES.
      WRITE: |*|.
    ENDDO.

    WRITE: /.
    index = index + 1.
  ENDDO.
