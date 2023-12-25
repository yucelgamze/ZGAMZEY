*&---------------------------------------------------------------------*
*& Include          ZGY_CRUD_TABLE_CONTROL_MDL
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  go_local->get_data( ).
  go_local->pbo_0100( ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  go_local->pai_0100( iv_ucomm = sy-ucomm ).
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module FILL_INVENTORY OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE fill_inventory OUTPUT.
  go_local->fill_inventory( ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ADD  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE add INPUT.
  go_local->add( ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  UPDATE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE update INPUT.
  go_local->update( ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  DELETE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE delete INPUT.
  go_local->delete( ).
ENDMODULE.
