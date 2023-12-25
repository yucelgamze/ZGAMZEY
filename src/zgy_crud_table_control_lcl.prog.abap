*&---------------------------------------------------------------------*
*& Include          ZGY_CRUD_TABLE_CONTROL_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      fill_inventory,
      add,
      update,
      delete,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm.
ENDCLASS.

CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.
    SELECT *
      FROM zgy_dil
      INTO CORRESPONDING FIELDS OF TABLE gt_dil.


  ENDMETHOD.

  METHOD fill_inventory.
    IF sy-stepl = 1.
      tc100-lines = tc100-top_line + sy-loopc - 1.
      MOVE-CORRESPONDING gs_dil TO zgy_dil.
    ENDIF.
  ENDMETHOD.

  METHOD add.
    READ TABLE gt_dil INTO gs_dil INDEX tc100-current_line.
    IF x EQ 'X'.
      gs_dil-userid = zgy_dil-userid.
      gs_dil-rus    = zgy_dil-rus.
      gs_dil-ita    = zgy_dil-ita.
      gs_dil-isp    = zgy_dil-isp.
      gs_dil-ing    = zgy_dil-ing.
      gs_dil-fra    = zgy_dil-fra.

      INSERT zgy_dil FROM gs_dil.
    ENDIF.
  ENDMETHOD.

  METHOD update.
    READ TABLE gt_dil INTO gs_dil INDEX tc100-current_line.
    IF x EQ 'X'.
      gs_dil-userid = zgy_dil-userid.
      gs_dil-rus    = zgy_dil-rus.
      gs_dil-ita    = zgy_dil-ita.
      gs_dil-isp    = zgy_dil-isp.
      gs_dil-ing    = zgy_dil-ing.
      gs_dil-fra    = zgy_dil-fra.

      MODIFY  zgy_dil FROM gs_dil.
    ENDIF.
  ENDMETHOD.

  METHOD delete.
    READ TABLE gt_dil INTO gs_dil INDEX tc100-current_line.
    IF x EQ 'X'.
      DELETE FROM zgy_dil WHERE userid EQ gs_dil-userid.
    ENDIF.
  ENDMETHOD.

  METHOD call_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS '0100'.
    SET TITLEBAR '0100'.
  ENDMETHOD.

  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&ADD'.
        go_local->add( ).
      WHEN '&UPDATE'.
        go_local->update( ).
      WHEN '&DELETE'.
        go_local->delete( ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
