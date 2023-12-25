*&---------------------------------------------------------------------*
*& Report ZGAMZEY_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_easy_if.

DATA:gv_num1 TYPE  i,
     gv_num2 TYPE  i,
     gv_num3 TYPE  i,
     gv_highest TYPE  i,
     gv_middle TYPE  i,
     gv_lowest TYPE  i.
gv_num1 = 9.
gv_num2 = 159.
gv_num3 = 99.
IF gv_num1 LE gv_num2 AND gv_num1 LE gv_num3.
  gv_lowest = gv_num1.
  IF gv_num2 LE gv_num3.
    gv_middle = gv_num2.
    gv_highest = gv_num3.
  ELSE.
    gv_middle = gv_num3.
    gv_highest = gv_num2.
  ENDIF.

ELSEIF gv_num2 LE gv_num1 AND gv_num2 LE gv_num3.
  gv_lowest = gv_num2.
  IF gv_num1 LE gv_num3.
    gv_middle = gv_num1.
    gv_highest = gv_num3.
  ELSE.
    gv_middle = gv_num3.
    gv_highest = gv_num1.
  ENDIF.

ELSE.
  gv_lowest = gv_num3.
  IF gv_num1 LE gv_num2.
    gv_middle = gv_num1.
    gv_highest = gv_num2.
  ELSE.
    gv_middle = gv_num2.
    gv_highest = gv_num1.
  ENDIF.

ENDIF.

WRITE:gv_lowest, gv_middle, gv_highest.
