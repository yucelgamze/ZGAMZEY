*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_HARD5_LCL
*&---------------------------------------------------------------------*
CLASS local DEFINITION.
  PUBLIC SECTION.
    METHODS:
      call_screen,
      ekle,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm.
ENDCLASS.

CLASS local IMPLEMENTATION.
  METHOD call_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD ekle.
    IF gv_pernr IS NOT INITIAL AND
       gv_descp IS NOT INITIAL.

      go_personal->personal_kontrolu(
        EXPORTING
          iv_pernr   = gv_pernr   " Personel numarası
        IMPORTING
          ev_success = gv_success   " Seçme kutusu
          ev_message = gv_message   " İleti metni
      ).

      IF gv_success EQ 'X'.

        go_personal->personal_aktivite_ekle(
          EXPORTING
            iv_pernr    = gv_pernr " Personel numarası
            iv_act_date = sy-datum  " Tarih
            iv_descp    = gv_descp  " Aktivite Açıklama de
          IMPORTING
            ev_success  = gv_success   " Seçme kutusu
            ev_message  = gv_message  " İleti metni
        ).

        IF gv_success EQ 'X'.
          MESSAGE i000 DISPLAY LIKE 'S'.
        ELSE.
          MESSAGE gv_message TYPE 'I' DISPLAY LIKE 'E'.
        ENDIF.

      ELSE.
        MESSAGE gv_message TYPE 'I' DISPLAY LIKE 'E'.
      ENDIF.
    ELSE.
      MESSAGE i001 DISPLAY LIKE 'W'.
    ENDIF.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS '0100'.
    SET TITLEBAR '0100'.
  ENDMETHOD.

  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&EKLE'.
        go_local->ekle( ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
