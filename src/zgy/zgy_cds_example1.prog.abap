*&---------------------------------------------------------------------*
*& Report zgy_cds_example1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_cds_example1.

START-OF-SELECTION.

*  SELECT * FROM zgy_ddl_0001
*  INTO TABLE @DATA(lt_ddl).

  SELECT matnr, meins FROM zgy_cds_0001
  INTO TABLE @DATA(lt_sql1). "mandt var

  SELECT matnr, meins FROM zgy_cds_0001
*   WHERE meins EQ 'ST'
  INTO TABLE @DATA(lt_sql2). "mandt var

*  SELECT * FROM zgy_v_0001
*  INTO TABLE @DATA(lt_cds).  "mandt yok


  BREAK-POINT.
