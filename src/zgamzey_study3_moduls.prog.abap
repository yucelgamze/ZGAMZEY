*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_STUDY2_MODULS
DATA zgamzey_study3_moduls.
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  go_local->get_data( ).
  go_local->pbo_0100( ).
  go_local->set_fcat( ).
  go_local->set_layout( ).
  go_local->display_alv( ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
 go_local->pai_0100( iv_ucomm = sy-ucomm ).
ENDMODULE.
