*&---------------------------------------------------------------------*
*& Report ZGY_NS_0006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0006.

*DATA:gt_scarr TYPE TABLE OF scarr,
*     gs_scarr TYPE scarr.
*
*SELECT * FROM scarr INTO TABLE gt_scarr.
*
*READ TABLE gt_scarr INTO gs_scarr INDEX 3.
*IF sy-subrc EQ 0.
*  WRITE:/ gs_scarr-carrname,'-',gs_scarr-currcode.
*ENDIF.

*******************************************************************************************

*SELECT * FROM scarr INTO TABLE @DATA(lt_scarr).
*
*DATA(ls_scarr) = lt_scarr[ 3 ].
*IF sy-subrc EQ 0.
*  WRITE:/ ls_scarr-carrname,'-',ls_scarr-currcode.
*ENDIF.


SELECT * FROM scarr INTO TABLE @DATA(lt_scarr).

TRY.
    DATA(ls_scarr) = lt_scarr[ 22 ].
  CATCH cx_sy_itab_line_not_found.
    WRITE:/ |Satır bulunamadı!|.
ENDTRY.

IF ls_scarr IS NOT INITIAL.
  WRITE:/ ls_scarr-carrname,'-',ls_scarr-currcode.
ENDIF.

BREAK-POINT.
