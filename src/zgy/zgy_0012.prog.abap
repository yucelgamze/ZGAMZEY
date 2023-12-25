*&---------------------------------------------------------------------*
*& Report ZGY_0012
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_0012.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
PARAMETERS:p_user TYPE char10,
           p_pass TYPE i MODIF ID x.
SELECTION-SCREEN END OF BLOCK a.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 EQ 'X'.
      screen-invisible = 1.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.
  IF p_user EQ 'SAPUSER' AND p_pass EQ 12345678.
    WRITE:|Sisteme başarılı bir şekilde giriş yaptınız!|.
  ELSEIF p_user NE 'SAPUSER'.
    WRITE:|Hatalı User girişi yaptınız!|.
  ELSEIF p_pass NE 12345678.
    WRITE:|Hatalı Password!|.
  ENDIF.
