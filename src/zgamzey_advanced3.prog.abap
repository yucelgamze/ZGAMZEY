*&---------------------------------------------------------------------*
*& Report ZGAMZEY_ADVANCED3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_advanced3.

"FG FOR TABLE MAINTENANCE  -->ZGAMZEY_TM
"ZTITLE_T TM TCODE ->> ZGY_001
"ZDEP_T   TM TCODE ->> ZGY_002

INCLUDE:zgamzey_advanced3_top,
        zgamzey_advanced3_lcl,
        zgamzey_advanced3_moduls.

START-OF-SELECTION.
  CREATE OBJECT go_local.

  CASE abap_true.
    WHEN rb_yeni.
      go_local->call_screen( ).
    WHEN rb_list.
      IF gv_flag EQ abap_true.
        go_local->call_screen_2( ).
      ENDIF.
  ENDCASE.
