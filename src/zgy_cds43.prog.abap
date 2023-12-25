*&---------------------------------------------------------------------*
*& Report ZGY_CDS43
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_cds43.

START-OF-SELECTION.

*  SELECT
*    matnr,
*    \_makt-maktx AS maktx
*    FROM zgy_ddl43
*    INTO TABLE @DATA(lt_table).

*  BREAK-POINT.

  SELECT
    matnr,
    maktx
    FROM zgy_ddl43
    INTO TABLE @DATA(lt_table43).

  SELECT
   matnr,
   maktx
   FROM zgy_ddl44
   INTO TABLE @DATA(lt_table44).

  SELECT
    COUNT(*)
    FROM zgy_ddl43
    INTO @DATA(lv_count43).

  SELECT
    COUNT(*)
    FROM zgy_ddl44
    INTO @DATA(lv_count44).

  BREAK gamzey.
