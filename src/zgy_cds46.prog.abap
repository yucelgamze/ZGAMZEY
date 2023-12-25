*&---------------------------------------------------------------------*
*& Report zgy_cds46
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_cds46.

PARAMETERS:p_meins TYPE meins.

START-OF-SELECTION.

  SELECT * FROM zgy_ddl46( p_meins = @p_meins, p_mtart = '1000' )
  INTO TABLE @DATA(lt_table46).

  cl_demo_output=>display( lt_table46 ).
