*&---------------------------------------------------------------------*
*& Report ZGY_CALL_CDS26
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_call_cds26.


SELECT
  vbeln,
  vbtyp,
  "association'a erişim formatını kullanacaksak her zaman DDL isimlendirmesi (define view) kullanılmalı!
  \_sitem-matnr AS material
  FROM zgy_ddl26
  INTO TABLE @DATA(lt_cds26).

BREAK gamzey.
