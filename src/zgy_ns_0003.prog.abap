*&---------------------------------------------------------------------*
*& Report ZGY_NS_0003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0003.

*DATA:gt_scarr TYPE TABLE OF scarr.
*
*SELECT * FROM scarr
*  INTO TABLE gt_scarr
*  WHERE currcode EQ 'EUR'.
*
*SELECT * FROM scarr
*  INTO TABLE @DATA(lt_scarr)
*  WHERE currcode EQ 'EUR'.

*BREAK-POINT.


DATA:gt_scarr TYPE TABLE OF scarr.

SELECT
  carrname
  currcode
  FROM scarr
  INTO CORRESPONDING FIELDS OF TABLE gt_scarr
  WHERE currcode EQ 'EUR'.

SELECT
  carrname,
  currcode
  FROM scarr
  INTO TABLE @DATA(lt_scarr)
  WHERE currcode EQ 'EUR'.

BREAK-POINT.
