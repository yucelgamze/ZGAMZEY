*&---------------------------------------------------------------------*
*& Report ZGY_0011
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_0011.

PARAMETERS:p_num TYPE i.

START-OF-SELECTION.

  IF p_num BETWEEN 0 AND 20.
    WRITE:|Harf notunuz FF|.
  ELSEIF p_num BETWEEN 20 AND 40.
    WRITE:|Harf notunuz DD|.
  ELSEIF p_num BETWEEN 40 AND 60.
    WRITE:|Harf notunuz CC|.
  ELSEIF p_num BETWEEN 60 AND 80.
    WRITE:|Harf notunuz BB|.
  ELSEIF p_num BETWEEN 80 AND 100.
    WRITE:|Harf notunuz AA|.
  ENDIF.
