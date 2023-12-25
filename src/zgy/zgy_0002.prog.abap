*&---------------------------------------------------------------------*
*& Report ZGY_0002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgy_0002.

PARAMETERS: p_num TYPE i.

CASE p_num.
  WHEN 1.
    WRITE:|Bir|.
  WHEN 2.
    WRITE:|İki|.
  WHEN 3.
    WRITE:|Üç|.
  WHEN 4.
    WRITE:|Dört|.
  WHEN 5.
    WRITE:|Beş|.
  WHEN 6.
    WRITE:|Altı|.
  WHEN 7.
    WRITE:|Yedi|.
  WHEN 8.
    WRITE:|Sekiz|.
  WHEN 9.
    WRITE:|Dokuz|.
  WHEN 10.
    WRITE:|On|.
  WHEN OTHERS.
    WRITE:|10'dan büyük sayı girilemez!|.
ENDCASE.
