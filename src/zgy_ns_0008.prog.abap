*&---------------------------------------------------------------------*
*& Report ZGY_NS_0008
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0008.
*DATA:gt_scarr TYPE TABLE OF scarr.
*
*SELECT * FROM scarr INTO TABLE gt_scarr.
*
*READ TABLE gt_scarr TRANSPORTING NO FIELDS INDEX 5.
*IF sy-subrc EQ 0.
*  WRITE:|Kayıt bulundu!|.
*ELSE.
*  WRITE:|Kayıt bulunamadı|.
*ENDIF.

*******************************************************************************************

*DATA:gt_scarr TYPE TABLE OF scarr.
*
*SELECT * FROM scarr INTO TABLE gt_scarr.
*
*READ TABLE gt_scarr TRANSPORTING NO FIELDS WITH KEY currcode = 'ABC'.
*IF sy-subrc EQ 0.
*  WRITE:|Kayıt bulundu!|.
*ELSE.
*  WRITE:|Kayıt bulunamadı|.
*ENDIF.

*******************************************************************************************

*SELECT * FROM scarr INTO TABLE @DATA(lt_scarr).
*
*IF line_exists( lt_scarr[ 3 ] ).
*  WRITE:|Kayıt bulundu!|.
*ELSE.
*  WRITE:|Kayıt bulunamadı|.
*ENDIF.

*******************************************************************************************

SELECT * FROM scarr INTO TABLE @DATA(lt_scarr).

IF line_exists( lt_scarr[ currcode = 'ABC' ] ).
  WRITE:|Kayıt bulundu!|.
ELSE.
  WRITE:|Kayıt bulunamadı|.
ENDIF.
