*&---------------------------------------------------------------------*
*& Include          ZGAMZEY_STUDY4_LCL
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS:
      get_data,
      choose_winner,
      check,
      call_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm.
ENDCLASS.
CLASS lcl_class IMPLEMENTATION.
  METHOD get_data.

    CLEAR:gt_kazanan.

    DATA:lv_asal    TYPE int4,
         lv_random  TYPE int4,
         lv_index   TYPE int4,
         lv_kazanan TYPE int4 VALUE 1.

    DO 6 TIMES.

      CALL FUNCTION 'QF05_RANDOM_INTEGER'
        EXPORTING
          ran_int_max = 49
          ran_int_min = 1
        IMPORTING
          ran_int     = lv_random.

      "asal sayı için
      lv_index = 2.
      lv_asal  = lv_random.

      WHILE lv_index <= lv_random / 2.

        IF lv_random MOD lv_index EQ 0.
          lv_asal = 0.
          EXIT.
        ENDIF.
        lv_index = lv_index + 1.

      ENDWHILE.

      IF lv_asal NE 0 .
        lv_asal = lv_random.
      ENDIF.

      APPEND lv_random TO gt_kazanan.
    ENDDO.

    LOOP AT gt_kazanan ASSIGNING FIELD-SYMBOL(<gfs_kazanan>)..
      CASE lv_kazanan.
        WHEN  1.
          gs_kazanan-gv_num1 = <gfs_kazanan>.
        WHEN  2.
          gs_kazanan-gv_num2 = <gfs_kazanan>.
        WHEN  3.
          gs_kazanan-gv_num3 = <gfs_kazanan>.
        WHEN  4.
          gs_kazanan-gv_num4 = <gfs_kazanan>.
        WHEN  5.
          gs_kazanan-gv_num5 = <gfs_kazanan>.
        WHEN  6.
          gs_kazanan-gv_num6 = <gfs_kazanan>.
      ENDCASE.

      lv_kazanan = lv_kazanan + 1.

    ENDLOOP.

  ENDMETHOD.

  METHOD choose_winner.
    DATA:lv_index TYPE int4.

    LOOP AT gt_kazanan ASSIGNING FIELD-SYMBOL(<gfs_kazanan>).
      LOOP AT gt_oynayan ASSIGNING FIELD-SYMBOL(<gfs_oynayan>).

        CASE <gfs_kazanan>.
          WHEN <gfs_oynayan>-gv_num1.
            lv_index = lv_index + 1.
          WHEN <gfs_oynayan>-gv_num2.
            lv_index = lv_index + 1.
          WHEN <gfs_oynayan>-gv_num3.
            lv_index = lv_index + 1.
          WHEN <gfs_oynayan>-gv_num4.
            lv_index = lv_index + 1.
          WHEN <gfs_oynayan>-gv_num5.
            lv_index = lv_index + 1.
          WHEN <gfs_oynayan>-gv_num6.
            lv_index = lv_index + 1.
        ENDCASE.

      ENDLOOP.
    ENDLOOP.

    CLEAR:gt_oynayan.
    CLEAR:lv_index.

    APPEND gs_oynayan TO gt_oynayan.

    IF lv_index LE 1.
      gv_bakiye = gv_bakiye - 50.
    ELSE.
      gv_bakiye = gv_bakiye + ( lv_index * 50 ).
    ENDIF.
  ENDMETHOD.

  METHOD check.

    IF gv_bakiye LE 50.
      LOOP AT SCREEN.
        IF screen-group1 EQ 'A'.
          screen-active = 0.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.

      MESSAGE |BAKİYE YETERSİZ!| TYPE 'I' DISPLAY LIKE 'W'.
    ELSE.
      LOOP AT SCREEN.
        IF screen-group1 EQ 'A'.
          screen-active = 1.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
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
      WHEN '&PARA_EKLE'.
        IF  gv_ekle IS NOT INITIAL.
          gv_bakiye = gv_bakiye + gv_ekle.
          CLEAR:gv_ekle.
        ENDIF.
      WHEN '&SWEEPSTAKE'.
        go_local->check( ).
        IF gs_oynayan IS NOT INITIAL.
          go_local->get_data( ).
          go_local->choose_winner( ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.
