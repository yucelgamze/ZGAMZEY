*&---------------------------------------------------------------------*
*& Report zgy_cds_example3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_cds_example3.

PARAMETERS:p_meins TYPE meins,
           p_mtart TYPE mtart.

START-OF-SELECTION.

  SELECT * FROM zgy_ddl_0015( p_meins = @p_meins, p_mtart = @p_mtart )
  INTO TABLE @DATA(lt_table).

  cl_demo_output=>display( lt_table ).
