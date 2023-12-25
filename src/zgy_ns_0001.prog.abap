*&---------------------------------------------------------------------*
*& Report ZGY_NS_0001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0001.

*DATA: gv_name TYPE char20.
*gv_name = 'Raskolnikov'.

"inline declaration
DATA(lv_name) = 'Raskolnikov'.

*DATA:gt_scarr TYPE TABLE OF scarr,
*     gs_scarr TYPE scarr.
*
*SELECT * FROM scarr INTO TABLE gt_scarr.
*
*LOOP AT gt_scarr INTO gs_scarr.
*  WRITE gs_scarr.
*ENDLOOP.

SELECT * FROM scarr INTO TABLE @DATA(lt_scarr).

*LOOP AT lt_scarr INTO DATA(ls_scarr).
**  WRITE:/ ls_scarr-carrname,'-',ls_scarr-currcode.
*ENDLOOP.

*READ TABLE lt_scarr INTO DATA(ls_scarr2) WITH KEY currcode = 'JPY'.
*IF sy-subrc EQ 0.
**  WRITE:/ ls_scarr2-carrname,'-',ls_scarr2-currcode.
*ENDIF.

LOOP AT lt_scarr  ASSIGNING FIELD-SYMBOL(<lfs_scarr>).
  IF <lfs_scarr>-currcode EQ 'EUR'.
    <lfs_scarr>-currcode = 'XXX'.
  ENDIF.
ENDLOOP.

LOOP AT lt_scarr INTO DATA(ls_scarr).
  WRITE:/ ls_scarr-carrname,'-',ls_scarr-currcode.
ENDLOOP.
