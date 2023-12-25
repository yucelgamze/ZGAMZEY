*&---------------------------------------------------------------------*
*& Report ZGY_NS_0009
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_ns_0009.

DATA:gt_scarr TYPE TABLE OF scarr,
     gv_tabix TYPE i.

SELECT * FROM scarr INTO TABLE gt_scarr.

*READ TABLE gt_scarr TRANSPORTING NO FIELDS WITH KEY currcode = 'JPY'.
*IF sy-subrc EQ 0.
*  gv_tabix = sy-tabix.
*  WRITE:/ |Bulunan satır->|,gv_tabix.
*ENDIF.

*READ TABLE gt_scarr TRANSPORTING NO FIELDS INDEX 15.
*IF sy-subrc EQ 0.
*  gv_tabix = sy-tabix.
*  WRITE:/ |Bulunan satır->|,gv_tabix.
*ENDIF.

SELECT * FROM scarr INTO TABLE @DATA(lt_scarr).

DATA(lv_tabix) = line_index( lt_scarr[ currcode = 'JPY' ] ).
WRITE:/ |Bulunan satır->|,lv_tabix.
