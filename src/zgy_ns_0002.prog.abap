*&---------------------------------------------------------------------*
*& Report ZGY_NS_0002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0002.

*DATA:gt_scarr TYPE TABLE OF scarr,
*     gs_scarr TYPE scarr.
*
*FIELD-SYMBOLS:<gfs_scarr> TYPE scarr.
*
*SELECT * FROM scarr INTO TABLE gt_scarr.
*
*READ TABLE gt_scarr ASSIGNING <gfs_scarr> WITH KEY currcode = 'JPY'.
*IF sy-subrc EQ 0.
*  <gfs_scarr>-carrname = 'XXX'.
*ENDIF.
*
*READ TABLE gt_scarr INTO gs_scarr WITH KEY currcode = 'JPY'.
*IF sy-subrc EQ 0.
*  WRITE:/ gs_scarr-carrname,'-',gs_scarr-currcode.
*ENDIF.

SELECT * FROM scarr INTO TABLE @DATA(lt_scarr).

READ TABLE lt_scarr ASSIGNING FIELD-SYMBOL(<lfs_scarr>) WITH KEY currcode = 'JPY'.
IF sy-subrc EQ 0.
  <lfs_scarr>-carrname = 'asdf'.
ENDIF.

READ TABLE lt_scarr INTO DATA(ls_scarr) WITH KEY currcode = 'JPY'.
IF sy-subrc EQ 0.
  WRITE:/ ls_scarr-carrname,'-',ls_scarr-currcode.
ENDIF.
