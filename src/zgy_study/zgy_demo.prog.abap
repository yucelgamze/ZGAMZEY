*&---------------------------------------------------------------------*
*& Report ZGY_DEMO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_demo.

START-OF-SELECTION.

  SELECT MAX( personal_id ) FROM zpersonal_t INTO @DATA(lv_personal_id).
  WRITE lv_personal_id.

  SELECT
    header~vbeln,
    header~erdat
    FROM vbak AS header
    INTO TABLE @DATA(lt_vbak). BREAK gamzey.
