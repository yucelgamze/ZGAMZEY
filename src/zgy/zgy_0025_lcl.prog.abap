*&---------------------------------------------------------------------*
*& Include          ZGY_0025_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      tahmin,
      listeye_ekle.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max   = 100
        ran_int_min   = 0
      IMPORTING
        ran_int       = gv_random
      EXCEPTIONS
        invalid_input = 1
        OTHERS        = 2.
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
      WHEN '&T'.
*        go_local->get_data( ).
        go_local->tahmin( ).
    ENDCASE.
  ENDMETHOD.
  METHOD tahmin.
    IF gv_random EQ gv_tahmin.
      MESSAGE |Tebrikler doğru tahmin| TYPE 'I' DISPLAY LIKE 'S'.
      CLEAR:gv_liste.
    ELSE.
      IF gv_random GE gv_tahmin.
        MESSAGE |Daha büyük sayı girin| TYPE 'I'.
        go_local->listeye_ekle( ).
      ELSEIF gv_random LE gv_tahmin.
        MESSAGE |Daha küçük sayı girin| TYPE 'I'.
        go_local->listeye_ekle( ).
      ENDIF.
    ENDIF.
  ENDMETHOD.
  METHOD listeye_ekle.
    DATA:lv_tahminc TYPE char3,
         lv_listes  TYPE string.
    lv_tahminc = gv_tahmin.
    lv_listes = |{ gv_liste }| & |{ lv_tahminc }|.
    gv_liste = lv_listes.
  ENDMETHOD.
ENDCLASS.
