*&---------------------------------------------------------------------*
*& Report ZGAMZEY_MEDIUM_PERS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_medium_pers.

*INCLUDE:
INCLUDE ZGY_MEDIUM_PERS_TOP.
*zgamzey_medium_pers_top,
INCLUDE ZGY_MEDIUM_PERS_LCL.
*zgamzey_medium_pers_class,
INCLUDE ZGY_MEDIUM_PERS_MDL.
*zgamzey_medium_pers_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
