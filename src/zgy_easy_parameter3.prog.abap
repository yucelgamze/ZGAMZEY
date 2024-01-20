*&---------------------------------------------------------------------*
*& Report ZGAMZEY_EASY_PARAMETER3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_easy_parameter3.

SELECTION-SCREEN BEGIN OF BLOCK a WITH FRAME TITLE TEXT-000.
PARAMETERS:
  p_user TYPE char10,
  p_pass TYPE i.
SELECTION-SCREEN END OF BLOCK a.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-name EQ 'P_PASS'.
      screen-invisible = 1.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.
  IF p_user EQ 'SAPUSER' AND p_pass EQ 12345678 .
    MESSAGE'Sisteme başarılı bir şekilde login oldunuz!' TYPE 'I' DISPLAY LIKE 'S'.
  ELSE.
    IF p_user NE 'SAPUSER'.
      MESSAGE'Hatalı  USER ID Girişi!' TYPE 'I' DISPLAY LIKE 'W'.
    ELSEIF p_pass NE 12345678.
      MESSAGE'Hatalı Parola Girişi!' TYPE 'I' DISPLAY LIKE 'W'.
    ENDIF.

  ENDIF.
