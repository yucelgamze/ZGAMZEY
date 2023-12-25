*&---------------------------------------------------------------------*
*& Report ZGY_NS_0004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0004.

*DATA:gs_scarr TYPE scarr.
*
*SELECT SINGLE *
*FROM scarr
*INTO gs_scarr
*WHERE currcode EQ 'JPY'.

*SELECT SINGLE *
*  FROM scarr
*  INTO @DATA(ls_scarr)
*  WHERE currcode EQ 'JPY'.
*
*BREAK-POINT.

DATA:gs_scarr TYPE scarr.

SELECT SINGLE
carrname
currcode
FROM scarr
INTO CORRESPONDING FIELDS OF gs_scarr
WHERE currcode EQ 'JPY'.

SELECT SINGLE
carrname,
currcode
  FROM scarr
  INTO @DATA(ls_scarr)
  WHERE currcode EQ 'JPY'.

SELECT SINGLE
carrname
  FROM scarr
  INTO @DATA(lv_scarr)
  WHERE currcode EQ 'JPY'.

BREAK-POINT.
