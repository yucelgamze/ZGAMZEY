*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_HARD9_MODULS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  go_local->pbo_0100( ).
  go_local->set_fieldcat( ).
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
