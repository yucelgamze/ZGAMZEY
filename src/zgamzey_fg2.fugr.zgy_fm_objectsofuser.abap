FUNCTION zgy_fm_objectsofuser.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  EXPORTING
*"     REFERENCE(EV_CDS_TIME) TYPE  INT4
*"     REFERENCE(EV_JOIN_TIME) TYPE  INT4
*"     REFERENCE(EV_NESTED_SELECT) TYPE  INT4
*"     REFERENCE(EV_SELECT_COUNT) TYPE  INT4
*"     REFERENCE(EV_VIEW_TIME) TYPE  INT4
*"----------------------------------------------------------------------

* 1)  CDS Call

  DATA: lv_tot_klasik TYPE int4,
        lv_tot_cds    TYPE int4,
        lv_tot_join   TYPE int4,
        lv_tot_count  TYPE int4,
        lv_tot_view   TYPE int4.

  GET RUN TIME FIELD DATA(t1).

  SELECT *
    FROM zgy_cds12
    INTO TABLE @DATA(lt_cds_003).

  GET RUN TIME FIELD DATA(t2).

  lv_tot_cds = t2 - t1.
  ev_cds_time = lv_tot_cds.


**2) Classic join call with parallel cursor
*
*  DATA: BEGIN OF ls_user_object,
*          user         TYPE e070-as4user,
*          total_count  TYPE int4,
*          total_object TYPE int4,
*        END OF ls_user_object,
*        lt_user_object  LIKE TABLE OF ls_user_object,
*        lv_total_count  TYPE int4,
*        lv_total_object TYPE int4.
*
*  DATA: BEGIN OF ls_filter_tab,
*          trkorr  TYPE trkorr,
*          as4user TYPE tr_as4user,
*        END OF ls_filter_tab,
*        lt_filter_tab LIKE TABLE OF ls_filter_tab.
*
*  DATA: BEGIN OF ls_user_tab,
*          as4user TYPE tr_as4user,
*        END OF ls_user_tab,
*        lt_user_tab LIKE TABLE OF ls_filter_tab.
*
*  GET RUN TIME FIELD DATA(t3).
*
*  SELECT e070~trkorr,
*         e070~as4user,
*         e071~as4pos
*    FROM e070
*    LEFT OUTER JOIN e071
*                 ON e070~trkorr EQ e071~trkorr
*    INTO TABLE @DATA(lt_join).
*
*  IF sy-subrc IS INITIAL.
*    lt_filter_tab = CORRESPONDING #( lt_join ).
*    SORT lt_filter_tab BY trkorr as4user.
*    DELETE ADJACENT DUPLICATES FROM lt_filter_tab COMPARING ALL FIELDS.
*
*    lt_user_tab = CORRESPONDING #( lt_filter_tab ).
*    SORT lt_user_tab BY as4user.
*    DELETE ADJACENT DUPLICATES FROM lt_user_tab COMPARING as4user.
*
*    DATA: lv_tabix TYPE sy-tabix.
*    DATA: lt_obj_list LIKE lt_join.
*
*    SORT lt_join BY as4user.
*
*    LOOP AT lt_user_tab INTO DATA(ls_user).
*
*      DATA(lt_req_list) = lt_filter_tab.
*      DELETE lt_req_list WHERE as4user NE ls_user-as4user.
*      DESCRIBE TABLE lt_req_list LINES DATA(lv_reqs_line).
*
*      REFRESH: lt_obj_list.
*      READ TABLE lt_join TRANSPORTING NO FIELDS
*                         WITH KEY as4user = ls_user-as4user
*                         BINARY SEARCH.
*
*      IF sy-subrc = 0.
*        lv_tabix = sy-tabix.
*
*        LOOP AT lt_join INTO DATA(ls_join) FROM lv_tabix WHERE as4pos NE space.
*          IF ls_join-as4user NE ls_user-as4user.
*            EXIT.
*          ENDIF.
*          APPEND ls_join TO lt_obj_list.
*        ENDLOOP.
*
*        DESCRIBE TABLE lt_obj_list LINES DATA(lv_obj_lines).
*
*        ls_user_object-user         = ls_user-as4user.
*        ls_user_object-total_count  = lv_reqs_line.
*        ls_user_object-total_object = lv_obj_lines.
*        APPEND ls_user_object TO lt_user_object.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
*
*  GET RUN TIME FIELD DATA(t4).
*  lv_tot_join = t4 - t3.
*  ev_join_time = lv_tot_join.
*
**eski yöntem***************************************
*  REFRESH lt_user_object.
*
*  GET RUN TIME FIELD DATA(t5).
*
*  SELECT trkorr,
*    as4user,
*    COUNT( * ) AS count
*   FROM e070
*    INTO @DATA(ls_user_req)
*    GROUP BY trkorr, as4user.
*
*    CLEAR: lv_total_object.
*
*    SELECT trkorr,
*      COUNT( * ) AS count_obj
*      FROM e071
*      INTO @DATA(ls_object)
*      WHERE trkorr EQ @ls_user_req-trkorr
*      GROUP BY trkorr.
*
*      lv_total_object = lv_total_object + ls_object-count_obj.
*    ENDSELECT.
*
*    ls_user_object-user         = ls_user_req-as4user.
*    ls_user_object-total_count  = ls_user_req-count.
*    ls_user_object-total_object = lv_total_object.
*    COLLECT ls_user_object INTO lt_user_object.
*  ENDSELECT.
*
*  GET RUN TIME FIELD DATA(t6).
*  lv_tot_klasik = t6 - t5.
*  ev_nested_select = lv_tot_klasik.
*
*  "*************************************
*  REFRESH lt_user_object.
*
*  GET RUN TIME FIELD DATA(t7).
*
*  SELECT trkorr,
*    as4user,
*    COUNT( * ) AS count
*    FROM e070
*    INTO TABLE @DATA(lt_user_req_count)
*    GROUP BY trkorr,as4user.
*  IF sy-subrc IS INITIAL.
*    SELECT trkorr,
*      COUNT( * ) AS count_obj
*      FROM e071
*      INTO TABLE @DATA(lt_object_count)
*      GROUP BY trkorr.
*    IF sy-subrc IS INITIAL.
*      LOOP AT lt_user_req_count INTO DATA(ls_user_count).
*        CLEAR ls_user_object.
*
*        ls_user_object-user         = ls_user_count-as4user.
*        ls_user_object-total_count  = ls_user_count-count.
*
*
*        READ TABLE lt_object_count INTO DATA(ls_object_count) WITH KEY trkorr = ls_object_count-trkorr.
*        IF sy-subrc IS INITIAL.
*          ls_user_object-total_object  = ls_object_count-count_obj.
*        ENDIF.
*        COLLECT ls_user_object INTO lt_user_object.
*      ENDLOOP.
*    ENDIF.
*  ENDIF.
*
*  GET RUN TIME FIELD DATA(t8).
*  lv_tot_count = t8 - t7.
*  ev_select_count = lv_tot_count.

ENDFUNCTION.
