*&---------------------------------------------------------------------*
*& Report ZGAMZEY_BONUS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_medium_bonus.

*INCLUDE:
INCLUDE ZGY_MEDIUM_BONUS_TOP.
*zgamzey_medium_bonus_top,
INCLUDE ZGY_MEDIUM_BONUS_LCL.
*zgamzey_medium_bonus_class,
INCLUDE ZGY_MEDIUM_BONUS_MDL.
*zgamzey_medium_bonus_moduls.


START-OF-SELECTION.
  CREATE OBJECT go_local.
  go_local->get_data( ).
  go_local->call_screen( ).
