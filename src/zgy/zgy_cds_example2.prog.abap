*&---------------------------------------------------------------------*
*& Report zgy_cds_example2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_cds_example2.


START-OF-SELECTION.

  SELECT
  matnr,

*  \_makt-maktx AS maktx                -> exposed ( _makt olarak asssociation olsaydı )
  maktx
  FROM zgy_ddl_0012
  INTO TABLE @DATA(lt_0012).


  SELECT
  malzeme,
  maktx
  FROM zgy_ddl_0013
  INTO TABLE @DATA(lt_0013).


  SELECT
  COUNT( * )
  FROM zgy_ddl_0012
  INTO @DATA(lv_0012).

  SELECT
  COUNT( * )
  FROM zgy_ddl_0013
  INTO @DATA(lv_0013).


  BREAK-POINT.
