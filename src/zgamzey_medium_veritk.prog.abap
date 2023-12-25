*&---------------------------------------------------------------------*
*& Report ZGAMZEY_VERITK
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_veritk.

PARAMETERS:p_par TYPE char20.

DATA:gv_htype TYPE dd01v-datatype.

CALL FUNCTION 'NUMERIC_CHECK'
  EXPORTING
    string_in = p_par
  IMPORTING
    htype     = gv_htype.

IF gv_htype eq 'CHAR'.
  MESSAGE 'Sayısal olmayan bir değer girdiniz!' TYPE 'I' DISPLAY LIKE 'S'.
ELSEIF gv_htype eq 'NUMC'.
  MESSAGE 'Sayısal bir değer girdiniz!' TYPE 'I' DISPLAY LIKE 'S'.
ENDIF.
