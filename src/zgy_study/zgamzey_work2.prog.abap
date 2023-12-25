*&---------------------------------------------------------------------*
*& Report ZGAMZEY_WORK2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgamzey_work2.

*LOOP AT itab1 INTO wa1.
*  READ TABLE itab2 INTO wa2 WITH KEY key = wa1-key.
*  IF sy-subrc EQ 0.
*    """procesing...
*  ENDIF.
*ENDLOOP.

*LOOP AT itab1 INTO wa1.
*  LOOP AT itab2 INTO wa2 WHERE key = wa1-key.
*    """procesing...
*  ENDLOOP.
*ENDLOOP.


*LOOP AT itab1 INTO wa1.
*  LOOP AT itab2 INTO wa2.
*    IF wa2-key = wa1-key.
*    """procesing...
*    ENDIF.
*  ENDLOOP.
*
*ENDLOOP.

DATA:gt_scarr TYPE TABLE OF scarr,
     gs_scarr TYPE scarr.

FIELD-SYMBOLS:<gfs_scarr> TYPE scarr.

START-OF-SELECTION.


  SELECT *
    FROM scarr
  INTO TABLE gt_scarr.

  READ TABLE gt_scarr ASSIGNING <gfs_scarr> WITH KEY carrid = 'LH'.
  <gfs_scarr>-carrname = 'CHANGED!'.
  BREAK gamzey.


*  LOOP AT gt_scarr INTO gs_scarr.
*    IF gs_scarr-carrid EQ 'LH'.
*      gs_scarr-carrname = 'CHANGED!!!!'.
*    ENDIF.
*    MODIFY gt_scarr FROM gs_scarr.
*  ENDLOOP.

*  LOOP AT gt_scarr ASSIGNING <gfs_scarr>.
*    IF <gfs_scarr>-carrid EQ 'LH'.
*      <gfs_scarr>-carrname = 'CHANGED!'.
*    ENDIF.
*  ENDLOOP.

*  READ TABLE gt_scarr INTO gs_scarr WITH KEY carrid = 'LH'.
*  gs_scarr-carrname = 'CHANGED!'.


*TYPES: BEGIN OF gty_type1,
*         col1 TYPE char10,
*         col2 TYPE char10,
*         col3 TYPE char10,
*         col4 TYPE char10,
*       END OF gty_type1.
*
*TYPES: BEGIN OF gty_type2,
*         col2 TYPE char10,
*         col3 TYPE char10,
*       END OF gty_type2.
*
*DATA:gs_st1 TYPE gty_type1,
*     gs_st2 TYPE gty_type2.
*
*START-OF-SELECTION.
*
*  gs_st1-col1 = 'aaa'.
*  gs_st1-col2 = 'bbb'.
*  gs_st1-col3 = 'ccc'.
*  gs_st1-col4 = 'ddd'.
*
**  gs_st2 = gs_st1.
**  MOVE gs_st1 TO gs_st2.
*
*MOVE-CORRESPONDING gs_st1 to gs_st2.
*
*  BREAK gamzey.




*TYPES: BEGIN OF gty_type1,
*         col1 TYPE char10,
*         col2 TYPE char10,
*         col3 TYPE char10,
*         col4 TYPE char10,
*       END OF gty_type1.
*
**TYPES: BEGIN OF gty_type2,
**         col2 TYPE char10,
**         col3 TYPE char10,
**       END OF gty_type2.
**
*DATA:gs_st1  TYPE gty_type1,
*     gs_st2 TYPE gty_type1.
*
*START-OF-SELECTION.
*
*  gs_st1-col1 = 'aaa'.
*  gs_st1-col2 = 'bbb'.
*  gs_st1-col3 = 'ccc'.
*  gs_st1-col4 = 'ddd'.
*
*  gs_st2 = gs_st1.
*
*  BREAK gamzey.




*
*DATA:gt_scarr    TYPE TABLE OF scarr,
*     gs_scarr    TYPE scarr,
*     gv_currcode TYPE s_currcode.

*TYPES:BEGIN OF gty_scarr,
*        carrid   TYPE  s_carr_id,
*        carrname TYPE  s_carrname,
*        currcode TYPE  s_currcode,
*        url       TYPE  s_carrurl,
*      END OF gty_scarr.
*
*DATA:gt_scarr TYPE TABLE OF gty_scarr.
*
*START-OF-SELECTION.

*  SELECT *
*    FROM scarr
*    INTO TABLE gt_scarr
*    WHERE carrid EQ 'AC'.
*
*  READ TABLE gt_scarr INTO gs_scarr INDEX 1. "bir satır veri okudu.
*
*  WRITE:gs_scarr-currcode.

*  SELECT * UP TO 5 ROWS FROM scarr
*    INTO TABLE gt_scarr.
*
*    BREAK-POINT.
*
*  SELECT * UP TO 1 ROWS
*    FROM scarr
*    INTO TABLE gt_scarr
*    WHERE carrid EQ 'AC'.
*
*  READ TABLE gt_scarr INTO gs_scarr INDEX 1.
*  WRITE:gs_scarr-currcode.

*  "WHERE Koşulu
*  SELECT SINGLE *
*    FROM scarr
*    INTO gs_scarr
*    WHERE carrid EQ 'AC'.
*  WRITE:gs_scarr-carrid.
**
*  SELECT SINGLE currcode
*    FROM scarr
*    INTO gv_currcode
*    WHERE carrid EQ 'AC'.
*
*  WRITE:gv_currcode.

*  SELECT *
*    FROM scarr
*    INTO TABLE gt_scarr.
*
*  READ TABLE gt_scarr INTO gs_scarr WITH KEY carrid = 'AZ'.
*  WRITE:gs_scarr-currcode.
*
** BREAK gamzey.
*
*  READ TABLE gt_scarr INTO gs_scarr WITH KEY currcode = 'EUR'
*                                             carrname = 'Alitalia'.
*  WRITE:/,gs_scarr.
*
*WRITE:/,'loop ile çoklu satır'.
*
*  LOOP AT  gt_scarr INTO gs_scarr WHERE currcode = 'EUR'.
*    WRITE:gs_scarr.
*  ENDLOOP.

*  SELECT
*    carrid
*    carrname
*    FROM scarr
*    INTO CORRESPONDING FIELDS OF TABLE gt_scarr.
**    break gamzey.

*  SELECT *
*    FROM scarr
*    INTO CORRESPONDING FIELDS OF TABLE gt_scarr.
