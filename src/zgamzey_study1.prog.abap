*&---------------------------------------------------------------------*
*& Report ZGAMZEY_STUDY1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_study1.

INCLUDE:zgamzey_study1_top,
        zgamzey_study1_lcl,
        zgamzey_study1_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.

  CASE abap_true.
    WHEN rb_kayit .
      IF gv_flag2 EQ abap_true.
        IF p_tc IS NOT INITIAL AND
           p_ad IS NOT INITIAL AND
           p_soyad IS NOT INITIAL.
          go_local->save_data( ).
          go_local->call_screen( ).
        ENDIF.
      ENDIF.
    WHEN  rb_rand.
      go_local->get_data( ).
      go_local->random( ).
  ENDCASE.
