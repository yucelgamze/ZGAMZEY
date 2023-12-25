*&---------------------------------------------------------------------*
*& Include          ZVKT_R_OOALV_MDL
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'STATUS_0100'.
  SET TITLEBAR 'TITLE_0100'.

  go_report->prepare_alv( ).
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CLEAR: gv_error.
  CASE sy-ucomm.
    WHEN '&F2' OR '&F3'.
      LEAVE TO SCREEN 0.
    WHEN '&F4'.
      LEAVE PROGRAM.
    WHEN '&F5'.
      IF go_report IS NOT INITIAL.
        go_report->get_data( ).
        go_report->refresh_alv_2( ).
      ENDIF.
    WHEN 'PRINT'.
      IF go_report IS NOT INITIAL.
        go_report->print( ).
      ENDIF.
    WHEN 'SMARTFORM'.
      IF go_report IS NOT INITIAL.
        go_report->smartform( ).
      ENDIF.
    WHEN 'ADOBEFORM'.
      IF go_report IS NOT INITIAL.
        go_report->adobeform( ).
      ENDIF.
    WHEN 'ADOBEFORM2'.
      IF go_report IS NOT INITIAL.
        go_report->adobeform2( ).
      ENDIF.
    WHEN 'ZPL'.
      IF go_report IS NOT INITIAL.
        go_report->zpl( ).
      ENDIF.
  ENDCASE.
ENDMODULE.
