*&---------------------------------------------------------------------*
*& Report ZGY_0028
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_0028.

PARAMETERS:p_input TYPE char20.
DATA:gv_htype TYPE dd01v-datatype.

START-OF-SELECTION.

  CALL FUNCTION 'NUMERIC_CHECK'
    EXPORTING
      string_in = p_input
    IMPORTING
      htype     = gv_htype.

  IF gv_htype EQ 'CHAR'.
    MESSAGE |Sayısal olmayan bir değer girdiniz!| TYPE 'I' DISPLAY LIKE 'W'.
  ELSEIF gv_htype EQ 'NUMC'.
    MESSAGE |Sayısal bir değer girdiniz!| TYPE 'I' DISPLAY LIKE 'S'.
  ENDIF.
